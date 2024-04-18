#ifndef Constant_h
#define Constant_h

NS_ASSUME_NONNULL_BEGIN
//authorityType: friend//好友  secret 私聊  circle交友 c2c 
static NSString* const AuthorityType_friend = @"friend";
static NSString* const AuthorityType_secret = @"secret";
static NSString* const AuthorityType_circle = @"circle";
static NSString* const AuthorityType_c2c = @"c2c";

static NSString* const TextMessageType = @"Chat_Txt";
static NSString* const DynamicMessageType = @"Chat_Dynamic";
static NSString* const PinMessageType = @"Pin_Message";
static NSString* const C2CNotifyMessageType = @"C2CNotify";
static NSString* const NoticeOTPMessageType = @"Notice_OTP";
static NSString* const ChatModeOtherChat = @"OTHER_CHAT";
static NSString* const RedPacketMessageType = @"SendSingleRedPacket";
static NSString* const RedPacketGroupMessageType = @"SendRoomRedPacket";
static NSString* const VoiceMessageType = @"Chat_Vc";
static NSString* const ImageMessageType = @"Chat_Img";
static NSString* const LocationMessageType = @"Chat_Location";
static NSString* const UserCardMessageType = @"Chat_UserCard";
static NSString* const AtAllMessageType = @"Chat_AtAll";
static NSString* const AtSingleMessageType = @"Chat_AtSingle";
static NSString* const TransFerMessageType = @"Transfer";
static NSString* const VideoMessageType = @"Chat_Sight";
static NSString* const FileMessageType = @"Chat_File";
static NSString* const URLMessageType = @"Chat_Url";
static NSString* const AIMessageType = @"Chat_Ai";
static NSString * const ReactionMessage = @"Reaction_Message";
static NSString* const AIMessageQuestionType = @"Chat_Ai_Question";
static NSString* const GamifyMessageType = @"GamificationPlay";
//分享的是其他应用 例如商品详情
static NSString* const kChatOtherShareType = @"Chat_OtherShare";
/** 朋友圈分享的消息类型 */
static NSString* const kChat_PostShare = @"Chat_PostShare";
/** 融云相关的消息 */
static NSString* const ChatCallMessageType = @"Chat_Call";
static NSString * const ChatCallPushMessageType = @"Chat_Call_Push";

static NSString* const ReceiptMessageType = @"Chat_receipt";
static NSString* const ReceiptGroupMessageType = @"Chat_group_receipt";

//RECEIVE("对方已收到")
static NSString* const ReceiptRECEIVE = @"RECEIVE";
//READ("对方已读", 1);
static NSString* const ReceiptREAD  = @"READ";
/** 添加或者移除管理员 */
static NSString* const Notice_GroupRoleUpdateType = @"Notice_GroupRoleUpdate";
/** 收到对方删除了消息 */
static NSString* const Notice_RemoveChatType = @"Notice_RemoveChat";
/** 收到某个群禁言的消息通知  */
static NSString* const Notice_AllShutUpMessageType = @"Notice_AllShutUp";
/** 收到某个群是否可以加好友 */
static NSString* const Notice_ShowUserInfoMessageType= @"Notice_ShowUserInfo";
/** 撤回消息  */
static NSString* const WithdrawMessageType = @"Chat_withdraw";
/** 收到别人进群的消息 */
static NSString* const  Notice_AddGroupMessageType= @"Notice_AddGroup";
/** 退出群聊 */
static NSString* const Notice_QuitGroupMessageType = @"Notice_QuitGroup";
/** 收到对方把你删除消息 */
static NSString* const Notice_DeleteFriendMessageType = @"Notice_DeleteFriend";

