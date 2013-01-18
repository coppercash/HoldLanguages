#import <Foundation/Foundation.h>
#define kDoubleAccurate 0.000001
typedef enum{
    CDDirectionNone = 0,
    CDDirectionUp = UISwipeGestureRecognizerDirectionUp,
    CDDirectionDown = UISwipeGestureRecognizerDirectionDown,
    CDDirectionLeft = UISwipeGestureRecognizerDirectionLeft,
    CDDirectionRight = UISwipeGestureRecognizerDirectionRight,
    CDDirectionHorizontal = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight,
    CDDirectionVertical = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown
}CDDirection;

typedef struct _CDTimeRange {
    NSTimeInterval location;
    NSTimeInterval length;
} CDTimeRange;