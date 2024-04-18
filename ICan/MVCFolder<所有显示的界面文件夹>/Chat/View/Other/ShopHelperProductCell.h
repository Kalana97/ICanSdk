//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/12/2021
- File name:  ShopHelperProductCell.h
- Description:
- Function List:
*/
        

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kShopHelperProductCell = @"ShopHelperProductCell";
@interface ShopHelperProductCell : QMUITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

NS_ASSUME_NONNULL_END
