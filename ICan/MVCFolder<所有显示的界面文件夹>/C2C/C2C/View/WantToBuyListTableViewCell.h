//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyListTableViewCell.h
- Description:我要买的listcell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kWantToBuyListTableViewCell = @"WantToBuyListTableViewCell";
@interface WantToBuyListTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIView *cellLineView;
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
//成交量
@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;
//比例
@property (weak, nonatomic) IBOutlet UILabel *volumeTwoLabel;
/** 是否是自选 我要买 */
@property(nonatomic, assign) BOOL isOptionBuy;
///是否是用户详情里面的cell
@property(nonatomic, assign) BOOL isUserDetail;
@end

NS_ASSUME_NONNULL_END
