
//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 14/10/2019
- File name:  FriendListTableViewCell.m
- Description:
- Function List:
*/
        

#import "FriendListTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
@interface FriendListTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *visibilityOfSelectBtn;
@property (nonatomic,strong) GroupMemberInfo * groupMemberData;
@end
@implementation FriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =  UIColorThemeMainBgColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    [self.iconImageView layerWithCornerRadius:17.5 borderWidth:0 borderColor:nil];
    self.iconImageView.backgroundColor = UIColor244RedColor;
}

-(void)setUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
    
    if ([userMessageInfo.remarkName isEqual:@""] || userMessageInfo.remarkName == nil) {
        self.nameLabel.text = userMessageInfo.nickname;
    }else{
        self.nameLabel.text = userMessageInfo.remarkName;
    }
}

-(void)setGroupMemberInfo:(GroupMemberInfo *)groupMemberInfo{
    self.groupMemberData = groupMemberInfo;
    [self.iconImageView setDZIconImageViewWithUrl:groupMemberInfo.headImgUrl gender:groupMemberInfo.gender];
   UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:groupMemberInfo.userId];
    if (messageInfo.isFriend) {
        self.nameLabel.text = messageInfo.remarkName?:groupMemberInfo.groupRemark?:groupMemberInfo.nickname;
    }else{
        self.nameLabel.text = groupMemberInfo.groupRemark?:groupMemberInfo.nickname;
    }
    self.visibilityOfSelectBtn.hidden = !self.selectionBtnStatus;
    if(groupMemberInfo.isMultipleSelected){
        self.visibilityOfSelectBtn.selected = YES;
    }else{
        self.visibilityOfSelectBtn.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)didUserSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userSelection" object:self.groupMemberData];
}
@end
