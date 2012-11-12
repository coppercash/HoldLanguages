//
//  CDString.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/12/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDString.h"

@implementation NSString (CDString)

- (BOOL)isVisuallyEmpty{
    NSMutableString* testString = [NSMutableString stringWithString:self];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)(testString));
    return testString.length == 0;
}

- (NSString*)previousCharacterBeforeSubstring:(NSString*)substring{
    @try {
        NSRange range = [self rangeOfString:substring];
        NSRange previousRange = NSMakeRange(range.location - 1, 1);
        NSString* previous = [self substringWithRange:previousRange];
        return previous;
    }
    @catch (NSException *exception) {
        return nil;
    }    
}

- (NSString*)nextCharacterAfterSubstring:(NSString*)substring{
    @try {
        NSRange range = [self rangeOfString:substring];
        NSRange nextRange = NSMakeRange(range.location + range.length, 1);
        NSString* next = [self substringWithRange:nextRange];
        return next;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
