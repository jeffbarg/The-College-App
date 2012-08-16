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
@synthesize leftColor;
@synthesize rightColor;
@synthesize centerText;

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
    UIBezierPath  *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds,0.5,0.5) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx); {
            
        [bezierPath addClip];

        [rightColor setFill];
        CGContextFillRect(ctx, self.bounds);
        
        [leftColor setFill];
        CGContextFillRect(ctx, CGRectMake(0, 0, self.percent * self.bounds.size.width, self.bounds.size.height));

        
        [[UIColor whiteColor] setFill];
        [self.centerText drawInRect:CGRectIntegral(CGRectInset(self.bounds, 0,6)) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
        [self.leftText drawInRect:CGRectIntegral(CGRectInset(CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height), 0,6)) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
        [self.rightText drawInRect:CGRectIntegral(CGRectInset(CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height), 0,6)) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];

    } CGContextRestoreGState(ctx);

    [[UIColor colorWithWhite:0.5 alpha:1.0] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}



@end
