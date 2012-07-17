//
//  FTNavigationHeader.m
//  The College App
//
//  Created by Jeffrey Barg on 7/16/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTNavigationHeader.h"
#import <QuartzCore/QuartzCore.h>

@interface FTNavigationHeader () {
CGGradientRef _backgroundGradient;
}
- (CGGradientRef) backgroundGradient;


@end
@implementation FTNavigationHeader

@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self.layer setShadowOffset:CGSizeMake(0, 1)];
//        [self.layer setShadowOpacity:0.3];
//        [self.layer setShadowColor:[UIColor blackColor].CGColor];
    }
    return self;
}

- (CGGradientRef) backgroundGradient {
    if (_backgroundGradient == NULL) {
        
        CGFloat colors[8] = {
            53.0 / 255.0, 54.0 / 255.0, 56.0 /255.0, 1.0,
            41.0 / 255.0, 42.0 / 255.0, 43.0 / 255.0, 1.0,
        };
        
        CGFloat colorStops[2] = {0.0, 1.0};
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _backgroundGradient = CGGradientCreateWithColorComponents(colorSpace, colors, colorStops, 4);
        CGColorSpaceRelease(colorSpace);
    }
    return _backgroundGradient;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //Draw gradient
    //// Gradient Declarations
    
    UIColor *topColor = [UIColor colorWithRed:0.451 green:0.000 blue:0.737 alpha:1.000];
    UIColor *bottomColor = [UIColor colorWithRed:0.557 green:0.000 blue:0.792 alpha:1.000];
    
    NSArray* gradientColors = [NSArray arrayWithObjects: 
                               (id)topColor.CGColor, 
                               (id)bottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, self.bounds.size.height), CGPointMake(0, 0), 0);
    
    CGContextSetAllowsAntialiasing(ctx, NO);
    
    
//    UIBezierPath *topLine = [UIBezierPath bezierPath];
//    [topLine moveToPoint:CGPointMake(0, 0.5)];
//    [topLine addLineToPoint:CGPointMake(self.bounds.size.width, 0.5)];
//    
//    [lightColor setStroke];
//    [topLine setLineWidth:1.0];
//    [topLine stroke];
    
//    UIBezierPath *lightLine = [UIBezierPath bezierPath];
//    [lightLine moveToPoint:CGPointMake(0, 0.5)];
//    [lightLine addLineToPoint:CGPointMake(self.bounds.size.width, 0.5)];
//    
//    [[lightColor colorWithAlphaComponent:0.6] setStroke];
//    [lightLine setLineWidth:1.0];
//    [lightLine stroke];
//    
//    UIBezierPath *darkLine = [UIBezierPath bezierPath];
//    [darkLine moveToPoint:CGPointMake(0, self.bounds.size.height-0.5)];
//    [darkLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 1)];
//    
//    [darkColor setStroke];
//    [darkLine setLineWidth:1.0];
//    [darkLine stroke];

    UIColor *darkColor = [UIColor colorWithRed:0.122 green:0.122 blue:0.129 alpha:1.000];
    UIColor *lightColor = [UIColor colorWithRed:0.282 green:0.282 blue:0.290 alpha:0.600];
    
    UIBezierPath *lightLine = [UIBezierPath bezierPath];
    [lightLine moveToPoint:CGPointMake(0, 0.5)];
    [lightLine addLineToPoint:CGPointMake(self.bounds.size.width, 0.5)];
    
    [lightColor setStroke];
    [lightLine setLineWidth:1.0];
    [lightLine stroke];
    
//    lightLine = [UIBezierPath bezierPath];
//    [lightLine moveToPoint:CGPointMake(0, self.bounds.size.height-2.5)];
//    [lightLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 1.5)];
//    
//    [[lightColor colorWithAlphaComponent:0.25] setStroke];
//    [lightLine setLineWidth:1.0];
//    [lightLine stroke];
    
    UIBezierPath *darkLine = [UIBezierPath bezierPath];
    [darkLine moveToPoint:CGPointMake(0, self.bounds.size.height-1)];
    [darkLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 0.5)];
    
    [darkColor setStroke];
    [darkLine setLineWidth:1.0];
    [darkLine stroke];
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGContextSaveGState(ctx); {
        [[UIColor colorWithRed:0.510 green:0.514 blue:0.518 alpha:1.000] setFill];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 0.0, [UIColor blackColor].CGColor);
        [self.title drawInRect:CGRectMake(10.0, 5.0, 300.0, self.bounds.size.height - 10.0) withFont:[UIFont boldSystemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
        
    } CGContextRestoreGState(ctx);
    
}

@end
