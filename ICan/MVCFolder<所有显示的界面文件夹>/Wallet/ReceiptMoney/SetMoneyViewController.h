//
//  SetMoneyViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//  设置金额

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetMoneyViewController : QDCommonViewController
@property(nonatomic, copy) void (^settingMoneySuccessBlock)(NSString*money);
/** 是否是扫描付款码进来的页面 */
@property(nonatomic, assign) BOOL isPayment;
@property(nonatomic, copy) NSString *codeStr;
@end

NS_ASSUME_NONNULL_END
