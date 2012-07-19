//
//  UIImage+UIImage_StandardFeatures.h
//  MGImageUtilities
//
//  Created by Jeffrey Barg on 7/19/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_StandardFeatures)

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;

- (UIImage *)imageToFitSize:(CGSize)size method:(MGImageResizingMethod)resizeMethod;
- (UIImage *)imageCroppedToFitSize:(CGSize)size; // uses MGImageResizeCrop
- (UIImage *)imageScaledToFitSize:(CGSize)size; // uses MGImageResizeScale

- (UIImage*) imageByRotatingImageFromImageOrientation;


@end
