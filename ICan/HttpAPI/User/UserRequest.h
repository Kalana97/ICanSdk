//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/10
- System_Version_MACOS: 10.14
- EasyPay
- File name:  UserRequest.h
- Description:
- Function List: 
- History:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserRequest : BaseRequest

@end

/**
 搜索用户
 */
@interface SearchUserRequest : BaseRequest
/** 搜索内容 */
@property(nonatomic, copy) NSString *username;
@end

/**
 搜索群或者人
 */
@interface SearchUserAndGroupRequest : BaseRequest
@property(nonatomic, copy) NSString *value;
@end


/**
 退出登录
 */
@interface LogoutRequest : BaseRequest

@end
/**
 用户点击授权登录
 0 微信 1支付宝 2 游客
 */
@interface UserThirdPartyAuthorizationRequest : BaseRequest
/** 支付宝或者是微信的cod  如果是游客登录那么传唯一设备号*/
@property (nonatomic,copy,nullable) NSString * code;

/** 0 微信 1支付宝 2 游客  */
@property (nonatomic,strong) NSNumber * type;

@property(nonatomic, strong,nullable) NSDictionary *extra;

@end

/** 发送验证码  */
@interface SendVerifyCodeRequest:BaseRequest
/** 手机号码或者邮箱 */
@property (nonatomic,copy,nullable) NSString * username;
/**  0 其他  1 注册 2 绑定 3 找回登录密码
 */
@property (nonatomic,strong,nullable) NSNumber * type;
@end

/** 发送验证码  */
@interface DeviceVerifyRequest:BaseRequest
/** 手机号码或者邮箱 */
@property (nonatomic,copy,nullable) NSString * username;
@property (nonatomic,copy,nullable) NSString * areaNum;
@property (nonatomic,copy,nullable) NSString * accountType;
@property (nonatomic,copy,nullable) NSString * code;
/**  0 其他  1 注册 2 绑定 3 找回登录密码
 */
@end

/**
 找回密码
 */
@interface FindPasswordRequest : BaseRequest
/** 账号 */
@property (nonatomic,copy,nullable) NSString * account;
/** 新密码 */
@property (nonatomic,copy,nullable) NSString * newpwd;
/** 短信验证码 */
@property (nonatomic,copy,nullable) NSString * pcode;

@end


/**
 获取离线消息
 */
@interface GetMessageOfflineRequest:BaseRequest

@end

@interface GetSellerMessageLast:BaseRequest
@end

@interface GetSellerOldMessagesList:BaseRequest
@property(nonatomic, copy) NSString *toUserId;
@end
/**
 上传图片
  NSDictionary *parametersDic = @{@"token": [UserInfoManager sharedManager].token, @"pub": pub, @"remark": remark};
 */
@interface UploadImageRequest : BaseRequest
@property(nonatomic, copy) NSString *token;
@property(nonatomic, strong) NSNumber *pub;
@property(nonatomic, copy) NSString *remark;
@end






/**
 生成二维码图片
 */
@interface GetQrCodeRequest : BaseRequest
//@param type    二维码类型 【0:我的二维码;1:收款二维码(2019开头);2:付款二维码;3:邀请注册二维码】
//@param money    收款码固定金额
//@param remark    收款码备注
@property(nonatomic, strong) NSNumber *type;

@property(nonatomic, copy) NSString *rmark;

@property(nonatomic, copy) NSString *money;


@end
@interface SettingUserHeadPortraitRequest:BaseRequest
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *ticket;
@end



/**
 删除好友
 */
@interface UserDeleteFriendRequest : BaseRequest
@property (nonatomic,copy) NSString * merchantCode;
@end




//____________________________//
/**
 登录接口
 */
@interface LoginRequest : BaseRequest

/** 账号 */
@property (nonatomic,copy,nullable) NSString * username;
/** 密码 */
@property (nonatomic,copy,nullable) NSString * password;
/**  账户类型：0、电话；1：email   2:id */
@property (nonatomic,assign) NSNumber*accountType;
/** 电话号码 */
@property(nonatomic, copy,nullable) NSString *areaNum;
@property (nonatomic,copy,nullable) NSString * code;
@end

/**
 注册接口
 */
@interface RegisterRequest : BaseRequest
/** 用户名  */
@property (nonatomic,copy,nullable) NSString * username;
/** 密码 */
@property (nonatomic,copy,nullable) NSString * password;
/** 昵称 */
@property (nonatomic,copy,nullable) NSString * nickname;
/** 验证码 */
@property (nonatomic,copy,nullable) NSString * code;
/** 0手机 1邮箱  */
@property (nonatomic,strong,nullable) NSNumber*accountType;
/** 区号 */
@property(nonatomic, copy,nullable) NSString *areaNum;

