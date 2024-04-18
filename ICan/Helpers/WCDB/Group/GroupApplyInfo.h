//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyInfo.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
static NSString* const KWCGroupApplyInfoTable = @"GroupApplyInfo";
@interface GroupApplyInfo : NSObject
/**
 进群类型
 //扫码加入
 #define KNotice_AddGroup_ScanCode @"ScanCode"
 //被邀请加入
 #define KNotice_AddGroup_BeInvited @"BeInvited"
 //后台加入
 #define KNotice_AddGroup_ManagerAdd @"ManagerAdd"
 */
@property(nonatomic, copy) NSString *addGroupMode;

@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *inviterId;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, copy) NSString *messageId;
@property(nonatomic, copy) NSString *messageTime;
@property(nonatomic, copy) NSString *joinType;
/** 是否已读 需要缓存  */
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isAgree;
@end
