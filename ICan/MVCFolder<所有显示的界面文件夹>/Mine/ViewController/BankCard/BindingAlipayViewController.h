//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  BindingViewController.h
- Description:绑定支付宝
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindingAlipayViewController : BaseViewController
@property(nonatomic, copy) void (^bindingSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
