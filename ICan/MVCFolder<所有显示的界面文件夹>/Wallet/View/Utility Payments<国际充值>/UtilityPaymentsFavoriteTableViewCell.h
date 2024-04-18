//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/6/2021
- File name:  UtilityPaymentsFavoriteTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kUtilityPaymentsFavoriteTableViewCell = @"UtilityPaymentsFavoriteTableViewCell";
@interface UtilityPaymentsFavoriteTableViewCell : BaseCell
@property(nonatomic, strong) DialogListInfo *dialogInfo;
@end

NS_ASSUME_NONNULL_END
