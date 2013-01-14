//
//  Header.h
//  HoldLanguages
//
//  Created by William Remaerd on 11/10/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#define kMissLocalizedString @"MissLocalizedString"
#define kDebugColor [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f]
#define kViewAutoresizingNoMarginSurround UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

#define DEBUG_MODE
#ifdef DEBUG_MODE

#define DLog(...);      NSLog(__VA_ARGS__);
#define DLogPoint(p)    NSLog(@"%f,%f", p.x, p.y);
#define DLogSize(p)     NSLog(@"%f,%f", p.width, p.height);
#define DLogRect(p)     NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);
#define  __FILENAME__  [[NSString stringWithCString:__FILE__ encoding:NSStringEncodingConversionAllowLossy] lastPathComponent]
#define DLogCurrentMethod NSLog(@"%@:%d@%@\n%@", __FILENAME__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else

#define DLog(...);
#define DLogPoint(p)
#define DLogSize(p)
#define DLogRect(p)

#endif
