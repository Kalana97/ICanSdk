//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  FriendSubscriptionInfo.h
- Description: 好友订阅的数据表
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>
static NSString * const KWCFriendSubscriptionInfoTable= @"FriendSubscriptionInfo";

@interface FriendSubscriptionInfo : NSObject

@property(nonatomic, retain) NSString *messageTime;
/**  附带过来的请求消息 */
@property(nonatomic, retain) NSString *message;
/** 谁发送过来的好友请求作为主键  */
@property(nonatomic, retain) NSString *sender;
//是否已回复 （0：拒绝，1：同意，2：还未处理）
@property(nonatomic, assign) NSInteger subscriptionType;

/** 是否已读 需要缓存 每次收到好友请求之后都是默认为NO 进入新好友页面之后都需要把该值设置为yes 并且更新chatlistViewcontroller的头部小红点去掉 并且把friendlst的的未读提示去掉 */
@property (nonatomic, assign) BOOL isRead;
@property(nonatomic, copy) NSString *showName;
/** 是否可以连续点击 是为了在新的好友页面 用户不可以连续点击 */
@property(nonatomic, assign) BOOL isCanClick;
@end
