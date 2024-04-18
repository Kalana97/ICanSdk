//
//  NewFriendsTableViewCell.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/6/17.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "FriendSubscriptionInfo.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const KNewFriendsTableViewCell=@"NewFriendsTableViewCell";
static CGFloat const kNewFriendsTableViewCellHeight = 100;
@interface NewFriendsTableViewCell : BaseCell
@property (nonatomic,copy) void(^agreeSucessBlock)(void);
@property (nonatomic,copy) void(^refuseSucessBlock)(void);


@property (nonatomic ,strong) FriendSubscriptionInfo * friendSubscriptionInfo;
@end

NS_ASSUME_NONNULL_END
