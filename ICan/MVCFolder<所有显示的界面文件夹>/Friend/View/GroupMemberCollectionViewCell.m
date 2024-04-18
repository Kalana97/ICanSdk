//
//  GroupMemberCollectionViewCell.m
//  OneChatAPP
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "GroupMemberCollectionViewCell.h"


@interface GroupMemberCollectionViewCell ()



@property (weak, nonatomic) IBOutlet UILabel *titleLB;

// 角色图标
@property (weak, nonatomic) IBOutlet UIImageView *roleImg;


@end

@implementation GroupMemberCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLB.textColor=UIColor252730Color;
    CGFloat width;
    if (ScreenWidth<330) {
        width=(ScreenWidth - 100) / 4;
    }else{
        width=(ScreenWidth - 120) / 5;
    }
    [self.iconView layerWithCornerRadius:width/2 borderWidth:0 borderColor:nil];
}

-(void)setMemberInfo:(GroupMemberInfo *)memberInfo{
    _memberInfo = memberInfo;
    self.titleLB.hidden=NO;
    [self.iconView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
    self.titleLB.text =memberInfo.groupRemark?:memberInfo.nickname;
    self.roleImg.hidden=NO;
    if ([memberInfo.role isEqualToString:@"0"]) {
        self.roleImg.image= [UIImage imageNamed:@"group_owner"];
    }else if ([memberInfo.role isEqualToString:@"1"]){
        self.roleImg.image= [UIImage imageNamed:@"group_manager"];
    }else{
        self.roleImg.hidden=YES;
    }
}

- (void)setImage:(UIImage *)image {
    self.titleLB.hidden=YES;
    self.roleImg.hidden=YES;
    if (image) {
        [self.iconView setTintColor:[UIColor lightGrayColor]];
        [self.iconView setImage:image];
        
    }
}



@end
