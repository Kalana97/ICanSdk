//消息记录
/*
 https://github.com/coderMyy/CocoaAsyncSocket_Demo  github地址 ,会持续更新关于即时通讯的细节 , 以及最终的UI代码
 
 https://github.com/coderMyy/MYCoreTextLabel  图文混排 , 实现图片文字混排 , 可显示常规链接比如网址,@,话题等 , 可以自定义链接字,设置关键字高亮等功能 . 适用于微博,微信,IM聊天对话等场景 . 实现这些功能仅用了几百行代码，耦合性也较低
 
 https://github.com/coderMyy/MYDropMenu  上拉下拉菜单，可随意自定义，随意修改大小，位置，各个项目通用
 
 https://github.com/coderMyy/MYPhotoBrowser 照片浏览器。功能主要有 ： 点击点放大缩小 ， 长按保存发送给好友操作 ， 带文本描述照片，从点击照片放大，当前浏览照片缩小等功能。功能逐渐完善增加中.
 
 https://github.com/coderMyy/MYNavigationController  导航控制器的压缩 , 使得可以将导航范围缩小到指定区域 , 实现页面中的页面效果 . 适用于路径选择,文件选择等

 如果有好的建议或者意见 ,欢迎博客或者QQ指出 , 您的支持是对贡献代码最大的鼓励,谢谢. 求STAR ..😊😊😊
 */

#import <Foundation/Foundation.h>

static NSString * const KWCChatModelTable= @"ChatModel";

@interface ChatModel : NSObject
/** 和谁聊天(群ID或者是用户ID) */
@property(nonatomic,retain) NSString *chatID;
@property(nonatomic,retain) NSString *chatMode;
/** 收到的消息  */
@property(nonatomic, retain) NSString *message;
/** 收到的msgConten的全部内容  */
@property(nonatomic,retain) NSString *messageContent;
/** 显示在界面上的 数据  主要是为了拿来搜索的时候 高亮显示*/
@property(nonatomic,retain) NSString * showMessage;
/** 翻译过后的文本 */
@property(nonatomic, retain) NSString *translateMsg;
/** 0 未翻译 1成功  2 失败*/
@property(nonatomic, assign) NSInteger translateStatus;
/** 是否是自己发送的消息 */
@property(nonatomic, assign) BOOL isOutGoing;
/** 消息来源(消息来自于谁)/如果是群聊 理论上需要保存该消息的来源 主要是为了显示xxx:xxxx  这个字段一定不能为空*/
@property(nonatomic, retain) NSString *messageFrom;
/** 消息来源（消息发送给谁） */
@property(nonatomic, retain) NSString *messageTo;
/** 用来区分是哪个平台发送过来的消息  APP或者是桌面端 */
@property(nonatomic, copy) NSString *platform;
/** 消息时间是一个时间戳  13位   */
@property(nonatomic, retain) NSString *messageTime;
/**
 消息的发送状态(发送方) 0是失败 1也就是成功  默认是2是发送中
 */
@property(nonatomic, assign) NSInteger sendState;
/** 消息内容类型 语音还是文字或者是其他 */
@property(nonatomic, copy) NSString *messageType;
/**文件的上传状态  0是上传失败  1是上传成功    默认是2是上传中  3是没有做任何操作*/
@property(nonatomic,assign) NSInteger uploadState;
/**文件的下载状态  0是下载失败  1是下载成功   2是下载中  3是没有做任何操作*/
@property(nonatomic,assign) NSInteger downloadState;
/** 消息的ID */
@property(nonatomic, copy) NSString *messageID;
/**本地用来阅后即焚   这个已读是相对于用户来说是否已读的 也就是收到对方的消息对于用户来说是否是已读 */
@property(nonatomic,assign) BOOL hasRead;
/** 语音是否已读  */
@property(nonatomic, assign) BOOL voiceHasRead;
/** RECEIVE("对方已收到" )READ("对方已读", 1);   */
@property(nonatomic, assign) NSString *receiptStatus;
/** 是否显示红包的状态 只有用户访问过红包详情之后 才会显示的  */
@property(nonatomic, assign) BOOL showRedState;
/**视频的的导出状态  0是导出失败   1是导出成功    2是导出中  3是默认转态*/
@property(nonatomic,assign) NSInteger exportState;
/** 红包ID */
@property(nonatomic, copy) NSString *redId;
/**
 第一种情况是红包 红包是否显示开的按钮
 第二种情况是当数据类型是Notice_JoinGroupApplyType的时候 来记录该信息是否已经处理
 */
