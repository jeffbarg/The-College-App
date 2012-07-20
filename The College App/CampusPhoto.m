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
#import "College.h"

#import "UIImageToDataTransformer.h"

#import "SBJson.h"

#import "FTAmazonConstants.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "S3RequestDelegate.h"

@interface CampusPhoto ()

@property (nonatomic, strong) S3RequestDelegate * s3Delegate;
@property (nonatomic, strong) S3PutObjectRequest * putObjectRequest;

@end

@implementation CampusPhoto

@dynamic caption;
@dynamic dateCreated;
@dynamic thumbnailImage;
@dynamic latitude;
@dynamic longitude;
@dynamic visit;
@dynamic photoData;
@dynamic uploaded;

@synthesize s3Delegate = _s3Delegate;
@synthesize putObjectRequest;

+ (void)initialize {
	if (self == [CampusPhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

- (void)awakeFromFetch {
    if (![self.uploaded boolValue]) {
        [self attemptUploadToCloud];
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
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{

        NSData *imageData = UIImageJPEGRepresentation(self.photoData.image, INTERFACE_IS_PAD? 1.0 : 0.9);
            
        AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
            
        NSString * FTDeviceUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kUUIDKeyDefaults];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM|dd|yyyy-hh:mma"];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        
        NSString *keyName    = [NSString stringWithFormat:@"%@/%@@%@", [self.visit.college.unitID description], FTDeviceUUID, [formatter stringFromDate:[NSDate date]]];

        
        // Put the file as an object in the bucket.
        putObjectRequest          = [[S3PutObjectRequest alloc] initWithKey:keyName inBucket:PICTURE_BUCKET];
        putObjectRequest.data = imageData;
        putObjectRequest.contentEncoding = @"image/jpeg";
        
        putObjectRequest.expires = 1000.0 * 20.0;
        
        [putObjectRequest setDelegate:self.s3Delegate];

        // When using delegates the return is nil.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [s3 putObject:putObjectRequest];
        }];

    }];

}

- (NSData *) dataRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:UIImageJPEGRepresentation(self.photoData.image, 1.0) forKey:@"image"];
    
    return nil;
}

- (void) prepareForDeletion {
    if (putObjectRequest != nil && putObjectRequest.urlConnection != nil) {
        [putObjectRequest.urlConnection cancel];
    }
    self.putObjectRequest = nil;
    self.s3Delegate = nil;
    
}

- (S3RequestDelegate *) s3Delegate {
    if (_s3Delegate) return _s3Delegate;
    
    _s3Delegate = [[S3RequestDelegate alloc] init];
    [_s3Delegate setCampusPhoto:self];
    return _s3Delegate;
}

@end
