//
//  FTRatingsCell.h
//  The College App
//
//  Created by Jeffrey Barg on 8/15/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNearbyCollegeCell.h"

@interface FTRatingsCell : UITableViewCell
    
@property (nonatomic, strong) UILabel *ratingsTextLabel;
@property (nonatomic, strong) NSArray *starButtons;

@end
