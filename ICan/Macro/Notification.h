//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 20/9/2019
- File name:  Notification.h
- Description:
- Function List: 
*/
        

#ifndef Notification_h
#define Notification_h

/** 刷新聊天列表 */
static NSString* const KChatListRefreshNotification  = @"KChatListRefreshNotification";
static NSString* const KUpdateUserMessageNotification = @"kUpdateUserMessageNotification";
static NSString* const KRefreshCurrencyValuesNotification = @"refreshCurrencyValues";
/** 删除好友通知  */
static NSString* const kDeleteFriendNotification = @"kDeleteFriendNotification";
/**  收到同意添加好友请求 */
static NSString* const kAgreeFriendNotification = @"kAgreeFriendNotification";
/** 收到好友请求通知  */
static NSString* const kReceiveFriendApplyNotication = @"kReceiveFriendApplyNotication";
/** 更新本地所有新好友的表的isRead为已读通知  */
static NSString* const kUpdateFriendSubscriptionReadNotication = @"kUpdateFriendSubscriptionReadNotication";
/** 收到群成员加入退出都需要调用该接口  */
static NSString* const kUpdateGroupMessageNotification = @"kUpdateGroupMessageNotification";
/**
 重新获取群详情
 */
static NSString* const KGetGroupDetailNotification=@"KGetGroupDetailNotification";
/** 退出群聊的通知 */
static NSString* const kQuitGroupMessageNotification = @"kQuitGroupMessageNotification";
/** 我行token失效的通知 */
static NSString* const KTokenFailureNotification = @"KTokenFailureNotification";


/** 修改好友备注通知 */
static NSString* const KUpdateFriendRemarkNotification = @"KUpdateFriendRemarkNotification";

static NSString* const kForwardingSendMessageNotification = @"kForwardingSendMessageNotification";
//收到撤回消息的通知
static NSString* const kWithdrawMessageNotification = @"kWithdrawMessageNotification";

static NSString* const kChatWithFriendNotification=@"kChatWithFriendNotification";

static NSString* const kRequestPhoneBillPriceNotification=@"kRequestPhoneBillPriceNotification";
//绑定邮箱或手机成功通知
static NSString* const kBindingSucessNotification=@"kBindingSucessNotification";
//转账成功的通知
static NSString* const KTransferSucessNotification=@"KTransferSucessNotification";
/** 版本更新通知 */
static NSString* const kNotice_VersionNotification = @"kNotice_VersionNotification";
/**
 商城地区改变的通知
 */
static NSString* const kShopAreaChangeNotification = @"kShopAreaChangeNotification";
/** 收到好友离线在线的通知 */
static NSString* const kNotice_OnlineChangeNotification = @"kNotice_OnlineChangeNotification";
/** 如果是系统的分享给ican 并且ican分享的人 正是在聊天的人 */
static NSString* const kShareExtensionNotification = @"kShareExtensionNotification";
/** 更新朋友圈未读消息的数量 */
static NSString* const kUpdateNoticeInfoNumberNotification = @"kUpdateNoticeInfoNumberNotification";
/** 收到对方发送删除的消息 */
static NSString* const kNotice_RemoveChatNotification = @"Notice_RemoveChatNotification";
/** 当点击屏蔽某个人的朋友圈的时候 如果是屏蔽的话 刷新朋友圈 */
static NSString* const kShieldTimeLineNotification = @"kShieldTimeLineNotification";

#pragma mark - 红包相关通知
/** 收到别人领取了你的红包通知 */
static NSString* const kReceiveSingleRedPacketGrabNotification = @"kReceiveSingleRedPacketGrabNotification";

static NSString* const KChangeTimelineSuccessNotification = @"KChangeTimelineSuccessNotification";
/** 点击播放的cell 播放结束的时候 */
static NSString* const KDZVideoPalyendNotification = @"KDZVideoPalyendNotification";
/** 收到语音通话申请或者是停止播放语音或者视频 */
static NSString* const KStopPlayVideoOrAudioNotification = @"KStopPlayVideoOrAudioNotification";
/** 重新播放语音或者视频 （因为语音通话而停止）*/
static NSString*const KStartPlayVideoOrAudioNotification=@"KStartPlayVideoOrAudioNotification";

/** 实名认证通过*/
static NSString*const KUserAuthPassNotification=@"KUserAuthPassNotification";

/** 收到禁用的消息通知 */
static NSString* const kNoticeBanNotification = @"kNoticeBanNotification";
/** 收到某个用户把你拉黑的通知*/
static NSString* const kNoticeBlockUsersNotification = @"kNoticeBlockUsersNotification";

