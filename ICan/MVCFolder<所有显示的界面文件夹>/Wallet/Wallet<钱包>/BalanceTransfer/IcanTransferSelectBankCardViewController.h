//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectBankCardViewController.h
- Description:选择转账的时候，输入的银行卡信息时候，选择银行
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanTransferSelectBankCardViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectBlock)(CommonBankCardsInfo*info);
@end

NS_ASSUME_NONNULL_END
