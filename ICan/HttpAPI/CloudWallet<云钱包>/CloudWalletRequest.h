//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2019
- File name:  CloudWalletRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudWalletRequest : BaseRequest

@end


/// 云钱包开户
@interface CloudWalletOpenEBaoRequest : BaseRequest

@end
/** 云钱包账户查询 */
@interface CloudWalletBalanceRequest : BaseRequest

@end
/** 支付密码管理
 /easyPay/cloudWallet/managePassword
 */
@interface CloudWalletManagePasswordRequest : BaseRequest

@end

///easyPay/cloudWallet/manageBankCard
@interface CloudWalletManageBankCardRequest : BaseRequest

@end
/**
 云钱包充值
 */
///easyPay/cloudWallet/recharge
@interface CloudWalletRechargeRequest : BaseRequest
@property(nonatomic, copy) NSString *amount;
@end
/**
 云钱包提现
 */
////easyPay/cloudWallet/withdraw
@interface CloudWalletWithdrawRequest : BaseRequest
@property(nonatomic, copy) NSString *amount;
@end
NS_ASSUME_NONNULL_END
