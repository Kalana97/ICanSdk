//  yanfeng
//
//  Created by 崔志伟 on 2018/1/2.
//  Copyright © 2018年 崔志伟. All rights reserved.
//

#import "UIView+FKAutoLayout.h"

@implementation UIView (FKAutoLayout)

- (NSArray *)autoFillSuperView
{
    return [self autoFillSuperViewWithInsets:UIEdgeInsetsZero];
}

- (NSArray *)autoFillSuperViewWithInsets:(UIEdgeInsets)insets
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * c1 = FKAutoLayoutMake(self, Leading, Equal, self.superview, Leading, insets.left);
    NSLayoutConstraint * c2 = FKAutoLayoutMake(self, Trailing, Equal, self.superview, Trailing, insets.right);
    NSLayoutConstraint * c3 = FKAutoLayoutMake(self, Top, Equal, self.superview, Top, insets.top);
    NSLayoutConstraint * c4 = FKAutoLayoutMake(self, Bottom, Equal, self.superview, Bottom, insets.bottom);
    
    NSArray * array = @[c1, c2, c3, c4];
    
    [self.superview addConstraints:array];
    
    return array;
}

@end
