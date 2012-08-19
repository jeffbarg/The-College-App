//
//  CollegeList.h
//  The College App
//
//  Created by Jeffrey Barg on 8/19/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class College;

@interface CollegeList : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *colleges;
@end

@interface CollegeList (CoreDataGeneratedAccessors)

- (void)insertObject:(College *)value inCollegesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCollegesAtIndex:(NSUInteger)idx;
- (void)insertColleges:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCollegesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCollegesAtIndex:(NSUInteger)idx withObject:(College *)value;
- (void)replaceCollegesAtIndexes:(NSIndexSet *)indexes withColleges:(NSArray *)values;
- (void)addCollegesObject:(College *)value;
- (void)removeCollegesObject:(College *)value;
- (void)addColleges:(NSOrderedSet *)values;
- (void)removeColleges:(NSOrderedSet *)values;
@end
