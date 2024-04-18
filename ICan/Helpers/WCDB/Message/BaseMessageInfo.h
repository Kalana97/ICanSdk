//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 26/9/2019
 - File name:  NoticeMessageInfo.h
 - Description: 通知类型消息
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import <Foundation/Foundation.h>
#import "BaseResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseMessageInfo : NSObject
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
/**
 发送方交友ID
 */
@property(nonatomic, copy) NSString *fromCircleUserId;
@property(nonatomic, copy) NSString *chatMode;
@property(nonatomic, copy) NSString *merchantId;
/**
 接收方交友ID
 */
@property(nonatomic, copy) NSString *toCircleUserId;
/**  通知的消息类型
 Notice_AddGroup
 Notice_QuitGroup
 */
@property(nonatomic, copy,nullable) NSString *msgType;
/** 具体的内容里面是一个json字符串  */
@property(nonatomic, copy,nullable) NSString *msgContent;
@property(nonatomic, copy,nullable) NSString *fromId;
@property(nonatomic, copy,nullable) NSString *toId;
/**  群ID */
@property(nonatomic, copy) NSString *groupId;
/** 13的时间戳  */
@property(nonatomic, copy,nullable) NSString *sendTime;
/** 消息ID  */
@property(nonatomic, copy,nullable) NSString *messageId;
/// 销毁时间 时间是秒
@property (nonatomic,assign) NSInteger  destroy;
/** 用来区分是哪个平台发送过来的消息  APP或者是桌面端 */
@property(nonatomic, copy) NSString *platform;
/**
 是否保存在离线消息中
 */
@property(nonatomic, assign) bool endurance;
/**
 扩展字段
 作用1：发送c2c字段的时候携带用户ID和当前的订单ID json 字符串 @{@"orderId":@"",@"c2cUserId":@""}
 */
@property(nonatomic, copy) NSString *extra;
@end
///Notice_AddGroup
@interface NoticeAddGroupInfo : NSObject
/**  操作者  */
@property(nonatomic, copy,nullable) NSString *invite;
@property(nonatomic, strong,nullable) NSArray *ids;
/**
 进群类型
 //扫码加入
 #define KNotice_AddGroup_ScanCode @"ScanCode"
 //被邀请加入
 #define KNotice_AddGroup_BeInvited @"BeInvited"
 //后台加入
 #define KNotice_AddGroup_ManagerAdd @"ManagerAdd"
 
 */
@property(nonatomic, copy,nullable) NSString *addGroupMode;

@property(nonatomic, copy,nullable) NSString *type;

@property(nonatomic, copy,nullable) NSString *operatore;
@end

@interface OperatoreInfo : NSObject
/**  操作者 */
@property(nonatomic, copy,nullable) NSString * operatore;

@property (nonatomic,copy,nullable) NSString * type;
@end
/// 离开群聊里面msgContent的内容Notice_QuitGroup
@interface NoticeQuitGroupInfo : OperatoreInfo

/** 离开群聊的人  */
@property (nonatomic,copy,nullable) NSString * leave;
/** 是否是被踢出群聊  */
@property (nonatomic,assign) BOOL  kickedOut;
@end

/// 删除好友里面msgContent的内容Notice_DeleteFriend
@interface NoticeDeleteFriendInfo : OperatoreInfo


@end

/// 同意好友msgContent的内容 被同意的人会收到 Notice_AddFriend
@interface NoticeAgreeFriendInfo : OperatoreInfo

@property(nonatomic, copy) NSString *content;
///  apply申请 agree同意 refusal拒绝
@property (nonatomic,copy) NSString* process;
@end
//Notice_UpdateGroupNickname
@interface NoticeUpdateGroupNicknameInfo : OperatoreInfo
@property(nonatomic, copy) NSString *nickname;
@end
//Notice_UpdateGroupNickname
@interface Notice_TransferGroupOwnerInfo : OperatoreInfo
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *oldGroupOwner;
@property(nonatomic, copy) NSString *freshGroupOwner;
@end
/// 阅后即焚的通知消息Notice_DestroyTime
@interface NoticeDestroyTimeInfo:OperatoreInfo
@property(nonatomic, strong) NSNumber *destroyTime;
@end
///Notice_Screencast截屏通知
@interface NoticeScreencastInfo : OperatoreInfo
/** OPEN打开  CLOSE关闭  NOTICE通知 */
@property(nonatomic, copy) NSString* screencastMode;

