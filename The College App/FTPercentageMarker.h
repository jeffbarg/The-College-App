//
//  FTPercentageMarker.h
//  The College App
//
//  Created by Jeffrey Barg on 8/9/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPercentageMarker : UIView

@property (nonatomic) CGFloat percent;
@property (nonatomic, strong) NSString * centerText;
@property (nonatomic, strong) NSString * leftText;
@property (nonatomic, strong) NSString * rightText;
@property (nonatomic, strong) UIColor *leftColor;
@property (nonatomic, strong) UIColor *rightColor;

@end
