//
//  UserInfoManager.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/5.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageMenuView.h"
@class UserMessageInfo;
@class PrivateParameterInfo;
@class UserBalanceInfo;
NS_ASSUME_NONNULL_BEGIN
static NSString* const KToken = @"token";
static NSString* const KChatId = @"chatId";
static NSString * const KuserId =@"userId";
static NSString * const KLoginType =@"loginType";
static NSString * const Knickname =@"nickname";
static NSString * const Kusername =@"username";
static NSString * const Krealname =@"realname";
static NSString * const Kcertification =@"certification";

static NSString* const kmobile = @"mobile";
static NSString* const kgender = @"gender";
static NSString* const knumberId = @"numberId";
static NSString* const kheadImageUrl = @"kheadImageUrl";
static NSString* const Kemial = @"Kemial";
static NSString* const KcardId = @"KcardId";
static NSString* const KloginStatus = @"loginStatus";
static NSString* const kisSetPayPwd = @"isSetPayPwd";
static NSString* const ktradePswdSet = @"tradePswdSet";
static NSString* const kopenPay = @"openPay";
static NSString* const kopenIdType = @"openIdType";
static NSString* const kisSetPassword = @"isSetPassword";
static NSString* const kOpenId = @"kOpenId";
static NSString* const kmallToken = @"mallToken";
static NSString* const kopenCloudPay = @"openCloudPay";
static NSString* const klastLoginTime = @"lastLoginTime";
static NSString* const kBeFound = @"kBeFound";
static NSString* const knearbyVisible = @"nearbyVisible";
static NSString* const KSignature = @"signature";
static NSString* const KloginPassword=@"loginPassword";
static NSString* const KopenRecommend=@"openRecommend";
static NSString* const KopenNearby=@"openNearby";
static NSString* const KopenRecharge=@"openRecharge";
static NSString* const KopenTransfer=@"openTransfer";
static NSString* const KopenWithdraw=@"openWithdraw";
static NSString* const KcloudLetterVideo=@"cloudLetterVideo";
static NSString* const KcloudLetterVoice=@"cloudLetterVoice";
static NSString* const kredPacketMaxMoney = @"redPacketMaxMoney";
static NSString* const kcloudLetterVideo = @"cloudLetterVideo";
static NSString* const kcloudLetterVoice = @"cloudLetterVoice";
static NSString* const KhelperDisturb=@"helperDisturb";
static NSString* const kquickFriend = @"quickFriend";
static NSString* const kfont = @"fontSize";
static NSString* const kselectedfont = @"selectedFont";
static NSString* const kwallpaper = @"wallpaperName";
static NSString* const kisEmailBinded = @"isEmailBinded";
static NSString* const kmustBindEmailPayPswd = @"mustBindEmailPayPswd";
static NSString* const kcountriesCode = @"countryCode";
@interface UserInfoManager : NSObject
//DECLARE_SINGLETON(UserInfoManager, sharedManager);
+ (instancetype)sharedManager;
/** token */
@property (nonatomic,copy,nullable) NSString * token;
@property (nonatomic,copy,nullable) NSString * chatID;
@property (nonatomic,copy,nullable) NSString * fontSize;
@property (nonatomic,copy,nullable) NSString * selectedFont;
@property (nonatomic,copy,nullable) NSString * wallpaperName;
/** userId */
@property (nonatomic,copy,nullable) NSString * userId;
/**0 微信 1支付宝  2 游客  3手机登录  4 游客登录 5ID登陆 6邮箱登陆 */
@property (nonatomic,copy,nullable) NSString * loginType;
/** 当前用户的登录状态 */
@property (nonatomic,assign) BOOL   loginStatus;
@property (nonatomic,copy,nullable) NSString * email;


@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic,copy,nullable) NSString * nickname;

@property (nonatomic,copy,nullable) NSString * username;
@property (nonatomic,copy,nullable) NSString * realname;
@property(nonatomic, copy) NSString *numberId;
//是否实名 1.已实名 3.未实名
@property (nonatomic,strong) NSString *certification;
@property (nonatomic,copy,nullable)  NSString *mobile;
//0w未设置 1,男 2,女
@property (nonatomic,copy,nullable)  NSString *gender;

//身份证号码
@property (nonatomic,copy,nullable)  NSString *cardId;
@property(nonatomic, copy) NSString *deviceToken;
/** 是否设置过支付密码 */
@property(nonatomic, assign) BOOL isSetPayPwd;
/** 是否开启支付 包括能否实名 和能否绑定银行卡和支付宝 */
@property(nonatomic, assign) BOOL openPay;
/** 是否开启云钱包 */
@property(nonatomic, assign) BOOL openCloudPay;
//是否设置了支付密码 1是设置
@property(nonatomic, assign) BOOL tradePswdSet;
//微信授权登录 WeChat 支付宝授权登录 AliPay 游客登录  Visitor
//如果是微信授权登录或者是已经绑定微信的情况下 那么在账号与安全里面不能在出现支付宝 反之亦然
@property(nonatomic, copy) NSString *openIdType;
/** 是否设置了登陆密码     */
@property(nonatomic, assign) BOOL isSetPassword;
@property(nonatomic, assign) BOOL isEmailBinded;
@property(nonatomic, assign) BOOL mustBindEmailPayPswd;
@property(nonatomic, copy)NSString * openId;
/** 注意需要刷新商城token */
@property(nonatomic, copy) NSString *mallToken;

