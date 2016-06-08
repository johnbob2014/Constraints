//
//  UIView+ConstraintHelper.m
//  Constraints-C05
//
//  Created by BobZhang on 16/6/8.
//  Copyright © 2016年 BobZhang. All rights reserved.
//

#import "UIView+ConstraintHelper.h"

@implementation UIView (ConstraintHelper)

#pragma mark - Constraint Management

// This ignores any priority, looking only at y (R) mx + b
- (BOOL)constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2
{
    if (constraint1.firstItem != constraint2.firstItem) return NO;
    if (constraint1.secondItem != constraint2.secondItem) return NO;
    if (constraint1.firstAttribute != constraint2.firstAttribute) return NO;
    if (constraint1.secondAttribute != constraint2.secondAttribute) return NO;
    if (constraint1.relation != constraint2.relation) return NO;
    if (constraint1.multiplier != constraint2.multiplier) return NO;
    if (constraint1.constant != constraint2.constant) return NO;
    
    return YES;
}

// Find first matching constraint. (Priority, Archiving ignored)
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint
{
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if ([self constraint:constraint matches:aConstraint])
            return constraint;
    }
    
    for (NSLayoutConstraint *constraint in self.superview.constraints)
    {
        if ([self constraint:constraint matches:aConstraint])
            return constraint;
    }
    
    return nil;
}

// Remove constraint
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint
{
    NSLayoutConstraint *match = [self constraintMatchingConstraint:aConstraint];
    if (match)
    {
        [self removeConstraint:match];
        [self.superview removeConstraint:match];
    }
}

- (void)removeMatchingConstraints:(NSArray *)anArray
{
    for (NSLayoutConstraint *constraint in anArray)
        [self removeMatchingConstraint:constraint];
}

#pragma mark - Constraints within a Superview

- (NSArray *)constraintsLimitingViewToSuperviewBounds
{
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
    return array;
}

- (void)constrainWithinSuperviewBounds
{
    if (!self.superview) return;
    [self.superview addConstraints:[self constraintsLimitingViewToSuperviewBounds]];
}

- (void)addSubviewAndConstrainToBounds:(UIView *)view
{
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view constrainWithinSuperviewBounds];
}

#pragma mark Size and Position

- (NSArray *)sizeConstraints:(CGSize)aSize atPriority:(float)aPriority
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(theWidth@priority)]" options:0 metrics:@{@"theWidth":@(aSize.width),@"priority":@(aPriority)} views:NSDictionaryOfVariableBindings(self)]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(theHeight@priority)]" options:0 metrics:@{@"theHeight":@(aSize.height),@"priority":@(aPriority)} views:NSDictionaryOfVariableBindings(self)]];
    return array;
}

- (NSArray *)positionConstraints:(CGPoint)aPoint atPriority:(float)aPriority
{
    if (!self.superview) return nil;
    NSMutableArray *array = [NSMutableArray array];
    
    // X position
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:aPoint.x]];
    
    // Y position
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:aPoint.y]];
    
    for (NSLayoutConstraint *constraint in array) {
        constraint.priority = aPriority;
    }
    return array;
}

// Set view size
- (void)constrainSize:(CGSize)aSize
{
    [self addConstraints:[self sizeConstraints:aSize atPriority:750.0f]];
}

// Set view location within superview
- (void)constrainPosition:(CGPoint)aPoint
{
    if (!self.superview) return;
    [self.superview addConstraints:[self positionConstraints:aPoint atPriority:750.0f]];
}

#pragma mark - Centering

- (NSLayoutConstraint *)horizontalCenteringConstraint
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)verticalCenteringConstraint
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
}

// Centering
- (void)centerHorizontallyInSuperview
{
    if (!self.superview) return;
    [self.superview addConstraint:[self horizontalCenteringConstraint]];
}

- (void)centerVerticallyInSuperview
{
    if (!self.superview) return;
    [self.superview addConstraint:[self verticalCenteringConstraint]];
}

- (void)centerInSuperview
{
    [self centerHorizontallyInSuperview];
    [self centerVerticallyInSuperview];
}

