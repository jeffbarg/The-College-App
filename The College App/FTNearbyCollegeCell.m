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
    [[UIColor colorWithWhite:0.898 alpha:1.000] setFill];
    
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetAllowsAntialiasing(ctx, NO);
    
    UIColor *darkColor = [UIColor colorWithWhite:0.710 alpha:1.000];
    UIColor *lightColor = [UIColor whiteColor];
    
    UIBezierPath *lightLine = [UIBezierPath bezierPath];
    [lightLine moveToPoint:CGPointMake(0, 0.5)];
    [lightLine addLineToPoint:CGPointMake(self.bounds.size.width, 0.5)];
    
    [lightColor setStroke];
    [lightLine setLineWidth:1.0];
    [lightLine stroke];
    
    UIBezierPath *darkLine = [UIBezierPath bezierPath];
    [darkLine moveToPoint:CGPointMake(0, self.bounds.size.height-1)];
    [darkLine addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 1)];
    
    [darkColor setStroke];
    [darkLine setLineWidth:1.0];
    [darkLine stroke];
}


@end
