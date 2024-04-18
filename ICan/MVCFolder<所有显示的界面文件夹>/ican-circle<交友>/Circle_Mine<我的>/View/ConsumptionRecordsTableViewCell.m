
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  ConsumptionRecordsTableViewCell.m
- Description:
- Function List:
*/
        

#import "ConsumptionRecordsTableViewCell.h"
#import "CircleUserDetailViewController.h"
@interface ConsumptionRecordsTableViewCell ()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageTypeDetailLabel;
@end

@implementation ConsumptionRecordsTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    [self.iconImageView addTap];
    self.iconImageView.tapBlock = ^{
        CircleUserDetailViewController*vc=[CircleUserDetailViewController new];
        vc.userId=self.consumptionRecordsInfo.targetUserId;
        [[AppDelegate shared]pushViewController:vc animated:YES];
    };
    self.timeTipLabel.text=@"Consumption time".icanlocalized;
}
#pragma mark - Setter
-(void)setConsumptionRecordsInfo:(ConsumptionRecordsInfo *)consumptionRecordsInfo{
    _consumptionRecordsInfo=consumptionRecordsInfo;
    self.nameLabel.text=consumptionRecordsInfo.targetUserNickname;
    self.packageNameLabel.text=consumptionRecordsInfo.showLocalPackageName;
    self.timeLabel.text=[GetTime convertDateWithString:consumptionRecordsInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.packageTypeDetailLabel.text=consumptionRecordsInfo.showLocaltitle;
    [self.iconImageView setDZIconImageViewWithUrl:consumptionRecordsInfo.targetUserAvatar gender:consumptionRecordsInfo.targetUserGender];
}

#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
