//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/10
- ICan
- File name:  WCDBManager+ChatSetting.h
- Description:
- Function List:
*/


#import "WCDBManager.h"
@class ChatSetting;
NS_ASSUME_NONNULL_BEGIN
@interface WCDBManager (ChatSetting)
-(ChatSetting*)fetchChatSettingWith:(ChatModel*)config;
/// 更新聊天详情是否置顶设置
/// @param isStick isStick description
/// @param chatId chatId description
-(void)updateChatSettingIsStick:(BOOL)isStick chatId:(NSString*)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;

/// 更新聊天详情是否免打扰设置
/// @param isNoDisturbing isNoDisturbing description
/// @param chatId chatId description
-(void)updateChatSettingIsNoDisturbing:(BOOL)isNoDisturbing chatId:(NSString*)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;

/// 更新是否显示群昵称
/// @param isShowNickname isShowGroupname description
/// @param chatId chatId description
-(void)updateChatSettingIsShowNickname:(BOOL)isShowNickname chatId:(NSString*)chatId chatType:(NSString*)chatType;
/// 跟新阅后即焚的时间
-(void)updateChatSettingDestoryTime:(NSString*)destoryTime chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;

-(void)updateTranslationSettingStates:(NSString*)translateLanguage translateLanguageCode:(NSString *)translateLanguageCode chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;

/// 缓存本地的截屏通知
-(void)updateChatSettingScreencast:(BOOL)isOpenScreencast chatId:(NSString *)chatId isGroup:(BOOL)isGroup chatType:(NSString*)chatType authorityType:(NSString*)authorityType;


/// 收到截屏通知的消息 更新对方是否开启截屏通知状态
/// @param isOpenTaskScreenNotice isOpenTaskScreenNotice description
/// @param chatId chatId description
-(void)updateChatSettingTowardsisOpenTaskScreenNotice:(BOOL)isOpenTaskScreenNotice chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;

-(void)deleteOneChatSettingWithChatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType;
@end

NS_ASSUME_NONNULL_END
