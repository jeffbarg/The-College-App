//
//  FTStandardizedTestView.m
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTStandardizedTestView.h"
#import "StandardizedTest.h"
#import "TestSection.h"

#import <QuartzCore/QuartzCore.h>

#define MARGIN_X 4
#define MARGIN_Y 4

@interface FTStandardizedTestView () {
    CGGradientRef _backgroundGradient;
    CGGradientRef _selecdtedBackgroundGradient;

}
- (CGGradientRef) backgroundGradient;
- (CGGradientRef) selectedBackgroundGradient;


@end


@implementation FTStandardizedTestView

@synthesize test = _test;
@synthesize buttonArray = _buttonArray;


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

- (void) setTest:(StandardizedTest *)test {
    _test = test;
    
    if (_buttonArray) {
        for (UIButton *button in _buttonArray) {
            [button removeFromSuperview];
        }
        _buttonArray = nil;
    }
    NSInteger sections = [self.test.testSections count];
    BOOL hasComposite = [self.test.hasComposite boolValue];
    if (hasComposite) sections ++;
    
    NSMutableArray *aButtonArray = [[NSMutableArray alloc] initWithCapacity:sections];
    for (int i = 0; i < sections; i++) {
        UIView *button = [[UIButton alloc] initWithFrame:CGRectZero];
//        [button.layer setBorderWidth:1.0];
//        [button.layer setBorderColor:[UIColor blackColor].CGColor];
        //[button setEnabled:NO];
        //[button setUserInteractionEnabled:NO];
        [self addSubview:button];
        [aButtonArray addObject:button];
    }
    self.buttonArray = [[NSArray alloc] initWithArray:aButtonArray];
}


- (CGGradientRef) backgroundGradient {
    if (_backgroundGradient == NULL) {
        
        //Draw gradient
        //// Gradient Declarations
        UIColor *topColor = [UIColor colorWithRed:0.933 green:0.949 blue:0.953 alpha:1.000];
        UIColor *bottomColor = [UIColor colorWithRed:0.867 green:0.890 blue:0.902 alpha:1.000];
        
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

- (CGGradientRef) selectedBackgroundGradient {
    if (_selecdtedBackgroundGradient == NULL) {
        
        //Draw gradient
        //// Gradient Declarations
        UIColor *topColor = [UIColor colorWithRed:0.667 green:0.690 blue:0.702 alpha:1.000];
        UIColor *bottomColor = [UIColor colorWithRed:0.133 green:0.749 blue:0.753 alpha:1.000];
        
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)topColor.CGColor,
                                   (id)bottomColor.CGColor, nil];
        
        CGFloat gradientLocations[] = {0, 1};        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _selecdtedBackgroundGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        CGColorSpaceRelease(colorSpace);
    }
    return _selecdtedBackgroundGradient;
}

- (void) layoutSubviews {
    int i = 0;
    for (UIView *button in self.buttonArray) {
        [button setFrame:[self rectForIndex:i]];
        i++;
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //Color Setup
    UIColor *borderColor = [UIColor colorWithWhite:0.686 alpha:1.000];
    
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // Drawing code
    UIBezierPath *fullPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5 + MARGIN_X, 0.5, self.bounds.size.width - 1.0 - 2 * MARGIN_X, self.bounds.size.height - 1.0 - MARGIN_Y) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CGContextSaveGState(ctx); {
        [fullPath setLineWidth:1.0];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 2.0, [UIColor colorWithWhite:0.5 alpha:0.5].CGColor);
        [borderColor setStroke];
        [fullPath stroke];
    } CGContextRestoreGState(ctx);
    

    
    CGContextSaveGState(ctx); {
        [fullPath addClip];        
        CGContextDrawLinearGradient(ctx, [self backgroundGradient], CGPointMake(0.0, 0.0), CGPointMake(0.0, self.bounds.size.height), 0);
    } CGContextRestoreGState(ctx);
    
    NSOrderedSet *testSections = self.test.testSections;
    
    NSInteger sections = [testSections count];
    BOOL hasComposite = [self.test.hasComposite boolValue];
    if (hasComposite) sections ++;
    
    for (int i = 0; i < sections; i ++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];

        UIColor *leftLineColor = [UIColor colorWithRed:0.969 green:0.976 blue:0.976 alpha:1.000]; // White Color
        UIColor *rightLineColor = [UIColor colorWithRed:0.827 green:0.839 blue:0.847 alpha:1.000]; // Gray Color
        
        
        if (button.highlighted || button.selected) {
            CGContextSaveGState(ctx); {
                UIRectCorner roundedCorners = 0;
                if (i == 0)
                    roundedCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
                else if (i == sections-1)
                    roundedCorners = UIRectCornerTopRight | UIRectCornerBottomRight;
                
                UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(button.frame, 1.0,1.0) byRoundingCorners:roundedCorners cornerRadii:CGSizeMake(4.0, 4.0)];
                
                [highlightPath addClip];
                CGContextDrawLinearGradient(ctx, [self backgroundGradient], CGPointMake(0.0, self.bounds.size.height), CGPointMake(0.0, 0.0), 0);
            } CGContextRestoreGState(ctx);
        }
        UIColor *textColor = [UIColor colorWithWhite:0.451 alpha:1.000];
        [textColor setFill];

        if (i !=0) {
            UIBezierPath *leftLine = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(button.frame), 1.0, 1.0, CGRectGetHeight(button.frame) - 2.0)];
            [leftLineColor setFill];
            [leftLine fill];
        }
        if (i != sections-1) {
            UIBezierPath *rightLine = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMaxX(button.frame) - 2.0, 1.0, 1.0, CGRectGetHeight(button.frame) - 2.0)];
            [rightLineColor setFill];
            [rightLine fill];
        }
        
        if (hasComposite && i == sections-1) {
            //Show Composite
            continue;
        }
        TestSection *section = [testSections objectAtIndex:i];

        [textColor setFill];
        
        [section.sectionName drawAtPoint:CGPointMake(button.frame.origin.x + 20, button.frame.origin.y + 20) forWidth:button.frame.size.width - 40.0 withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip];

        [[UIColor colorWithWhite:0.337 alpha:1.000] setFill];
        
        NSString *str = [NSString stringWithFormat:@"%@", section.score];
        [str drawInRect:CGRectMake(button.frame.origin.x + 15.0, button.frame.origin.y + 52.0, button.frame.size.width - 30.0, self.frame.size.height - 52.0) withFont:[UIFont boldSystemFontOfSize:45.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
    }
    
    
}

- (CGRect) rectForIndex: (NSInteger) index{
    CGRect rect = CGRectZero;
    rect.origin.y = 0;
    rect.size.height = self.frame.size.height - MARGIN_Y;
    
    if (self.test) {
        NSInteger sections = [self.test.testSections count];
        BOOL hasComposite = [self.test.hasComposite boolValue];
        if (hasComposite) sections ++;
        CGFloat lastOffset = hasComposite?75.0:0.0;
        
        CGFloat buttonWidth = (self.frame.size.width - lastOffset) / (CGFloat)sections;
        
        rect.size.width = buttonWidth + ((index == sections -1)? lastOffset-MARGIN_X:0);
        
        if (index == 0) {
            rect.origin.x = MARGIN_X;
            rect.size.width -= MARGIN_X;
        }
        else
            rect.origin.x = buttonWidth * index;
    }
    NSLog(@"%@",NSStringFromCGRect(rect));
    return CGRectIntegral(rect);
}


@end