static NSString* const Notice_ReadReceiptMessageType = @"Notice_ReadReceipt";
/** 收到添加好友请求 */
static NSString* const Notice_AddFriendMessageType = @"Notice_AddFriend";
/** 修改群名称 */
static NSString* const Notice_SubjectMessageType = @"Notice_Subject";
/** 修改群备注 */
static NSString* const Notice_UpdateGroupNicknameType = @"Notice_UpdateGroupNickname";
/** 收到禁用的消息  */
static NSString* const Notice_BanMessageType = @"Notice_Ban";
/** 收到群主转让的消息  */
static NSString* const Notice_TransferGroupOwnerType = @"Notice_TransferGroupOwner";
/** 收到登录的消息 */
static NSString* const Notice_LoginType = @"Notice_Login";
/** 用户注销账号 他的好友收到的消息 */
static NSString* const Notice_DestroyUserType = @"Notice_DestroyUser";
/** 收到消息的阅后即焚时间  */
static NSString* const Notice_DestroyTimeType = @"Notice_DestroyTime";
static NSString* const Notice_UserShutUp = @"Notice_UserShutUp";
/** 开启截屏通知 或者是发送截屏通知的消息 OPEN打开  CLOSE关闭  NOTICE通知 */
static NSString* const Notice_ScreencastType = @"Notice_Screencast";
static NSString* const Notice_ScreencastTypeOPEN = @"OPEN";
static NSString* const Notice_ScreencastTypeCLOSE = @"CLOSE";
static NSString* const Notice_ScreencastTypeNOTICE = @"NOTICE";
/** 成为好友之后的提示消息 */
static NSString* const Add_friend_successType = @"Notice_AddFriendSuccess";
/**
 更新了群设置
 */
static NSString* const Notice_Group_UpdateType=@"Notice_Group_Update";
/** 版本更新 */
static NSString* const Notice_VersionType = @"Notice_Version";
/** 用户的在线状态改变之后 服务器给该用户的好友发送的在线离线的状态消息 */
static NSString* const Notice_OnlineChangeType = @"Notice_OnlineChange";
/** 帖子的通知消息类型*/
static NSString* const TimeLine_Notice = @"TimeLine_Notice";
/** 别人把你拉黑 你收到的消息 */
static NSString* const Notice_BlockUserType = @"Notice_BlockUser";

//支付助手
static NSString* const PayHelperMessageType = @"PayHelper";
//商城助手
static NSString* const ShopHelperMessageType = @"ShopHelper";
//系统助手
static NSString* const SystemHelperMessageType = @"SystemHelper";
static NSString* const AnnouncementHelperMessageType = @"AnnouncementHelper";




///C2C的通知消息 比如说下单 或者有人确认收款
static NSString* const C2COrderMessageType = @"C2COrder";
///C2C的通知消息 比如说下单 或者有人确认收款
static NSString* const C2CHelperMessageType = @"C2CHelper";
///C2C充值和提现发送的通知
static NSString* const C2CExtRechargeWithdrawType = @"C2CExtRechargeWithdraw";
///C2C转账
static NSString* const C2CTransferType = @"C2CTransfer";
/**
 冻结用户
 */
static NSString* const Notice_FreezeType = @"Notice_Freeze";
/**
 收付款码
 */
static NSString* const Notice_PayQRType = @"Notice_PayQR";

/** 收到别人发送的单人红包 */
static NSString* const SendSingleRedPacketType = @"SendSingleRedPacket";
/** 别人领取了你发送的单人红包 */
static NSString* const GrabSingleRedPacketType = @"GrabSingleRedPacket";
/** 收到退回的红包消息 */
static NSString* const RejectSingleRedPacketType = @"RejectSingleRedPacket";

/** 收到别人发送的多人红包 */
static NSString* const SendRoomRedPacketType = @"SendRoomRedPacket";
/** 别人领取了你发送的多人红包 */
static NSString* const GrabRoomRedPacketTypeType = @"GrabRoomRedPacket";
/** 收到退回的多人红包消息 */
static NSString* const RejectRoomRedPacketType = @"RejectRoomRedPacket";
/** 进群申请 群主或者管理员会收到 */
static NSString* const Notice_JoinGroupApplyType = @"Notice_JoinGroupApply";
/** 群开启了审核验证之后，用户可以收到这条通知 */
static NSString* const kNotice_JoinGroupReviewUpdate = @"Notice_JoinGroupReviewUpdate";
//红包错误类型 "expired", "红包已经过期" "received", "请勿重复领取" "empty","手慢了已经被抢完" success 表示成功抢到红包 或者对方成功
#define Kreceived @"received"
#define KreceivedDescription @"你已经抢过该红包了"
#define Kexpired  @"expired"
#define KexpiredDescription @"该红包已过期"
#define KbalanceLack @"balanceLack"
#define KbalanceLackDescription @"余额不足"
#define KEmpty @"over"
#define KEmptyDescription @"手慢了，红包派完了"
#define KNoexisting @"no-existing"
#define KNoexistingDescription @"你还没有加入群聊"

