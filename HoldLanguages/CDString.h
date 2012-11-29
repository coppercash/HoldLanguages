//
//  CDString.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyrics.h"

@interface NSString (CDString)
- (BOOL)isVisuallyEmpty;
- (NSString*)previousCharacterBeforeSubstring:(NSString*)substring;
- (NSString*)nextCharacterAfterSubstring:(NSString*)substring;
@end
