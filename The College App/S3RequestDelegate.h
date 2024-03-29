/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


#import "CampusPhoto.h"
#import <AWSiOSSDK/AmazonServiceResponse.h>

@interface S3RequestDelegate:NSObject<AmazonServiceRequestDelegate>
{
    UILabel *bytesIn;
    UILabel *bytesOut;

    @public
    AmazonServiceResponse *response;
    NSException           *exception;
    NSError               *error;
}

@property (nonatomic, readonly) AmazonServiceResponse *response;
@property (nonatomic, readonly) NSError               *error;
@property (nonatomic, readonly) NSException           *exception;
@property (nonatomic, retain)   UILabel               *bytesIn;
@property (nonatomic, retain)   UILabel               *bytesOut;

@property (nonatomic, strong) CampusPhoto *campusPhoto;

-(bool)isFinishedOrFailed;
-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response;
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response;
-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data;
-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error;
-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception;



@end
