//
//  ICanWalletWithdrawStatusViewController.h
//  ICan
//
//  Created by dzl on 14/6/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICanWalletWithdrawStatusViewController : BaseViewController
@property(nonatomic, strong) IcanWalletWithdrawRequest *request;
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;
@end

NS_ASSUME_NONNULL_END