/** 国家代码 */
@property(nonatomic, copy,nullable) NSString *countriesCode;

/** 邀请人id  */
@property(nonatomic, copy,nullable) NSString *guiderId;

/** 邀请人numberId */
@property(nonatomic, copy,nullable) NSString *guiderNumberId;

@property(nonatomic, strong,nullable) NSDictionary *extra;

    
@end


/** 发送短信验证码  */
@interface SendSMSCodeRequest : BaseRequest
@property (nonatomic,copy,nullable) NSString *mobile;
/** 类型：0、注册；1、登陆；2、找回密码； */
@property(nonatomic, strong) NSNumber *type;
@end

/** 发送短信验证码  */
@interface SendEmailCodeRequest : BaseRequest
@property (nonatomic,copy,nullable) NSString *mobile;
/** 类型：0、注册；1、登陆；2、找回密码； */
@property(nonatomic, strong) NSNumber *type;
@end



/** 获取阿里OSS token  */
@interface GetAliyunOSSSecurityTokenRequest : BaseRequest

@end


/// 忘记登录密码
@interface ForgetLoginPasswordRequest:BaseRequest
/// 验证码
@property(nonatomic, copy) NSString *code;
/// 密码
@property(nonatomic, copy) NSString *password;
/// 账号（手机号或者邮箱）
@property(nonatomic, copy) NSString *username;
/** 手机区号 */
@property(nonatomic, copy) NSString *areaNum;
@end


/// 修改用户信息
@interface EditUserMessageRequest : BaseRequest
@property(nonatomic, copy, nullable) NSString *headImgUrl;
/// 性别 0 位置 1 男 2女
@property(nonatomic, copy, nullable) NSString *gender;
@property(nonatomic, copy, nullable) NSString *nickname;
@end

/// 修改登录密码
@interface ChangeLoginPasswordRequest : BaseRequest
@property (nonatomic,copy) NSString * password;
@property (nonatomic,copy) NSString * oldPassword;
@end


/** 获取用户信息 */
@interface GetUserMessageRequest : BaseRequest
/** 用户ID */
@property (nonatomic,copy,nullable) NSString * userId;
@end
/** 批量获取用户信息 */
@interface GetUserListRequest : BaseRequest
/** 用户ID */
@property (nonatomic,strong,nullable) NSArray * ids;
@end
/**
 通过numberId批量搜索用户 body 里面直接传一个数组
 */
@interface GetUserListByNumberIdRequest : BaseRequest
@property(nonatomic, strong,nullable) NSArray *numberIds;
@end
/**实名认证*/
@interface RealNameAuthenticationRequest : BaseRequest
@property (nonatomic,copy,nullable) NSString * realName;
@property (nonatomic,copy,nullable) NSString * cardId;

@end


/// 报告用户登录
@interface ReportUserLoginRequest:BaseRequest

@end

@interface ReportUserLogoutRequest:BaseRequest

@end

/// 设置支付密码
@interface SettingUserpPayPasswordRequest : BaseRequest
@property(nonatomic, copy) NSString *oldPayPassword;
@property(nonatomic, copy) NSString *payPassword;
@end
/// 设置支付密码
@interface FindUserpPayPasswordRequest : BaseRequest
@property(nonatomic, copy) NSString *payPassword;
/** 手机号码或者邮箱 */
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *code;
@end
@interface BindingUserDeviceTokenRequesr : BaseRequest
@property(nonatomic, copy) NSString *token;
@end
/**设置APP消息未读数量 put*/
@interface SetApplicationIconBadgeNumberRequest : BaseRequest

@end
/** 校验支付密码 */
@interface VerifyPaymentPasswordRequest : BaseRequest
@property(nonatomic, copy) NSString *paymentPassword;
@end

@interface BindingUserMobileRequest : BaseRequest
//手机号码
@property(nonatomic, copy) NSString *mobile;
//验证码
@property(nonatomic, copy) NSString *code;
/** 区号 */
@property(nonatomic, copy) NSString *areaNum;

@end

@interface BindingUserEmailRequest : BaseRequest

//email号码
@property(nonatomic, copy) NSString *email;
//验证码
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy, nullable) NSString *prevVerifyKey;
@end

@interface VerifySelfEmail : BaseRequest
@property(nonatomic, copy) NSString *code;

@end

/** 绑定第三方 */
@interface BindThirdPartyRequest : BaseRequest
@property(nonatomic, copy) NSString *code;
/** 0 微信 1支付宝     */
@property(nonatomic, strong) NSNumber *type;
@end

