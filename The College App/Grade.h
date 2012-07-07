//
//  Grade.h
//  The College App
//
//  Created by Jeffrey Barg on 7/6/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grade : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * honors;
@property (nonatomic, retain) NSNumber * fullCredit;

@end
