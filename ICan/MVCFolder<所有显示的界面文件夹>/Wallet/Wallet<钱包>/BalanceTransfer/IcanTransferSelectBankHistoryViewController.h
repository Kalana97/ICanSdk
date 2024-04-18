//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectUserViewController.h
- Description:选择转账银行卡的历史记录
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanTransferSelectBankHistoryViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectBlock)(BindingBankCardListInfo*info);
@end

NS_ASSUME_NONNULL_END
