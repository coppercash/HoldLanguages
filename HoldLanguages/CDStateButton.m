//
//  CDStateButton.m
//  HoldLanguages
//
//  Created by William Remaerd on 11/21/12.
//  Copyright (c) 2012 Coder Dreamer. All rights reserved.
//

#import "CDStateButton.h"
#import "Header.h"

@interface CDStateButton ()
- (void)initialize;
- (void)touchDown;
- (void)touchMoveInside;
- (void)touchMoveOutside;
- (void)touchUpInside;
- (void)touchUpOutside;
- (void)touchCancel;
- (NSUInteger)nextIndex;
@end

@implementation CDStateButton
@synthesize images = _images, backgound = _backgound;
@synthesize state = _state, delegate = _delegate;
#pragma mark - UIControl Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _state = 0;
    self.backgroundColor = [UIColor clearColor];
    
    _backgound = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_backgound];
    _backgound.autoresizingMask = kViewAutoresizingNoMarginSurround;
    _backgound.backgroundColor = [UIColor clearColor];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_images.count == 0) return NO;
    [self touchDown];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    static BOOL isInside = YES;
    CGPoint touchPoint = [touch locationInView:self];
    CGRect effectiveRect = CGRectInset(self.bounds, kEffectiveRectInset, kEffectiveRectInset);
    if (CGRectContainsPoint(effectiveRect, touchPoint)) {
        if (!isInside) {
            [self touchMoveInside];
        }
        isInside = YES;
    }else{
        if (isInside) {
            [self touchMoveOutside];
        }
        isInside = NO;
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect effectiveRect = CGRectInset(self.bounds, kEffectiveRectInset, kEffectiveRectInset);
    if (CGRectContainsPoint(effectiveRect, touchPoint)) {
        [self touchUpInside];
    }else{
        [self touchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [self touchCancel];
}

#pragma mark - Keys
static NSString* keyOfNormal = @"Normal";
static NSString* keyOfHighlighted = @"Highlighted";

#pragma mark - Images
- (void)addImagesForStateNormal:(UIImage*)normalImage forHighlighted:(UIImage*)highlightedImage{
    NSDictionary* dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                normalImage, keyOfNormal,
                                highlightedImage, keyOfHighlighted,
                                nil];
    if (_images == nil){
        _images = [[NSArray alloc] initWithObjects:dictionary, nil];
        NSDictionary* next = [_images objectAtIndex:0];
        UIImage* newImage = [next objectForKey:keyOfNormal];
        [self loadImage:newImage];
    }else{
        NSMutableArray* newArray = [[NSMutableArray alloc] initWithArray:_images];
        [newArray addObject:dictionary];
        _images = [[NSArray alloc] initWithArray:newArray];
    }
}

- (void)addPNGFilesNormal:(NSString*)normalName highlighted:(NSString*)highlightedName{
    UIImage* normal = [UIImage pngImageWithName:normalName];
    UIImage* highlighted = nil;
    if ([normalName isEqualToString:highlightedName]) {
        highlighted = normal;
    }else{
        highlighted = [UIImage pngImageWithName:highlightedName];
    }
    [self addImagesForStateNormal:normal forHighlighted:highlighted];
}

- (void)loadImage:(UIImage*)image{
    if (_backgound.image == image) return;
    [_backgound setImage:image];
}

- (void)setImageHighlighted:(BOOL)highlighted{
    NSDictionary* current = [_images objectAtIndex:_state];
    UIImage* newImage = nil;
    if (highlighted) {
        newImage = [current objectForKey:keyOfHighlighted];
    }else{
        newImage = [current objectForKey:keyOfNormal];
    }
    [self loadImage:newImage];
}

#pragma mark - Touch events handling
- (void)touchDown{
    [self setImageHighlighted:YES];
}

- (void)touchMoveInside{
    [self setImageHighlighted:YES];
}

- (void)touchMoveOutside{
    [self setImageHighlighted:NO];
}

- (void)touchUpInside{
    NSInteger shouldIndex = [_delegate shouldStateButtonChangedValue:self];
    NSUInteger destinationIndex;
    if (shouldIndex == CDStateButtonShouldChangeMaskKeep) {
        destinationIndex = _state;
    }else if (shouldIndex == CDStateButtonShouldChangeMaskNext){
        destinationIndex = self.nextIndex;
    }else{
        destinationIndex = shouldIndex;
    }
    NSDictionary* next = [_images objectAtIndex:destinationIndex];
    UIImage* newImage = [next objectForKey:keyOfNormal];
    [self loadImage:newImage];
    _state = destinationIndex;
}

- (void)touchUpOutside{
    [self setImageHighlighted:NO];
}

- (void)touchCancel{
    [self setImageHighlighted:NO];
}

- (NSUInteger)nextIndex{
    NSUInteger nextIndex = (_state + 1) % _images.count;
    return nextIndex;
}

@end
