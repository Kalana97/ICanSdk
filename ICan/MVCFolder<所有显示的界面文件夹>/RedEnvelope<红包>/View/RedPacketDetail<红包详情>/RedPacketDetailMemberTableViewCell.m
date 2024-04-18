//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 7/4/2020
- File name:  RedPacketDetailMemberTableViewCell.m
- Description:
- Function List:
*/
        
#import "GetTime.h"
#import "RedPacketDetailMemberTableViewCell.h"

@implementation RedPacketDetailMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    self.moneyLabel.textColor=UIColorThemeMainTitleColor;
    self.timeLabel.textColor=UIColorThemeMainTitleColor;
    self.goodLucketLabel.textColor=UIColorMake(244, 173, 58);
    [self.receiveIconImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    self.goodLucketLabel.text=@"Luckiest Draw".icanlocalized;
}

-(void)setRedPacketDetailMemberInfo:(RedPacketDetailMemberInfo *)redPacketDetailMemberInfo{
    self.nameLabel.text=redPacketDetailMemberInfo.nickname;
    [self.receiveIconImageView setDZIconImageViewWithUrl:redPacketDetailMemberInfo.headImgUrl gender:BoyDefault];
    self.timeLabel.text=[GetTime convertDateWithString:redPacketDetailMemberInfo.grabTime dateFormmate:@"MM-dd HH:mm"];
    
    self.goodLucketLabel.hidden=self.goodLuckImageView.hidden=!redPacketDetailMemberInfo.goodLucky;
    if (BaseSettingManager.isChinaLanguages) {
        self.moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[redPacketDetailMemberInfo.money doubleValue]];
    }else{
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2fCNY",[redPacketDetailMemberInfo.money doubleValue]];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2fCNT",[redPacketDetailMemberInfo.money doubleValue]];
        }
    }
    
}

@end
