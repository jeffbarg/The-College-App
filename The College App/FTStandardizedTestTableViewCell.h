//
//  FTStandardizedTestTableViewCell.h
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTStandardizedTestView;
@class FTStandardizedTestingViewController;

@interface FTStandardizedTestTableViewCell : UITableViewCell

@property (nonatomic, strong) FTStandardizedTestView * testView;
@property (nonatomic, weak)   FTStandardizedTestingViewController *viewController;

@end
