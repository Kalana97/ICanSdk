//
//  NewFriendRecommendCollectionViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "NewFriendRecommendCollectionViewCell.h"

@implementation NewFriendRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = UIColorMake(51, 51, 51);
    ViewRadius(self.iconImageView, 17.5);
    
}

-(void)setUserRecommendListInfo:(UserRecommendListInfo *)userRecommendListInfo{
    _userRecommendListInfo = userRecommendListInfo;
    self.nameLabel.text = userRecommendListInfo.nickname;
    [self.iconImageView setDZIconImageViewWithUrl:userRecommendListInfo.headImgUrl gender:userRecommendListInfo.gender];
    
    
}

@end
