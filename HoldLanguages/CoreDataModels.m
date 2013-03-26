//
//  CoreDataModels.m
//  HoldLanguages
//
//  Created by William Remaerd on 3/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CoreDataModels.h"
#import "CDiTunesFinder.h"
#import "Audio.h"
#import "Lyrics.h"
#import "Image.h"
#import "Content.h"
#import "CDItem.h"

@implementation Audio (Enhance)
- (NSString *)hostName{
    return self.item.hostName;
}

- (NSString *)absolutePath{
    return directoryDocuments(self.path);
}
@end

@implementation Image (Enhance)
- (NSString *)hostName{
    return self.item.hostName;
}

- (NSString *)absolutePath{
    return directoryDocuments(self.path);
}
@end

@implementation Lyrics (Enhance)
- (NSString *)hostName{
    return self.item.hostName;
}

- (NSString *)absolutePath{
    return directoryDocuments(self.path);
}
@end


