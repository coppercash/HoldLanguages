#import "CDFunctions.h"

float limitedFloat(float value, float min, float max){
    if (value < min) value = min;
    else if (value > max) value = max;
    return value;
}

double limitedDouble(double value, double min, double max){
    if (value < min) value = min;
    else if (value > max) value = max;
    return value;
}

CDTimeRange CDMakeTimeRange(NSTimeInterval location, NSTimeInterval range){
    //if (location < 0) location = 0.0f;
    CDTimeRange timeRange = {location, fabs(range)};
    return timeRange;
}

CDTimeRange CDIntersectionTimeRange (CDTimeRange range1, CDTimeRange range2){
    CDTimeRange left = range1;
    CDTimeRange right = range2;
    if (range1.location > range2.location) {
        left = range2;
        right = range1;
    }
    
    NSTimeInterval leftEnd = left.location + left.length;
    NSTimeInterval rightEnd = right.location + right.length;
    if (leftEnd < right.location) {
        //|_left_|
        //          |_right_|
        return CDMakeTimeRange(0.0f, 0.0f);
    }else if (leftEnd < rightEnd){
        //|_left_|
        //  |_right_|
        return CDMakeTimeRange(right.location, leftEnd - right.location);
    }else{
        //|____left____|
        //  |_right_|
        return right;
    }
}

NSTimeInterval CDTimeRangeGetEnd(CDTimeRange range){
    return range.location + range.length;
}

BOOL CDTimeRangeContainsTimeRange (CDTimeRange range1, CDTimeRange range2){
    if (range1.location > range2.location) return NO;
    if (range1.location + range1.length < range2.location + range2.length) return NO;
    return YES;
}

BOOL CDEqualTimeRanges(CDTimeRange range1, CDTimeRange range2){
    if (fabs(range1.location - range2.location) >= kDoubleAccurate) return NO;
    if (fabs(range1.length - range2.length) >= kDoubleAccurate) return NO;
    return YES;
}
