//
//  FTCollegeInfoViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/11/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;


@interface FTCollegeInfoViewController : UIViewController
    
@property (nonatomic, strong) College *school;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
