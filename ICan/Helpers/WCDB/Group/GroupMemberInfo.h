//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- Modifier: Rohan Jayasekara on 2022-09-19
- File name:  GroupMemberInfo.h
- Description: 群成员数据
- Function List:
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>
#import "InvitedByInfo.h"

static NSString* const KWCGroupMemberInfoTable = @"GroupMemberInfo";
@interface GroupMemberInfo : NSObject

@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * gender;
@property (nonatomic,retain) NSString * numberId;
@property (nonatomic,retain) NSString * nickname;
@property (nonatomic,retain) NSString * username;
@property (nonatomic,retain) NSString * headImgUrl;
@property (nonatomic,retain) NSString * groupRemark;
@property (nonatomic,retain) NSString * groupId;
@property (nonatomic,retain) NSString * joinType;
@property (nonatomic,retain) NSString * joinTime;
@property (nonatomic,retain) NSString * joinTimeEnd;
@property (nonatomic,retain) NSString * joinTimeStat;
@property (nonatomic,retain) InvitedByInfo * invitedBy;
//0 群主 1 管理员 2 普通成员
@property (nonatomic,retain) NSString * role;
/** 是否是VIP */
@property(nonatomic, assign) BOOL vip;

@property(nonatomic, strong) NSNumber *vipMoney;
/** 是否可以点击  */
@property(nonatomic, assign) BOOL canEnabled;
/** 当前是否是选中状态 */
@property(nonatomic, assign) BOOL isSelect;
@property(nonatomic, assign) BOOL isMultipleSelected;
@property(nonatomic, assign) BOOL mutedByAdmin;
@end

