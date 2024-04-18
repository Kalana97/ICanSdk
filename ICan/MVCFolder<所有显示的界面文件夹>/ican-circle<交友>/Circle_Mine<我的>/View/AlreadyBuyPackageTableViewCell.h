//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  AlreadyBuyPackageTableViewCell.h
- Description:已购套餐的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kAlreadyBuyPackageTableViewCell = @"AlreadyBuyPackageTableViewCell";
@interface AlreadyBuyPackageTableViewCell : BaseCell
@property(nonatomic, strong) MyPackagesInfo *myPackagesInfo;
@end

NS_ASSUME_NONNULL_END
