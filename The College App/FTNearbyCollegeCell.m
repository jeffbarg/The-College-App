//
//  FTNearbyCollegeCell.m
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTNearbyCollegeCell.h"

@implementation FTNearbyCollegeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = [UIColor colorWithHue:0.562 saturation:0.032 brightness:0.986 alpha:1.000];

    [fillColor setFill];
    
    CGContextFillRect(ctx, self.bounds);
    
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


@end
