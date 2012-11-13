//
//  CDStack.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/13/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDLyrics.h"

@interface NSMutableArray (CDStack)
- (void)push:(id)object;
- (id)pop;
- (BOOL)isEmpty;
@end
