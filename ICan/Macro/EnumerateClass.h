//
//  EnumerateClass.h
//  OneChatAPP
//
//  Created by mac on 2017/5/23.
//  Copyright © 2017年 DW. All rights reserved.
//

#ifndef EnumerateClass_h
#define EnumerateClass_h
typedef NS_ENUM(NSInteger,AddressListType){
    AddressListType_friend,//是好友
    AddressListType_register,//已经注册,但不是好友
    AddressListType_waitInvite//待邀请
};

typedef NS_ENUM(NSInteger,FriendDetailType){
    FriendDetailType_fromNewFriend,//来自新好友页面
    FriendDetailType_push,//直接push到聊天界面
    FriendDetailType_popChatView,//直接回到chatView
    FriendDetailType_pushChatViewNotification,//通过通知先pop回root页面 再push到chatView页面
    
};
typedef NS_ENUM(NSInteger,MunRoomQrcodeType){
    MunRoomQrcodeType_collectionMoney,//收款
    MunRoomQrcodeType_personQrCode,//个人二维码
    MunRoomQrcodeType_groupQrCode//房间二维码
};
#pragma mark == 是否开启指纹支付 ==
typedef enum : NSUInteger {
    PayPassWordTouchIDTypeUnKnow = 0,
    PayPassWordTouchIDTypeOpen = 1,
    PayPassWordTouchIDTypeClose = 2,
} PayPassWordTouchIDType;

// 聊天键盘枚举
typedef NS_ENUM(NSUInteger, ChatMenuState) {
    ChatMenuStateVoice = 2001,
    ChatMenuStateEmjo,
    ChatMenuStateAddMore,
};
// 群成员角色
typedef NS_ENUM(NSUInteger, MemberRoleType) {
    MemberRoleType_Owner  = 10,//群主
    MemberRoleType_Manger = 20,// 管理员
    MemberRoleType_Member = 30,// 普通成员
};
// 地区选择
typedef NS_ENUM(NSUInteger, RegionState) {
    RegionStateCountry,//国家
    RegionStateProvince,//省
    RegionStateCity,//市
};
typedef NS_ENUM(NSUInteger, RedEnvelopeType) {
    RedEnvelopeTypeNomal = 0,//
    RedEnvelopeTypeSpell = 1,//
    
};



typedef NS_ENUM(NSUInteger, RedEnvelopePropertyType) {
    RedEnvelopePropertyTypePersonal = 0,//
    RedEnvelopePropertyTypeGroup = 1,//
};


typedef NS_ENUM(NSUInteger, RedPackState) {
    RedPackStateNomal,//
    RedPackStateOverTime,//
    RedPackStateEmpty,//
};

typedef NS_ENUM(NSUInteger, QueryUserGender) {
    
    QueryUserGenderWoman = 2001,//女
    QueryUserGenderMan = 2002,//男
    QueryUserGenderAll = 2003,//不限
};

// 第三方登录
typedef enum : NSUInteger {
    ThirdAuthLoginTypeNormal = 0, //0 表示为 普通登录
    ThirdAuthLoginTypeWeChat = 1,// 微信
    ThirdAuthLoginTypeQQ = 2,// qq
    ThirdAuthLoginTypeAli = 3,// 阿里
} ThirdAuthLoginType;


//朋友圈消息类型
typedef enum : NSUInteger {
    CircleOfFriendsTypeText,// 文本
    CircleOfFriendsTypePicture,// 图片
    CircleOfFriendsTypeVideo,// 视频
    CircleOfFriendsTypeGif,// gif图片
} CircleOfFriendsType;

// 长安消息，选择消息处理的类型
typedef enum : NSUInteger {
    SelectMessageTypeCopy,// 复制
    SelectMessageTypeForward,//转发
    SelectMessageTypeDelete,//删除
    SelectMessageTypeCollection,//收藏
    SelectMessageTypeWithdraw,// 撤回消息
    SelectMessageTypeReply,//回复
    SelectMessageTypeTranslateHide,
    SelectMessageTypeTranslate,//翻译
    SelectMessageTypeOriginText,//原文
    SelectMessageTypeToText,//转文字
    SelectMessageTypeAll,//全选
    SelectMessageTypeReceiver,//听筒播放
    SelectMessageTypeVoiceToText,//语音转文字
    SelectMessageTypeMore,//更多
    SelectMessageTypeQuickMessage,
    SelectMessageTypePinMessage,
    SelectMessageTypeUnpinMessage,
} SelectMessageType;

// 消息发送的状态
typedef enum : NSInteger {
    MessageSendTypeFailed = 0,
    MessageSendTypeSuccess,
    MessageSendTypeSending,
} MessageSendType;

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, XMNVoiceMessageState){
    XMNVoiceMessageStateNormal,/**< 未播放状态 */
    XMNVoiceMessageStateDownloading,/**< 正在下载中 */
    XMNVoiceMessageStatePlaying,/**< 正在播放 */
    XMNVoiceMessageStateCancel,/**< 播放被取消 */
    XMNVoiceMessageStateEnd,
};

typedef enum : NSUInteger {
    SendImageTypeThumbnail= 0,// 缩略图
    SendImageTypeOriginal = 1,// 原图
    SendImageTypeGif,
    SendImageTypeVideo
} SendImageType;

typedef NS_ENUM(NSInteger,SurePaymentViewType){
    SurePaymentView_Withdraw,
    SurePaymentView_Normal,
    SurePaymentView_UtilityPay,
    SurePaymentView_c2cConfirmReceiptMoney,///c2c界面确认收款
};
typedef NS_ENUM(NSInteger,ChatFunctionViewType){
    ChatFunctionViewType_group,//群聊
    ChatFunctionViewType_icanService,//我行客服
    ChatFunctionViewType_thirdPartyService,//第三方客服
    ChatFunctionViewType_userChat,//单聊是好友
    ChatFunctionViewType_secret,//单聊中的密聊
    ChatFunctionViewType_circle,//交友
    ChatFunctionViewType_c2c,//c2c
    ChatFunctionViewType_chatOther,
};
typedef NS_ENUM(NSInteger,TimelineType) {
    TimelineType_UserAll,
    TimelineType_find,//显示朋友圈
    TimelineType_openVideo,//显示公开分享的视频
    TimelineType_openText,//显示公开分享的文字和图片
    TimelineType_AllShare,//获取所有的分享 包括文字图片 视频
    TimelineType_video,//仅仅显示video
    
};
typedef NS_ENUM(NSInteger,TranspondType) {
    TranspondType_ChatVc,//分享的是其他消息
    TranspondType_Time,//朋友圈
    TranspondType_OtherApp,//其他APP的分享
    TranspondType_Image,//分享的是图片（不是聊天中的图片）
    
    
};
//圈子喜欢我的 我不喜欢的
typedef NS_ENUM(NSInteger,CircleListType){
    CircleListType_LikeMe,//喜欢我的
    CircleListType_Dislike,//我不喜欢的也就是我不感兴趣的
    CircleListType_Favorite,//我收藏的
    CircleListType_ILike,//我喜欢的
};



//地区选择器
typedef NS_ENUM(NSInteger,AddressViewType){
    AddressViewType_Home,//首页选择地区
    AddressViewType_FirstSetUserMessage,//首次设置用户信息区域
    AddressViewType_SetUserMessage,//再次设置用户信息
};
//发送的朋友圈的类型
typedef NS_ENUM(NSInteger,PostMessageType){
    TimelinesVideo,//视频
    TimelinesShare,//分享
    TimeLinesFriendCrile//朋友圈
    
    
};
#endif /* EnumerateClass_h */
