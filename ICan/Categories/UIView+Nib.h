
//  yanfeng
//
//  Created by 崔志伟 on 2018/1/2.
//  Copyright © 2018年 崔志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

+ (UINib *)nib;
+ (UINib *)nibWithName:(NSString *)name;

// 在 StoryBoard 或者 XIB 里复用另外一个 XIB
- (void)loadFromNib;

+ (instancetype)loadFromNib;
+ (instancetype)loadFromNib:(NSString *)nibName;
+ (instancetype)loadFromNibWithFrame:(CGRect)frame;

- (void)customize;

@end
