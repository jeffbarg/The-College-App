//
//  CampusPhoto.m
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "CampusPhoto.h"
#import "PhotoData.h"
#import "Visit.h"
#import "UIImageToDataTransformer.h"

#import "SBJson.h"

@interface CampusPhoto ()

@end

@implementation CampusPhoto

@dynamic caption;
@dynamic dateCreated;
@dynamic thumbnailImage;
@dynamic latitude;
@dynamic longitude;
@dynamic visit;
@dynamic photoData;

+ (void)initialize {
	if (self == [CampusPhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

- (void) attemptUploadToCloud {
    
}

- (NSData *) dataRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:UIImageJPEGRepresentation(self.photoData.image, 1.0) forKey:@"image"];
    
}

@end
