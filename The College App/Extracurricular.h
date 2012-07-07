//
//  Extracurricular.h
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    kFTExtracurricularGradesInvolved9 = 1<<0,
    kFTExtracurricularGradesInvolved10 = 1<<1,
    kFTExtracurricularGradesInvolved11 = 1<<2,
    kFTExtracurricularGradesInvolved12 = 1<<3
} FTExtracurricularGradesInvolved;

@interface Extracurricular : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * gradesInvolved;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * weeks;
@property (nonatomic, retain) NSNumber * index;


@end
