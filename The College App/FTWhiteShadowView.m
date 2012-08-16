//
//  FTWhiteShadowView.m
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTWhiteShadowView.h"

@implementation FTWhiteShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [kViewBackgroundColor setFill];
    CGContextFillRect(ctx, self.bounds);
    
    if (INTERFACE_IS_PAD) {
        CGRect pathRect = self.bounds;
        pathRect = CGRectInset(pathRect, 4, 4.5);
        pathRect = CGRectOffset(pathRect, 0, -0.5);
        
        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:pathRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.0, 5.0)];
            
        //// Shadow Declarations
        UIColor* shadow = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        CGSize shadowOffset = CGSizeMake(0, 1);
        CGFloat shadowBlurRadius = 4;

        
        CGContextSaveGState(ctx);
        CGContextSetShadowWithColor(ctx, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [[UIColor colorWithRed:0.961 green:0.969 blue:0.973 alpha:1.000] setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(ctx);
        
        for (int i = 1; i < (self.tag % 10); i ++) {
            [[UIColor colorWithRed:0.863 green:0.871 blue:0.875 alpha:1.000] setFill];
            CGContextFillRect(ctx, CGRectMake(5.0, 4.0 + 64 * i, self.frame.size.width - 10.0, 1));
            
            [[UIColor colorWithWhite:1.000 alpha:1.000] setFill];
            CGContextFillRect(ctx, CGRectMake(5.0, 5.0 + 64 * i, self.frame.size.width - 10.0, 1));
        }
    } else {
        //Draw Cell Dividers
        
        CGContextSetAllowsAntialiasing(ctx, NO);
        CGContextSetShouldAntialias(ctx, NO);
        CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
        
        UIColor *darkColor = [[UIColor colorWithWhite:0.710 alpha:1.000] colorWithAlphaComponent:0.8];
        UIColor *lightColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        
        UIBezierPath *lightPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        [lightColor setFill];
        [lightPath fill];
        
        UIBezierPath *darkPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
        [darkColor setFill];
        [darkPath fill];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
    
}


@end
