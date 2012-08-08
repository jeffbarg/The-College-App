//
//  FTExtracurricularCell.m
//  The College App
//
//  Created by Jeff Barg on 6/25/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTExtracurriclarsViewController.h"
#import "FTExtracurricularCellView.h"

#import "Extracurricular.h"
#import <QuartzCore/QuartzCore.h>

@interface FTExtracurricularCellView () {
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleTextLabel;

@property (nonatomic, strong) UILabel *hoursPerWeekLabel;
@property (nonatomic, strong) UILabel *weeksPerYearLabel;

@property (nonatomic, strong) UIView *containerView; // Clipping magic for numbers.
@property (nonatomic, strong) UILabel *cellIndexView;

@property (nonatomic, strong) NSArray * gradeIndicatorButtons;

@end


@implementation FTExtracurricularCellView

@synthesize cellIndex;
@synthesize titleLabel = _titleLabel;
@synthesize subtitleTextLabel = _subtitleTextLabel;

@synthesize hoursPerWeekLabel = _hoursPerWeekLabel;
@synthesize weeksPerYearLabel = _weeksPerYearLabel;

@synthesize containerView = _containerView;
@synthesize cellIndexView = _cellIndexView;

@synthesize gradeIndicatorButtons = _gradeIndicatorButtons;

@synthesize managedObjectContext;

@synthesize activity = _activity;

@synthesize viewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Insert some subviews, maybe?
        if (INTERFACE_IS_PHONE) self.opaque = YES;
        
        UIColor *titleColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.1 alpha:1.0];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.textColor = titleColor;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];

        _titleLabel.text = [self.activity name];
        
        [self addSubview:self.titleLabel];
        

        _subtitleTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleTextLabel.numberOfLines = 1;
        _subtitleTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _subtitleTextLabel.textAlignment = UITextAlignmentCenter;
        _subtitleTextLabel.textColor = titleColor;
        _subtitleTextLabel.backgroundColor = [UIColor clearColor];
        _subtitleTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _subtitleTextLabel.font = [UIFont systemFontOfSize:17.0];
        
        _subtitleTextLabel.text = [self.activity position];
        
        [self addSubview:self.subtitleTextLabel];
        
        _hoursPerWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hoursPerWeekLabel.numberOfLines = 1;
        _hoursPerWeekLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _hoursPerWeekLabel.textAlignment = UITextAlignmentCenter;
        _hoursPerWeekLabel.backgroundColor = [UIColor clearColor];
        _hoursPerWeekLabel.textColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.188 alpha:1.000];
        _hoursPerWeekLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _hoursPerWeekLabel.font = [UIFont boldSystemFontOfSize:17.0];
        
        _hoursPerWeekLabel.text = @"43";
        
        [self addSubview:self.hoursPerWeekLabel];
        
        
        _weeksPerYearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _weeksPerYearLabel.numberOfLines = 1;
        _weeksPerYearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _weeksPerYearLabel.textAlignment = UITextAlignmentCenter;
        _weeksPerYearLabel.backgroundColor = [UIColor clearColor];
        _weeksPerYearLabel.textColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.188 alpha:1.000];
        _weeksPerYearLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        _weeksPerYearLabel.font = [UIFont boldSystemFontOfSize:17.0];
        
        _weeksPerYearLabel.text = @"52";
        
        [self addSubview:self.weeksPerYearLabel];
        
        
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_containerView setClipsToBounds:YES];
        [self addSubview:self.containerView];
        
        _cellIndexView = [[UILabel alloc] initWithFrame:CGRectZero];
        _cellIndexView.font = [UIFont boldSystemFontOfSize:100.0f];
        _cellIndexView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _cellIndexView.numberOfLines = 1;
        _cellIndexView.backgroundColor = [UIColor clearColor];
        _cellIndexView.textColor = [UIColor colorWithHue:0.600 saturation:0.023 brightness:0.835 alpha:1.000];

        [self.containerView addSubview:self.cellIndexView];
        
