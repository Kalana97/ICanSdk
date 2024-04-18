//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 21/4/2020
 - File name:  TimeLineRecommendCollectionViewCell.m
 - Description:
 - Function List:
 */


#import "TimeLineRecommendCollectionViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
@interface TimeLineRecommendCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *icaonImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *recAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@end
@implementation TimeLineRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor qmui_colorWithHexString:@"F8F8F8"];
    self.bgView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    self.desLabel.textColor=UIColorThemeMainSubTitleColor;
    [self.recAddBtn layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self.nearAddBtn layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self.removeBtn layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self.icaonImageView layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self.recAddBtn setBackgroundColor:UIColorThemeMainColor];
    [self.nearAddBtn setBackgroundColor:UIColorThemeMainColor];
    [self.removeBtn setBackgroundColor:UIColorSeparatorColor];
    [self.removeBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    //加好友
    [self.recAddBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
    [self.removeBtn setTitle:@"Remove".icanlocalized forState:UIControlStateNormal];
    [self.nearAddBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
    
}
-(void)setNearbyInfo:(UserLocationNearbyInfo *)nearbyInfo{
    _nearbyInfo=nearbyInfo;
    self.recAddBtn.hidden=self.removeBtn.hidden=YES;
    self.nearAddBtn.hidden=NO;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:nearbyInfo.ID successBlock:^(UserMessageInfo * _Nonnull info) {
        self.nearbyInfo.isFriend = info.isFriend;
        [self.icaonImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        self.nameLabel.text = info.remarkName?:info.nickname;
        if (info.isFriend) {
            [self.nearAddBtn setTitle:@"friend.detail.chat".icanlocalized forState:UIControlStateNormal];
        }else{
            [self.nearAddBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
        }
        self.desLabel.text = nearbyInfo.showDistance;
    }];
}
-(void)setRecommendInfo:(UserRecommendListInfo *)recommendInfo{
    _recommendInfo=recommendInfo;
    self.recAddBtn.hidden=self.removeBtn.hidden=NO;
    self.nearAddBtn.hidden=YES;
    [self.icaonImageView setImageWithString:recommendInfo.headImgUrl placeholder:BoyDefault];
    self.nameLabel.text=recommendInfo.nickname;
    self.desLabel.text=recommendInfo.signature?:@"";
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:recommendInfo.ID successBlock:^(UserMessageInfo * _Nonnull info) {
        self.recommendInfo.isFirend=info.isFriend;
        if (info.isFriend) {
            [self.recAddBtn setTitle:@"friend.detail.chat".icanlocalized forState:UIControlStateNormal];
        }else{
            [self.recAddBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
        }
    }];
}
- (IBAction)recAddBtnAction:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock(self.recommendInfo, 0);
    }
}
- (IBAction)removeBtnAction:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock(self.recommendInfo, 1);
    }
}
- (IBAction)nearAddBtnAction:(id)sender {
    if (self.buttonBlock) {
        self.buttonBlock(self.nearbyInfo, 2);
    }
}

@end
