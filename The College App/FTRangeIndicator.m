//
//  FTRangeIndicator.m
//  The College App
//
//  Created by Jeffrey Barg on 7/11/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTRangeIndicator.h"

@implementation FTRangeIndicator

@synthesize lowerBound  = _lowerBound;
@synthesize upperBound  = _upperBound;

@synthesize minValue    = _minValue;
@synthesize maxValue    = _maxValue;

@synthesize value       = _value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, false);
    
    UIColor *greenColor = [UIColor colorWithRed:0.314 green:0.573 blue:0.157 alpha:1.000];
    UIColor *textColor = [UIColor colorWithWhite:0.639 alpha:1.000];
    
    UIFont *labelFont = [UIFont boldSystemFontOfSize:10.0];
    
    CGRect fullRect = CGRectMake(0.5, 20.5, self.frame.size.width - 1.0, self.frame.size.height - 40.0 - 1.0);
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:fullRect];
    [[UIColor blackColor] setFill];
    [[UIColor purpleColor] setStroke];
    
    [rectPath fill];
    
    rectPath.lineWidth = 1;
    [rectPath stroke];

    CGRect rangeRect = CGRectZero;
    rangeRect.origin.y = fullRect.origin.y;
    rangeRect.size.height = fullRect.size.height;
    
    rangeRect.origin.x = fullRect.origin.x + ((self.minValue - self.lowerBound) / (self.upperBound - self.lowerBound) * fullRect.size.width);
    rangeRect.size.width = (self.maxValue - self.minValue) / (self.upperBound - self.lowerBound) * fullRect.size.width;
    
    UIBezierPath *rangeRectPath = [UIBezierPath bezierPathWithRect:rangeRect];
    [greenColor setFill];
    
    [rangeRectPath fill];
    
    CGContextSetAllowsAntialiasing(context, true);
    
    [textColor setFill];
    
    [[NSString stringWithFormat:@"%.0f", self.lowerBound] drawInRect:CGRectMake(0.5, CGRectGetMaxY(fullRect), 50.0, 20.0) withFont:labelFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
    
    [[NSString stringWithFormat:@"%.0f", self.upperBound] drawInRect:CGRectMake(CGRectGetMaxX(fullRect) - 50.0, CGRectGetMaxY(fullRect), 50.0, 20.0) withFont:labelFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
    
    NSString *minValueStr = [NSString stringWithFormat:@"%.0f", self.minValue];
    NSString *maxValueStr = [NSString stringWithFormat:@"%.0f", self.maxValue];
    
    CGSize minValSize = [minValueStr sizeWithFont:labelFont];
    CGSize maxValSize = [maxValueStr sizeWithFont:labelFont];
    
    CGRect maxValRect = CGRectZero;
    maxValRect.size = maxValSize;
    maxValRect.origin.y = CGRectGetMinY(rangeRect) - 18.0;
    maxValRect.origin.x = MIN(CGRectGetMaxX(rangeRect) - maxValSize.width/2.0, fullRect.size.width - maxValSize.width);
    
    [maxValueStr drawInRect:maxValRect withFont:labelFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    CGRect minValRect = CGRectZero;
    minValRect.size = minValSize;
    minValRect.origin.y = CGRectGetMinY(rangeRect) - 18.0;
    minValRect.origin.x = MAX(CGRectGetMinX(rangeRect) - minValSize.width/2.0, 0.5);
    minValRect.origin.x = MIN(minValRect.origin.x, maxValRect.origin.x - minValSize.width - 2.0);
    
    [minValueStr drawInRect:minValRect withFont:labelFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    
    

}


#pragma mark - Setters

- (void) setValue:(CGFloat)value {
    _value = value;
    [self setNeedsDisplay];
}

- (void) setMinValue:(CGFloat)minValue {
    _minValue = minValue;
    [self setNeedsDisplay];
}

- (void) setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    [self setNeedsDisplay];
}

- (void) setLowerBound:(CGFloat)lowerBound {
    _lowerBound = lowerBound;
    [self setNeedsDisplay];
}

- (void) setUpperBound:(CGFloat)upperBound {
    _upperBound = upperBound;
    [self setNeedsDisplay];
}

@end