//        NSMutableArray *mButtonArray = [[NSMutableArray alloc] initWithCapacity:4];
//        
//        for (int i = 0; i < 4; i ++) {
//            UIButton *gradeIndicatorButton = [[UIButton alloc] initWithFrame:CGRectZero];
//            [gradeIndicatorButton setShowsTouchWhenHighlighted:YES];
//            [gradeIndicatorButton addTarget:self action:@selector(pressGradeIndicator:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:gradeIndicatorButton];
//            [mButtonArray addObject:gradeIndicatorButton];
//        }
//        
//        self.gradeIndicatorButtons = [[NSArray alloc] initWithArray:mButtonArray];
    
    }
    
    return self;
}

- (void) pressGradeIndicator:(UIButton *)gradeIndicatorButton {
    [self.viewController setDidPressCellButton:YES];
    
    int index = [self.gradeIndicatorButtons indexOfObject:gradeIndicatorButton];
    
    NSInteger gradeToChange = 1<<index;
    
    NSInteger gradesInvolvedMask = [[self.activity gradesInvolved] integerValue];
    
    [self.activity setGradesInvolved:[NSNumber numberWithInteger:gradesInvolvedMask ^ gradeToChange]];
    
    if (self.managedObjectContext != nil) {
        NSError *err = nil;
        [self.managedObjectContext save:&err];
        
        if (err != nil) {
            NSLog(@" Error: %@", [err localizedDescription]);
        }
    }
    
    [self setNeedsDisplay];
}

