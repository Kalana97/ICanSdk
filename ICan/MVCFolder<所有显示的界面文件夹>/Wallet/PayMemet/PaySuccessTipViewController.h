//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2020
- File name:  PaySuccessTipViewController.h
- Description:收款结果显示 或者是付款结果显示
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaySuccessTipViewController : BaseViewController
@property(nonatomic, copy)NSString*userId;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, assign) BOOL isPay;
@end

NS_ASSUME_NONNULL_END
