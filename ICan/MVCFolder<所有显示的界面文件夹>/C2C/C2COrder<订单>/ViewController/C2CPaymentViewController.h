//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/11/2021
- File name:  C2CConfirmReceiptMoneyViewController.h
- Description:买家确认付款
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CPaymentViewController : QDCommonViewController

@property (nonatomic, strong) C2COrderInfo *orderInfo;
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
@property(nonatomic, assign) NSInteger payCancelTime;
@property (nonatomic, strong) C2CPaymentMethodInfo *methodInfo;
@end

NS_ASSUME_NONNULL_END
