//
//  FTAddExtracurricularViewController.h
//  The College App
//
//  Created by Jeff Barg on 7/5/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Extracurricular;

@interface FTAddExtracurricularViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL isEditController;

@property (nonatomic, strong) Extracurricular * activity;

@end
