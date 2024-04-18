
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2021
- File name:  MemberCenterVIPCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "MemberCenterVIPCollectionViewCell.h"

@interface MemberCenterVIPCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;


@end

@implementation MemberCenterVIPCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)setVipInfo:(MemberCentreVipInfo *)vipInfo{
//    3 Months,
//    ￥252,
//    ￥83/Month
    self.timeLabel.textColor = UIColorThemeMainTitleColor;
    self.eachLab.textColor = UIColorThemeMainSubTitleColor;
    if (BaseSettingManager.isChinaLanguages) {
        self.timeLabel.text = vipInfo.title_cn;
        float each = vipInfo.price.doubleValue/(vipInfo.duration*1.0);
        self.eachLab.text = [NSString stringWithFormat:@"￥%.2f元/月",each];
    }else{
        self.timeLabel.text = vipInfo.title_en;
        float each = vipInfo.price.doubleValue/(vipInfo.duration*1.0);
        self.eachLab.text = [NSString stringWithFormat:@"￥%.2f/Month",each];
    }
    if (vipInfo.duration == 1) {
        self.eachLab.hidden = YES;
    }else{
        self.eachLab.hidden = NO;
    }
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",vipInfo.price.stringValue];
}
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
