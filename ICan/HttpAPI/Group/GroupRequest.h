//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 15/10/2019
- File name:  GroupRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupRequest : BaseRequest

@end
//创建群聊
@interface CreateGroupRequest :BaseRequest
@property (nonatomic,strong) NSArray * inviterIds;

@property(nonatomic, copy) NSString *name;
@end


/**
 用户自己退出群聊
 */
@interface QuitGroupRequest : BaseRequest

@end


/**
 加入群聊
 */
@interface InviteGroupRequest : BaseRequest
// 群id
@property (nonatomic,strong) NSNumber * groupId;
// 邀请人id
@property (nonatomic,strong) NSNumber * inviterId;
//  加入类型：1、邀请加入；2、扫描二维码   3: 搜索入群 Search；
//  加群类型,可用值:Create,Invite,QRCode,Manager,Other,Search
@property (nonatomic,strong) NSString * joinType;
//  被邀请人id列表   item 类型: string
@property (nonatomic,strong) NSArray * userIds;
/** 同意的管理员或群主ID  */
@property(nonatomic, strong,nullable) NSNumber *operater;
@end
/**
 踢人出群
 */
//POST /group/kickOut
@interface KickOutGroupRequest : BaseRequest

@end
/**
 获取群详情
 */
@interface GetGroupDetailRequest : BaseRequest
@end

/**
 获取群聊列表
 */
@interface GetGroupListRequest : BaseRequest

@end
@interface EditGroupNameRequest : BaseRequest
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *groupName;
@end

/// 修改自己在群中的昵称group/groupUserNickname
@interface EditgroupUserNicknameRequest : BaseRequest
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *groupUserNickname;
@end

/**
 查询群成员信息
 */
@interface GetGroupUserListRequest : BaseRequest
@property(nonatomic, copy,nullable) NSString *groupId;
/** 需要查询的群用户 不传就是查所有 */
@property(nonatomic, copy,nullable) NSArray *ids;
@end

//设置群聊的截屏通知/group/screenCaptureNotice/{id
@interface SettingScreenCaptureNoticeRequest:BaseRequest
@end

/** 设置群聊的阅后即焚时间/group/destructionTime/{id}/{time} */
@interface SettingDestructionTimeRequest : BaseRequest

@end

/// 设置群公告/group/announce
@interface SettingAnnounceRequest : BaseRequest
@property(nonatomic, strong) NSNumber *groupId;
@property(nonatomic, copy) NSString *announce;
@end

///group/{id}/showNickName设置是否显示昵称
@interface SettingGroupShowNickNameRequest:BaseRequest

@end

///group/{id}/messageNotDisturb开启关闭消息免打扰
@interface SettingGroupMessageNotDisturbRequest:BaseRequest

@end
////group/{id}/topChat开启关闭聊天置顶
@interface SettingGroupTopChatRequest:BaseRequest

@end

@interface ChangeGroupHeadImgUrlRequest : BaseRequest
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *headImgUrl;

@end
/**
 group/{id}/showUserInfo
 开启关闭群是否显示用户详情
 */
@interface ChangeGroupShowUserInfoRequest:BaseRequest
@end
/**
 /group/{id}/allShutUp
 开启关闭群是否全员禁言
 */
@interface ChangeGroupallShutUpRequest:BaseRequest
@end



/**
 PUT/group/groupRole
 转让群主，设置管理员.修改群成员身份
 */
@interface SettingGroupOwnerOrManagerRequest:BaseRequest

@property(nonatomic, copy) NSString *groupId;
//用户id
@property(nonatomic, copy) NSString *userId;
//Owner Manager  Member
@property(nonatomic, copy) NSString *groupRole;
@end

@interface MuteUserSettingGroupRequest:BaseRequest
@property (nonatomic, assign) NSInteger groupId;
@property (assign, nonatomic) BOOL mute;
@property (nonatomic, assign) NSInteger userToMute;
@end
/**
 /message/remove/group/{id}
 删除群的所有消息
 */
@interface RemoveGroupAllMessageRequest : BaseRequest

@end

/**
 设置入群审核
 PUT
 /group/joinGroupReview/{id}/{open}
 */
@interface SettingJoinGroupReviewRequest:BaseRequest
@end
NS_ASSUME_NONNULL_END
