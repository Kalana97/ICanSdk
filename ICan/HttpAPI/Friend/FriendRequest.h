//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 16/10/2019
- File name:  FriendRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequest : BaseRequest

@end


/// 申请添加好友
@interface ApplyFriendRequest : BaseRequest
@property(nonatomic, strong,nullable) NSNumber *userId;
@property(nonatomic, copy,nullable) NSString *message;
@end

/// 同意添加好友
@interface AgreeFriendRequest : BaseRequest
@property(nonatomic, copy) NSNumber *userId;
@end
@interface DeleteFriendRequest : BaseRequest

@end

/** <#注释#> */
@interface SetFriendRemarknameRequest : BaseRequest
@property(nonatomic, copy) NSNumber *userId;
@property(nonatomic, copy, nullable) NSString *remark;
@end
/** 获取好友列表 */
@interface GetFriendsListRequest : BaseRequest

@end

NS_ASSUME_NONNULL_END
