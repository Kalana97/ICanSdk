//
//  ChatUtil.h
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/12.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatModel,ChatAlbumModel;

typedef void(^videoModelCallback)(ChatModel *videoModel);
@interface ChatUtil : NSObject
+(ChatModel*)creatChatMessageModelWithConfig:(ChatModel*)configModel;

+(ChatModel*)creatChatMessageModelWithChatId:(NSString*)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType circleUserId:(NSString*)circleUserId;
///初始化文本消息模型
+ (ChatModel *)initTextMessage:(NSString *)text config:(ChatModel *)config;
+ (ChatModel *)initUrlMessage:(NSString *)text config:(ChatModel *)config;
+ (ChatModel *)initGamifyTextMessage:(NSString *)text config:(ChatModel *)config;
/** 初始化同意好友请求的消息 */
+(ChatModel*)initAddFriendWithChatId:(NSString*)chatId authorityType:(NSString*)authorityType;

//初始化语音消息模型
+ (ChatModel *)initAudioMessage:(ChatAlbumModel *)audio config:(ChatModel *)config;
///初始化图片消息模型
+ (NSArray<ChatModel *> *)initPicMessage:(NSArray<ChatAlbumModel *> *)pics config:(ChatModel *)config isGif:(BOOL)isGif;
///初始化名片消息模型
+(ChatModel *)initUserCardModelWithConfig:(ChatModel *)config;

/// 初始化文件消息
/// @param model model description
+(ChatModel*)initFileWithChatModel:(ChatModel*)model;

/// 初始化定位消息
+(ChatModel*)initLocationWithChatModel:(ChatModel*)config;

/// 创建截屏通知的消息 也就是你在ChatViewController中截屏的时候发送的消息model
/// @param config config description
+(ChatModel*)initScreenNotice:(ChatModel*)config ;

/// 创建转账的model
/// @param config config description
+(ChatModel*)creatTransferMessageInfoWithChatModel:(ChatModel*)config;
/// 通过配置model创建视频model
/// @param config config description
/// @param saveUrl saveUrl description
/// @param firstImage firstImage description
+(ChatModel*)creatVideoChatModelWith:(ChatModel*)config saveUrl:(NSURL*)saveUrl firstImage:(UIImage*)firstImage;

/// 点击开启截屏通知时候发送的消息模型
/// @param chatId 会话ID
/// @param isGroup isGroup description
/// @param isOpen isOpen description
+(ChatModel*)initClickOpenScreenNoticeWithModel:(ChatModel*)configModel  isOpen:(BOOL)isOpen;

/// 创建设置阅后即焚之后的消息model
/// @param chatId 会话ID
/// @param isGroup 是否是群聊
/// @param destoryTime destoryTime description
/// @param destoryTimeTitle destoryTimeTitle description
+(ChatModel*)creatDestroyTimeMessageModelWithConfig:(ChatModel*)configModel  destoryTime:(int)destoryTime;

/// 创建发送单人红包的消息
/// @param chatId chatId description
/// @param messageId messageId description
+(ChatModel*)creatSingleRedPacketMessageInfoWithConfig:(ChatModel*)configModel messId:(NSString*)messageId;

/// 创建发送多人红包的消息
/// @param chatId chatId description
/// @param messageId messageId description
+(ChatModel*)creatMultipleRedPacketMessageInfoWithChatId:(NSString*)chatId messId:(NSString*)messageId;

/// 创建领取红包成功的model
/// @param configModel configModel description
/// @param showMessage showMessage description
/// @param messageType messageType description
+(ChatModel*)creatGrabSuccessRedPacketWithConfig:(ChatModel*)configModel showMessage:(NSString*)showMessage messageType:(NSString*)messageType;

/// 根据需要转发的图片消息创建发送model
/// @param chatId chatId description
/// @param chatType chatType description
/// @param transpondModel transpondModel description
+(ChatModel*)creatTranspondImageModelWithConfig:(ChatModel*)configModel transpondModel:(ChatModel*)transpondModel;

/// 根据需要转发的视频消息创建发送model
/// @param chatId chatId description
/// @param chatType chatType description
/// @param transpondModel transpondModel description
+(ChatModel*)creatTranspondVideoModelWithConfig:(ChatModel*)configModel  transpondModel:(ChatModel*)transpondModel;
/// 创建Chat_AtAll类型的消息model
/// @param chatId chatId description
/// @param announce announce description
+(ChatModel*)creatAtAllMessageInfoWithConfig:(ChatModel*)config announce:(NSString*)announce;

/// 创建@某个人的的消息
/// @param chatId chatId description
/// @param text text description
/// @param atIds atIds description
+(ChatModel*)creatAtSingleMessageInfoWithChatId:(NSString*)chatId text:(NSString*)text atIds:(NSArray*)atIds;

/// 创建邀请进群的消息 不需要发送消息
/// @param chatId chatId description
/// @param text text description
+(ChatModel*)creatAddGroupMessageInfoWithChatId:(NSString*)chatId text:(NSString*)text;



/// 创建转发的文件model
/// @param model model description
+(ChatModel*)creatTranspondFileWithChatModel:(ChatModel*)model;


@end

