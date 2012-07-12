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
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.824 green:0.847 blue:0.859 alpha:1.000] setFill];
    CGContextFillRect(ctx, self.bounds);
    
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
    [[UIColor whiteColor] setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(ctx);
    

}


@end
