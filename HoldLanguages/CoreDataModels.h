//
//  CoreDataModels.h
//  HoldLanguages
//
//  Created by William Remaerd on 3/18/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Item.h"
#import "Audio.h"
#import "Image.h"
#import "Lyrics.h"

#import "CDNetwork.h"



@interface Audio (Enhance) <CDNetworkTrans>
@end

@interface Image (Enhance) <CDNetworkTrans>
- (NSString *)absolutePath;
@end

@interface Lyrics (Enhance) <CDNetworkTrans>
@end
