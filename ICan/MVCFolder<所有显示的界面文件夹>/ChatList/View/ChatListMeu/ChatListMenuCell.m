//
//  ItemTableViewCell.m
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "ChatListMenuCell.h"

@interface ChatListMenuCell ()


@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UIImageView *bottomLineView;


@end

@implementation ChatListMenuCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLB.textColor=[UIColor whiteColor];
    self.bottomLineView.backgroundColor=UIColorMake(74, 76, 80);
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=UIColor.clearColor;
    [self.cirecleLabel layerWithCornerRadius:7/2 borderWidth:0 borderColor:nil];
}

- (void)setIconName:(NSString *)iconName title:(NSString *)title isShow:(BOOL)show {
    self.iconView.image = [UIImage imageNamed:iconName];
    self.titleLB.text = title;
    self.bottomLineView.hidden = show;
}


@end
