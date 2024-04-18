//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 16/9/2019
- File name:  ChatListModel.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
static NSString * const KWCChatListModelTable= @"ChatListModel";

@interface ChatListModel : NSObject
/** 消息来源(消息来自于谁) */
@property(nonatomic, retain) NSString *  messageFrom;
/** 消息来源（消息发送给谁） */
@property(nonatomic, retain) NSString *  messageTo;
@property(nonatomic, retain) NSString *  chatMode;
/** 单聊的用户ID */
@property (nonatomic,retain) NSString *userID;
/** 群聊的群ID */
@property (nonatomic,retain) NSString *groupID;
/** 和谁聊天(群或者是人) */
@property (nonatomic,retain) NSString *chatID;
/** 消息内容 */
@property (nonatomic,retain) NSString *messageContent;
/** 最后一条消息的时间 */
@property (nonatomic, retain) NSString *lastMessageTime;
/** 普通聊天未读消息数量 */
@property (nonatomic,assign) NSInteger  unReadMessageCount;
/** 聊天类型（单聊 userChat  或 群聊 groupChat） */
@property (nonatomic,retain) NSString *chatType;
/** 是否为自己发的 */
@property ( nonatomic, assign) BOOL isOutGoing;
/** 是否置顶 */
@property (nonatomic, assign) BOOL isStick;
/** 免打扰
 */
@property (nonatomic, assign) BOOL isNoDisturbing;
/** 消息内容类型 语音还是文字或者是其他
 */
@property (nonatomic, copy) NSString* messageType;
/** 存储非私聊草稿信息 */
@property (nullable, nonatomic, retain) NSString *draftMessage;

/**是否显示@ 即时收到了其他消息 但是如果用户还没有点击进去看 那么还是显示有人@你*/
@property (nonatomic,assign) BOOL isShowAt;
/**是否是客服*/
@property (nonatomic,assign) BOOL isService;
/** 显示的名字 主要是为了搜索的时候，可以搜索名字出来 并且显示高亮*/
@property (nullable, nonatomic, retain)  NSString * showName;

/** 是否设置全员禁言 */
@property(nonatomic, assign) BOOL allShutUp;

/** 是否自己拉黑别人 */
@property(nonatomic, assign) BOOL block;
/** 是否被别人拉黑 */
@property(nonatomic, assign) BOOL beBlock;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend 好友  secret 私聊  circle 交友  c2c
 */
@property(nonatomic, copy) NSString *authorityType;
/**
 交友用户ID
 */
@property(nonatomic, copy) NSString *circleUserId;
/** 对方的c2c用户ID */
@property(nonatomic, copy) NSString *c2cUserId;
/** c2c的订单ID */
@property(nonatomic, copy) NSString *c2cOrderId;
//下面字段不会保存在数据库里面
/** 是否是选中 */
@property(nonatomic, assign) BOOL isSelect;
@end
NS_ASSUME_NONNULL_END