@end

/// 收到群名称修改通知Notice_Subject
@interface NoticeSubjectInfo : OperatoreInfo
@property(nonatomic, copy,nullable) NSString *groupId;
@property(nonatomic, copy,nullable) NSString *subject;
@end

@interface NoticeAllShutUpInfo : OperatoreInfo
@property(nonatomic, copy,nullable) NSString *groupId;
@property(nonatomic, assign) BOOL allShutUp;
@end

@interface NoticeShowUserInfoInfo : OperatoreInfo
@property(nonatomic, copy,nullable) NSString *groupId;
@property(nonatomic, assign) BOOL showUserInfo;
@end

//Notice_Login 登录之后 会收到一条这样的消息
@interface NoticeLoginInfo :NSObject
@property(nonatomic, copy) NSString *token;
/** iOS */
@property(nonatomic, copy) NSString *platform;

@property(nonatomic, assign) NSInteger time;

@end

/** Notice_OnlineChange 用户在线离线之后 给他的好友发送的消息 */
@interface Notice_OnlineChangeInfo:NSObject
@property(nonatomic, assign) BOOL online;
@property(nonatomic, copy) NSString *userId;
@end
//聊天消息类型msgContent里面的内容

@interface ExtraInfo:NSObject
@property(nonatomic, copy,nullable) NSString *extra;
@end
/// 文本消息Chat_Txt
@interface TextMessageInfo : ExtraInfo

/// 文本内容
@property(nonatomic, copy,nullable) NSString *content;
@end


/// at所有人info Chat_AtAll
@interface AtAllMessageInfo:TextMessageInfo
@end

/// at某个人Chat_AtSingle
@interface AtSingleMessageInfo:TextMessageInfo
/** at的用户ID */
@property(nonatomic, strong,nullable) NSArray *atIds;
@end
//Chat_File
@interface FileMessageInfo:ExtraInfo
/// 文件名
@property(nonatomic, copy,nullable) NSString *name;
/// 文件大小 KB
@property(nonatomic, assign) NSInteger size;
/// 文件类型
@property(nonatomic, copy,nullable) NSString *type;
/// 地址
@property(nonatomic, copy,nullable) NSString *fileUrl;
@end
//Chat_Vc
@interface VoiceMessageInfo:ExtraInfo
/** url地址  */
@property(nonatomic, copy) NSString *content;
//语音消息的时长，最长为 60 秒（单位：秒）。
@property(nonatomic, assign) NSInteger duration;
@end
//Chat_Sight
@interface VideoMessageInfo : ExtraInfo
/** 视频地址 */
@property(nonatomic, copy) NSString *sightUrl;
/** 首帧的缩略图*/
@property(nonatomic, copy) NSString *content;
/** duration    视频时长，单位：秒。 */
@property(nonatomic, assign) NSInteger duration;
/** 视频大小单位 bytes */
@property(nonatomic, assign) float size;
/** 发送端视频的文件名，小视频文件格式为 .mp4。 */
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
@end
//Chat_Img
@interface ImageMessageInfo : ExtraInfo
@property(nonatomic, copy,nullable) NSString *imageUrl;
@property(nonatomic, copy,nullable) NSString *thumbnails;
@property(nonatomic, copy,nullable) NSString *bigImageUrl;
/** 是否压缩 */
@property(nonatomic, assign) BOOL isFull;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
@end
//dynamicMsg
@interface DynamicMessageInfo : ExtraInfo
@property(nonatomic, copy,nullable) NSString *headerImgUrl;
@property(nonatomic, copy,nullable) NSString *messageData;
@property(nonatomic, copy,nullable) NSString *onclickFunction;
@property(nonatomic, copy,nullable) NSString *onclickData;
@property(nonatomic, copy,nullable) NSString *sender;
@property(nonatomic, copy,nullable) NSString *senderImgUrl;
@property(nonatomic, copy,nullable) NSString *merchantId;
@property(nonatomic, copy,nullable) NSString *title;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) NSInteger languageCode;
@property(nonatomic, assign) NSInteger messageType;
@end
//Chat_Location
@interface LocationMessageInfo:ExtraInfo
@property(nonatomic, copy,nullable) NSString *mapUrl;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, copy,nullable) NSString *name;
@property(nonatomic, copy,nullable) NSString *address;
@end
//Chat_UserCard
@interface UserCardMessageInfo:ExtraInfo
@property(nonatomic, copy,nullable) NSString *userId;
@property(nonatomic, copy,nullable) NSString *avatarUrl;
@property(nonatomic, copy,nullable) NSString *username;
@property(nonatomic, copy,nullable) NSString *nickname;
@end
//撤回消息Chat_withdraw
@interface WithdrawMessageInfo:ExtraInfo
@property(nonatomic, copy) NSString *content;
@end
//Chat_receipt RECEIVE("对方已收到")READ("对方已读", 1); 
@interface ReceiptMessageInfo : ExtraInfo
@property(nonatomic, copy) NSString *receiptStatus;
@end
//群聊的消息已读回执
@interface ChatGroupReceiptInfo : ExtraInfo
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *groupId;
@end
@interface TranferMessageInfo : ExtraInfo
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *currencyCode;