/// 登录成功的时间
@property(nonatomic, copy) NSString *lastLoginTime;
// 是否推荐给其他用户(被其他用户发现)
@property(nonatomic, assign) BOOL beFound;
/** 自己是否被附近的人可见 用户自己打开*/
@property(nonatomic, assign) BOOL nearbyVisible;
/** 是否自动同意好友请求 */
@property(nonatomic, assign) BOOL quickFriend;
/** 是否开启已读回执 */
@property(nonatomic, assign) BOOL readReceipt;
///个性签名
@property(nonatomic, copy) NSString *signature;
@property(nonatomic, copy) NSString *countryCode;
/** 登陆密码 */
@property(nonatomic, copy) NSString *loginPassword;
/**是否开启推荐的人*/
@property(nonatomic, assign) BOOL openRecommend;
/**系统是否开启附近的人*/
@property(nonatomic, assign) BOOL openNearbyPeople;
/**是否开启充值*/
@property(nonatomic, assign) BOOL openRecharge;
/**是否开启转装*/
@property(nonatomic, assign) BOOL openTransfer;
/**是否开启提现*/
@property(nonatomic, assign) BOOL openWithdraw;
/**是否开启兑换*/
@property(nonatomic, assign) BOOL openExchange;
/**是否开启商城*/
@property(nonatomic, assign) BOOL openShop;
/** 是否开启私聊 */
@property(nonatomic, assign) BOOL isSecret;
/** 单人红包的最大金额 */
@property(nonatomic, copy) NSString *redPacketMaxMoney;

/** 云信语音 */
@property(nonatomic, assign) BOOL cloudLetterVoice;
@property(nonatomic, assign) BOOL cloudLetterVideo;
/** 支付助手是否是免打扰 */
@property(nonatomic, assign) BOOL helperDisturb;
@property(nonatomic, assign) NSNumber* vip;
/**
 最后看朋友圈的时间 时间是毫秒
 */
@property(nonatomic, copy) NSString *lookTimelineTime;
@property(nonatomic, assign) BOOL cs;
/** 第三方APPID 可以用来判断是不是第三方用户 */
@property(nonatomic, copy,nullable) NSString *thirdPartySystemAppId;
@property(nonatomic, strong) MessageMenuView *messageMenuView;
/** 是否显示了广告界面 */
@property(nonatomic, assign) BOOL hasShowAdver;
@property(nonatomic, copy) NSString *mallH5Url;
/** 是不是新用户 */
@property(nonatomic, assign) BOOL isNew;
/** 区号  */
@property(nonatomic, copy) NSString *areaNum;
/** 高级会员过期时间*/
@property(nonatomic, copy,nullable) NSString *seniorMemberExpiration;
/** 钻石会员过期时间  */
@property(nonatomic, copy,nullable) NSString *diamondMemberExpiration;
/** 高级会员是否在有效期内 */
@property(nonatomic, assign) BOOL seniorValid;
/** 钻石会员是否在有效期内 */
@property(nonatomic, assign) BOOL diamondValid;

/** 是否开始阻止别人删除我的消息 默认开启 是会员的情况下 */
@property(nonatomic, assign) BOOL preventDeleteMessage;

/** 认证状态,可用值:NotAuth,Authing,Authed */
@property(nonatomic, copy,nullable) NSString *userAuthStatus;
/** 姓  */
@property(nonatomic, copy,nullable) NSString *lastName;
/** 名  */
@property(nonatomic, copy,nullable) NSString *firstName;
/** 系统通知免打扰 */
@property(nonatomic, assign) BOOL systemHelperDisturb;
/** 支持的全部货币 */
@property(nonatomic, strong) NSArray *allSupportedCurrenciesItems;
@property(nonatomic, copy) NSString *countriesCode;
/** Pay Password Block */
@property(nonatomic, copy, nullable) NSString *attemptCount;
@property(nonatomic, assign) BOOL isPayBlocked;
@property(nonatomic, copy, nullable) NSString *unblockTime;
/***/
-(NSString*)getSymbol:(NSString*)currencyCode;
-(void)removeObjectWithKey:(NSString *)key;
-(void)hiddenmessageMenuView;
-(void)getMineMessageRequest:(void(^)(UserMessageInfo*info))successBlock;
-(void)getPrivateParameterRequest:(void (^)(PrivateParameterInfo * _Nonnull))successBlock;
-(void)fetchUserBalanceRequest:(void (^)(UserBalanceInfo*balance))successBlock;
/// 获取阿里云相关数据
-(void)getAliyunOSSSecurityToken:(void (^)(void))successBlock;
///阿里云oss是否在有效期内
- (BOOL)validateWithExpireTime:(NSString *)expireTime;
+(void)uploadAppLanguagesRequest;
@end


NS_ASSUME_NONNULL_END
