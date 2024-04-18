//
//TODO 需要考虑线程分发机制 因为现在都在主线程 导致了界面卡顿
//  websocket STOMP的订阅都是成对出现
//目前的普通聊天消息 以及申请好友
// 113 2
// 112 5
/**
 每次新添加新的消息类型需要修改的文件：
 1:
 2:
 3:
 4:
 
 
 */
#import <Foundation/Foundation.h>
#import "WebsocketStompKit.h"
@class ChatModel;
@class BaseMessageInfo;
NS_ASSUME_NONNULL_BEGIN

/// 收到普通消息回执例如（文本图片等等）
@interface ReceiptInfo:NSObject
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *msgId;
@property(nonatomic, copy) NSString *msgType;
@property(nonatomic, copy) NSString *data;
@end
typedef NS_ENUM(NSInteger) {
    SocketConnectStatus_UnConnected       = 0<<0,//未连接状态
    SocketConnectStatus_Connected         = 1<<0,//连接成功状态
    SocketConnectStatus_NoNet             = 2<<0,//没有网络
    SocketConnectStatus_Connecting        = 3<<0//连接中

}SocketConnectStatus;

@protocol WebSocketManagerDelegate <NSObject>

@optional

/// 收到好友请求代理
-(void)receivedFriendRequest;
/**
 收到消息回执(服务器发送回来的)

 @param receiptInfo receiptInfo description
 */
-(void)webSocketManagerDidReceiveReceiptInfo:(ReceiptInfo *)receiptInfo;
/**
 成功收到消息

 @param chatModel chatModel description
 */
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel;

/// 成功收到对方发送的消息回执
/// @param receiptMessageInfo receiptMessageInfo description
-(void)webSocketDidReceiptBaseMessageInfo:(BaseMessageInfo *)baseMessageInfo;
@end

@interface WebSocketManager : NSObject
@property(nonatomic, strong,nullable) STOMPClient *client;
@property(nonatomic, weak) id <WebSocketManagerDelegate> delegate;
/** socket连接状态 */
@property(nonatomic, assign) SocketConnectStatus connectStatus;
/** 是否是手动断开连接 */
@property(nonatomic, assign) BOOL isManualClose;
/** 根据AF返回的网络状态判断是否有网 */
@property(nonatomic, assign) BOOL hasNewWork;
/** 当前和谁聊天 */
@property(nonatomic, copy)  NSString * currentChatID;

/** 当前的订阅数组 */
@property(nonatomic, strong) NSMutableArray * subscribeArray;
/** 用来处理当前链接中 已经收到的消息ID */
@property(nonatomic, strong) NSMutableArray<NSString*> *cacheMessageIds;

+(instancetype)sharedManager;

/// 保存聊天消息到数据库
/// @param chatModel chatModel description
-(void)saveMessageWithChatModel:(ChatModel*)chatModel;
/** 开始连接 */
- (void)initWebScoket;
/** 关闭连接 */
- (void)closeWebSocket;
/// 获取云信token
-(void)getNIMTokenRequest;
/** 设置APP的红色的小角标 */
-(void)setApplicationIconBadgeNumber;
/// 订阅群消息
/// @param groupId groupId description
-(void)subscriptionGroupWihtGroupId:(NSString*)groupId;
/// 取消某个群订阅 自己退出群聊或者是被踢出群聊
/// @param groupId groupId description
-(void)unsubscribeGroupWithGroupId:(NSString*)groupId;
/// 上传推送token
-(void)pushDeviceToken;
/** 用户手动退出登录 或者是被顶号 */
-(void)userManualLogout;
@end

NS_ASSUME_NONNULL_END
