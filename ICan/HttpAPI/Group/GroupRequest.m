//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 15/10/2019
- File name:  GroupRequest.m
- Description:
- Function List:
*/
        

#import "GroupRequest.h"

@implementation GroupRequest

@end
@implementation CreateGroupRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"创建群聊";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/group/create"];
}

@end

@implementation QuitGroupRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"用户自己退出群聊";
}


@end


@implementation InviteGroupRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"加入群聊";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/group/join"];
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"operater":@"operator"};
}
@end
@implementation KickOutGroupRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"踢人出群";
}

@end
@implementation GetGroupListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取群聊列表";
}
-(NSString *)pathUrlString{
    return  [NSString stringWithFormat:@"%@/group/list",self.baseUrlString];
}
@end
@implementation GetGroupDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"群详情";
}



@end
@implementation EditGroupNameRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改群名称";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/group/groupName"];
}
@end
@implementation EditgroupUserNicknameRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改群昵称";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/group/groupUserNickname"];
}
@end

@implementation GetGroupUserListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"查询群成员信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/group/groupUserList"];
}

@end
@implementation SettingScreenCaptureNoticeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置群聊的截屏通知";
}


@end
@implementation SettingDestructionTimeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置群聊阅后即焚";
}


@end
@implementation SettingAnnounceRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置群告";
}
-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/group/announce"];
}

@end

@implementation SettingGroupShowNickNameRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置群是否显示昵称";
}

@end
@implementation SettingGroupMessageNotDisturbRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置开启关闭消息免打扰";
}

@end

@implementation SettingGroupTopChatRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"开启关闭聊天置顶";
}

@end

@implementation ChangeGroupHeadImgUrlRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置群头像";
}
-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/group/headImgUrl"];
}


@end
@implementation ChangeGroupShowUserInfoRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"开启关闭群是否显示用户详情";
}

@end
@implementation ChangeGroupallShutUpRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @" 开启关闭群是否全员禁言";
}

@end

@implementation SettingGroupOwnerOrManagerRequest


-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @" 修改群成员身份";
}

-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/group/groupRole"];
}


@end

@implementation MuteUserSettingGroupRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @" 修改群成员身份";
}
-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/group/muteUser"];
}
@end

@implementation RemoveGroupAllMessageRequest


-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"删除群的所有消息";
}

@end
@implementation SettingJoinGroupReviewRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置入群审核";
}

@end


