//
//  FTRangeIndicator.h
//  The College App
//
//  Created by Jeffrey Barg on 7/11/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTRangeIndicator : UIView

@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat maxValue;

@property (nonatomic) CGFloat value;

@property (nonatomic) CGFloat lowerBound;
@property (nonatomic) CGFloat upperBound;

@end
