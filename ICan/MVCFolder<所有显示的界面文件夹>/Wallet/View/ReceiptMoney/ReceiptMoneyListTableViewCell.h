//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/9/2020
- File name:  ReceiptMoneyListTableViewCell.h
- Description:收款码页面的人数
- Function List:
*/
        

#import "BaseCell.h"
@class Notice_PayQRInfo;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kReceiptMoneyListTableViewCell = @"ReceiptMoneyListTableViewCell";
static CGFloat const kHeightReceiptMoneyListTableViewCell = 50;
@interface ReceiptMoneyListTableViewCell : BaseCell
@property(nonatomic, strong) Notice_PayQRInfo *info;
@end

NS_ASSUME_NONNULL_END