/** 网络不可用的情况下的提示 */
static NSString* const KAFNetworkReachabilityStatusNotReachable = @"KAFNetworkReachabilityStatusNotReachable";
static NSString* const kUpdateShowNearPeopleNotification = @"kUpdateShowNearPeopleNotification";
// 用户开始连接
#define KConnectSocketStartNotification     @"KConnectSocketStartNotification"
// 链接成功
#define KConnectSocketSuccessNotification   @"KConnectSocketSuccessNotification"
// 连接失败
#define KConnectSocketFailedNotification    @"KConnectSocketFailedNotification"
//商城相关通知
/** 支付成功的通知 */
static NSString* const kYXPaySuccessNotification = @"kYXPaySuccessNotification";
/** 点击确认收货的通知 */
static NSString* const kYXConfirmReceiptNotification = @"kYXConfirmReceiptNotification";

/** 点击评价成功的通知 */
static NSString* const kYXPushEvaluateSuccessNotification = @"kYXPushEvaluateSuccessNotification";
/** 点击评价成功的通知 */
static NSString* const kYXCancelOrderSuccessNotification = @"kYXCancelOrderSuccessNotification";
/** 点击退款申请成功提交的按钮 */
static  NSString* const kRefundOrderSuceessNotification = @"kRefundOrderSuceessNotification";
/**    商城token失效 */
static NSString* const kShopTokenFailureNotification = @"kShopTokenFailureNotification";
/**
 获取私有设置的通知
 */
static NSString* const kGetPriviSuccessNotification = @"kGetPriviSuccessNotification";

static NSString* const kUpdateNewUserSettingMobileOrEmailNotification = @"kUpdateNewUserSettingMobileOrEmailNotification";

static NSString* const ksetPasswordSuccessNotification = @"ksetPasswordSuccessNotification";
static NSString * const KClickDialogFavoriteButotnNotification = @"KClickDialogFavoriteButotnNotification";
/** 收到入群通知 */
static NSString * const KreceivedApplyJoinGroupNotification = @"KreceivedApplyJoinGroupNotification";
static NSString* const KShowNewTipViewNotification = @"KShowNewTipViewNotification";
//成功创建群聊通知
static NSString* const KCreatGroupSuccessNotification=@"KCreatGroupSuccessNotification";
static NSString* const kUserMessageChangeNotificatiaon = @"kUserMessageChangeNotificatiaon";
//清理交友聊天消息
static NSString* const kCleanCircleMessageNotificatiaon = @"kCleanCircleMessageNotificatiaon";
/** 修改了快捷消息的通知 */
static NSString * const KChangeQuickMessageNotification = @"KChangeQuickMessageNotification";
static NSString * const KTranspondSuccessNotification = @"KTranspondSuccessNotification";
/** c2c金额变化的通知 */
static NSString * const KC2CBalanceChangeNotification = @"KC2CBalanceChangeNotification";

//注销交友账号
static NSString* const kCancelCircleUserNotificatiaon = @"kCancelCircleUserNotificatiaon";

//注销交友账号
static NSString* const kUpdateCircleUserMessageNotificatiaon = @"kUpdateCircleUserMessageNotificatiaon";
static NSString* const kUpdateBusinessIconNotificatiaon = @"kUpdateBusinessIconNotificatiaon";
/** 购买了VIP会员 */
static NSString * const KBuyVIPNotification = @"KBuyVIPNotification";
/** 购买了NumberID */
static NSString * const KBuyNumberIdNotification = @"KBuyNumberIdNotification";
/** 购买货币成功通知 */
static NSString * const kBuyCurrencySuccessNotification = @"kBuyCurrencySuccessNotification";
/** 交友的照片墙照片改变了 */
static NSString * const kCirclePhotoWallChangeNotification = @"CirclePhotoWallChangeNotification";

#pragma mark - C2C
/** 发布广告成功 */
static NSString * const kC2CPublishAdverSuccessNotification = @"kC2CPublishAdverSuccessNotification";
/** 刷新订单列表通知 */
static NSString * const kC2CRefreshOrderListNotification = @"kC2CRefreshOrderListNotification";
/** 成功收款通知 */
static NSString * const kC2CSuccessReceiveMoneyNotification = @"kC2CSuccessReceiveMoneyNotification";
static NSString * const kC2COrderNotification = @"kC2COrderNotification";
#endif /* Notification_h */
