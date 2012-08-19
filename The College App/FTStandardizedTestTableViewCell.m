//
//  FTStandardizedTestTableViewCell.m
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTStandardizedTestingViewController.h"
#import "FTStandardizedTestTableViewCell.h"
#import "FTStandardizedTestView.h"

#define MARGIN_X 20
#define MARGIN_Y 15

#define SIDE_PEEK 60.0

@interface FTStandardizedTestTableViewCell ()

@property (nonatomic, strong) UIButton * deleteButton;

@end

@implementation FTStandardizedTestTableViewCell

@synthesize testView = _testView;
@synthesize viewController;

@synthesize deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
        self.editing = NO;
        self.multipleTouchEnabled = NO;
        _testView = [[FTStandardizedTestView alloc] initWithFrame:CGRectZero];
        [_testView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_testView setContentMode:UIViewContentModeRedraw];
        [self.contentView addSubview:self.testView];
        
        UIGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        [self addGestureRecognizer:swipeGesture];
    }
    return self;
}

- (void) layoutSubviews {
    if (self.editing) {
        [self.testView setFrame:CGRectMake(2 * MARGIN_X + 80.0, MARGIN_Y, self.frame.size.width - 140.0, self.frame.size.height - 2 * MARGIN_Y)];
    } else {
        [self.testView setFrame:CGRectMake(2 * MARGIN_X + 80.0 + SIDE_PEEK, MARGIN_Y, self.frame.size.width - 140.0, self.frame.size.height - 2 * MARGIN_Y)];
    }
}

- (void) swipe:(UISwipeGestureRecognizer *) swipeGesture {

    if ([swipeGesture direction] == UISwipeGestureRecognizerDirectionRight) {
        for (UITableViewCell * cell in [self.viewController.tableView visibleCells]) {
            if (cell != self)
                [cell setEditing:NO animated:YES];
        }
        self.editing = YES;
    } else if ([swipeGesture direction] == UISwipeGestureRecognizerDirectionLeft) {
        self.editing = NO;
    }
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:YES];
    
//    if (editing) {
//        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.testView.frame.origin.x, CGRectGetMinY(self.testView.frame) + CGRectGetHeight(self.testView.frame)/2.0 - 13.0, 25, 26.0)];
//        [deleteButton setBackgroundImage:[UIImage imageNamed:@"rounddelete.png"] forState:UIControlStateNormal];
//        [self addSubview: deleteButton];
//        
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            [self.testView setFrame:CGRectMake(2 * MARGIN_X + 80.0 + SIDE_PEEK, MARGIN_Y, self.frame.size.width - 140.0, self.frame.size.height - 2 * MARGIN_Y)];
//        }];
//    } else {
//        [UIView animateWithDuration:0.4 animations:^{
//            [self.testView setFrame:CGRectMake(2 * MARGIN_X + 80.0, MARGIN_Y, self.frame.size.width - 140.0, self.frame.size.height - 2 * MARGIN_Y)];
//        } completion:^(BOOL finished) {
//            [self.deleteButton removeFromSuperview];
//        }];
//    }
}

- (void) didAddSubview:(UIView *)subview {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSArray *buttonArray = self.testView.buttonArray;
    for (UIButton *button in buttonArray) {
        if (CGRectContainsPoint(button.frame, [touch locationInView:self.testView])) {
            [button setHighlighted:YES];
            [self.testView setNeedsDisplayInRect:button.frame];
        }
    }
    [self.testView setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSArray *buttonArray = self.testView.buttonArray;
    UIButton *selButton = nil;
    for (UIButton *button in buttonArray) {
        if (button.highlighted) {
            selButton = button;
        }
        [button setSelected:NO];
        [button setHighlighted:NO];
    }
    if (CGRectContainsPoint(selButton.frame, [touch locationInView:self.testView])) {
        [selButton setSelected:YES];
        [self.viewController presentEditPopoverFromButton:selButton fromTestView:self.testView];
    } else {
        if (self.viewController.masterPopoverController && [self.viewController.masterPopoverController isPopoverVisible])
            [self.viewController.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    [self.testView setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSArray *buttonArray = self.testView.buttonArray;
    for (UIButton *button in buttonArray) {
        if (CGRectContainsPoint(button.frame, [touch locationInView:self.testView])) {
            [button setHighlighted:NO];
            [self.testView setNeedsDisplay];
        }
    }
    [self.testView setNeedsDisplay];
}
@end
