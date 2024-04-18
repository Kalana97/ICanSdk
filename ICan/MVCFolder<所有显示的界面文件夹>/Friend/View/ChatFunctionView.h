//聊天界面底部的功能按钮
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/5
 - System_Version_MACOS: 10.14
 - File name:  ChatFunctionView.h
 - Description:
 - Function List:
 - History:
 */


#import <UIKit/UIKit.h>
#import "XMChatFaceView.h"
#import "XMChatMoreView.h"
@class GroupListInfo;
@class ChatAlbumModel;
@class ChatFunctionView;
NS_ASSUME_NONNULL_BEGIN
@protocol ChatFunctionViewDelegate <NSObject>


@optional
-(void)clickFastBtn:(ChatFunctionView*)functionView;
/// 点击发送按钮
/// @param text text description
-(void)clickSendMessageWithText:(NSString*)text;

-(void)diceGame;

/// 点击了加号 的功能按钮（拍照等功能）
/// @param xmChatMoreItemType xmChatMoreItemType description
-(void)moreItemClickWithXMChatMoreItemType:(XMChatMoreItemType)xmChatMoreItemType;

/// 该View的高度发生变化
/// @param height height description
-(void)frameHasChangeWithHeight:(CGFloat)height keyboardTime:(CGFloat)keyboardTime;

-(void)presentToAtUser;
/// 发送语音消息
/// @param chatAlbumModel chatAlbumModel description
-(void)sendVoiceWithChatAlbumModel:(ChatAlbumModel*)chatAlbumModel;
@end
@interface ChatFunctionView : UIView
@property(nonatomic, weak)   id <ChatFunctionViewDelegate>delegate;
@property(strong, nonatomic) QMUITextView *messageTextView;
@property(nonatomic, assign) ChatFunctionViewType chatFunctionViewType;
@property(nonatomic, strong) NSMutableArray *atMemberArr;
@property(nonatomic, strong) UIButton *fastButton;
@property(nonatomic, strong) UIButton *sendButton;
@property(strong, nonatomic) UIButton *voicedButton;
@property(strong, nonatomic) UIButton *faceButton;
@property(nonatomic, assign) CGFloat textViewBgViewRightMargin;
@property(nonatomic, strong) UIView *leftBgView;
@property (nonatomic,copy) NSString *chatFunctionType;
/** 是否显示左边边的 放置功能按钮的 bgView */
@property(nonatomic, assign) BOOL isShowLeftBgView;
@property(nonatomic, copy)   void (^textViewDidChangeBlock)(NSString*text);
@property(nonatomic, strong) UILabel *tipsLabel;

/// 配置交友的情况下 按钮能否点击
/// @param circleUserInfo circleUserInfo description
/// @param dislikeMeInfo dislikeMeInfo description
/// @param draftMessage 草稿
-(void)configCirclecanSendMessageWith:(CircleUserInfo*)circleUserInfo dislikeMeInfo:(GetCircleDislikeMeInfo*)dislikeMeInfo draftMessage:(NSString*)draftMessage;

-(void)configcanSendMessageWith:(UserMessageInfo*)userMessageInfo draftMessage:(NSString*)draftMessage;

-(void)configGroupWithGroupDetailInfo:(GroupListInfo*)groupDetailInfo draftMessage:(NSString*)draftMessage;
/// 当滑动tableView的时候隐藏所有的view
-(void)hiddenAllView;
-(void)hideAllBtn;
-(void)disableAllFunctions;
-(void)enableAllFunctions;
-(void)ajustUIforAIChat;
-(void)disableSendBtn;
-(void)enableSendBtn;
-(void)updateTranslateOnstatus:(BOOL)statusTranslate;
- (void)dealWithAtUserMessageWithShowName:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress;
- (void)dealWithAtUserMessageWithShowNameAll:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress usersDatas: (NSArray<GroupMemberInfo *>*) groupMemberInfo;
-(void)addNotification;
-(void)removeNotification;
-(void)moreViewAction;
@end

NS_ASSUME_NONNULL_END
