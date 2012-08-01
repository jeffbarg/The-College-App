//
//  CampusPhoto.h
//  The College App
//
//  Created by Jeffrey Barg on 7/31/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoData, Visit;

@interface CampusPhoto : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) id thumbnailImage;
@property (nonatomic, retain) NSNumber * uploaded;
@property (nonatomic, retain) PhotoData *photoData;
@property (nonatomic, retain) Visit *visit;

@end