#pragma mark - Aspect Ratios

- (NSLayoutConstraint *)aspectConstraint:(CGFloat)aspectRatio
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0.0f];
    
}

// Set view aspect ratio
- (void)constrainAspectRatio:(CGFloat)aspectRatio
{
    [self addConstraint:[self aspectConstraint:aspectRatio]];
}

#pragma mark - Debugging & Logging

- (NSString *)nameForLayoutAttribute:(NSLayoutAttribute)anAttribute{
    switch (anAttribute) {
        case NSLayoutAttributeTop: return @"Top";
        case NSLayoutAttributeLeft: return @"Left";
        case NSLayoutAttributeRight: return @"Right";
        case NSLayoutAttributeWidth: return @"Width";
        case NSLayoutAttributeBottom: return @"Bottom";
        case NSLayoutAttributeHeight: return @"Height";
        case NSLayoutAttributeCenterX: return @"CenterX";
        case NSLayoutAttributeCenterY: return @"CenterY";
        case NSLayoutAttributeLeading: return @"Leading";
        case NSLayoutAttributeBaseline: return @"Baseline";
        case NSLayoutAttributeTrailing: return @"Trailing";
        case NSLayoutAttributeTopMargin: return @"TopMargin";
        case NSLayoutAttributeLeftMargin: return @"LeftMargin";
        case NSLayoutAttributeRightMargin: return @"RightMargin";
        case NSLayoutAttributeBottomMargin: return @"BottomMargin";
        //case NSLayoutAttributeLastBaseline: return @"LastBaseline";
        case NSLayoutAttributeFirstBaseline: return @"FirstBaseline";
        case NSLayoutAttributeLeadingMargin: return @"LeadingMargin";
        case NSLayoutAttributeTrailingMargin: return @"TrailingMargin";
        case NSLayoutAttributeCenterXWithinMargins: return @"CenterXWithinMargins";
        case NSLayoutAttributeCenterYWithinMargins: return @"CenterYWithinMargins";
        case NSLayoutAttributeNotAnAttribute: return @"NotAnAttribute";
        default: return @"Unknown";
    }
}

- (NSString *)nameForLayoutRelation:(NSLayoutRelation)aRelation{
    switch (aRelation) {
        case NSLayoutRelationEqual: return @"==";
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        default: return @"NotARelation";
    }
}

- (NSString *)nameForItem:(id)anItem{
    if (!anItem) return @"nil";
    if (anItem == self) return @"[self]";
    if (anItem == self.superview) return @"[superview]";
    return [NSString stringWithFormat:@"[%@:%d]",[anItem class],(int) anItem];
}

- (NSString *)constraintRepresentation:(NSLayoutConstraint *)aConstraint{
    NSString *item1 = [self nameForItem:aConstraint.firstItem];
    NSString *item2 = [self nameForItem:aConstraint.secondItem];
    NSString *relationship = [self nameForLayoutRelation:aConstraint.relation];
    NSString *attr1 = [self nameForLayoutAttribute:aConstraint.firstAttribute];
    NSString *attr2 = [self nameForLayoutAttribute:aConstraint.secondAttribute];
    
    NSString *result;
    
    if (!aConstraint.secondItem)
    {
        result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %0.3f", aConstraint.priority, item1, attr1, relationship, aConstraint.constant];
    }
    else if (aConstraint.multiplier == 1.0f)
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %@.%@", aConstraint.priority, item1, attr1, relationship, item2, attr2];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.constant];
    }
    else
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ * %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ ((%@.%@ * %0.3f) + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier, aConstraint.constant];
    }
    
    return result;
}

- (void)showConstraints{
    NSString *viewName = [NSString stringWithFormat:@"[%@:%d]",[self class],(int)self];
    NSLog(@"View %@ has %ld constraints",viewName,(long)self.constraints.count);
    for (NSLayoutConstraint *constraint in self.constraints) {
        NSLog(@"%@",[self constraintRepresentation:constraint]);
    }
}
@end
