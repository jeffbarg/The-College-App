//
//  FTPercentageMarker.m
//  The College App
//
//  Created by Jeffrey Barg on 8/9/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTPercentageMarker.h"

@implementation FTPercentageMarker

@synthesize percent;
@synthesize leftText;
@synthesize rightText;

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
    // Drawing code
    
    [[UIColor colorWithRed:0.961 green:0.969 blue:0.973 alpha:1.000] setFill];
    UIBezierPath  *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [path fill];
    
    CGFloat radius = self.bounds.size.height / 2.0;
    UIBezierPath  *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    [bezierPath addClip];
        
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithHue:0.270 saturation:0.726 brightness:0.573 alpha:1.000] setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, self.percent * self.bounds.size.width, self.bounds.size.height));
    [[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.275 alpha:1.000] setFill];
    CGContextFillRect(ctx, CGRectMake(self.percent * self.bounds.size.width, 0, self.bounds.size.width - self.percent * self.bounds.size.width, self.bounds.size.height));
    
    [[UIColor whiteColor] setFill];
    [@"9%" drawInRect:CGRectInset(self.bounds, 0,6) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
}



@end
