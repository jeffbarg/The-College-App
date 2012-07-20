//
//  PhotoData.m
//  The College App
//
//  Created by Jeffrey Barg on 7/17/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "PhotoData.h"
#import "CampusPhoto.h"

@interface PhotoData () {
    
}

@property (nonatomic, strong) NSOperationQueue *bgQueue;

@end

@implementation PhotoData

@dynamic image;
@dynamic imageURL;
@dynamic campusPhoto;

@synthesize bgQueue;

- (UIImage *)image
{
    [self willAccessValueForKey:@"image"];
    UIImage *tmpValue = [self primitiveValueForKey:@"image"];
    [self didAccessValueForKey:@"image"];
    
    if (tmpValue == nil) {
        //get the documents directory:
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //get file name to read data using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, self.imageURL];
        
        //save content to the documents directory
        NSError *err = nil;
        NSData *data = [NSData dataWithContentsOfFile:fileName options:NSDataReadingMappedIfSafe error:&err];
        if (err != nil) {
            NSLog(@"%@", [err description]);
        }
        tmpValue = [UIImage imageWithData:data];
        
        [self setPrimitiveValue:tmpValue forKey:@"image"];
    }
    return tmpValue;
}
            
- (void)setImage:(UIImage *)value
{
    [self willChangeValueForKey:@"image"];
    [self setPrimitiveValue:value forKey:@"image"];
    [self didChangeValueForKey:@"image"];
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString * newUUID =  (__bridge_transfer NSString *)string;
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory, newUUID];
    
    bgQueue = [[NSOperationQueue alloc] init];
    [bgQueue addOperationWithBlock:^{
        //save content to the documents directory
        NSError *err = nil;
        

        if (![UIImageJPEGRepresentation(value, 1.0) writeToFile:fileName options:NSDataWritingAtomic error:&err]) {
            self.imageURL = nil;
            NSLog(@"%@", [err localizedDescription]);
        }
    }];

    self.imageURL = [NSString stringWithFormat:@"%@",
                     newUUID];
}

- (void)prepareForDeletion {
    if (self.imageURL != nil) {
        //get the documents directory:
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //get file name to read data using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, self.imageURL];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *err;
        if ([fileManager fileExistsAtPath:fileName])
            [fileManager removeItemAtPath:fileName error:&err];
        if (err != nil) {
            NSLog(@"%@", [err description]);
        }
        
    }
}

@end
