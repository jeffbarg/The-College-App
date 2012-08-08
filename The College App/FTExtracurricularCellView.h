//
//  FTExtracurricularCell.h
//  The College App
//
//  Created by Jeff Barg on 6/25/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Extracurricular;
@class FTExtracurricularsViewController;

@interface FTExtracurricularCellView : UIView

@property (nonatomic, strong) NSNumber *cellIndex;
@property (nonatomic, strong) Extracurricular *activity;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) FTExtracurricularsViewController *viewController;

- (void) updateCellIndex:(NSInteger) index animated:(BOOL) animated;
- (void) redisplayInformation;

@end