@end
//{"msgType":"Chat_Call","msgContent":"{\"callStatus\":\"REMOTE_REJECT\",\"callTime\":0,\"callType\":\"VOICE\"}","fromId":136,"toId":5,"groupId":null,"sendTime":1577084886080,"messageId":"28001463879359136","destroy":0}
/** 融云的相关消息 */
@interface ChatCallMessageInfo:ExtraInfo
@property(nonatomic, copy) NSString *callStatus;
@property(nonatomic, assign) NSInteger callTime;
@property(nonatomic, copy) NSString *callType;
@end

/** 别人对你的帖子做了评论或者分享的通知消息 */
@interface TimeLineJsonInfo:IDInfo
/** 评论ID */
@property(nonatomic, retain) NSString *commentId;
@property(nonatomic, retain) NSString* messageType;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickName;
/** 帖子的时间 */
@property(nonatomic, assign) NSInteger time;
@property(nonatomic, copy) NSString *gender;
@end


/** 单人红包类型的消息  */
@interface SingleRedPacketMessageInfo : IDInfo
/** 红包编号 */
@property(nonatomic, copy) NSString *code;
/** 红包备注 */
@property(nonatomic, copy) NSString *comment;
/** 红包金额 */
@property(nonatomic, copy) NSString *money;
@end

/** 多人红包类型的消息  */
@interface MultipleRedPacketMessageInfo : SingleRedPacketMessageInfo

@end

//Notice_RemoveChat
@interface RemoveChatMsgInfo : ExtraInfo
@property(nonatomic, strong) NSArray<NSString*> *messageIds;
/**
当前执行删除操作的是某个人 是操作的那个人 比如说是A把和B的聊天消息删除 那么该字段就是A的userid
*/
@property(nonatomic, copy) NSString *userId;
/**
 群部分GroupPart,人部分 UserPart,群全部GroupAll,人全部UserAll, 全部消息All
 */
@property(nonatomic, copy) NSString *type;
/** 是否在其他人设备上删除 */
@property(nonatomic, assign) bool deleteAll;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@end


@interface PayHelperMsgInfo : ExtraInfo
@property(nonatomic, copy) NSString *payChannelTypeName;
/**
 支付渠道类型,可用值:Balance,BankCard,CreditCard,AliPay,WeChatPay
 */
@property(nonatomic, copy) NSString *payChannelType;
/**
支付类型转账Transfer,
单人退回RefundSingleRedPacket,
多人退回RefundRoomRedPacket,
手机充值MobileRecharge,
Gift Card PurchaseGiftCard,
余额充值 BalanceRecharge,
提现WITHDRAW_CREATE,
Successful withdrawalWITHDRAW_SUCCESS,
Withdrawal failedWITHDRAW_FAIL
付款码 Payment
收款码  ReceivePayment
 */
@property(nonatomic, copy) NSString *payType;
/** 金额 */
@property(nonatomic, copy) NSString *amount;
/** 订单ID */
@property(nonatomic, copy) NSString *orderId;
/** 备注 */
@property(nonatomic, copy) NSString *remark;

