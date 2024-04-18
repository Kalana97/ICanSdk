//
//  PayMoneyViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
// 付款码页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PayMoneyViewController : BaseViewController
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, strong) GetPaymentListInfo *info;
@end

NS_ASSUME_NONNULL_END
