//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  ChatSetting.h
- Description: 关于对应聊天的一些设置
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>

static NSString * _Nonnull const KWCChatSettingTable= @"ChatSetting";
@interface ChatSetting : NSObject
@property (nonatomic, copy,nullable) NSString* chatId;

/** 用户对某个会话设置的阅后即焚 保存的是秒数 */
@property ( nonatomic, copy,nullable) NSString *destoryTime;

/** 当前的聊天背景 */
@property (nonatomic, copy,nullable) NSString * chatBackgroundImage;
/** 当前的聊天背景 */
@property (nonatomic, copy,nullable) NSString * chatType;
@property (nonatomic, copy,nullable) NSString * chatMode;
/** 保存在通讯录 */
@property ( nonatomic, assign) BOOL isSaveInContact;
/** 是否秘聊 */
@property ( nonatomic, assign) BOOL isSecret;
/** 是否显示用户呢称（群聊会话） */
@property (nonatomic, assign) BOOL isShowNickName;
/* 自己是否开启截屏通知 */
@property (nonatomic, assign) BOOL  isOpenTaskScreenNotice;
/** 对方是否开启截屏通知 */
@property (nonatomic,assign)  BOOL  towardsisOpenTaskScreenNotice;
/** 是否开启强提醒 */
@property (nonatomic, assign) BOOL isStrongNotice;
/** 是否置顶 */
@property (nonatomic, assign) BOOL isStick;
/** 免打扰 */
@property (nonatomic, assign) BOOL isNoDisturbing;
/** 是否可以点击头像进入到用户详情 */
@property (nonatomic,assign) BOOL showUserInfo;
/** 是否设置全员禁言 */
@property(nonatomic, assign) BOOL allShutUp;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy,nullable) NSString *authorityType;
@property(nonatomic, copy,nullable) NSString *translateLanguage;
@property(nonatomic, copy,nullable) NSString *translateLanguageCode;
@end
