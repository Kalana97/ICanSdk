
//  yanfeng
//
//  Created by 崔志伟 on 2018/1/2.
//  Copyright © 2018年 崔志伟. All rights reserved.
//

#import "UIView+Nib.h"
#import "UIView+FKAutoLayout.h"

@implementation UIView (Nib)


+ (UINib *)nib
{
    return [self nibWithName:NSStringFromClass([self class])];
}

+ (UINib *)nibWithName:(NSString *)name
{
    return [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadFromNib
{
    return [self loadFromNib:NSStringFromClass([self class])];
}

+ (instancetype)loadFromNib:(NSString *)nibName
{

    return [[[self nibWithName:nibName] instantiateWithOwner:nil options:nil] firstObject];
}

+ (instancetype)loadFromNibWithFrame:(CGRect)frame
{
	UIView * nibView = [self loadFromNib];
	nibView.frame = frame;
	return nibView;
}

- (void)loadFromNib
{
    UIView * shadow = [[[[self class] nib] instantiateWithOwner:self options:nil] firstObject];

    [self addSubview:shadow];

    [shadow autoFillSuperView];
}

- (void)customize
{
    
}

@end
