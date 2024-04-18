//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/9/2020
- File name:  PayReceiptMentViewController.h
- Description: 扫描收款码之后->支付界面
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayReceiptMentViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^settingMoneySuccessBlock)(NSString*money);
@property(nonatomic, copy)NSString*code;
@property(nonatomic, copy)NSString*userId;
@property(nonatomic, copy)NSString*money;

/** 是否是扫描付款码进来的页面 */
@property(nonatomic, assign) BOOL isPayment;
@property(nonatomic, copy) NSString *codeStr;
@end

NS_ASSUME_NONNULL_END
