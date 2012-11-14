//
//  Header.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "AppDelegate.h"
#import "CDString.h"
#import "CDStack.h"
#import "CDArray.h"

#define kMissLocalizedString @"MissLocalizedString"
#define kDebugColor [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f]

#define DEBUG_MODE
#ifdef DEBUG_MODE

#define DLog(...);      NSLog(__VA_ARGS__);
#define DLogPoint(p)    NSLog(@"%f,%f", p.x, p.y);
#define DLogSize(p)     NSLog(@"%f,%f", p.width, p.height);
#define DLogRect(p)     NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#else

#define DLog(...);      // NSLog(__VA_ARGS__);
#define DLogPoint(p)    // NSLog(@"%f,%f", p.x, p.y);
#define DLogSize(p)     // NSLog(@"%f,%f", p.width, p.height);
#define DLogRect(p)     // NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#endif
