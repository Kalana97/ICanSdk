//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/10
- System_Version_MACOS: 10.14
- EasyPay
- File name:  UserResponse.h
- Description:
- Function List: 
- History:
*/
        

#import "BaseResponse.h"
#import "GroupListInfo.h"
#import "UserMessageInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserResponse : BaseResponse

@end





@interface MessageOfflineInfo : NSObject
@property (nonatomic,strong) NSArray * chatOfflineList;
@property (nonatomic,strong) NSArray * groupChatOfflineList;
@end

@interface UploadInfo : IDInfo
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *contentType;
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, assign) NSInteger uploadDate;
@property(nonatomic, copy) NSString *md5;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *share;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *sharePass;
@property(nonatomic, copy) NSString *merchantCode;
@property(nonatomic, copy) NSString *remark;
/** 地址 */
@property(nonatomic, copy) NSString *path;
@end






@interface CredentialsInfo : NSObject
@property(nonatomic, copy) NSString *securityToken;
@property(nonatomic, copy) NSString *accessKeySecret;
@property(nonatomic, copy) NSString *accessKeyId;
@property(nonatomic, copy) NSString *expiration;

@end

@interface OSSSecurityTokenInfo : NSObject
@property(nonatomic, copy) NSString *bucket;
@property(nonatomic, copy) NSString *ossEndpoint;
@property(nonatomic, copy) NSString *urlBegin;
@property(nonatomic, copy) NSString *region;
@property(nonatomic,strong)CredentialsInfo * credentials;
@end

//#define KUserIsAcceptMessageNotice @"isAcceptMessageNotice"
//#define KUserisShowMessageNoticeDetail @"isShowMessageNoticeDetail"
//#define KUserisOpenFace @"isOpenFace"
//#define KUserisOpenSound @"isOpenSound"
//#define KUserisOpenShake @"isOpenShake"
/// 用户配置开启振动等

@interface UserConfigurationInfo : NSObject
@property(nonatomic, assign) BOOL isAcceptMessageNotice;
@property(nonatomic, assign) BOOL isShowMessageNoticeDetail;
@property(nonatomic, assign) BOOL isOpenFace;
@property(nonatomic, assign) BOOL isOpenShake;
@property(nonatomic, assign) BOOL isOpenSound;
/**
 是否已经同意收付款协议
 */
@property(nonatomic, assign) BOOL isAgreePayment;
//全局的消息删除的时间
@property(nonatomic, copy)NSString * deleteMessageWholeTime;
/** 商城TelephoeCode，默认86*/
@property(nonatomic, copy) NSString *mallTelephoeCode;
/** 商城跟首页右上角国家名字，默认中国大陆*/
@property(nonatomic, copy) NSString *mallCountryName;

@end



@interface GetRongYunTokenInfo : NSObject
@property(nonatomic, copy) NSString *token;

@end

@interface CheckUserOnlineInfo:NSObject
@property(nonatomic, assign) BOOL online;
/** 1578379779000 */
@property(nonatomic, strong) NSString* lastOnlineTime;
@end

@interface UserLocationNearbyInfo : IDInfo

/** 距离 */
@property(nonatomic, copy)   NSString *distanceValue;
/** 单位 */
@property(nonatomic, copy)   NSString *distanceUnit;
/**
 单位 千米 0 就是100米以内
 */
@property(nonatomic, assign) NSInteger distance;
@property(nonatomic, copy)   NSString *headImgUrl;
@property(nonatomic, copy)   NSString *nickname;
@property(nonatomic, assign) NSInteger numberId;
@property(nonatomic, copy)   NSString *gender;
@property(nonatomic, assign) BOOL isFriend;
@property(nonatomic, copy)   NSString *showDistance;
@end

@interface UserRecommendListInfo :IDInfo

/** 昵称 */
@property(nonatomic, copy) NSString *nickname;
/** 性别 */
@property(nonatomic, copy) NSString *gender;
/** 头像 */
@property(nonatomic, copy) NSString *headImgUrl;
/** 个性签名 */
@property(nonatomic, copy) NSString *signature;
@property(nonatomic, assign) BOOL isFirend;
@end

/** 搜索返回 */
@interface SearchUserInfo:NSObject
@property(nonatomic, strong) NSArray<UserMessageInfo*> *users;
@property(nonatomic, strong) GroupListInfo *group;
@end


@interface GetPayHelperDisturbInfo:NSObject
@property(nonatomic, assign) BOOL payHelper;
/** 系统免打扰 */
@property(nonatomic, assign) BOOL systemHelper;
/** 商城免打扰 */
@property(nonatomic, assign) BOOL mallHelper;
@end

/**
 获取商城token返回
 */
@interface GetMallLoginTokenInfo : NSObject
@property(nonatomic, copy) NSString *access_token;
@property(nonatomic, copy) NSString *token_type;
@property(nonatomic, copy) NSString *refresh_token;
@property(nonatomic, copy) NSString *expires_in;
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *enabled;
@end

@interface BeInvitedInfo : IDInfo
/** 昵称 */
@property(nonatomic, copy) NSString *nickname;
/** 性别 */
@property(nonatomic, copy) NSString *gender;
/** 头像 */
@property(nonatomic, copy) NSString *headImgUrl;
@property(nonatomic, copy) NSString *numberId;
@end

@interface BeInvitedListInfo : ListInfo

@end
@interface GetBeInvitedCountInfo : NSObject
@property(nonatomic, assign) NSInteger count;
@end

@interface BlockUsersListInfo : ListInfo

@end

