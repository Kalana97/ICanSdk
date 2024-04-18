//
//  GroupListViewController.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/8/28.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "BaseViewController.h"
#import "QDCommonTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupListViewController : QDCommonTableViewController
/// 是否从转发页面点击进来的
@property(nonatomic, assign) BOOL fromTranpond;
@property(nonatomic, copy) void (^selectBlock)(NSArray*selectGroupArray);
@end

NS_ASSUME_NONNULL_END