@property(nonatomic,assign) BOOL isShowOpenRedView;
/** 红包错误类型 "expired", "红包已经过期" "received", "请勿重复领取" "empty","手慢了已经被抢完" success 表示成功抢到红包 或者对方成功*/
@property(nonatomic, copy) NSString *redPacketState;
@property(nonatomic, copy) NSString *redPacketAmount;
/** 阅后即焚的消息时间 对应秒数 */
@property(nonatomic, copy) NSString *destoryTime;
/**文件名显示在界面上的名字 */
@property(nonatomic, copy) NSString *showFileName;
/** 视频的相册路径 */
@property(nonatomic, copy) NSString *videoAlbumUrl;
/** 视频或者是图片的本地资源标志 需要用这个来判断是否存在 */
@property(nonatomic, copy) NSString *localIdentifier;
/// 文件（不包含图片和语音）的本地缓存文件名 需要用来拼接MessageVideoCache才可以获取本地的压缩视频路径
@property(nonatomic, copy) NSString *fileCacheName;
/** 文件的服务器的（文件，语音,视频）地址路径  */
@property(nonatomic, copy) NSString *fileServiceUrl;
/**文件的总大小 单位是 byte  B*/
@property(nonatomic, assign) int64_t totalUnitCount;
/** 语音时间 */
@property(nonatomic, assign) NSInteger mediaSeconds;
/** 表明群聊还是单聊 */
@property(nonatomic, copy) NSString *chatType;
/** 布局宽度  */
@property(nonatomic, assign) float layoutWidth;
/** 布局高度 */
@property(nonatomic, assign) float layoutHeight;
/** 自己发送的消息 在群里的已读人的ID */
@property(nonatomic, strong) NSArray *hasReadUserIdItems;
/** 群里面 已经读消息的人的ID和消息时间  @{@"time":@"",@"id":"用户ID"} */
@property(nonatomic, strong) NSArray *hasReadUserInfoItems;
/// 是否为原图
@property(nonatomic, assign) BOOL isOrignal;
/** 发送图片的时候 是否是GIF */
@property(nonatomic, assign) BOOL isGif;
/** 扩展字段 用来展示是否显示引用 */
@property(nonatomic, copy) NSString *extra;
/**
 扩展字段
 作用1：发送c2c字段的时候携带用户ID和当前的订单ID json 字符串 @{@"orderId":@"",@"c2cUserId":@""}
 */
@property(nonatomic, copy) NSString *c2cExtra;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友 c2c交友
 */
@property(nonatomic, copy) NSString *authorityType;
/** 对方的交友用户ID */
@property(nonatomic, copy) NSString *circleUserId;
/** 对方的c2c用户ID */
@property(nonatomic, copy) NSString *c2cUserId;
/** c2c的订单ID */
@property(nonatomic, copy) NSString *c2cOrderId;
/** 以下的数据都不会缓存在数据库中 */
/** 和文本布局相关的属性 */
@property(nonatomic, strong) NSMutableAttributedString *attrStr;
/** 图片原图data */
@property(nonatomic, strong) NSData *orignalImageData;
/** 图片压缩过后的data */
@property(nonatomic, strong) NSData *compressImageData;
/** 图片的原图url地址 同时也用来做视频第一帧的图片地址*/
@property(nonatomic, copy) NSString *imageUrl;
/** 图片的缩略图地址 */
@property(nonatomic, copy) NSString *thumbnails;
@property(nonatomic, strong) NSData *fileData;
/** */
/**上传文件的已完成的大小 以B为单位  B*/
@property(nonatomic, assign) int64_t completedUnitCount;
/** 当前的上传进度 文件图片视频*/
@property(nonatomic, retain) NSString *uploadProgress;
/** 视频第一帧图片的上传进度 */
@property(nonatomic, retain) NSString *videFirstUploadProgress;
@property(nonatomic, assign) float exportProgress;
@property(nonatomic, copy) NSString *showName;
@property(nonatomic, copy) NSString *headImageUrl;
/** 当前的model cell是否是选中状态 */
@property(nonatomic, assign) BOOL isSelect;
@property(nonatomic, assign) BOOL isSelectAll;

@property (nonatomic, retain) NSString *thumbnailImageurlofTextUrl;
@property (nonatomic, retain) NSString *thumbnailTitleofTextUrl;
@property (nonatomic, retain) NSString *translateLanguage;
@property (nonatomic, retain) NSString *translateLanguageCode;
@property(nonatomic, assign) BOOL translateModeOnOff;
@property(nonatomic, assign) NSInteger gamificationStatus;

@property(nonatomic, assign) BOOL isPin;
@property(nonatomic, assign) NSString *pinAudiance; //Self/All
@property(nonatomic, assign) BOOL isReacted;
@property(nonatomic, copy) NSString *selfReaction;
@property(nonatomic, strong) NSMutableDictionary *reactions;

//dynamic message type
@property(nonatomic, assign) NSInteger languageCode;
@property(nonatomic, copy) NSString *headerImgUrl;
@property(nonatomic, copy) NSString *messageData;
@property(nonatomic, copy) NSString *onclickFunction;
@property(nonatomic, copy) NSString *onclickData;
@property(nonatomic, copy) NSString *merchantId;
@property(nonatomic, copy) NSString *sender;
@property(nonatomic, copy) NSString *senderImgUrl;
@property(nonatomic, copy) NSString *title;
//@property(nonatomic, copy) NSString *languageCode;
@property(nonatomic, strong) NSArray *dataList;
@end



