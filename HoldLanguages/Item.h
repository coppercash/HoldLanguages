//
//  Item.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/20/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Audio, Content, Image, Lyrics;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * absolutePath;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * downloadTry;
@property (nonatomic, retain) Audio *audio;
@property (nonatomic, retain) Content *content;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Lyrics *lyrics;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
