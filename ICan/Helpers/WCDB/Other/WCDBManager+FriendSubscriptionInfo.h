//
//  WCDBManager+FriendSubscriptionInfo.h
//  EasyPay
//
//  Created by young on 26/9/2019.
//  Copyright © 2019 EasyPay. All rights reserved.
//

//#import <AppKit/AppKit.h>

#import "WCDBManager.h"
@class FriendSubscriptionInfo;
NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (FriendSubscriptionInfo)
/**
 插入某条数据

 @param friendSubscriptionInfo friendSubscriptionInfo description
 */
-(void)insertFriendSubscriptionInfo:(FriendSubscriptionInfo *)friendSubscriptionInfo;

/// 删除某条数据
-(void)deleteFriendSubscriptionInfoWithSender:(NSString *)sender;

/// 更新好友订阅的状态
-(void)updateFriendSubscriptionIsHasReadWithSender:(NSString *)sender SubscriptionType:(NSInteger)subscriptionType;

/// 更新好友订阅的状态
-(void)updateFriendSubscriptionShowName:(NSString *)showName withSender:(NSString *)sender;

//  获取所有好友订阅消息
-(NSArray *)fetchAllFriendSubscriptionInfo;

/**  查询未读的好友请求数量 */
-(NSInteger)fetchFriendSubscriptionUnReadAmount;

/// 更新本地所有的好友请求为已读
-(void)updateFriendSubscriptionInfoHasRead;
@end

NS_ASSUME_NONNULL_END
