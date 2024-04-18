//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferBankViewController.h
- Description:转账到银行卡界面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanSureTransferViewController : BaseViewController
/** 是不是提现到支付宝 */
@property(nonatomic, copy) NSString *bank;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *bankName;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *bindingId;
@property(nonatomic, copy) NSString *bankType;
@property(nonatomic, copy) NSString *bankTypeId;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *availableBalance;

@end

NS_ASSUME_NONNULL_END
