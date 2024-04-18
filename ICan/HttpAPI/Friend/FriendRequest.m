//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 16/10/2019
- File name:  FriendRequest.m
- Description:
- Function List:
*/
        

#import "FriendRequest.h"

@implementation FriendRequest

@end
@implementation ApplyFriendRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"申请好友";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/userFriend/apply"];
}

@end
@implementation AgreeFriendRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"同意添加好友";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/userFriend/add"];
}

@end
@implementation DeleteFriendRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除好友";
}


@end
@implementation SetFriendRemarknameRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置好友备注";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/userFriend/setRemark"];
}

@end
@implementation GetFriendsListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取好友列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/userFriend/friendList"];
}


@end
