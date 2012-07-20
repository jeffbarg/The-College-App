//
//  TestSection.h
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StandardizedTest;

@interface TestSection : NSManagedObject

@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSNumber * minScore;
@property (nonatomic, retain) NSNumber * maxScore;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) StandardizedTest *standardizedTest;

@end
