//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  AlipayListViewController.h
- Description: 绑定的支付宝列表
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlipayListViewController : QDCommonTableViewController
@property(nonatomic, assign) BOOL isFromWithdraw;
@property(nonatomic, copy) void (^selectAlipyBlock)(BindingAliPayListInfo*info);
@end

NS_ASSUME_NONNULL_END
