//
//  FTStandardizedTestView.m
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTStandardizedTestView.h"
#import "StandardizedTest.h"

#define MARGIN_X 4
#define MARGIN_Y 4
@interface FTStandardizedTestView () {
    CGGradientRef _backgroundGradient;
}
- (CGGradientRef) backgroundGradient;

@end


@implementation FTStandardizedTestView

@synthesize test = _test;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
        self.backgroundColor = kViewBackgroundColor;
    }
    return self;
}


- (CGGradientRef) backgroundGradient {
    if (_backgroundGradient == NULL) {
        
        //Draw gradient
        //// Gradient Declarations
        UIColor *topColor = [UIColor colorWithWhite:0.910 alpha:1.000];
        UIColor *bottomColor = [UIColor colorWithWhite:0.886 alpha:1.000];
        
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)topColor.CGColor,
                                   (id)bottomColor.CGColor, nil];
        
        CGFloat gradientLocations[] = {0, 1};        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _backgroundGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        CGColorSpaceRelease(colorSpace);
    }
    return _backgroundGradient;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //Color Setup
    UIColor *borderColor = [UIColor colorWithWhite:0.686 alpha:1.000];
    

    
    // Drawing code
    UIBezierPath *fullPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5 + MARGIN_X, 0.5, self.bounds.size.width - 1.0 - 2 * MARGIN_X, self.bounds.size.height - 1.0 - MARGIN_Y) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CGContextSaveGState(ctx); {
        CGContextSetShadow(ctx, CGSizeMake(0, 0), 2);
        [borderColor setStroke];
        [fullPath setLineWidth:1.0];
        [fullPath stroke];
    } CGContextRestoreGState(ctx);

    CGContextSaveGState(ctx); {
        [fullPath addClip];
        
        
        CGContextDrawLinearGradient(ctx, [self backgroundGradient], CGPointMake(0.0, 0.0), CGPointMake(0.0, self.bounds.size.height), 0);
    } CGContextRestoreGState(ctx);
    

    
    
}


@end
