//
//  PhotoData.h
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CampusPhoto;

@interface PhotoData : NSManagedObject

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) CampusPhoto *campusPhoto;

@end
