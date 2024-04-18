//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectAlipayViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanTransferSelectAlipayHistoryViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectBlock)(BindingAliPayListInfo*info);

@end

NS_ASSUME_NONNULL_END
