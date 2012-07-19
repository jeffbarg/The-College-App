//
//  FTAmazonConstants.h
//  The College App
//
//  Created by Jeffrey Barg on 7/19/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"AKIAJBVHR6LPIDW43SRQ"
#define SECRET_KEY             @"d8tmoRLbqxnKeIlqLCgCz+52x4N/ClZ/Zzl/GRpM"


// Constants for the Bucket and Object name.
#define PICTURE_BUCKET         @"FTCollegeAppImages"

#define CREDENTIALS_MESSAGE    @"AWS Credentials not configured correctly.  Please review the README file."


@class AmazonS3Client;

@interface FTAmazonConstants : NSObject


/**
 * Utility method to create a bucket name using the Access Key Id.  This will help ensure uniqueness.
 */
+(NSString *)pictureBucket;


/**
 * Utility method to display an alert message.  Used to communicate errors and failures.
 */
+(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title;



+(UIAlertView *)credentialsAlert;
 
+ (AmazonS3Client *) s3Client;

@end

