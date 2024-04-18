//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletTransferInputMoneyViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletTransferInputMoneyViewController : BaseViewController
@property(nonatomic, copy) NSString *numberId;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickname;

@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;

@end

NS_ASSUME_NONNULL_END
