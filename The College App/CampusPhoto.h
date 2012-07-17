//
//  CampusPhoto.h
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visit;

@interface CampusPhoto : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) Visit *visit;

@end