/**
 获取y融云token
 /user/{id}/rongCloudToken
 */
@interface GetRongYunTokenRequest:BaseRequest
@end
/**
 检查用户是否在线
 /user/checkOnline/{id}
 */
@interface CheckUserOnlineRequest : BaseRequest

@end
/**
 注销用户
 /user/destroy
 */
@interface UserDestroyRequest:BaseRequest

@end

/**
 同意桌面端登陆
 */
///user/webLogin/agree/{uuid}
@interface UserWebLoginAgreeRequest:BaseRequest

@end
/** 群主登录
 /group/login/{uuid}
 UUID规则
 G_O_L_uuid
 */
@interface GroupLoginRequest:BaseRequest

@end
/**
 设置附近的人是否可见
 */
////user/nearbyVisible
@interface UserNearbyVisibleRequest:BaseRequest

@end


/**
 上报用户位置
 */
///PUT/userLocation/upload
@interface UploadUserLocationRequest:BaseRequest
/** 精度 */
@property(nonatomic, copy) NSString *longitude;
/** 纬度 */
@property(nonatomic, copy) NSString *latitude;
@end



/**
 附近的人
 /userLocation/nearby/v1
 */

@interface GetUserNearbyRequest:BaseRequest
/**
 从1开始
 */
@property(nonatomic, strong) NSNumber* page;
/**
 Male,   Female
 */
@property(nonatomic, copy) NSString *gender;
@end

/**
 设置用户是否被推荐
 */
//PUT/user/beFound
@interface SetUserBeFoundRequest:BaseRequest

@end


/**
 推荐用户
 */
//user/recommend
@interface GertUserRecommendRequest:BaseRequest
@property(nonatomic,strong,nullable) NSNumber *page;
@property(nonatomic,strong,nullable) NSNumber *size;
@end

/**
 修改个性签名
 */
//user/recommend
@interface ModifyUserSignatureRequest:BaseRequest
//如果要置空，就传null
@property(nonatomic, copy) NSString *signature;
@end

@interface IcanAIRequest:BaseRequest
//如果要置空，就传null
@property(nonatomic, copy) NSString *message;
@end

/** 客服列表 /user/kfList */
@interface UserServiceListRequest:BaseRequest

@end
/**
 /message/remove
 用户删除消息
 传入messageId,表示删除用户会话中该messageId的消息
 传入userId 表示删除用户和该userId用户的全部会话
 传入groupId 表示删除该用户和该groupId群的全部会话
 都不传表示清除全部的消息
 */

@interface UserRemoveMessageRequest : BaseRequest
/** messageId */
@property(nonatomic, strong,nullable) NSArray *messageIds;
@property(nonatomic, copy,nullable) NSString *userId;
@property(nonatomic, copy,nullable) NSString *groupId;
/** 群部分GroupPart,人部分 UserPart,群全部GroupAll,人全部UserAll, 全部消息也就是点击了设置里面的清除所有消息All
 */
@property(nonatomic, copy) NSString *type;
/** 是否在其他人设备上删除 */
@property(nonatomic, assign) bool deleteAll;
/**
 是否是密聊消息
 */
@property(nonatomic, assign) bool isSecret;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@end

/** 获取云信token
 /user/{id}/cloudLetterToke
 */
@interface UserGetNIMTokenRequest:BaseRequest

@end
/**
 获取助手免打扰
 */
@interface GetPayHelperDisturbRequest : BaseRequest

@end

/**
 获取助手免打扰
 */
@interface SettingPayHelperDisturbRequest : BaseRequest
@property(nonatomic, assign) BOOL payHelper;
/** 系统免打扰 */
@property(nonatomic, assign) BOOL systemHelper;
/** 商城免打扰 */
@property(nonatomic, assign) BOOL mallHelper;
/** 钱包免打扰 */
@property(nonatomic, assign) BOOL C2CHelper;
@end

///user/quickFriend
@interface AutoAgreeFriendRequest:BaseRequest

@end

/** /mall/login  登录获取token商城*/
@interface GetMallLoginTokenRequest : BaseRequest

@end


/** /beInvited/{id}
 下线列表（分页）
 */
@interface BeInvitedListRequest : ListRequest

@end


/**
 下线人数
 /beInvited/{id}/count
 */
@interface GetBeInvitedCountRequest : BaseRequest


@end
/**
 拉黑用户
 /user/block/{userId}
 
 */
@interface BlockUserRequest:BaseRequest

@end
/** /blockUsers */
@interface BlockUsersListRequest:ListRequest
@end

