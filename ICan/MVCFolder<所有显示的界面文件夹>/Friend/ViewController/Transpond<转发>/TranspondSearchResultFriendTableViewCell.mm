//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 28/10/2019
 - File name:  TranspondSearchResultTableViewCell.m
 - Description:
 - Function List:
 */


#import "TranspondSearchResultFriendTableViewCell.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
@interface TranspondSearchResultFriendTableViewCell ()
@property(nonatomic, weak) IBOutlet UIButton *selectButton;
@property(nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@end
@implementation TranspondSearchResultFriendTableViewCell
-(void)setIsShowSelectButton:(BOOL)isShowSelectButton{
    self.lineView1.hidden = self.selectButton.hidden = !isShowSelectButton;
}

-(void)setChatListModel:(ChatListModel *)chatListModel{
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
    _chatListModel=chatListModel;
    if ([chatListModel.chatType isEqualToString:GroupChat]) {//群聊
        [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatListModel.chatID successBlock:^(GroupListInfo * _Nonnull info) {
            self.nameLabel.text=[NSString stringWithFormat:@"%@(%@人)",info.name,info.userCount];
            [self.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
        }];
    }else{//单聊
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatListModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
            
            self.nameLabel.text=[NSString stringWithFormat:@"%@",info.remarkName?:info.nickname];
            [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
        }];
    }
    [self.selectButton setBackgroundImage:[UIImage imageNamed:chatListModel.isSelect?@"icon_selectperson_sel":@"icon_selectperson_nor"] forState:UIControlStateNormal];
    
}
-(void)setUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
    [self.iconImageView setImageWithString:userMessageInfo.headImgUrl placeholder:userMessageInfo.gender];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:userMessageInfo.isSelect?@"icon_selectperson_sel":@"icon_selectperson_nor"] forState:UIControlStateNormal];
    self.nameLabel.text = userMessageInfo.remarkName?:userMessageInfo.nickname;
}
-(void)setGroupListInfo:(GroupListInfo *)groupListInfo{
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
    self.iconImageView.clipsToBounds = YES;
    _groupListInfo=groupListInfo;
    [self.iconImageView setImageWithString:groupListInfo.headImgUrl placeholder:GroupDefault];
    self.nameLabel.text = groupListInfo.name;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:groupListInfo.isSelect?@"icon_selectperson_sel":@"icon_selectperson_nor"] forState:UIControlStateNormal];
}

@end
