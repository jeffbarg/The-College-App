//
//  FTCollegeCellView.m
//  The College App
//
//  Created by Jeffrey Barg on 7/9/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTCollegeCellView.h"

#import "College.h"

#define X_MARGIN 15
#define Y_MARGIN 15
#define LEFTBAR_MARGIN 30

#define HOLE_RADIUS 4.0
#define NUM_HOLES 0
#define HOLE_TOP_MARGIN 15.0

@interface FTCollegeCellView () {
    CGGradientRef _backgroundGradient;
}
- (CGGradientRef) backgroundGradient;

@end

@implementation FTCollegeCellView

@synthesize titleLabel          = _titleLabel;
@synthesize subtitleLabel       = _subtitleLabel;
@synthesize actScore            = _actScore;
@synthesize satScore            = _satScore;

@synthesize school = _school;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
        self.backgroundColor = kViewBackgroundColor;
        
        UIColor *greenColor = [UIColor colorWithRed:0.157 green:0.490 blue:0.000 alpha:1.000];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:self.titleLabel];
        
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.numberOfLines = 1;
        _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _subtitleLabel.textAlignment = UITextAlignmentCenter;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor blackColor];
        _subtitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _subtitleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        [self addSubview:self.subtitleLabel];
        
        _satScore = [[UILabel alloc] initWithFrame:CGRectZero];
        _satScore.textColor = greenColor;
        _satScore.numberOfLines = 1;
        _satScore.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _satScore.textAlignment = UITextAlignmentRight;
        _satScore.backgroundColor = [UIColor clearColor];
        _satScore.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:self.satScore];

        _actScore = [[UILabel alloc] initWithFrame:CGRectZero];
        _actScore.textColor = greenColor;
        _actScore.numberOfLines = 1;
        _actScore.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _actScore.textAlignment = UITextAlignmentRight;
        _actScore.backgroundColor = [UIColor clearColor];
        _actScore.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:self.actScore];
    }
    return self;
}

- (void) layoutSubviews {
    
    [self.titleLabel setFrame:CGRectMake(X_MARGIN + LEFTBAR_MARGIN, Y_MARGIN, self.bounds.size.width - 2 * X_MARGIN - LEFTBAR_MARGIN, 20.0)];
        
    [self.subtitleLabel setFrame:CGRectMake(0, 0, self.bounds.size.height - 20.0, LEFTBAR_MARGIN - 10.0)];
    [self.subtitleLabel setTransform:CGAffineTransformMakeRotation(degreesToRadians(-90))];
    [self.subtitleLabel setCenter:CGPointMake(1.0 + LEFTBAR_MARGIN / 2.0, self.bounds.size.height / 2.0)];
    
    [self.satScore setFrame:CGRectMake(self.frame.size.width - 100.0 - X_MARGIN, 82.0, 100.0, 20.0)];
    [self.actScore setFrame:CGRectMake(self.frame.size.width - 100.0 - X_MARGIN, 97.0, 100.0, 20.0)];
}


- (CGGradientRef) backgroundGradient {
    if (_backgroundGradient == NULL) {
        
        CGFloat colors[8] = {
            1.0, 1.0, 1.0, 1.0,
            243.0 / 255.0, 247.0 / 255.0, 250.0 / 255.0, 1.0,
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
- (void)drawRect:(CGRect) rect
{
    CGContextRef ctx        = UIGraphicsGetCurrentContext();
    
    UIColor *borderColor = [UIColor colorWithHue:0.574 saturation:0.147 brightness:0.722 alpha:1.000];
    
    //Add rounded corners with a clip path
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5 , 0.5, self.frame.size.width - 1.0, self.frame.size.height - 1.0)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(5.0f, 5.0f)];
    
    CGContextSaveGState(ctx);
    //Add rounded rectangle clipping
    [clipPath addClip];
    
    //Draw gradient
    CGPoint startPoint      = {0.0, 0.0};
    CGPoint endPoint        = {0.0, self.bounds.size.height};
    CGContextDrawLinearGradient(ctx, [self backgroundGradient], startPoint, endPoint, 0);
    
    UIBezierPath *leftSidebarPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.5, 0.5, LEFTBAR_MARGIN - 0.5, self.bounds.size.height - 1.0)];
    
    UIColor *sidebarColor = nil;
    if ([self.school color1] != nil) {
        sidebarColor = [UIColor blueColor];
    } else {
        sidebarColor = [UIColor colorWithHue:0.563 saturation:0.929 brightness:0.494 alpha:1.000];
    }
        
    [self.subtitleLabel setBackgroundColor:sidebarColor];
    
    
    [sidebarColor setFill];
    [leftSidebarPath fill];
    
//    [leftSidebarPath setLineWidth:1.0];
//    [borderColor setStroke];
//    [leftSidebarPath stroke];
    
    //Remove Clipping
    CGContextRestoreGState(ctx);
    
    [borderColor setStroke];
    
    [clipPath setLineWidth:1.0];
    [clipPath stroke];
    
    for (int i = 0; i < NUM_HOLES; i++) {
        CGPoint holeCenter = CGPointMake(0, HOLE_TOP_MARGIN + HOLE_RADIUS + i*((self.bounds.size.height - 2 * HOLE_TOP_MARGIN - 2 * HOLE_RADIUS)/(NUM_HOLES - 1)));
        NSLog(@"%@", NSStringFromCGPoint(holeCenter));
        
        UIBezierPath *holePath = [UIBezierPath bezierPathWithArcCenter:holeCenter radius:HOLE_RADIUS startAngle:0.0 endAngle:degreesToRadians(360.0) clockwise:NO];
        
        [kViewBackgroundColor setFill];
        [holePath fill];
    }
    
    //[clipPath stroke];
    
    [[UIColor colorWithRed:0.659 green:0.675 blue:0.686 alpha:1.000] setFill];
    
    [@"Middle 50%" drawInRect:CGRectMake(self.frame.size.width - 69.0 - 100.0, 69.0, 100.0, 10.0) withFont:[UIFont boldSystemFontOfSize:12.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
    
    [[UIColor blackColor] setFill];
    
    [@"SAT" drawAtPoint:CGPointMake(X_MARGIN + LEFTBAR_MARGIN, 80.0) withFont:[UIFont boldSystemFontOfSize:14.0]];
    [@"ACT" drawAtPoint:CGPointMake(X_MARGIN + LEFTBAR_MARGIN, 100.0) withFont:[UIFont boldSystemFontOfSize:14.0]];
}

#pragma mark - Custom Setters/Getters

- (void) setSchool:(College *)school {
    _school = school;
    
    [self setNeedsDisplay];
}

@end
