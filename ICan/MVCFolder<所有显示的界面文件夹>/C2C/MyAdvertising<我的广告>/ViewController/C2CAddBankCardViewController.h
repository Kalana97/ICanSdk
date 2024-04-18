//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CAddBankCardViewController.h
- Description:添加银行卡
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CAddBankCardViewController : QDCommonViewController
@property(nonatomic, copy) void (^addSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
