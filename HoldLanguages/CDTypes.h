#import <Foundation/Foundation.h>

typedef enum{
    CDDirectionNone = 0,
    CDDirectionUp = UISwipeGestureRecognizerDirectionUp,
    CDDirectionDown = UISwipeGestureRecognizerDirectionDown,
    CDDirectionLeft = UISwipeGestureRecognizerDirectionLeft,
    CDDirectionRight = UISwipeGestureRecognizerDirectionRight,
    CDDirectionHorizontal = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight,
    CDDirectionVertical = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown
}CDDirection;