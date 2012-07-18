//
//  Visit.h
//  The College App
//
//  Created by Jeffrey Barg on 7/18/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CampusPhoto, College;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *campusPhotos;
@property (nonatomic, retain) NSSet *campusRatings;
@property (nonatomic, retain) College *college;
@end

@interface Visit (CoreDataGeneratedAccessors)

- (void)addCampusPhotosObject:(CampusPhoto *)value;
- (void)removeCampusPhotosObject:(CampusPhoto *)value;
- (void)addCampusPhotos:(NSSet *)values;
- (void)removeCampusPhotos:(NSSet *)values;

- (void)addCampusRatingsObject:(NSManagedObject *)value;
- (void)removeCampusRatingsObject:(NSManagedObject *)value;
- (void)addCampusRatings:(NSSet *)values;
- (void)removeCampusRatings:(NSSet *)values;

@end
