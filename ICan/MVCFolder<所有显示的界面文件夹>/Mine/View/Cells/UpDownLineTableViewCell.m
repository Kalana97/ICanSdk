//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2020
- File name:  UpDownLineTableViewCell.m
- Description:
- Function List:
*/
        

#import "UpDownLineTableViewCell.h"

@implementation UpDownLineTableViewCell
-(void)setBeInvitedInfo:(BeInvitedInfo *)beInvitedInfo{
    _beInvitedInfo=beInvitedInfo;
    self.IdLabel.text=beInvitedInfo.numberId;
    self.nicknameLabel.text=beInvitedInfo.nickname;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.serialLabel.textColor=UIColorThemeMainTitleColor;
    self.nicknameLabel.textColor=UIColorThemeMainTitleColor;
    self.IdLabel.textColor=UIColorThemeMainTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
