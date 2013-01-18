#import "CDTypes.h"
float limitedFloat(float value, float min, float max);
double limitedDouble(double value, double min, double max);
CDTimeRange CDMakeTimeRange(NSTimeInterval location, NSTimeInterval range);
CDTimeRange CDIntersectionTimeRange (CDTimeRange range1, CDTimeRange range2);
NSTimeInterval CDTimeRangeGetEnd(CDTimeRange range);
BOOL CDTimeRangeContainsTimeRange (CDTimeRange range1, CDTimeRange range2);
BOOL CDEqualTimeRanges(CDTimeRange range1, CDTimeRange range2);
