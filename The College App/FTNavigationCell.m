//
//  FTNavigationCell.m
//  The College App
//
//  Created by Jeffrey Barg on 7/16/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTNavigationCell.h"

@implementation FTNavigationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [self setNeedsDisplay];
    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
    UIColor *backgroundColor = [UIColor colorWithRed:0.200 green:0.204 blue:0.212 alpha:1.000];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    if (self.highlighted || self.selected) {
        UIColor *topColor = [UIColor colorWithRed:0.557 green:0.000 blue:0.792 alpha:1.000];
        UIColor *bottomColor = [UIColor colorWithRed:0.329 green:0.000 blue:0.529 alpha:1.000];//[UIColor colorWithRed:0.451 green:0.000 blue:0.737 alpha:1.000];
        
        NSArray* gradientColors = [NSArray arrayWithObjects: 
                                   (id)topColor.CGColor, 
                                   (id)bottomColor.CGColor, nil];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        CGContextDrawLinearGradient(ctx, gradient,CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height),  0); 
    } else {
        [backgroundColor setFill];
        CGContextFillRect(ctx, self.bounds);   
    }
    
    CGContextSetAllowsAntialiasing(ctx, NO);
    
    
    UIColor *darkColor = [UIColor colorWithRed:0.122 green:0.122 blue:0.129 alpha:1.000];
    UIColor *lightColor = [UIColor colorWithRed:0.282 green:0.282 blue:0.290 alpha:0.600];
    
    UIBezierPath *lightLine = [UIBezierPath bezierPath];
    [lightLine moveToPoint:CGPointMake(0, 0.5)];
    [lightLine addLineToPoint:CGPointMake(self.bounds.size.width, 0.5)];
    
    [lightColor setStroke];
    [lightLine setLineWidth:1.0];
    [lightLine stroke];
    
    UIBezierPath *darkLine = [UIBezierPath bezierPath];
    [darkLine moveToPoint:CGPointMake(0, self.bounds.size.height-0.5)];
    [darkLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 0.5)];
    
    [darkColor setStroke];
    [darkLine setLineWidth:1.0];
    [darkLine stroke];
    
}

@end
