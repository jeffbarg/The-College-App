//
//  StandardizedTest.h
//  The College App
//
//  Created by Jeff Barg on 7/20/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestSection;

@interface StandardizedTest : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * hasComposite;
@property (nonatomic, retain) NSDate * dateTaken;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * sectionPriority;
@property (nonatomic, retain) NSSet *testSections;
@end

@interface StandardizedTest (CoreDataGeneratedAccessors)

- (void)addTestSectionsObject:(TestSection *)value;
- (void)removeTestSectionsObject:(TestSection *)value;
- (void)addTestSections:(NSSet *)values;
- (void)removeTestSections:(NSSet *)values;

@end
