//
//  FTCollegeCellView.h
//  The College App
//
//  Created by Jeffrey Barg on 7/9/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCollegeCellView : UIView

@property (nonatomic, strong) UILabel       * titleLabel;
@property (nonatomic, strong) UILabel       * subtitleLabel;
@property (nonatomic, strong) UILabel       * satScore;
@property (nonatomic, retain) UILabel       * actScore;

@property (nonatomic, strong) UIImageView   * locationIndicatorView;

@end
