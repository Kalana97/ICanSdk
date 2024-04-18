//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/11/2019
- File name:  RechargeRecordListTableViewCell.m
- Description:
- Function List:
*/
        

#import "RechargeRecordListTableViewCell.h"

@implementation RechargeRecordListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRechargeRecordInfo:(RechargeRecordInfo *)rechargeRecordInfo{
    _rechargeRecordInfo=rechargeRecordInfo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
