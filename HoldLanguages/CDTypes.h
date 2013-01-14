typedef enum{
    CDDirectionNone,
    CDDirectionUp,
    CDDirectionDown,
    CDDirectionLeft,
    CDDirectionRight
}CDDirection;

#define UISwipeGestureRecognizerDirectionNone 0
#define UISwipeGestureRecognizerDirectionVertical (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown)
#define UISwipeGestureRecognizerDirectionHorizontal (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)