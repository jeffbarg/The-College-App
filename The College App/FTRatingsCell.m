//
//  FTRatingsCell.m
//  The College App
//
//  Created by Jeffrey Barg on 8/15/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTRatingsCell.h"

@interface FTRatingsCell ()

@property (nonatomic, strong) UIView * starContainer;

@end
@implementation FTRatingsCell

@synthesize starButtons;
@synthesize ratingsTextLabel;
@synthesize starContainer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        starContainer = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 5 * 50.0) / 2.0, 40.0, 5 * 250.0, 50.0)];
        [starContainer setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:starContainer];

        ratingsTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [ratingsTextLabel setTextColor:[UIColor blackColor]];
        [ratingsTextLabel setShadowColor:[UIColor whiteColor]];
        [ratingsTextLabel setShadowOffset:CGSizeMake(0, 1)];
        [ratingsTextLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [ratingsTextLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:ratingsTextLabel];
        
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:5];

        for (int i = 0; i < 5; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * 50.0, 0.0, 50.0, 50.0)];
            [starContainer addSubview:button];
            [mArray addObject:button];
            [button setImage:[UIImage imageNamed:@"unstarred.png"] forState:UIControlStateNormal];


            [button setShowsTouchWhenHighlighted:YES];
            [button setAutoresizingMask:UIViewAutoresizingNone];
            [button addTarget:self action:@selector(starButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self setStarButtons:[[NSArray alloc] initWithArray:mArray]];
        
    }
    return self;
}

- (void) layoutSubviews {
    [self.starContainer setFrame:CGRectMake((320.0 - 5 * 50.0) / 2.0, 40.0, 5 * 50.0, 50.0)];
    [self.ratingsTextLabel setFrame:CGRectMake(20.0, 15.0, self.frame.size.width - 40.0, 30.0)];
}

- (void) starButton:(UIButton *)button {
    NSInteger index = [self.starButtons indexOfObject:button];
    
    for (int i = 0; i < [self.starButtons count]; i++) { 
        UIButton *starButton = [self.starButtons objectAtIndex:i];
        if (i <= index)
            [starButton setImage:[UIImage imageNamed:@"starred.png"] forState:UIControlStateNormal];
        else
            [starButton setImage:[UIImage imageNamed:@"unstarred.png"] forState:UIControlStateNormal];
            
    }
}

- (void) prepareForReuse {
    for (UIButton *starButton in self.starButtons) { 
        [starButton setImage:[UIImage imageNamed:@"unstarred.png"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = [UIColor colorWithHue:0.574 saturation:0.036 brightness:0.969 alpha:1.000];
    
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
