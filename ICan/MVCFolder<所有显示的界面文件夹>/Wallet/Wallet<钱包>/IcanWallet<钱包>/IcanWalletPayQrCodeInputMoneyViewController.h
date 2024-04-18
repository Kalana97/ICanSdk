//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletTransferInputMoneyViewController.h
- Description:扫描c2c收款码之后的付款界面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletPayQrCodeInputMoneyViewController : BaseViewController
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
