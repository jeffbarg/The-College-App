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

#import "S3RequestDelegate.h"

@implementation S3RequestDelegate

@synthesize response;
@synthesize error;
@synthesize exception;
@synthesize bytesIn;
@synthesize bytesOut;

@synthesize campusPhoto = _campusPhoto;

-(id)init
{
    self = [super init];
    if (self)
    {
        response  = nil;
        exception = nil;
        error     = nil;
        bytesIn   = nil;
        bytesOut  = nil;
    }
    return self;
}

-(bool)isFinishedOrFailed
{
    return (response != nil || error != nil || exception != nil);
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)aResponse
{
    NSLog(@"didReceiveResponse");
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)aResponse
{
    NSLog(@"didCompleteWithResponse : %@", aResponse);
    response = aResponse;
    [self.campusPhoto setUploaded:[NSNumber numberWithBool:YES]];
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    int total = [bytesIn.text intValue];
    total       += [data length];
    bytesIn.text = [NSString stringWithFormat:@"%d", total];
}

-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"didSendData");
    int total = [bytesOut.text intValue];
    total        += bytesWritten;
    bytesOut.text = [NSString stringWithFormat:@"%d", total];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)theError
{
    [self.campusPhoto setUploaded:[NSNumber numberWithBool:NO]];
    NSLog(@"didFailWithError : %@", theError);
    error = theError;
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)theException
{
    NSLog(@"didFailWithServiceException : %@", theException);
    exception = theException;
}


@end





