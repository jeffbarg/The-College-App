//
//  FTSegmentedControllerViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 8/15/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTSegmentedControllerViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic) NSInteger selectedIndex;

@end
