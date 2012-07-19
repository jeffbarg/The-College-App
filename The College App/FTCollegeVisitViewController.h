//
//  FTCollegeVisitViewController.h
//  The College App
//
//  Created by Jeffrey Barg on 7/12/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;
@class Visit;

@interface FTCollegeVisitViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) College *school;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@property (nonatomic, strong) Visit *visit;

@property (nonatomic) BOOL isNotepadFocused;

- (void) bringFocusToNotepad;
- (void) unfocusNotepad;

@end