//扫码加入
#define KNotice_AddGroup_ScanCode @"ScanCode"
//被邀请加入
#define KNotice_AddGroup_BeInvited @"BeInvited"
//后台加入
#define KNotice_AddGroup_ManagerAdd @"ManagerAdd"
//用户搜索自己加入
#define KNotice_AddGroup_Search @"Search"

static NSString* const  UserChat= @"userChat";
static NSString* const  GroupChat= @"groupChat";

static NSString* const BoyDefault = @"img_default_boy";
static NSString* const GirlDefault = @"img_default_girl";
static NSString* const GroupDefault = @"img_default_groud";
static NSString* const DefaultImg = @"img_default_placeholder";

//当前用户的缓存路径
#define MessageCache     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"com.shouju.easypay/%@/Message",[UserInfoManager sharedManager].userId]]
//某个会话的资源缓存路径
#define MeesageChatIDCache(chatId) [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",chatId]]
//数据库的缓存路径
#define MessageCacheWCDB  [MessageCache stringByAppendingPathComponent:@"message.db"]
//和某个会话图片的缓存路径
#define MessageImageCache(chatId) [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Image",chatId]]
//和某个会话视频的缓存路径
//[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"camera_movie"];
#define MessageVideoCache(chatId) [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Video",chatId]]
//和某个会话语音的缓存路径
#define MessageAudioCache(chatId) [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Audio",chatId]]
//和某个会话文件的缓存路径
#define MessageFileCache(chatId) [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/File",chatId]]
//和某个用户本地收藏文件的缓存路径
#define MessageCollectFileCache [MessageCache stringByAppendingPathComponent:[NSString stringWithFormat:@"File"]]

#define KUserIsAcceptMessageNotice @"isAcceptMessageNotice"
#define KUserisShowMessageNoticeDetail @"isShowMessageNoticeDetail"
#define KUserisOpenFace @"isOpenFace"
#define KUserisOpenSound @"isOpenSound"
#define KUserisOpenShake @"isOpenShake"


#define KRedPacketExpired @"expired" //红包已经过期
#define KRedPacketReceived @"received" //请勿重复领取
#define KRedPacketEmpty @"empty" //红包已领完
#define KRedPacketsuccess @"success" //表示成功抢到红包 或者对方成功领取了你的单人红包

//Organization
static NSString* const REMOVE_USERS = @"REMOVE_USERS";
static NSString* const INVITE_USERS = @"INVITE_USERS";
static NSString* const CONFIRM_USERS = @"CONFIRM_USERS";
static NSString* const APR_TRANSACTION = @"APR_TRANSACTION";
static NSString* const VIEW_TRANSACTION_ORG = @"VIEW_TRANSACTION_ORG";
static NSString* const CHANGE_PERMISSION = @"CHANGE_PERMISSION";
static NSString* const OWNER = @"OWNER";

static NSString * const ksearchText = @"searchText";
static NSString * const kshouldStartLoad = @"shouldStartLoad";
static NSString * const kshowName = @"showName";
static NSString * const kchatID = @"chatID";
static NSString * const kchatType = @"chatType";
static NSString * const kchatMode = @"chatMode";
static NSString * const kauthorityType = @"authorityType";
static NSString * const kcircleUserId = @"circleUserId";
static NSString * const kmessageTime = @"messageTime";
static NSString * const kC2CUserId = @"c2cUserId";
static NSString * const kC2COrderId = @"c2cOrderId";
NS_ASSUME_NONNULL_END
#endif /* Constant_h */
