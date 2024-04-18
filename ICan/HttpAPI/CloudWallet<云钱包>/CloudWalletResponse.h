//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2019
- File name:  CloudWalletResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudWalletResponse : BaseResponse

@end
/**
 云钱包查询
 */
@interface CloudWalletBalanceInfo : BaseResponse
@property(nonatomic, copy) NSString *balance;
//是否设置了支付密码 1是设置
@property(nonatomic, assign) BOOL tradePswdSet;
//钱包是否可用
@property(nonatomic, copy) NSString *walletStatus;
//云钱包ID
@property(nonatomic, copy) NSString *walletUserNo;
/** vip 等级 */
@property(nonatomic, copy) NSString *walletCategory;
@end

NS_ASSUME_NONNULL_END
