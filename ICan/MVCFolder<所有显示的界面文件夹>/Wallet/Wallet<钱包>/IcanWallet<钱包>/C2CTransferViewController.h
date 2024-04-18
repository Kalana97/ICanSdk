//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/12/2021
- File name:  C2CTransferViewController.h
- Description:划转
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CTransferViewController : BaseViewController
/** 是否是从余额账户到钱包账户 */
@property(nonatomic, assign) BOOL isCapitalToWallet;
@end

NS_ASSUME_NONNULL_END
