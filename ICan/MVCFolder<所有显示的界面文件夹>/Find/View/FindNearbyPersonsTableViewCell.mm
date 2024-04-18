//
//  FindNearbyPersonsTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/31.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "FindNearbyPersonsTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"

@implementation FindNearbyPersonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor = UIColorThemeMainTitleColor;
    self.edgeLabel.textColor = UIColorThemeMainSubTitleColor;
    ViewRadius(self.iconImageView, 30);
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    ViewRadius(self.addFriendBtn, 17.5);
    self.addFriendBtn.backgroundColor = UIColorThemeMainColor;
    //加好友
}

- (IBAction)addFriendAction:(id)sender {
    if([self.addFriendBtn.titleLabel.text isEqualToString: @"chatlist.menu.list.addfriend".icanlocalized]){
        if (self.addBlock) {
            self.addBlock();
        }
    }else if([self.addFriendBtn.titleLabel.text isEqualToString: @"Chat".icanlocalized]){
        if (self.chatBlock) {
            self.chatBlock();
        }
    }
}

-(void)setUserLocationNearbyInfo:(UserLocationNearbyInfo *)userLocationNearbyInfo{
    //    * 距离显示逻辑
    //    * 1. 距离小于100米 显示100米内
    //    * 2. 距离100<距离<1000米 显示  （距离+100） 米内，距离取百
    //    * 3. 1KM<距离<200KM 显示 （距离+1） KM米内，距离取整
    _userLocationNearbyInfo = userLocationNearbyInfo;
    [self.iconImageView setDZIconImageViewWithUrl:userLocationNearbyInfo.headImgUrl gender:userLocationNearbyInfo.gender];
    self.nameLabel.text = userLocationNearbyInfo.nickname;
    self.edgeLabel.text = userLocationNearbyInfo.showDistance;
    self.genderImageView.image=[userLocationNearbyInfo.gender isEqualToString:@"2"]?UIImageMake(@"icon_gender_girl"):UIImageMake(@"icon_gender_boy");
    self.addFriendBtn.hidden = NO;
    if(userLocationNearbyInfo.isFriend == true){
        [self.addFriendBtn setTitle:@"Chat".icanlocalized forState:UIControlStateNormal];
    }else{
        [self.addFriendBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
    }
}



@end
