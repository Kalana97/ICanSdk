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
   UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:memberInfo.userId];
    [self.iconView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
    if (messageInfo.isFriend) {
        if([messageInfo.remarkName isEqual:@""] || messageInfo.remarkName == nil){
            self.titleLB.text = messageInfo.nickname;
        }else{
            self.titleLB.text = messageInfo.remarkName;
        }
    }else{
        if([memberInfo.groupRemark isEqual:@""] || memberInfo.groupRemark == nil){
            self.titleLB.text = memberInfo.nickname;
        }else{
            self.titleLB.text = memberInfo.groupRemark;
        }
    }
   
    self.roleImg.hidden=NO;
    if ([memberInfo.role isEqualToString:@"0"]&&memberInfo.vip) {
        self.roleImg.image= [UIImage imageNamed:@"icon_group_leader_vip"];
    }else if ([memberInfo.role isEqualToString:@"1"]&&memberInfo.vip){
        self.roleImg.image= [UIImage imageNamed:@"icon_group_keeper_vip"];
    }else if ([memberInfo.role isEqualToString:@"0"]){
        self.roleImg.image= [UIImage imageNamed:@"icon_group_leader"];
    }else if ([memberInfo.role isEqualToString:@"1"]){
        self.roleImg.image= [UIImage imageNamed:@"icon_group_keeper"];
    }else if (memberInfo.vip){
         self.roleImg.image= [UIImage imageNamed:@"icon_group_vip"];
    }
    else{
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
