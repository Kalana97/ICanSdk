//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/11/2019
- File name:  WithdrawRecordListTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kWithdrawRecordListTableViewCell = @"WithdrawRecordListTableViewCell";
static CGFloat const kHeightWithdrawRecordListTableViewCell =60;
@interface WithdrawRecordListTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(nonatomic, strong) WithdrawRecordInfo *withdrawRecordInfo;
@property(nonatomic, strong) RechargeRecordInfo *rechargeRecordInfo;
@property(nonatomic, strong) BillInfo *billInfo;
@end

NS_ASSUME_NONNULL_END