@property(nonatomic, assign) NSInteger time;
/** 订单金额单位     */
@property (nonatomic, strong) NSString * unit;
/** 实际充值金额 */
@property (nonatomic, copy) NSString* actualAmount;
/** 实际订单金额单位     */
@property (nonatomic, strong) NSString * actualUnit;
@end

/** 商城助手 */
@interface ShopHelperMsgInfo:ExtraInfo
/** 头像地址 */
@property(nonatomic, copy) NSString *avatar;
/** 名字 */
@property(nonatomic, copy) NSString *name;
/** 标题 */
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *address;
///运费
@property(nonatomic, copy) NSDecimalNumber *courierFee;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *payType;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *to;
@property(nonatomic, strong) NSDecimalNumber *totalMoney;
@property(nonatomic, strong) NSArray *productInfo;
@end


//@interface JsonMessageInfo:NSObject
//@property(nonatomic, copy) NSString *content;
//@property(nonatomic, copy) NSString *extra;
//@end
@interface ReplyMessageInfo : NSObject
@property(nonatomic, copy) NSString *jsonMessage;
/** 原来的消息类型 */
@property(nonatomic, strong) NSString *originalMessageType;

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy,nullable) NSString *groupId;
@end
@interface BlockUserMessageInfo:NSObject
@property(nonatomic, assign) BOOL block;
@property(nonatomic, copy) NSString *who;
@end

/** 分享商品 */
@interface ShareGoodsUrlInfo : ExtraInfo
/** 商品ID
 */
@property(nonatomic, assign) NSInteger prodId;
/**
 店铺名称
 */
@property(nonatomic, copy) NSString *shopName;
/**
 商品名称
 */
@property(nonatomic, copy) NSString *goodsName;
/** 商品图片
 */
@property(nonatomic, copy) NSString *pic;
/**
 店铺头像
 */
@property(nonatomic, copy) NSString *shopAvatarUrl;
/**
 内容URL
 */
@property(nonatomic, copy) NSString *contentUrl;
@end

@interface ChatOtherUrlInfo : NSObject
@property(nonatomic, copy,nullable) NSString *extra;
/**
 图片
 */
@property(nonatomic, copy) NSString *imageUrl;
/**
 内容
 */
@property(nonatomic, copy) NSString *content;
/** app名字
 */
@property(nonatomic, copy) NSString *appName;
/**
 applogo
 */
@property(nonatomic, copy) NSString *appLogo;
/**
 内容URL
 https://shop.shinianwangluo.com
 */
@property(nonatomic, copy) NSString *link;
@end
@interface Notice_FreezeInfo : ExtraInfo
@property(nonatomic, copy) NSString *content;
@end
@interface NoticeGroupUpdateInfo:ExtraInfo
@property(nonatomic, assign) NSInteger groupId;
@end
/**
 出示付款码的人收到的消息
 Notice_PayQR
 */
@interface Notice_PayQRInfo : ExtraInfo
/**
* 类型
* payment 付款码
* receivePayment 收款码
*/
@property(nonatomic, copy) NSString *qrCodeType;
/**
* 二维码
*/
@property(nonatomic, copy) NSString *code;
/**
* 支付中 1
* 支付完成 2
* 支付取消 3
*/
@property(nonatomic, assign) NSInteger status;
/**
* 付款或收款用户
*/
@property(nonatomic, assign) NSInteger userId;
/**
 金额
 */
@property(nonatomic, assign) double money;
@end

@interface ChatPostShareMessageInfo : ExtraInfo
@property(nonatomic, assign) NSInteger postId;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *avatarUrl;
@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) NSArray<NSString*> *imageUrls;
@end


@interface Add_friend_successInfo : NSObject
/** 邀请人 */
@property(nonatomic, strong) NSNumber *invite;
/** 被邀请人 */
@property(nonatomic, strong) NSNumber *beInvited;
@end
/** Notice_GroupRoleUpdate */
@interface Notice_GroupRoleUpdateInfo : NSObject
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *operatorId;
@property(nonatomic, copy) NSString *userId;
/**
 * 群主 Owner 群管理员 Manager   群成员Member
 */