/**
接口名称：文件是否存在
接口路径：POST/oss/exist
 */
@interface CheckFileHasExistRequest : BaseRequest
@property(nonatomic, copy) NSString *hashId;
@end
/**
 接口名称：上传文件回调
 接口路径：POST/oss/add
 */
@interface OssAddFileRequest : BaseRequest
@property(nonatomic, copy) NSString *hashId;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *size;
@end

/** 获取预授权应用信息
 /prepareAccessToken/{accessToken}
 */
@interface GetPrepareAccessTokenInfoRequest : BaseRequest

@end
/**
 授权
 /prepareAccessToken/{accessToken}
 */
@interface PUTPrepareAccessTokenRequest : BaseRequest

@end


//根据分组获取列表 /dialog/list

@interface GetDialogListRequest : BaseRequest
/** 可用值:Telecom,OtherUtility
 */
@property(nonatomic, copy) NSString *dialogClass;
@property(nonatomic, copy) NSString *countryCode;
@end
/**
 手机号码是否合法？
 /dialog/checkNumber
 */
@interface PostCreateDialogOrderRequest : BaseRequest
@property(nonatomic, copy) NSString *accountNumber;
@property(nonatomic, copy) NSString *refernceMobileNumber;
@property(nonatomic, copy) NSString *txType;
@property(nonatomic, copy) NSString *domain;
@property(nonatomic, assign) NSString *txAmount;
@property(nonatomic, assign) NSString *dialogId;
@end

/**
 充值
 /dialog/payment
 */
@interface  PostDialogPaymentRequest : BaseRequest
@property (nonatomic, copy,nullable) NSString * channelId;
@property (nonatomic, copy,nullable) NSString * payPassword;
@property(nonatomic, copy) NSString *paymentId;
@property(nonatomic, strong,nullable) NSNumber *saveCard;
@property(nonatomic, copy,nullable) NSString *quickPayId;
@end

/**
 /dialog/orders
 获取充值订单
 */
@interface GetDialogOrderListRequest : ListRequest

@end

@interface GetRechargeEnabledCountries : BaseRequest
@property(nonatomic, copy) NSString *scope;
@end

/**
 /exchange/byAmount
 */
@interface GetExchangeByAmountRequest : BaseRequest
/**
 货币代码

 */
@property(nonatomic, copy) NSString *fromCode;
@property(nonatomic, copy) NSString *amount;
@end
/** cloudLetterNERTCToken
 /user/{uid}/cloudLetterNERTCToken
 */
@interface GetCloudLetterNERTCTokenRequest:BaseRequest
@end
//获取交友服务token /iCanCircle/token
@interface GetCircleTokenRequest : BaseRequest
@property(nonatomic, assign) NSInteger type;
@end
/**
 收藏或取消收藏
 GET
 /dialog/favorites
 */
@interface PostDialogFavoritesRequest:BaseRequest
/** 账号   */
@property(nonatomic, copy,nullable) NSString *accountNumber;
@property(nonatomic, copy,nullable) NSString *dialogId;
@property(nonatomic, copy,nullable) NSString *nickname;
@property(nonatomic, copy,nullable) NSString *refernceMobileNumber;
@end
/**
 编辑收藏
 GET
 /dialog/favorites/id
 */
@interface PutDialogFavoritesRequest:BaseRequest
/** 账号   */
@property(nonatomic, copy,nullable) NSString *accountNumber;
@property(nonatomic, copy,nullable) NSString *dialogId;
@property(nonatomic, copy,nullable) NSString *nickname;
@property(nonatomic, copy,nullable) NSString *refernceMobileNumber;
@end
/**
 删除收藏
 GET
 /dialog/favorites/id
 */
@interface DeleteDialogFavoritesRequest:BaseRequest
@end
/**
 /dialog/favorites/{dialogId}/{account}
 */
@interface CheckDialogFavoritesRequest : BaseRequest

@end
/**
 GET
 /dialog/favorites
 */
@interface GetDialogFavoritesListRequest:BaseRequest

@end

/**
 根据payType获取快捷支付的银行卡列表
 /quickPayInfo/list
 */
@interface GetQuickPayInfoListRequest : BaseRequest
@property(nonatomic, copy) NSString *channelCode;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy) NSString *amount;
@end
/**
 清除快捷方式复制接口复制文档复制地址
 GET
 /quickPayInfo/{id}
 */
@interface ClearQuickPayInfoRequest : BaseRequest

@end
/** 设置阅后即焚
 /userFriend/destructionTime/{id}/{time}
 */
@interface UpdateFriendDestructionTimeRequest:BaseRequest

@end
/**
 /user/readReceipt
 设置已读回执
 */