@interface ServicesInfo : IDInfo
@property(nonatomic, copy) NSString *headImgUrl;
@property(nonatomic, copy) NSString *linkUrl;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *gender;
@end
@interface CustomerServicesInfo:NSObject
@property(nonatomic, strong) NSArray *csUserList;
@property(nonatomic, strong) NSArray *csWebList;
@end

@interface AccessTokenInfo : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, assign) BOOL shortcutPayment;
@property(nonatomic, copy) NSString *reason;
@end
@interface DialogListInfo : IDInfo
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, strong) NSString * dialogClass;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger weights;
@property(nonatomic, copy) NSString *dialogId;
/** 是否校验手机号码
 */
@property(nonatomic, assign) BOOL isCheck;
/**
 是否显示通知号码
 */
@property(nonatomic, assign) BOOL showNoticeAccount;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *accountNumber;
@end
/**
 国外充值返回的结果
 */
@interface DialogPaymentInfo : NSObject
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *redirectUrl;
@property(nonatomic, assign) NSInteger paymentHoldingStatus;
@end

@interface PostCreateDialogOrderInfor : NSObject
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *paymentId;
@property (nonatomic, assign) NSInteger paymentUrl;
@property (nonatomic, strong) NSString *amount;
@end

@interface RechargePaymentCountryInfo : NSObject
@property (nonatomic, strong) NSString * phoneCode;
@property (nonatomic, strong) NSString * nameEn;
@property (nonatomic, strong) NSString * nameCn;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * currencyCode;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *flagUrl;
@end

@interface ExchangeByAmountInfo : NSObject
@property (nonatomic, assign) NSString* amount;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) NSInteger exchangeRateId;
@property (nonatomic, strong) NSString * fromCode;
@property (nonatomic, strong) NSString * fromName;
@property (nonatomic, assign) NSInteger handlingFee;
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, assign) NSInteger rateNumber;
/** 需要支付的金额
 */
@property (nonatomic, copy) NSString* toAmount;
/**
 转换成货币代码
 */
@property (nonatomic, strong) NSString * toCode;
@property (nonatomic, strong) NSString * toName;
@property (nonatomic, strong) NSString * updateTime;
@end
@interface DialogOrderInfo : NSObject
@property(nonatomic, copy) NSString *payChannelTypeName;
/**
 支付渠道类型,可用值:Balance,BankCard,CreditCard,AliPay,WeChatPay
 */
@property(nonatomic, copy) NSString *payChannelType;
///充值的手机号码
@property (nonatomic, strong) NSString * accountNumber;
@property (nonatomic, strong) NSString * agentAlias;
@property (nonatomic, assign) NSInteger agentPin;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, strong) NSString * channelCode;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * dialogName;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * logo;

@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * payInfo;
/**
 支付状态,可用值:Paying,Success,Fail,Refund
 */
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString * rechargeStatus;
@property (nonatomic, strong) NSString * payUrl;
@property (nonatomic, strong) NSString * refernceMobileNumber;
/** 充值结果 5 成功  其他都是失败 有可能为空 */
@property (nonatomic, assign) NSNumber * status;
/** 充值金额 */
@property (nonatomic, assign) double txAmount;
/** 订单金额单位     */
@property (nonatomic, strong) NSString * unit;
/** 实际充值金额 */
@property (nonatomic, assign) double actualAmount;
/** 实际订单金额单位     */
@property (nonatomic, strong) NSString * actualUnit;

@property (nonatomic, strong) NSString * txReference;
@property (nonatomic, strong) NSString * txType;
@property (nonatomic, assign) NSInteger userId;

@end

@interface DialogOrdersListInfo : ListInfo

@end

@interface GetCircleToeknInfo:NSObject
@property(nonatomic, copy) NSString *token;
@end

@interface Get43PaywayInfo : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL select;
@end
@interface QuickPayInfo:IDInfo
@property (nonatomic, copy) NSString * bankExpiry;
@property (nonatomic, copy) NSString * bankNum;
@property (nonatomic, copy) NSString * bankToken;
@property (nonatomic, copy) NSString* channelCode;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL select;
@property(nonatomic, copy) NSString *acceptedCurrencyCode;
@property(nonatomic, copy) NSString *convertedAmount;
@end

@interface QuickMessageInfo : IDInfo
@property(nonatomic, copy) NSString *value;
@end

@interface MemberCentreVipInfo : NSObject
@property (nonatomic, assign) BOOL deleted;
/** 时长 （月） */
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSInteger memberId;
/** 会员类型,可用值:SeniorMember,DiamondMember */
@property (nonatomic, strong) NSString * memberType;
@property (nonatomic, strong) NSString * title_cn;
@property (nonatomic, strong) NSString * title_en;
/** 金额 */
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, assign) NSInteger weights;

@end
@interface MemberCentreNumberIdSellInfo:IDInfo
@property(nonatomic, assign) NSInteger numberIdSellId;
@property(nonatomic, strong) NSNumber* numberId;
@property(nonatomic, strong) NSNumber * price;

@end
@interface AllCountryInfo : IDInfo
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *nameCn;
@property(nonatomic, copy) NSString *nameEn;
@property(nonatomic, copy) NSString *phoneCode;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, nullable) NSString *flagUrl;
@property(nonatomic, nullable) NSString *rateToCNY;
@end

@interface LanguageInfo : IDInfo
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@end

@interface C2CTokenInfo : NSObject
@property(nonatomic, copy) NSString *c2cUserId;
@property(nonatomic, copy) NSString *token;
@end

@interface CloudLetterToken : NSObject
@property(nonatomic, copy) NSString *cloudLetterToken;
@end

@interface SelfEmailVerificationKey : NSObject
@property(nonatomic, copy) NSString *key;
@end
NS_ASSUME_NONNULL_END
