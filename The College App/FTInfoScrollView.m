//
//  FTInfoScrollView.m
//  The College App
//
//  Created by Jeffrey Barg on 8/8/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTInfoScrollView.h"

@interface FTInfoScrollView ()

@property (nonatomic, strong) UIView *touchedView;

@end

@implementation FTInfoScrollView

@synthesize viewBelow;
@synthesize touchedView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (point.y < 0) {
//        NSLog(@"%@",@"asdf");
//        return viewBelow;
//    }
    return [super hitTest:point withEvent:event];
}



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = (UITouch *)[touches anyObject];
//    
//    CGPoint loc = [touch locationInView:self];
//    if (loc.y < 0) {
//        touchedView = viewBelow;
//    } else {
//        touchedView = self;
//        [super touchesBegan:touches withEvent:event];
//    }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (touchedView == self)
//        return [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    if (touchedView == self)
//        return [super touchesEnded:touches withEvent:event];
//    
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (touchedView == self)
//        return [super touchesCancelled:touches withEvent:event];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
