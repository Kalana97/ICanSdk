//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  WCDBManager+GroupApplyInfo.h
- Description:
- Function List:
*/
        

#import "WCDBManager.h"
@class GroupApplyInfo;

NS_ASSUME_NONNULL_BEGIN
@class GroupApplyInfo;
@interface WCDBManager (GroupApplyInfo)
-(void)insertGroupApplyInfo:(GroupApplyInfo*)info;
-(NSArray*)getAllApplyInfo;
-(void)deleteOneGroupAppInfo:(NSString*)messageId;
-(NSNumber*)getAllGroupApplyUnReadCount;
-(void)updateGroupApplyInfoHasRead;
-(void)updateGroupApplyInfoAgreeWithMessageId:(NSString*)messageId;
@end

NS_ASSUME_NONNULL_END
