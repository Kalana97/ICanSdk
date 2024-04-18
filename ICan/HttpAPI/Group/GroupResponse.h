//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 15/10/2019
- File name:  GroupResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"
#import "GroupMemberInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupResponse : BaseResponse

@end

/**
 群详情
 */
@interface GroupDetailInfo : NSObject
//群名称
@property (nonatomic,copy) NSString *name;
//群头像
@property (nonatomic,copy) NSString *headImgUrl;
//群公告
@property (nonatomic,copy) NSString *announce;
//群描述
@property (nonatomic,copy) NSString *Description;
//群二维码
@property (nonatomic,copy) NSString *groupQrcode;

@property(nonatomic, copy) NSString *groupId;

@property(nonatomic, copy) NSString *groupNumberId;

@property(nonatomic, copy) NSString *destructionTime;
/** 角色：2、普通成员；0、群主；1、管理员；  */
@property(nonatomic, copy) NSString *role;

/** 群备注 */
@property(nonatomic, copy) NSString *groupRemark;
//创建时间
@property (nonatomic,copy) NSString *createTime;
//是否锁定
@property (nonatomic,assign)BOOL locked;
//是否删除
@property (nonatomic,assign)BOOL deleted;
//渠道
@property (nonatomic,copy) NSString *channel;
//邀请类型
@property (nonatomic,copy) NSString *inviteType;
//用户数量
@property (nonatomic,copy) NSString *userCount;
/**
 允许发送的红包的最大金额
 */
@property(nonatomic, copy) NSString *maxMoney;
/**
 是否在群里
 */
@property (nonatomic,assign)BOOL isInGroup;
/** 是否可以点击头像进入到用户详情 */
@property (nonatomic,assign) BOOL showUserInfo;
/** 是否设置全员禁言 */
@property(nonatomic, assign) BOOL allShutUp;
/** 是否置顶 */
@property(nonatomic, assign) BOOL topChat;
/** 显示群成员昵称 */
@property(nonatomic, assign) BOOL displaysGroupUserNicknames;
@property(nonatomic, assign) BOOL screenCaptureNotice;
/** 消息免打扰 */
@property(nonatomic, assign) BOOL messageNotDisturb;
/**
普通群Ordinary,
vip群Vip
 */
@property(nonatomic, copy) NSString *businessType;
@end

/**
 创建群聊
 */
@interface CreateGroupInfo : NSObject
@property(nonatomic, copy) NSString *groupId;

@end

@interface GroupUserInfo : IDInfo
@property(nonatomic, copy) NSString *gender;
@property(nonatomic, copy) NSString *numberId;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *headImgUrl;
@property(nonatomic, copy) NSString *groupRemark;
@end

/**
查询群成员信息
*/
@interface GroupUserListInfo : NSObject
@property(nonatomic, strong)NSArray <GroupUserInfo *> *object;

@end







NS_ASSUME_NONNULL_END
