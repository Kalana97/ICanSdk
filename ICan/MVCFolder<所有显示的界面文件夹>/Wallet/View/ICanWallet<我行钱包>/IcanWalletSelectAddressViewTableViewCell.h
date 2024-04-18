//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletSelectAddressViewTableViewCell.h
 - Description:
 - Function List:
 */


#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanWalletSelectAddressViewTableViewCell = @"IcanWalletSelectAddressViewTableViewCell";
static CGFloat  const kHeightIcanWalletSelectAddressViewTableViewCell = 70;
@interface IcanWalletSelectAddressViewTableViewCell : BaseCell
@property(nonatomic, copy) void (^didSelectBlock)(void);
@property(nonatomic, copy) void (^deleteBlock)(void);
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;
@property(nonatomic, strong) ExternalWalletsInfo *walletAddressInfo;
@property(nonatomic, strong) ICanWalletAddressInfo *addressInfo;
@property(nonatomic, strong)  NSString *typeDirected;
@end

NS_ASSUME_NONNULL_END