- (void) layoutSubviews {

    if (INTERFACE_IS_PAD) {
        [self.titleLabel        setFrame:CGRectMake(80.0, 30.0, 300.0, 35.0)];
        [self.subtitleTextLabel setFrame:CGRectMake(self.frame.size.width - 220.0, 30.0, 200.0, 35.0)];
        
        [self.hoursPerWeekLabel setFrame:CGRectMake(self.frame.size.width - 240.0, 87.0, 60.0, 44.0)];
        [self.weeksPerYearLabel setFrame:CGRectMake(self.frame.size.width - 60.0f, 87.0, 60.0, 44.0)];

        [self.containerView setFrame:CGRectMake(20.0, 18, 100.0, 70.0)];
        [self.cellIndexView setFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    
        CGFloat gradesInvolvedIndicatorSpacing = 60.0;
        
        for (int i = 0; i < 4; i ++) {
            UIButton * button = (UIButton *)[self.gradeIndicatorButtons objectAtIndex:i];
            CGRect buttonRect = CGRectMake(0.5 + i * gradesInvolvedIndicatorSpacing, 88, gradesInvolvedIndicatorSpacing, 43.5);
            
            [button setFrame:buttonRect];
            
        }
    } else { // iPhone Version
        
        CGFloat rightMargin = INTERFACE_IS_PORTRAIT? 5 : 10;
        
        [self.titleLabel        setFrame:CGRectMake(20.0, 20.0, 280, 35.0)];
        [self.titleLabel        setTextAlignment:UITextAlignmentLeft];
        
        [self.subtitleTextLabel setFrame:CGRectMake(20, 43.0, 200.0, 35.0)];
        [self.subtitleTextLabel setTextAlignment:UITextAlignmentLeft];

        [self.hoursPerWeekLabel setFrame:CGRectMake(self.frame.size.width - 120.0 - rightMargin, 87.0, 30.0, 44.0)];
        [self.weeksPerYearLabel setFrame:CGRectMake(self.frame.size.width - 30.0 - rightMargin, 87.0, 30.0, 44.0)];
        
        [self.containerView setFrame:CGRectMake(self.frame.size.width - 65, 18, 100.0, 70.0)];
        [self.cellIndexView setFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
        
        CGFloat gradesInvolvedIndicatorSpacing = INTERFACE_IS_PORTRAIT? 32.0 : 60.0;
        
        for (int i = 0; i < 4; i ++) {
            UIButton * button = (UIButton *)[self.gradeIndicatorButtons objectAtIndex:i];
            CGRect buttonRect = CGRectMake(0.5 + i * gradesInvolvedIndicatorSpacing, 88, gradesInvolvedIndicatorSpacing, 43.5);
            
            [button setFrame:buttonRect];
            
        }
    }

}

- (void) updateCellIndex:(NSInteger) index animated:(BOOL) animated {
    self.cellIndex = [NSNumber numberWithInteger:index];
    
    if (animated) {
    
        //Snapshot Cell Index Label View Layer
        CALayer *snapshottedLayer = [self.cellIndexView layer];
        UIGraphicsBeginImageContextWithOptions([snapshottedLayer bounds].size, NO, 0);
        [snapshottedLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Create temporary image view
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.cellIndexView.frame];
        [imgView setImage:img];
        
        //Move label below clipped region and add placeholder image.
        
        [self.cellIndexView setFrame:CGRectMake(0.0, 88.0, self.cellIndexView.frame.size.height, self.cellIndexView.frame.size.height)];
        [self.containerView addSubview:imgView];
        
        //Reset text on label.
        NSString *str = [NSString stringWithFormat:@"%i", [cellIndex integerValue]+1];
        _cellIndexView.text = str;

        //Animate to normalcy
        [UIView animateWithDuration:0.4 animations:^{
            [self.cellIndexView setFrame:CGRectMake(0.0, 0.0, self.cellIndexView.frame.size.height, self.cellIndexView.frame.size.height)];
            [imgView setFrame:CGRectMake(0.0, 88.0, self.cellIndexView.frame.size.height, self.cellIndexView.frame.size.height)];

        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
        
    } else {
        //Simple Update - No Animation
        NSString *str = [NSString stringWithFormat:@"%i", [cellIndex integerValue]+1];
        _cellIndexView.text = str;
    }
}

- (void) redisplayInformation {
    _titleLabel.text = [self.activity name];
    _subtitleTextLabel.text = [self.activity position];
    NSString *str = [NSString stringWithFormat:@"%i", [cellIndex integerValue]+1];
    _cellIndexView.text = str;
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger gradesInvolved = [[self.activity gradesInvolved] integerValue];
    CGFloat gradesInvolvedIndicatorSpacing = INTERFACE_IS_PAD? 60.0 : INTERFACE_IS_PORTRAIT? 32.0 : 60.0;
    CGFloat rightMargin = INTERFACE_IS_PORTRAIT? 5 : 10;

    //// Color Declarations
    UIColor* color = [UIColor colorWithHue:0.583 saturation:0.075 brightness:0.937 alpha:1.000];//[UIColor colorWithRed: 0.79 green: 0.82 blue: 0.85 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.68 green: 0.73 blue: 0.77 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 0.95 green: 0.98 blue: 0.98 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.56 green: 0.58 blue: 0.59 alpha: 1];
    UIColor* gradeIndicatorColor = [UIColor colorWithHue:0.771 saturation:1.000 brightness:0.765 alpha:0.11]; // Purple Glow Color 0.13 Alpha
    UIColor* gradeIndicatorTextColor = [UIColor colorWithHue:0.819 saturation:1.000 brightness:0.416 alpha:1.000];
    UIColor* borderColor = [UIColor colorWithRed: 0.68 green: 0.72 blue: 0.75 alpha: 0.5];
    UIColor* cellIndexColor = [UIColor colorWithHue:0.600 saturation:0.023 brightness:0.835 alpha:1.000];
    UIColor *titleColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.1 alpha:1.0];

    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects: 
                               (id)[UIColor whiteColor].CGColor, 
                               (id)gradientColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Gradient Declarations
    NSArray* gradeIndicatorColors = [NSArray arrayWithObjects: 
                                     (id)[UIColor clearColor].CGColor,
                                     (id)[UIColor clearColor].CGColor,
                                     (id)gradeIndicatorColor.CGColor, nil];
    CGFloat gradeIndicatorGradientLocations[] = {0, 0.45, 1};
    CGGradientRef gradeIndicatorGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradeIndicatorColors, gradeIndicatorGradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor lightGrayColor];
    CGSize shadowOffset = CGSizeMake(0, 2);
    CGFloat shadowBlurRadius = 2;
    
    
    //// Rounded Rectangle Drawing
    UIRectCorner roundedCorners = INTERFACE_IS_PAD? UIRectCornerBottomLeft | UIRectCornerBottomRight : 0;

    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 87.5, self.frame.size.width - 1, 44) byRoundingCorners: roundedCorners cornerRadii: CGSizeMake(5, 5)];
    [color setFill];
    [roundedRectanglePath fill];
    
    
    ////// Rounded Rectangle Inner Shadow
    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
    
    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadowBlurRadius,
                                    shadow.CGColor);
        
        [roundedRectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
        [roundedRectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [roundedRectangleNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    
    [color2 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    //// Rounded Rectangle 2 Drawing
    roundedCorners = INTERFACE_IS_PAD? UIRectCornerTopLeft | UIRectCornerTopRight : 0;
    
    UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, self.frame.size.width - 1, 88) byRoundingCorners: roundedCorners cornerRadii: CGSizeMake(5, 5)];
    CGContextSaveGState(context);
    [roundedRectangle2Path addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(352, 0.5), CGPointMake(352, 88.5), 0);
    CGContextRestoreGState(context);
    
    [color2 setStroke];
    roundedRectangle2Path.lineWidth = 1;
    [roundedRectangle2Path stroke];
    
//    //Draw Clipped Cell Index
//    CGContextSaveGState(context);
//    {
//        [roundedRectangle2Path addClip];
//        
//        NSString *str = [NSString stringWithFormat:@"%i", [cellIndex integerValue]+1];
//        UIFont * font = [UIFont boldSystemFontOfSize:0.0f];
//        
//
//        //[[UIColor colorWithHue:0.583 saturation:0.019 brightness:0.839 alpha:1.000] setFill];
//        [cellIndexColor setFill];
//        [str drawAtPoint:CGPointMake(20.0, 65.0) forWidth:100.0 withFont:font fontSize:100.0f lineBreakMode:NSLineBreakByCharWrapping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
//    }
//    CGContextRestoreGState(context);
    
    
    

    //// Grade 9 Indicator
    roundedCorners = 0;
    if (INTERFACE_IS_PAD) roundedCorners = UIRectCornerBottomLeft; //Square on iPhone, rounded corners on iPad
    
    UIBezierPath* grade9RectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 88, gradesInvolvedIndicatorSpacing, 43.5) byRoundingCorners: roundedCorners cornerRadii: CGSizeMake(5, 5)];
    if ((gradesInvolved & kFTExtracurricularGradesInvolved9)) {
        CGContextSaveGState(context);
        [grade9RectanglePath addClip];
        CGContextDrawLinearGradient(context, gradeIndicatorGradient, CGPointMake(0.5 * gradesInvolvedIndicatorSpacing + 0.5, 87.5), CGPointMake(0.5 * gradesInvolvedIndicatorSpacing + 0.5, 131.5), 0); //Midsection starting and ending X values of gradient
    }
    
    [borderColor setStroke];
    grade9RectanglePath.lineWidth = 1;
    [grade9RectanglePath stroke];

    if ((gradesInvolved & kFTExtracurricularGradesInvolved9)) {
        UIBezierPath* purplePath = [UIBezierPath bezierPath];
        [purplePath moveToPoint: CGPointMake(0.5, 130.0)];
        [purplePath addLineToPoint: CGPointMake(gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [[gradeIndicatorColor colorWithAlphaComponent:1.0] setStroke];
        purplePath.lineWidth = 2;
        [purplePath stroke];
        
        CGContextRestoreGState(context);
    }
    
    if ((gradesInvolved & kFTExtracurricularGradesInvolved9))
        [gradeIndicatorTextColor setFill];
    else
        [titleColor setFill];
    
    [@"9" drawInRect:CGRectMake(1, 99, gradesInvolvedIndicatorSpacing, 43.5) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    //// Grade 10 Indicator
    UIBezierPath* grade10RectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(gradesInvolvedIndicatorSpacing + 0.5, 88, gradesInvolvedIndicatorSpacing, 43.5) byRoundingCorners: 0 cornerRadii: CGSizeMake(5, 5)];
    if ((gradesInvolved & kFTExtracurricularGradesInvolved10)) {
        CGContextSaveGState(context);
        [grade10RectanglePath addClip];
        CGContextDrawLinearGradient(context, gradeIndicatorGradient, CGPointMake(1.5 * gradesInvolvedIndicatorSpacing + 0.5, 87.5), CGPointMake(1.5 * gradesInvolvedIndicatorSpacing + 0.5, 131.5), 0); //Midsection starting and ending X values of gradient
        CGContextRestoreGState(context);
    }
    
    [borderColor setStroke];
    grade10RectanglePath.lineWidth = 1;
    [grade10RectanglePath stroke];
    
    if ((gradesInvolved & kFTExtracurricularGradesInvolved10)) {
        UIBezierPath* purplePath = [UIBezierPath bezierPath];
        [purplePath moveToPoint: CGPointMake(gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [purplePath addLineToPoint: CGPointMake(2 * gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [[gradeIndicatorColor colorWithAlphaComponent:1.0] setStroke];
        purplePath.lineWidth = 2;
        [purplePath stroke];
    }
    
    if ((gradesInvolved & kFTExtracurricularGradesInvolved10))
        [gradeIndicatorTextColor setFill];
    else
        [titleColor setFill];
    
    [@"10" drawInRect:CGRectMake(0.5 + gradesInvolvedIndicatorSpacing, 99, gradesInvolvedIndicatorSpacing, 43.5) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    //// Grade 11 Indicator
    UIBezierPath* grade11RectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2 * gradesInvolvedIndicatorSpacing + 0.5, 88, gradesInvolvedIndicatorSpacing, 43.5) byRoundingCorners: 0 cornerRadii: CGSizeMake(5, 5)];
    if ((gradesInvolved & kFTExtracurricularGradesInvolved11)) {
        CGContextSaveGState(context);
        [grade11RectanglePath addClip];
        CGContextDrawLinearGradient(context, gradeIndicatorGradient, CGPointMake(2.5 * gradesInvolvedIndicatorSpacing + 0.5, 87.5), CGPointMake(2.5 * gradesInvolvedIndicatorSpacing + 0.5, 131.5), 0);
        CGContextRestoreGState(context);
    }
    
    [borderColor setStroke];
    grade11RectanglePath.lineWidth = 1;
    [grade11RectanglePath stroke];
    
    if ((gradesInvolved & kFTExtracurricularGradesInvolved11)) {
        UIBezierPath* purplePath = [UIBezierPath bezierPath];
        [purplePath moveToPoint: CGPointMake(2 * gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [purplePath addLineToPoint: CGPointMake(3 * gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [[gradeIndicatorColor colorWithAlphaComponent:1.0] setStroke];
        purplePath.lineWidth = 2;
        [purplePath stroke];
    }
    
    if ((gradesInvolved & kFTExtracurricularGradesInvolved11))
        [gradeIndicatorTextColor setFill];
    else
        [titleColor setFill];
    
    [@"11" drawInRect:CGRectMake(0.5 + 2 * gradesInvolvedIndicatorSpacing, 99, gradesInvolvedIndicatorSpacing, 43.5) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    //// Grade 12 Indicator
    
    UIBezierPath* grade12RectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(3 * gradesInvolvedIndicatorSpacing + 0.5, 88, gradesInvolvedIndicatorSpacing, 43.5) byRoundingCorners: 0 cornerRadii: CGSizeMake(5, 5)];
    if ((gradesInvolved & kFTExtracurricularGradesInvolved12)) {
        CGContextSaveGState(context);
        [grade12RectanglePath addClip];
        CGContextDrawLinearGradient(context, gradeIndicatorGradient, CGPointMake(3.5 * gradesInvolvedIndicatorSpacing + 0.5, 87.5), CGPointMake(3.5 * gradesInvolvedIndicatorSpacing + 0.5, 131.5), 0);
        CGContextRestoreGState(context);
    }
    
    [borderColor setStroke];
    grade12RectanglePath.lineWidth = 1;
    [grade12RectanglePath stroke];
    
    if (gradesInvolved & kFTExtracurricularGradesInvolved12) {
        UIBezierPath* purplePath = [UIBezierPath bezierPath];
        [purplePath moveToPoint: CGPointMake(3 * gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [purplePath addLineToPoint: CGPointMake(4 * gradesInvolvedIndicatorSpacing + 0.5, 130.0)];
        [[gradeIndicatorColor colorWithAlphaComponent:1.0] setStroke];
        purplePath.lineWidth = 2;
        [purplePath stroke];
    }
    
    if (gradesInvolved & kFTExtracurricularGradesInvolved12)
        [gradeIndicatorTextColor setFill];
    else
        [titleColor setFill];
    
    [@"12" drawInRect:CGRectMake(0.5 + 3 * gradesInvolvedIndicatorSpacing, 99, gradesInvolvedIndicatorSpacing, 43.5) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    
    //// Text Drawing
    
    NSString *str1 = nil;
    [[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.5 alpha:1.0] setFill];
    
    if (INTERFACE_IS_PAD) {
        str1 =  @"hours per week";

        [str1 drawInRect:CGRectMake(self.frame.size.width - 380.0f, 99.0, 170.0, 33.0) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
    } else {
        str1 = @"hrs/wk";
        [str1 drawInRect:CGRectMake(self.frame.size.width - 180.0 - rightMargin, 99.0, 60.0, 33.0) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];

    }
    
    NSString *str2 = nil;
    
    [[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.5 alpha:1.0] setFill];
    if (INTERFACE_IS_PAD) {
        str2 = @"weeks per year";
        [str2 drawInRect:CGRectMake(self.frame.size.width - 182.0, 99.0, 130.0, 33.0) withFont:[UIFont boldSystemFontOfSize:17.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
    } else {
        str2 = @"wks/yr";
        CGFloat fontSize = INTERFACE_IS_PORTRAIT? 12.0:17.0;
        [str2 drawInRect:CGRectMake(self.frame.size.width - 90.0 - rightMargin, 99.0, 60.0, 33.0) withFont:[UIFont boldSystemFontOfSize:fontSize] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];

    }
    
    //// Bezier Drawing (Lines Drawing)
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(1, 88.5)];
    [bezierPath addLineToPoint: CGPointMake(self.frame.size.width - 1, 88.5)];
    [color3 setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    if (INTERFACE_IS_PAD) { //Draw in divider line between name and position.
        
        UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
        [bezierPath2 moveToPoint: CGPointMake(self.frame.size.width - 240.0, 1)];
        [bezierPath2 addLineToPoint: CGPointMake(self.frame.size.width - 240.0, 88)];
        [cellIndexColor setStroke];
        bezierPath2.lineWidth = 1;
        [bezierPath2 stroke];
    }
    
//    UIBezierPath* bezierPath3 = [UIBezierPath bezierPath];
//    [bezierPath3 moveToPoint: CGPointMake(self.frame.size.width - 238.0, 1)];
//    [bezierPath3 addLineToPoint: CGPointMake(self.frame.size.width - 238.0, 88)];
//    [[UIColor whiteColor] setStroke];
//    bezierPath3.lineWidth = 1;
//    [bezierPath3 stroke];

    
    //// Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(gradeIndicatorGradient);
    CGColorSpaceRelease(colorSpace);
    
    ////Simple UIKit Stuff
    
    _titleLabel.text = [self.activity name];
    _subtitleTextLabel.text = [self.activity position];
    NSString *str = [NSString stringWithFormat:@"%i", [cellIndex integerValue]+1];
    _cellIndexView.text = str;
    

}


@end
