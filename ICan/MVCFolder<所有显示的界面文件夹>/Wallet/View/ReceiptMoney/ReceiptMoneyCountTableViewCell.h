//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/9/2020
- File name:  ReceiptMoneyCountTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kReceiptMoneyCountTableViewCell = @"ReceiptMoneyCountTableViewCell";
static CGFloat const kHeightReceiptMoneyCountTableViewCell = 50;
@interface ReceiptMoneyCountTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *countMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *coutTipsLabel;

@end

NS_ASSUME_NONNULL_END
