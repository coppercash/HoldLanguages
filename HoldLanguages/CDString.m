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
    NSRange range = [self rangeOfString:substring];
    if (range.location <= 0) return nil;
    NSRange previousRange = NSMakeRange(range.location - 1, 1);
    NSString* previous = [self substringWithRange:previousRange];
    return previous;
}

- (NSString*)nextCharacterAfterSubstring:(NSString*)substring{
    NSRange range = [self rangeOfString:substring];
    NSUInteger subLocation = range.location + range.length;
    if (subLocation >= self.length) return nil;
    NSRange nextRange = NSMakeRange(subLocation, 1);
    NSString* next = [self substringWithRange:nextRange];
    return next;
}

@end
