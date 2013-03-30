//
//  CDItem.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDItem.h"
#import "CoreDataModels.h"
#import "CDStoryView.h"

#import "CDiTunesFinder.h"

@implementation Item (Enhance)

static NSString * const gKeyURL = @"url";
static NSString * const gKeyTitle = @"title";
static NSString * const gKeyContent = @"content";
static NSString * const gKeyImgSrc = @"imgSrc";
static NSString * const gKeyAudio = @"audio";
static NSString * const gKeyLyrics = @"lrc";

#pragma mark - Fetch
+ (Item *)fetchOrCreatItem:(NSDictionary *)dictionary{
    NSString *url = [dictionary objectForKey:gKeyURL];
    if (url == nil) return nil;
    
    NSArray *results = [Item itemsOfAbsolutePath:url];
    if (results.count == 0) {
        [Item newItemWithDictionary:dictionary];
    }else if (results.count == 1) {
        return [results objectAtIndex:0];
    }
    NSAssert(results.count <= 1, @"%d Item with same absolutePath", results.count);
    return nil;
}

+ (Item *)newItemWithDictionary:(NSDictionary *)dictionary{
    NSString *url = [dictionary objectForKey:gKeyURL];
    if (url == nil || [Item exixtsItemWithSameAbsolutePath:url]) return nil;
    
    NSManagedObjectContext *context = kMOContext;
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Item class]) inManagedObjectContext:context];
    [item configureWithDictionary:dictionary forced:YES];
    return item;
}

+ (NSArray *)itemsDownloaded{
    NSManagedObjectContext *context = kMOContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %d", ItemStatusDownloaded];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Item class])];
    request.predicate = predicate;

    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"%@", error.userInfo);

    return results;
}

+ (NSArray *)itemsOfAbsolutePath:(NSString *)path{
    NSManagedObjectContext *context = kMOContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"absolutePath = %@", path];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Item class])];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"%@", error.userInfo);
    NSAssert(results.count <= 1, @"%d Item with same absolutePath", results.count);
    
    return results;
}

+ (BOOL)exixtsItemWithSameAbsolutePath:(NSString *)path{
    NSArray *results = [Item itemsOfAbsolutePath:path];
    return results.count != 0;
}

#pragma mark - Configure
- (void)configureWithDictionary:(NSDictionary *)dictionary forced:(BOOL)isForced{
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"Item can only be configured with NSDictionary.");
    
    NSManagedObjectContext *context = kMOContext;
    NSString *(^pathFromLink)(NSString *) = ^(NSString *link){
        NSString *ex = link.pathExtension;  //extension
        NSString *name = [nameDateNow() stringByAppendingPathExtension:ex];
        NSString *path = directoryRelativeDownload(name);
        NSAssert(path != nil, @"Path can't be nil.");
        return path;
    };
    
    if (isForced || self.absolutePath == nil) {
        NSString *url = [dictionary objectForKey:gKeyURL];
        if (url) self.absolutePath = url;
    }
    
    if (isForced || self.title == nil) {
        NSString *title = [dictionary objectForKey:gKeyTitle];
        if (title) self.title = title;
    }
    
    if (isForced || self.audio == nil) {
        NSString *audioLink = [dictionary objectForKey:gKeyAudio];
        if (audioLink) {
            Audio *audio = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Audio class]) inManagedObjectContext:context];
            self.audio = audio;
            audio.link = audioLink;
            audio.path = pathFromLink(audioLink);
        }
    }
    
    if (isForced || self.lyrics == nil) {
        NSString *lrcLink = [dictionary objectForKey:gKeyLyrics];
        if (lrcLink) {
            Lyrics *lyrics = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Lyrics class]) inManagedObjectContext:context];
            self.lyrics = lyrics;
            lyrics.link = lrcLink;
            lyrics.path = pathFromLink(lrcLink);
        }
    }
    
    if (isForced || self.content == nil) {
        NSArray *content = [dictionary objectForKey:gKeyContent];
        if (content) {
            NSMutableString *collector = [[NSMutableString alloc] init];
            for (id text in content) {
                if ([text isKindOfClass:[NSString class]]) {
                    if ([text isEqualToString:@"\r\n"]) continue;
                    [collector appendFormat:@"%@\n", text];
                    
                    /*
                     if ([text isEqualToString:@"\r\n"]) {
                     isFeed = YES;
                     continue;
                     }else{
                     if (isFeed) {
                     [collector appendFormat:@"\n"];
                     isFeed = NO;
                     }
                     [collector appendFormat:@"%@", text];
                     }
                     */
                    
                }else if ([text isKindOfClass:[NSDictionary class]]) {
                    //Image Item
                    NSString *link = [text objectForKey:gKeyImgSrc];
                    if (link == nil) continue;
                    
                    NSString *path = pathFromLink(link);

                    Image *image = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
                    [self addImagesObject:image];
                    image.link = link;
                    image.path = path;
                }
            }
            self.content = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Content class]) inManagedObjectContext:context];
            self.content.content = collector;
        }
    }
}

