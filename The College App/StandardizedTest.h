//
//  StandardizedTest.h
//  The College App
//
//  Created by Jeffrey Barg on 7/23/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestSection;

@interface StandardizedTest : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateTaken;
@property (nonatomic, retain) NSNumber * hasComposite;
@property (nonatomic, retain) NSNumber * sectionPriority;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSOrderedSet *testSections;
@end

@interface StandardizedTest (CoreDataGeneratedAccessors)

- (void)insertObject:(TestSection *)value inTestSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTestSectionsAtIndex:(NSUInteger)idx;
- (void)insertTestSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTestSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTestSectionsAtIndex:(NSUInteger)idx withObject:(TestSection *)value;
- (void)replaceTestSectionsAtIndexes:(NSIndexSet *)indexes withTestSections:(NSArray *)values;
- (void)addTestSectionsObject:(TestSection *)value;
- (void)removeTestSectionsObject:(TestSection *)value;
- (void)addTestSections:(NSOrderedSet *)values;
- (void)removeTestSections:(NSOrderedSet *)values;
@end
