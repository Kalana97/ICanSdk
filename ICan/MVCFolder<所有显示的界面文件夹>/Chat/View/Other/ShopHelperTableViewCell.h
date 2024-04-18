//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/12/2021
- File name:  ShopHelperTableViewCell.h
- Description:商城助手
- Function List:
*/
        

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kShopHelperTableViewCell = @"ShopHelperTableViewCell";
@interface ShopHelperTableViewCell : QMUITableViewCell
@property(nonatomic, strong) ShopHelperMsgInfo *info;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END
