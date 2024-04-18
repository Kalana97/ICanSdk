//
//  BankCardListViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankCardListViewController : QDCommonTableViewController
@property(nonatomic, assign) BOOL isFromWithdraw;
@property(nonatomic, copy) void (^selectBankcardBlock)(BindingBankCardListInfo*info);
@end

NS_ASSUME_NONNULL_END
