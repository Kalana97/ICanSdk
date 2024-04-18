//
//  BankCardRechargeViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankCardRechargeViewController : QDCommonTableViewController
@property (nonatomic,strong) RechargeChannelInfo * rechargeChannelInfo;
@property (nonatomic,copy)   NSString * orderAmount;
@end

NS_ASSUME_NONNULL_END
