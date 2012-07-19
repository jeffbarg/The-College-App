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

#import "FTAmazonConstants.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "S3RequestDelegate.h"

@interface CampusPhoto ()

@property (nonatomic, strong) S3RequestDelegate * s3Delegate;

@end

@implementation CampusPhoto

@dynamic caption;
@dynamic dateCreated;
@dynamic thumbnailImage;
@dynamic latitude;
@dynamic longitude;
@dynamic visit;
@dynamic photoData;

@synthesize s3Delegate = _s3Delegate;

+ (void)initialize {
	if (self == [CampusPhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

            
- (void)setPhotoData:(PhotoData *)photoData {
    [self willChangeValueForKey:@"photoData"];
    [self setPrimitiveValue:photoData forKey:@"photoData"];
    [self didChangeValueForKey:@"photoData"];
    
    if (photoData != nil) {
        [self attemptUploadToCloud];
    }
}

- (void) attemptUploadToCloud {

    NSData *imageData = UIImageJPEGRepresentation(self.photoData.image, 1.0);
        
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        
    NSString *keyName    = [NSString stringWithFormat:@"File%@", [[NSDate date] description]];

    
    // Put the file as an object in the bucket.
    S3PutObjectRequest * putObjectRequest          = [[S3PutObjectRequest alloc] initWithKey:keyName inBucket:PICTURE_BUCKET];
    putObjectRequest.data = imageData;
    [putObjectRequest setDelegate:self.s3Delegate];
    
    // When using delegates the return is nil.
    [s3 putObject:putObjectRequest];

}

- (NSData *) dataRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:UIImageJPEGRepresentation(self.photoData.image, 1.0) forKey:@"image"];
    
    return nil;
}

- (S3RequestDelegate *) s3Delegate {
    if (_s3Delegate) return _s3Delegate;
    
    _s3Delegate = [[S3RequestDelegate alloc] init];
    
    return _s3Delegate;
}

@end