@property(nonatomic, copy) NSString *groupRole;
@end
/** 对方开启了消息回执 */
@interface Notice_ReadReceiptInfo:NSObject
@property(nonatomic, assign) BOOL readReceipt;
@end
/** 开启了群审核功能字后 收到的消息 */
@interface Notice_JoinGroupReviewUpdateInfo:NSObject
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *operatorId;
@property(nonatomic, assign) BOOL open;
@end

/// 系统组手目前仅仅用在实名认证的通知
@interface SystemHelperInfo : NSObject
/** 备注 */
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, assign) NSInteger time;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;

@end
/**
 1：当买家取消了订单，卖家收到消息通知
 2： 当卖家确认收款，买家收到消息通知
 3：
 {\"transactionType\":\"Buy\",\"buyC2CUserId\":\"8\",\"buyIcanUserId\":\"111183\",\"sellC2CUserId\":\"13\",\"sellIcanUserId\":\"111261\",\"status\":\"Completed\",\"orderId\":\"916285916329410560\",\"systemOperate\":false}"
 */
@interface C2COrderMessageInfo:NSObject
/** 交易类型 */
@property(nonatomic, copy) NSString *transactionType;
/**  */
@property(nonatomic, copy) NSString *buyC2CUserId;
/**  */
@property(nonatomic, copy) NSString *buyICanUserId;
/**  */
@property(nonatomic, copy) NSString *sellC2CUserId;
/**  */
@property(nonatomic, copy) NSString *sellICanUserId;
@property(nonatomic, strong) NSDecimalNumber *totalCount;
@property(nonatomic, strong) NSDecimalNumber *quantity;
@property(nonatomic, copy) NSString *legalTender;
@property(nonatomic, copy) NSString *virtualCurrency;
@property(nonatomic, assign) NSInteger adOrderId;
/**
 未付款 Unpaid,   您有新的订单
 已付款 Paid,    订单已付款
 申诉 Appeal,     订单正在进行申诉
 已完成 Completed,   订单已完成
 已取消 Cancelled    订单已取消
 */
@property(nonatomic, copy) NSString *status;
/** 订单ID */
@property(nonatomic, copy) NSString *orderId;
///自动回复的消息
@property(nonatomic, copy) NSString *autoMessage;
@property(nonatomic, assign) BOOL systemOperate;
@end
/**
 ///C2C充值和提现发送的通知
 static NSString* const C2CExtRechargeWithdrawType = @"C2CExtRechargeWithdraw";
 ///C2C转账
 static NSString* const C2CTransferType = @"C2CTransfer";
 */
@interface C2CExtRechargeWithdrawMessageInfo : NSObject
/** Recharge/Withdraw */
@property(nonatomic, copy) NSString *type;

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, strong) NSDecimalNumber *amount;
@property(nonatomic, copy) NSDecimalNumber *handlingFeeMoney;
@property(nonatomic, copy) NSString *currencyCode;
/** 充值展示这个 */
@property(nonatomic, copy) NSString *fromAddress;
/** 提现展示这个 */
@property(nonatomic, copy) NSString *toAddress;
@property(nonatomic, copy) NSString *transactionHash;
@property(nonatomic, copy) NSString *createTime;

@end
@interface C2CTransferMessageInfo : NSObject
/** Recharge/Withdraw */
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *fromUserId;
@property(nonatomic, strong) NSDecimalNumber *amount;
@property(nonatomic, copy) NSString *fromNumberId;
/** 充值展示这个 */
@property(nonatomic, copy) NSString *toUserId;
/** 提现展示这个 */
@property(nonatomic, copy) NSString *toNumberId;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy) NSString *createTime;
@end

@interface C2CNotifyMessageInfo : NSObject
@property(nonatomic, copy) NSString *toUserId;
@property(nonatomic, copy) NSString *toNumberId;
@property(nonatomic, copy) NSDecimalNumber *balance;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *createTime;
@end

@interface NoticeOTPMessageInfo : NSObject
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *otp;
@property(nonatomic, copy) NSString *appName;
@property(nonatomic, copy) NSString *imgUrl;
@end

@interface ReactionMessageInfo : NSObject
@property(nonatomic, copy) NSString *reactedMsgId;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *reaction;
@end
NS_ASSUME_NONNULL_END
