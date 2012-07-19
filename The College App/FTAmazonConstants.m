//
//  FTAmazonConstants.m
//  The College App
//
//  Created by Jeffrey Barg on 7/19/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAmazonConstants.h"

@implementation FTAmazonConstants

+(NSString *)pictureBucket
{
    return [NSString stringWithFormat:@"%@", PICTURE_BUCKET];
}

+ (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

+(UIAlertView *)credentialsAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Missing Credentials" message:CREDENTIALS_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
