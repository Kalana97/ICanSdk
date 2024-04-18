//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletTransferTableViewController.h
- Description:我行->ican钱包->钱包界面->转账->输入转账用户或者是选择转账用户
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletTransferInputUserTableViewController : QDCommonTableViewController
@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@end

NS_ASSUME_NONNULL_END
