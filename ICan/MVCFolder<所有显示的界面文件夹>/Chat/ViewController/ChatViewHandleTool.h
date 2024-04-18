//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 25/8/2020
- File name:  ChatViewHandleTool.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN
@protocol ChatViewHandleToolDelegate <NSObject>

-(void)chatViewHandleToolTranspondChatModel:(ChatModel*)model;

@end

@interface ChatViewHandleTool : NSObject

@property(nonatomic, assign) BOOL isScrollViewScroll;

@property(nonatomic, strong) ChatModel *config;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *messageItems;

+(instancetype)shareManager;
@property(nonatomic, weak) id <ChatViewHandleToolDelegate>delegete;

/// 点击视频播放
/// @param chatmodel 当前的聊天model
/// @param downloadProgressBar 下载进度条
/// @param success 下载成功回调
/// @param failure 下载失败回调
-(void)chatViewHandleToolDownloadVideoWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure;

/// 点击收藏消息
/// @param collectionModel 收藏的message对象
+(void)collectMessageWithChatModel:(ChatModel*)collectionModel;

+(void)colletcMoreMessageWithItems:(NSArray*)messageItems;
/// 点击文件-->显示文件
/// @param chatModel 点击的cell
/// @param container 显示文件的容器
/// @param downloadProgressBar 下载进度
/// @param success 下载成功回调
/// @param failure 下载失败回调
-(void)chatViewHandleShowFileWithChatModel:(ChatModel*)chatModel container:(UIViewController*)container downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure ;

/// 上传文件
/// @param tableView tableView description
/// @param messageItems messageItems description
/// @param configModel configModel description
-(void)chatViewHandleUploadFile;

/// 点击红包
/// @param tableView tableView description
/// @param messageItems messageItems description
/// @param currentModel currentModel description
/// @param configModel configModel description
/// @param isGroup isGroup description
-(void)chatViewHandleShwoSingleRedPacketWithCurrentModel:(ChatModel*)currentModel;

/// 点击了回复的文件
/// @param replyMessageInfo replyMessageInfo description
/// @param container container description
-(void)showReplyFileWithContent:(ReplyMessageInfo*)replyMessageInfo container:(UIViewController*)container;

-(void)tapOtherIconWithChatModel:(ChatModel*)model groupDetailInfo:(GroupListInfo*)groupDetailInfo chatModel:(ChatModel*)config;

-(void)ossAddHashWihtHash:(NSString*)hash url:(NSString*)url name:(NSString*)name size:(NSString*)size path:(NSString*)path;



/// 跳转到发送红包页面
/// @param groupDetailInfo groupDetailInfo description
-(void)pushSendHongbaoViewControllerWithGroupDetaiInfo:(GroupListInfo*)groupDetailInfo;

/// 处理收到的已读
/// @param baseMessageInfo 收到的消息对象
/// @param messageItems 聊天界面的model数组
/// @param tableView tableView
/// @param config 传递进来的config
-(void)handleWebSocketDidReceiptMessageWithBaseMessageInfo:(BaseMessageInfo*)baseMessageInfo;
-(void)clickReplyCellWithContainer:(UIViewController*)container chatModel:(ChatModel*)model;
-(void)hiddenPlayerView;

/// 根据阅后即焚时间获取对应的文字
/// @param destroyTime 阅后即焚时间
+(NSString*)getTitleByDestroyTime:(NSString*)destroyTime;
+(NSString*)getLanguageByLanguageCode:(NSString*)languageCode;
+(NSString*)getLanguageCodeByLanguage:(NSString*)languageCode;
+(NSString*)getImageByCurrencyCode:(NSString*)currencyCode;
+(NSString*)getImageByChannelCodeWatchWallet:(NSString*)channelCode;

/// 根据阅后即焚的文字获取对应时间
/// @param destroyTitle 阅后即焚文字
+(NSInteger)transformDestroyTitleWithTime:(NSString*)destroyTitle;
-(void)deleteMessageConfig:(ChatModel*)config;
//删除本地消息
-(void)deleteMessageFromChatModel:(ChatModel*)model config:(ChatModel*)config;
-(NSArray*)deleteMessageByChatModelWhenViewWillDisappear:(ChatModel*)model configModel:(ChatModel*)configModel;
/// 删除多条或者一条消息的时候 告诉后台接口
/// @param messageId 需要删除的消息ID
/// @param deleteAll 是否在其他人设备上面删除
-(void)deleteMoreMessageRequestWithMessageIds:(NSArray*)messageId  configModel:(ChatModel*)config deleteAll:(BOOL)deleteAll;
@end

NS_ASSUME_NONNULL_END
