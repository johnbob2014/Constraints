//
//  UIView+ConstraintHelper.h
//  Constraints-C05
//
//  Created by BobZhang on 16/6/8.
//  Copyright © 2016年 BobZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintHelper)

// Constraint Management (Recipe 5-1)

/**
 比较两个约束是否相匹配（不包括优先级） - ConstraintHelper
 */
- (BOOL)constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2;

/**
 返回与指定约束相匹配的 第一个 约束 - ConstraintHelper
 */
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;

/**
 删除 一个 与指定约束相匹配的约束
 */
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint;

/**
 删除 一组 与指定约束相匹配的约束
 */
- (void)removeMatchingConstraints:(NSArray *)anArray;

// Superview bounds limits (Recipe 5-2)

/**
 返回一组约束，确保视图在其父视图的bounds范围内，即可以显示出来
 */
- (NSArray *)constraintsLimitingViewToSuperviewBounds;

/**
 将视图约束在其父视图的bounds范围内
 */
- (void)constrainWithinSuperviewBounds;

/**
 添加一个子视图，并将此子视图约束在本视图的bounds范围内
 */
- (void)addSubviewAndConstrainToBounds:(UIView *)view;

// Size & Position (Recipe 5-2)

/**
 生成并返回本视图 尺寸 约束
 */
- (NSArray *)sizeConstraints:(CGSize)aSize atPriority:(float)aPriority;

/**
 生成并返回本视图 原点 约束
 */
- (NSArray *)positionConstraints: (CGPoint)aPoint atPriority:(float)aPriority;

/**
 设置尺寸约束
 */
- (void)constrainSize:(CGSize)aSize;

/**
 设置原点约束
 */
- (void)constrainPosition: (CGPoint)aPoint; // w/in superview bounds

// Centering (Recipe 5-3)

/**
 生成并返回水平居中约束
 */
- (NSLayoutConstraint *)horizontalCenteringConstraint;

/**
 生成并返回垂直居中约束
 */
- (NSLayoutConstraint *)verticalCenteringConstraint;

/**
 设置在父视图中水平居中的约束
 */
- (void)centerHorizontallyInSuperview;

/**
 设置在父视图中垂直居中的约束
 */
- (void)centerVerticallyInSuperview;

/**
 设置在父视图中居中的约束
 */
- (void)centerInSuperview;

// Aspect Ratios (Recipe 5-4)

/**
 生成并返回指定宽高比的约束
 */
- (NSLayoutConstraint *)aspectConstraint:(CGFloat)aspectRatio;

/**
 设置指定宽高比的约束
 */
- (void)constrainAspectRatio:(CGFloat)aspectRatio;

// Debugging & Logging (Recipe 5-6)

/**
 返回指定约束的描述字符串
 */
- (NSString *)constraintRepresentation:(NSLayoutConstraint *)aConstraint;

/**
 显示视图所有约束的描述字符串
 */
- (void)showConstraints;

@end
