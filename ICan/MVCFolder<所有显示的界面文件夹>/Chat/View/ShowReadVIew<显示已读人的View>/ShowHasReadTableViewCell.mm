//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 27/12/2019
- File name:  ShowHasReadTableViewCell.m
- Description:
- Function List:
*/
        

#import "ShowHasReadTableViewCell.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
@interface ShowHasReadTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation ShowHasReadTableViewCell
-(void)setDict:(NSDictionary *)dict{
    _dict=dict;
    NSDate*date=[GetTime dateConvertFromTimeStamp:dict[@"time"]];
      self.timeLabel.text=[GetTime getTimeWithMessageDate:date];;
    if (self.isGroup) {
        [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.groupId userId:dict[@"id"] successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
            [self.iconImageView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
            self.nameLabel.text=![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname;
            
        }];
    }else{
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:dict[@"id"] successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            self.nameLabel.text=info.remarkName?:info.nickname;
        }];
    }
    
}
-(void)setUserMessageInfo:(TimelineLoveInfo *)userMessageInfo{
    self.timeLabel.hidden=YES;
    _userMessageInfo=userMessageInfo;
    [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
    self.nameLabel.text=userMessageInfo.nickname;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor= UIColorViewBgColor;
    [self.iconImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    self.nameLabel.textColor = UIColorThemeMainTitleColor;
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.lineView.hidden= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
