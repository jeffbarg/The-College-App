//
//  GTPopoverBackgorundView.m
//
//  Created by Chris Scianski on 12.02.2012.
//  Copyright (c) 2012 www.scinaski.com. All rights reserved.
//

#import "KSCustomPopoverBackgroundView.h"
#import "UIImage+UIImage_StandardFeatures.h"

#import <QuartzCore/QuartzCore.h>

// Predefined arrow image width and height
#define ARROW_WIDTH 34.0
#define ARROW_HEIGHT 18.0

// Predefined content insets
#define TOP_CONTENT_INSET 8
#define LEFT_CONTENT_INSET 8
#define BOTTOM_CONTENT_INSET 10
#define RIGHT_CONTENT_INSET 8

#pragma mark - Private interface

@interface KSCustomPopoverBackgroundView ()
{    
    UIImage *_topArrowImage;
    UIImage *_leftArrowImage;
    UIImage *_rightArrowImage;
    UIImage *_bottomArrowImage;
}

@end

#pragma mark - Implementation

@implementation KSCustomPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset, arrowDirection = _arrowDirection, popoverBackgroundImageView = _popoverBackgroundImageView, arrowImageView = _arrowImageView;

#pragma mark - Overriden class methods

// The width of the arrow triangle at its base.
+ (CGFloat)arrowBase 
{
    return ARROW_WIDTH;
}

// The height of the arrow (measured in points) from its base to its tip.
+ (CGFloat)arrowHeight
{
    return ARROW_HEIGHT;
}

// The insets for the content portion of the popover.
+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(TOP_CONTENT_INSET, LEFT_CONTENT_INSET, BOTTOM_CONTENT_INSET, RIGHT_CONTENT_INSET);
}

#pragma mark - Custom setters for updating layout

// Whenever arrow changes direction or position layout subviews will be called in order to update arrow and backgorund frames

-(void) setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

-(void) setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame 
{    
    if (self = [super initWithFrame:frame])
    {
        _topArrowImage = [UIImage imageNamed:@"toparrow.png"];
        _leftArrowImage = [UIImage imageNamed:@"leftarrow.png"];
        _bottomArrowImage = [UIImage imageNamed:@"bottomarrow.png"];
        _rightArrowImage = [UIImage imageNamed:@"rightarrow.png"];
                             
//        UIImage *popoverBackgroundImage = [[UIImage imageNamed:@"popover-black-bcg-image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(49, 46, 49, 45)];
        UIImage *popoverBackgroundImage = [[UIImage imageNamed:@"popover.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(48.0, 12.0, 10.0, 12.0)];
        self.popoverBackgroundImageView = [[UIImageView alloc] initWithImage:popoverBackgroundImage];
        [self addSubview:self.popoverBackgroundImageView];
        
        self.arrowImageView = [[UIImageView alloc] init];
        [self addSubview:self.arrowImageView];
        
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0.0, 5.0)];
        [self.layer setShadowRadius:20.0];
        [self.layer setShadowOpacity:0.5];
         
    }
    
    return self;
}

#pragma mark - Layout subviews

-(void)layoutSubviews
{    
    CGFloat popoverImageOriginX = 0;
    CGFloat popoverImageOriginY = 0;
    
    CGFloat popoverImageWidth = self.bounds.size.width;
    CGFloat popoverImageHeight = self.bounds.size.height;
    
    CGFloat arrowImageOriginX = 0;
    CGFloat arrowImageOriginY = 0;
    
    CGFloat arrowImageWidth = ARROW_WIDTH;
    CGFloat arrowImageHeight = ARROW_HEIGHT;
    
    // Radius value you used to make rounded corners in your popover background image
    CGFloat cornerRadius = 9;
    
    switch (self.arrowDirection) {
            
        case UIPopoverArrowDirectionUp:
            
            popoverImageOriginY = ARROW_HEIGHT - 2;
            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT;
            
            // Calculating arrow x position using arrow offset, arrow width and popover width
            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset) - 5.0; //THE MINUS ONE IS CHANGED
            
            // If arrow image exceeds rounded corner arrow image x postion is adjusted 
            if (arrowImageOriginX + ARROW_WIDTH > self.bounds.size.width - cornerRadius)
            {
                arrowImageOriginX -= cornerRadius;
            }
            
            if (arrowImageOriginX < cornerRadius)
            {
                arrowImageOriginX += cornerRadius;
            }
            
            // Setting arrow image for current arrow direction
            self.arrowImageView.image = _topArrowImage;
            
            break; 
            
        case UIPopoverArrowDirectionDown:
            
            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT + 2;
            
            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset);
            
            if (arrowImageOriginX + ARROW_WIDTH > self.bounds.size.width - cornerRadius)
            {
                arrowImageOriginX -= cornerRadius;
            }
            
            if (arrowImageOriginX < cornerRadius)
            {
                arrowImageOriginX += cornerRadius;
            }
            
            arrowImageOriginY = popoverImageHeight - 2;
            
            self.arrowImageView.image = _bottomArrowImage;
            
            break;
            
        case UIPopoverArrowDirectionLeft:
            
            popoverImageOriginX = ARROW_HEIGHT - 2;
            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT;
            
            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);
            
            if (arrowImageOriginY + ARROW_WIDTH > self.bounds.size.height - cornerRadius)
            {
                arrowImageOriginY -= cornerRadius;
            }
            
            if (arrowImageOriginY < cornerRadius)
            {
                arrowImageOriginY += cornerRadius;
            }
            
            arrowImageWidth = ARROW_HEIGHT;
            arrowImageHeight = ARROW_WIDTH;
            
            self.arrowImageView.image = _leftArrowImage;
            
            break;
            
        case UIPopoverArrowDirectionRight:
            
            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT + 2;
            
            arrowImageOriginX = popoverImageWidth - 2;
            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);
            
            if (arrowImageOriginY + ARROW_WIDTH > self.bounds.size.height - cornerRadius)
            {
                arrowImageOriginY -= cornerRadius;
            }
            
            if (arrowImageOriginY < cornerRadius)
            {
                arrowImageOriginY += cornerRadius;
            }
            
            arrowImageWidth = ARROW_HEIGHT;
            arrowImageHeight = ARROW_WIDTH;
            
            self.arrowImageView.image = _rightArrowImage;
            
            break;
            
        default:
            break;
    }
    
    self.popoverBackgroundImageView.frame = CGRectMake(popoverImageOriginX, popoverImageOriginY, popoverImageWidth, popoverImageHeight);
    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
}

@end
