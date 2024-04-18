//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/16
- System_Version_MACOS: 10.14
- EasyPay
- File name:  WCDBManager+ChatList.h
- Description:
- Function List: 
- History:
*/
        

#import "WCDBManager.h"
@class ChatListModel;

//NS_ASSUME_NONNULL_BEGIN
@interface WCDBManager (ChatList)
/// 删除某种类型的所有消息
/// @param authorityType authorityType description
-(void)deleteChatListModelWithAuthorityType:(NSString*)authorityType;

/// 删除某一条聊天列表数据
/// @param config config description
-(void)deleteOneChatListWithChatModel:(ChatModel*)config;

/// 重置当前会话的未读消息数量未零
/// @param config config description
-(void)resetChatListModelUnReadMessageCountWithChatModel:(ChatModel*)config;

/// 保存或者更新会话列表的最后一条消息内容
/// @param chatModel chatModel description
-(void)saveChatListModelWithChatModel:(ChatModel*)chatModel;
/// 添加c2c的钱包助手消息
-(ChatModel*)insertC2CHelperMessageWithChatModel:(ChatModel*)chatModel;
/// Notice_OTP
- (ChatModel*)insertNoticeOTPMessageWithChatModel:(ChatModel*)chatModel;
/** 更新需要显示的最后一条消息 */
-(void)updateChatListModelLastMessageWithChatModel:(ChatModel*)config;
/// 更新是否是免打扰
/// @param isNoDisturbing 是否免打扰
/// @param chatId 当前会话ID
-(void)updateIsNoDisturbing:(BOOL)isNoDisturbing chatId:(NSString*)chatId chatType:(NSString*)chatType;

/// 更新是否置顶
/// @param isStick isStick description
/// @param chatId chatId description
-(void)updateIsStick:(BOOL)isStick chatId:(NSString*)chatId chatType:(NSString*)chatType;
/// 跟新显示的名字
/// @param showName showName description
/// @param chatId chatId description
-(void)updateShowName:(NSString*)showName chatId:(NSString*)chatId chatType:(NSString*)chatType;


/// 更新不显示@
-(void)updateNoShowAt:(ChatModel*)config;


/// 更新群聊是否禁言
/// @param chatId chatId description
-(void)updateGroupAllShutUp:(NSString*)chatId allShutUp:(BOOL)allShutUp;
/// 更新保存的草稿消息
/// @param draftText draftText description
/// @param chatId chatId description
/// @param chatType chatType description
/// @param authorityTyp authorityTyp description
-(void)saveDraftMessage:(NSString*)draftText chatModel:(ChatModel*)config;
/// 更新是否是客服
/// @param chatId chatId description
-(void)updateIsService:(BOOL)IsService userId:(NSString*)userId;

/// 更新该会话的用户是否被自己拉黑 用户不显示在聊天列表
/// @param block 是否被拉黑
/// @param chatId chatId description
-(void)updateIsBlock:(BOOL)block chatId:(NSString*)chatId;

/// 更新自己是否被拉黑 自己被拉黑还可以显示在聊天列表
/// @param block 是否被拉黑
/// @param chatId chatId description
-(void)updateIsbeBlock:(BOOL)beBlock chatId:(NSString*)chatId;

-(void)updateShowLastModelWithConfig:(ChatModel*)config;
/// 获取AuthorityType_friend所有的会话
-(NSArray<ChatListModel*>*)getAllIcanChatListModel;
/// 获取所有能够被转发消息的会话
-(NSArray<ChatListModel*>*)getCanTranspondAllChatListModel;
/// 获取所有的私聊
-(NSArray<ChatListModel*>*)getSecretChatListModel;
/// 获取所有的交友聊天列表
-(NSArray<ChatListModel*>*)getAllCircleChatListModel;
/**
 查询所有的普通未读消息数量
 */
-(NSNumber*)fetchAllUnReadNumberCount;

/**
 查询所有的私聊未读消息数量
 */
-(NSNumber*)fetchAllSecretUnReadNumberCount;

/**
 查询所有的交友未读消息数量
 */
-(NSNumber*)fetchAllCircleUnReadNumberCount;

/// 获取c2c某个订单的未读消息数量
/// @param c2cUserId c2cUserId description
/// @param c2cOrderId c2cOrderId description
/// @param icanUserId 我行的用户ID用来聊天
-(NSNumber*)fetchC2COrderUnReadMessageCountWith:(NSString*)c2cUserId c2cOrderId:(NSString*)c2cOrderId icanUserId:(NSString*)icanUserId;


/// 查询某个会话
/// @param chatId chatId description
/// @param chatType chatType description

-(ChatListModel*)fetchOneChatListModelWithChatModel:(ChatModel*)config;
@end

//NS_ASSUME_NONNULL_END
