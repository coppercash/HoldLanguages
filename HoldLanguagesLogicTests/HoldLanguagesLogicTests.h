//
//  HoldLanguagesLogicTests.h
//  HoldLanguagesLogicTests
//
//  Created by William Remaerd on 12/17/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#define LogStart    NSLog(@"%@ start", self.name);
#define LogEnd    NSLog(@"%@ end", self.name);

@class CDLRCLyrics;
@interface HoldLanguagesLogicTests : SenTestCase {
    CDLRCLyrics* _lrcLyrics;
}

@end