#pragma mark - Delete
- (void)removeResource{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSString *absolutePath = nil;
    
    Audio *audio = self.audio;
    absolutePath = audio.absolutePath;
    if (audio && [manager fileExistsAtPath:absolutePath]) {
        [manager removeItemAtPath:absolutePath error:&error];
        AssertError(error);
    }
    
    Lyrics *lyrics = self.lyrics;
    absolutePath = lyrics.absolutePath;
    if (lyrics && [manager fileExistsAtPath:absolutePath]) {
        [manager removeItemAtPath:absolutePath error:&error];
        AssertError(error);
    }
    
    NSSet *images = self.images;
    for (Image *image in images) {
        absolutePath = image.absolutePath;
        if (![manager fileExistsAtPath:absolutePath]) continue;
        [manager removeItemAtPath:absolutePath error:&error];
        AssertError(error);
    }
}

+ (void)removeInitItems{
    NSManagedObjectContext *context = kMOContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %d", ItemStatusInit];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Item class])];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"%@", error.userInfo);
    
    for (Item *item in results) {
        [item removeResource];
        [context deleteObject:item];
    }
}

#pragma mark - Getter
- (NSString *)hostName{
    NSURL *url = [[NSURL alloc] initWithString:self.absolutePath];
    return url.host;
}

- (NSString *)relativePath{
    NSURL *url = [[NSURL alloc] initWithString:self.absolutePath];
    return url.relativePath;
}

- (Image *)anyImage{
    NSSet *images = self.images;
    if (images && images.count != 0) {
        return [images anyObject];
    }
    return nil;
}
/*
- (NSString *)contentWithTitle{
    NSString *text = [[NSString alloc] initWithFormat:@"<%@>%@</%@>\n%@", gStroyTagHead, self.title, gStroyTagHead, self.content.content];
    return text;
}*/

- (NSString *)description{
    NSMutableString *des = [NSMutableString string];
    if (self.title) [des appendFormat:@"\ntitle = %@\tstatus = %d", self.title, self.status.integerValue];
    if (self.absolutePath) [des appendFormat:@"\nabPath = %@", self.absolutePath];
    if (self.audio) [des appendFormat:@"\naudio = \n\t%@\n\t%@", self.audio.link, self.audio.path];
    if (self.lyrics) [des appendFormat:@"\nlyrics = \n\t%@\n\t%@", self.lyrics.link, self.lyrics.path];
    if (self.images && self.images.count != 0) {
        [des appendString:@"\nimages ="];
        for (Image *img in self.images) {
            [des appendFormat:@"\n\timage =\n\t\t%@\n\t\t%@", img.link, img.path];
        }
    }
    if (self.content) [des appendFormat:@"\ncontent =\n%@", self.content.content];
    
    return des;
}

- (BOOL)isEqualToItem:(Item *)anotherItem{
    BOOL isEqual = [self.absolutePath isEqualToString:anotherItem.absolutePath];
    return isEqual;
}

@end

