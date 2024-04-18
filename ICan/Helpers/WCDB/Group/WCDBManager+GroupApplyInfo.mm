//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  WCDBManager+GroupApplyInfo.m
- Description:
- Function List:
*/
        

#import "WCDBManager+GroupApplyInfo.h"
#import "GroupApplyInfo+WCTTableCoding.h"
@implementation WCDBManager (GroupApplyInfo)
-(void)insertGroupApplyInfo:(GroupApplyInfo*)info{
    [self.wctDatabase insertObject:info into:KWCGroupApplyInfoTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:KreceivedApplyJoinGroupNotification object:nil];
}
-(NSArray*)getAllApplyInfo{
    return  [self.wctDatabase getObjectsOfClass:[GroupApplyInfo class] fromTable:KWCGroupApplyInfoTable orderBy:{GroupApplyInfo.messageTime.order(WCTOrderedDescending)}];
}
-(void)deleteOneGroupAppInfo:(NSString*)messageId{
    [self.wctDatabase deleteObjectsFromTable:KWCGroupApplyInfoTable where:GroupApplyInfo.messageId==messageId];
}
-(NSNumber *)getAllGroupApplyUnReadCount{
    NSArray*array=[self.wctDatabase getObjectsOfClass:[GroupApplyInfo class] fromTable:KWCGroupApplyInfoTable where:GroupApplyInfo.isRead==NO];
    return @(array.count);
}
-(void)updateGroupApplyInfoHasRead{
    [self.wctDatabase updateRowsInTable:KWCGroupApplyInfoTable onProperty:GroupApplyInfo.isRead withValue:@(YES) where:GroupApplyInfo.isRead==NO];
    
    
}
-(void)updateGroupApplyInfoAgreeWithMessageId:(NSString*)messageId{
    [self.wctDatabase updateRowsInTable:KWCGroupApplyInfoTable onProperty:GroupApplyInfo.isAgree withValue:@(YES) where:GroupApplyInfo.messageId==messageId];
    
    
}
@end