@interface PutReadReceiptRequest:BaseRequest
@property(nonatomic, assign) BOOL readReceipt;
@end
/**
 全部的快捷消息
 GET
 /quickMessage/all
 */
@interface GetQuickMessageAllRequest : BaseRequest

@end
/**
 添加
 POST
 /quickMessage
 */
@interface PostQuickMessageRequest:BaseRequest
@property(nonatomic, copy,nullable) NSString *value;
@end
NS_ASSUME_NONNULL_END

/**
 修改
 PUT
 /quickMessage/{id}
 */
@interface PutQuickMessageRequest:BaseRequest
@property(nonatomic, copy,nullable) NSString *value;
@end

@interface PutUserMute:BaseRequest
@property(nonatomic, copy,nullable) NSString *userId;
@property(nonatomic, assign) bool status;
@end
/**
 删除
 DELETE
 /quickMessage/{id}
 */
@interface DeleteQuickMessageRequest:BaseRequest

@end


//会员中心
/**
 全部的会员
 /memberCentre/member/all
 */
@interface GetMemberCentreRequest : BaseRequest

@end
/**
 全部的出售中的账号
 GET
 /memberCentre/numberIdSell/all
 */
@interface GetMemberCentreAllNumberIdRequest : BaseRequest

@end
/**
 买会员复制接口复制文档复制地址
 POST
 /memberCentre/member/buy
 */
@interface BuyMemberCentreRequest : BaseRequest
@property(nonatomic, assign) NSInteger memberId;
@property(nonatomic, copy,nullable) NSString *payPassword;
@end

/**
 购买账号
 POST
 /memberCentre/numberIdSell/buy
 */
@interface BuyMemberCentreNumberIdRequest : BaseRequest
@property(nonatomic, assign) NSInteger numberId;
@property(nonatomic, copy,nullable) NSString * payPassword;
@property(nonatomic, strong,nullable) NSNumber * price;
@end
/**
 检查numberId是否可用
 POST
 /memberCentre/check/{numberId}
 */
@interface CheckMemberCentreNumberIdRequest : BaseRequest

@end

/**
 设置是否开启阻止其他人删除消息
 PUT
 /user/preventDeleteMessage/{whether}
 */
@interface SettingPreventDeleteMessageRequest : BaseRequest

@end
/**
 国家和地区 
 GET
 /public/countries
 */
@interface GetAllCountriesRequest:BaseRequest
@end

@interface GetCountriesAvailableDataRequest:BaseRequest
@property(nonatomic,copy,nullable) NSString *dialogClass;
@end
/**
 单个国家和地区
 GET
 /public/countries/{code}
 */
@interface GetOneCountriesRequest:BaseRequest

@end
/** 实名认证
 userAuth
 */
@interface UserAuthRequest : BaseRequest
/** 证件ID     */
@property(nonatomic, copy,nullable) NSString *cardId;
/** 名 */
@property(nonatomic, copy,nullable) NSString *firstName;
/** 性别,可用值:Unknown,Male,Female */
@property(nonatomic, copy,nullable) NSString *gender;
/**  证件照 */
@property(nonatomic, strong,nullable) NSArray *idImgs;
/** 证件类型,可用值:IDCard,DriverLicense,Passport     */
@property(nonatomic, copy,nullable) NSString *idType;
/** 姓 */
@property(nonatomic, copy,nullable) NSString *lastName;
/** 自拍照 */
@property(nonatomic, copy,nullable) NSString *selfieImg;
@property(nonatomic, copy,nullable) NSString *countriesCode;
@end
/**
 token
 GET
 /c2c/token
 */
@interface GetC2CTokenRequest : BaseRequest

@end
/**
 精准搜索用户 优先级 手机号 > 邮箱 > numberId
 GET
 /user/search
 */
@interface GetUserInfoRequestByAccuracyRequest : BaseRequest
@property(nonatomic, copy ,nullable) NSString *mail;
@property(nonatomic, copy ,nullable) NSString *mobile;
@property(nonatomic, copy ,nullable) NSString *numberId;
@property(nonatomic, copy ,nullable) NSString *area;
@end
/**
 上报用户的语言
 PUT
 /user/upload/language/{language}
 */
@interface UploadUserLanguageRequest:BaseRequest

@end

@interface ChatCallPushNotificationRequest:BaseRequest
@property(nonatomic, copy ,nullable) NSString *toUserId;
@property(nonatomic, copy ,nullable) NSString *callType;
@property(nonatomic, assign) BOOL isGroup;
@property(nonatomic, copy ,nullable) NSString *groupId;
@end
