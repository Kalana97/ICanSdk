//
//  WCDBManager+FriendSubscriptionInfo.m
//  EasyPay
//
//  Created by young on 26/9/2019.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "WCDBManager+FriendSubscriptionInfo.h"
#import "FriendSubscriptionInfo+WCTTableCoding.h"


@implementation WCDBManager (FriendSubscriptionInfo)

-(void)insertFriendSubscriptionInfo:(FriendSubscriptionInfo *)friendSubscriptionInfo{
    BOOL isSuccess=   [self.wctDatabase insertOrReplaceObject:friendSubscriptionInfo into:KWCFriendSubscriptionInfoTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:kReceiveFriendApplyNotication object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil userInfo:nil];
    DDLogInfo(@"insertFriendSubscriptionInfo=%d",isSuccess);
    
}

-(BOOL)checkFriendSubscriptionInfoIsExistWithSender:(NSString *)sender{
    NSArray<FriendSubscriptionInfo*>*array= [self.wctDatabase getObjectsOfClass:[FriendSubscriptionInfo class] fromTable:KWCFriendSubscriptionInfoTable where:FriendSubscriptionInfo.sender ==sender];
    return array.count>0?YES:NO;
    
}


-(void)deleteFriendSubscriptionInfoWithSender:(NSString *)sender{
    BOOL isExist = [self checkFriendSubscriptionInfoIsExistWithSender:sender];
    if (isExist) {
        [self.wctDatabase deleteObjectsFromTable:KWCFriendSubscriptionInfoTable where:FriendSubscriptionInfo.sender ==sender];
    }
    
}

-(void)updateFriendSubscriptionIsHasReadWithSender:(NSString *)sender SubscriptionType:(NSInteger)subscriptionType{
    [self.wctDatabase updateRowsInTable:KWCFriendSubscriptionInfoTable onProperty:FriendSubscriptionInfo.subscriptionType withValue:@(subscriptionType) where:FriendSubscriptionInfo.sender==sender];
}
-(void)updateFriendSubscriptionShowName:(NSString *)showName withSender:(NSString *)sender{
    [self.wctDatabase updateRowsInTable:KWCFriendSubscriptionInfoTable onProperty:FriendSubscriptionInfo.showName withValue:showName where:FriendSubscriptionInfo.sender==sender];
}
-(NSArray *)fetchAllFriendSubscriptionInfo{
    return  [self.wctDatabase getObjectsOfClass:[FriendSubscriptionInfo class] fromTable:KWCFriendSubscriptionInfoTable orderBy:{FriendSubscriptionInfo.messageTime.order(WCTOrderedDescending)}];
}
-(NSInteger)fetchFriendSubscriptionUnReadAmount{
    NSArray*array=[self.wctDatabase getObjectsOfClass:[FriendSubscriptionInfo class] fromTable:KWCFriendSubscriptionInfoTable where:FriendSubscriptionInfo.isRead==NO];
    return array.count;
}
-(void)updateFriendSubscriptionInfoHasRead{
    [self.wctDatabase updateRowsInTable:KWCFriendSubscriptionInfoTable onProperty:FriendSubscriptionInfo.isRead withValue:@(YES) where:FriendSubscriptionInfo.isRead==NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateFriendSubscriptionReadNotication object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil userInfo:nil];
    
}
@end
