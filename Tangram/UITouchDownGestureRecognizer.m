//
//  UITouchDownGestureRecognizer.m
//  Tangram
//
//  Created by Joe Newbry on 12/11/13.
//  Copyright (c) 2013 Joe Newbry. All rights reserved.
//

#import "UITouchDownGestureRecognizer.h"
// need to include this import to be able to subclass
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation UITouchDownGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible){
        [self setState:UIGestureRecognizerStateRecognized];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateFailed;
}


@end
