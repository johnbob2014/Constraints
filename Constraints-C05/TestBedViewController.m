//
//  TBVC_03_NameExtensions.m
//  UIView-C04
//
//  Created by BobZhang on 16/6/6.
//  Copyright © 2016年 BobZhang. All rights reserved.
//


#import "TestBedViewController.h"
#import "Utility.h"

#import "UIView+ConstraintHelper.h"

#pragma mark - TBVC

@implementation TBVC{
    UIImageView *imageView;
    CGPoint beganPoint;
}

- (void)viewDidLoad{
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon"]];
    [self.view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [imageView constrainWithinSuperviewBounds];
    
    [self.view showConstraints];
    
    imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGRAction:)];
    [imageView addGestureRecognizer:panGR];
}

- (void)panGRAction:(UIPanGestureRecognizer *)panGR{
    
    if (panGR.state == UIGestureRecognizerStateBegan) {
        beganPoint = [panGR translationInView:self.view];
    }
    if (panGR.state == UIGestureRecognizerStateChanged) {
        CGPoint changedPoint = [panGR translationInView:self.view];
        CGPoint originalPoint = imageView.frame.origin;
        
        CGPoint newPoint = CGPointMake(originalPoint.x + changedPoint.x -beganPoint.x, originalPoint.y + changedPoint.y - beganPoint.y);
        
        //使用代码更改约束
        [self.view removeConstraints:self.view.constraints];
        [imageView constrainPosition:newPoint];
        NSLog(@"%@",NSStringFromCGPoint(newPoint));
        
        beganPoint = changedPoint;
    }
    
    
}
@end

