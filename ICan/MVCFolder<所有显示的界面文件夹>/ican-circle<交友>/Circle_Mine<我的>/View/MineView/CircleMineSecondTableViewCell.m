//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/5/2021
- File name:  CircleMineSecondTableViewCell.m
- Description:
- Function List:
*/
        

#import "CircleMineSecondTableViewCell.h"
#import "CircleSettingViewController.h"
#import "AlreadyBuyPackageViewController.h"
@interface CircleMineSecondTableViewCell()
@property (weak, nonatomic) IBOutlet UIControl *buyBgView;
@property (weak, nonatomic) IBOutlet UILabel *mealLabel;

@property (weak, nonatomic) IBOutlet UIControl *settingCon;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;

@end
@implementation CircleMineSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.buyBgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    self.lineView.hidden=YES;
    //    "AlreadyBuyPackageViewController.title"="已购套餐";
    self.mealLabel.text=@"CircleMineSecondTableViewCell.pakges".icanlocalized;
    //"CircleMineSecondTableViewCell.setting"="设置";
    self.settingLabel.text=@"CircleMineSecondTableViewCell.setting".icanlocalized;
}
- (IBAction)settingAction:(id)sender {
    [[AppDelegate shared]pushViewController:[CircleSettingViewController new] animated:YES];
}
- (IBAction)buyedAction {
    [[AppDelegate shared]pushViewController:[AlreadyBuyPackageViewController new] animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
