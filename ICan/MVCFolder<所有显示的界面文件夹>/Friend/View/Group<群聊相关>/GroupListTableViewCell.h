//
//  TransferTableViewCell.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/24.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
NS_ASSUME_NONNULL_BEGIN
static NSString* const kGroupListTableViewCell = @"GroupListTableViewCell";
static CGFloat const kHeightGroupListTableViewCell = 55;
@interface GroupListTableViewCell : BaseCell


@property (nonatomic,strong) GroupListInfo * groupListInfo;


@end

NS_ASSUME_NONNULL_END
