//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/11/2021
- File name:  C2CConfirmReceiptMoneyViewController.h
- Description: 购买订单确认
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CPConfirmOrderViewController : QDCommonViewController
@property (nonatomic, strong) C2COrderInfo *orderInfo;
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
@property (nonatomic, assign) BOOL haveUnreadMsg;
@property (nonatomic, assign) BOOL fromTopup;
@end

NS_ASSUME_NONNULL_END
