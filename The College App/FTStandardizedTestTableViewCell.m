//
//  FTStandardizedTestTableViewCell.m
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTStandardizedTestTableViewCell.h"
#import "FTStandardizedTestView.h"

#define MARGIN_X 20
#define MARGIN_Y 15

@implementation FTStandardizedTestTableViewCell

@synthesize testView = _testView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _testView = [[FTStandardizedTestView alloc] initWithFrame:CGRectZero];
        [_testView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_testView setContentMode:UIViewContentModeRedraw];
        [self.contentView addSubview:self.testView];
    }
    return self;
}

- (void) layoutSubviews {
    [self.testView setFrame:CGRectMake(2 * MARGIN_X + 80.0, MARGIN_Y, self.frame.size.width - 140.0, self.frame.size.height - 2 * MARGIN_Y)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
