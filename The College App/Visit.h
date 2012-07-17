//
//  Visit.h
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class College;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) College *college;
@property (nonatomic, retain) NSSet *campusPhotos;
@property (nonatomic, retain) NSSet *campusRatings;
@end

@interface Visit (CoreDataGeneratedAccessors)

- (void)addCampusPhotosObject:(NSManagedObject *)value;
- (void)removeCampusPhotosObject:(NSManagedObject *)value;
- (void)addCampusPhotos:(NSSet *)values;
- (void)removeCampusPhotos:(NSSet *)values;

- (void)addCampusRatingsObject:(NSManagedObject *)value;
- (void)removeCampusRatingsObject:(NSManagedObject *)value;
- (void)addCampusRatings:(NSSet *)values;
- (void)removeCampusRatings:(NSSet *)values;

@end
