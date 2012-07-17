//
//  CampusPhoto.m
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "CampusPhoto.h"
#import "Visit.h"

#import "UIImageToDataTransformer.h"

@implementation CampusPhoto

@dynamic caption;
@dynamic latitude;
@dynamic longitude;
@dynamic image;
@dynamic dateCreated;
@dynamic visit;

+ (void)initialize {
	if (self == [CampusPhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
