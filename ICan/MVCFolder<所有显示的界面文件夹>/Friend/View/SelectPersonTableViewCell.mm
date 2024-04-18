//
//  SelectPersonTableViewCell.m
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "SelectPersonTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
@interface SelectPersonTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property ( nonatomic, assign) BOOL  isSelect;
@property (weak, nonatomic) IBOutlet UIView *topUnSelectView;

@end

@implementation SelectPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLB.textColor=UIColorThemeMainTitleColor;
    self.nameLB.text = @"";
    self.timeLB.text = @"";
    [self.iconView layerWithCornerRadius:30/2 borderWidth:0 borderColor:nil];
    self.topUnSelectView.backgroundColor=UIColorMakeWithRGBA(255, 255, 255, 0.1);
}
-(void)setUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    _userMessageInfo = userMessageInfo;
    self.nameLB.text = userMessageInfo.remarkName?:userMessageInfo.nickname;
    [self.iconView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
    if (userMessageInfo.canEnabled) {
        self.selectBtn.selected = userMessageInfo.isSelect;
        self.topUnSelectView.hidden=YES;
        if (userMessageInfo.isSelect) {
            [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateNormal];
        }else{
            [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
        }
    }else{
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_dis"] forState:UIControlStateNormal];
        self.topUnSelectView.hidden=NO;
    }
    
}


-(void)setGroupMemberInfo:(GroupMemberInfo *)groupMemberInfo{
    _groupMemberInfo = groupMemberInfo;
    self.nameLB.text = groupMemberInfo.nickname;
    self.topUnSelectView.hidden=YES;
    [self.iconView setDZIconImageViewWithUrl:groupMemberInfo.headImgUrl gender:groupMemberInfo.gender];
    if (groupMemberInfo.isSelect) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
    }
}
-(void)setSettingGroupRoleGroupMemberInfo:(GroupMemberInfo *)settingGroupRoleGroupMemberInfo{
    _settingGroupRoleGroupMemberInfo = settingGroupRoleGroupMemberInfo;
    self.topUnSelectView.hidden=YES;
    UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:settingGroupRoleGroupMemberInfo.userId];
    NSString * name;
    if (messageInfo.isFriend) {
        name = messageInfo.remarkName?:settingGroupRoleGroupMemberInfo.groupRemark?:settingGroupRoleGroupMemberInfo.nickname;
    }else{
        name = settingGroupRoleGroupMemberInfo.groupRemark?:settingGroupRoleGroupMemberInfo.nickname;
    }
    
    self.nameLB.text = name;
    [self.iconView setDZIconImageViewWithUrl:settingGroupRoleGroupMemberInfo.headImgUrl gender:settingGroupRoleGroupMemberInfo.gender];
    if (settingGroupRoleGroupMemberInfo.isSelect) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
    }
    
}


- (IBAction)buttonAction:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}


@end
