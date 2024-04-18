//
//  RecommendTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor =UIColor252730Color;
    ViewRadius(self.iconImageView, 17.5);
    self.singaLabel.textColor = UIColor153Color;
    ViewRadius(self.singaLabel, 5.0);
    [self.recommendBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.recommendBgView.backgroundColor=UIColorBg243Color;
}

-(void)setUserRecommendListInfo:(UserRecommendListInfo *)userRecommendListInfo{
    _userRecommendListInfo = userRecommendListInfo;
    self.nameLabel.text = userRecommendListInfo.nickname;
    [self.iconImageView setDZIconImageViewWithUrl:userRecommendListInfo.headImgUrl gender:userRecommendListInfo.gender];
    self.genderImageView.image = [UIImage imageNamed:[userRecommendListInfo.gender isEqualToString:@"2"]?@"icon_gender_girl":@"icon_gender_boy"];
    self.singaLabel.text = userRecommendListInfo.signature;
    self.recommendBgView.hidden=!userRecommendListInfo.signature;
}


@end
