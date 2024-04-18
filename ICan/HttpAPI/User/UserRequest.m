//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/10
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  UserRequest.m
 - Description:
 - Function List:
 - History:
 */


#import "UserRequest.h"

@implementation UserRequest

@end

@implementation SearchUserRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"搜索用户";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/searchs"];
    
}
@end
@implementation SearchUserAndGroupRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"搜索用户";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/searchUserAndGroup"];
    
}
@end

@implementation LogoutRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"退出登录";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/merchantuser/logout"];
}
-(NSString *)ticket{
    return [UserInfoManager sharedManager].token;
}

@end

@implementation UserThirdPartyAuthorizationRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"用户授权登录";
}
-(NSString *)pathUrlString{
    return [NSString stringWithFormat:@"%@/user/authorization",self.baseUrlString];
    
}
@end
@implementation SendVerifyCodeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"发送验证码";
}
-(NSString *)pathUrlString{
    return [NSString stringWithFormat:@"%@/verify/sendCode",self.baseUrlString];
    
}
@end
@implementation DeviceVerifyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发送验证码";
}
-(NSString *)pathUrlString{
    
    return [self.baseUrlString stringByAppendingString:@"/user/verify/device"];
    
}
@end
@implementation LoginRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"登录";
}
-(NSString *)pathUrlString{
    
    return [self.baseUrlString stringByAppendingString:@"/user/login"];
    
}
-(bool)isPrivatAPi{
    return NO;
}

@end
@implementation RegisterRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"注册";
}
-(bool)isPrivatAPi{
    return NO;
}
-(NSString *)pathUrlString{
    
    return [self.baseUrlString stringByAppendingString:@"/user/register"];
}

@end

@implementation GetMessageOfflineRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取离线消息";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/message/offline"];
    
}
@end

@implementation GetSellerOldMessagesList
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取离线消息";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/otherchat/messagesByUserId"];
}
@end

@implementation GetSellerMessageLast
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取离线消息";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/otherchat/chatList"];
}
@end

@implementation UserDeleteFriendRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"删除好友";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/friend/delete"];
}

@end




@implementation SendSMSCodeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"发送短信验证码";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/verify/sendSMSCode"];
}

@end

@implementation SendEmailCodeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"发送邮箱验证码";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/verify/sendEmailCode"];
}


@end
@implementation ForgetLoginPasswordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"忘记登录密码";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/forgetPassword"];
}


@end
@implementation EditUserMessageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改用户信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/edit"];
}


@end
@implementation ChangeLoginPasswordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改登录密码";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/loginPassword"];
}


@end

@implementation GetAliyunOSSSecurityTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取阿里OSS token";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/oss/securityToken"];
}


@end
@implementation GetUserMessageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取用户信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/userInfo"];
}


@end
@implementation GetUserListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"批量获取用户信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/list"];
}


@end
@implementation GetUserListByNumberIdRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"通过numberId批量搜索用户";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/userInfoByNumberId"];
}


@end

@implementation RealNameAuthenticationRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"实名认证";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/realNameAuthentication"];
}


@end
///user/report/login
@implementation ReportUserLoginRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"报告用户登录";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/report/login"];
}

@end
@implementation UploadImageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"报告用户登录";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/report/login"];
}

@end
@implementation ReportUserLogoutRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"报告用户登出";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/report/logout"];
}

@end
@implementation SettingUserpPayPasswordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置支付密码";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/payPassword"];
}

@end
@implementation FindUserpPayPasswordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"找回支付密码";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/forgetPayPassword"];
}

@end
@implementation BindingUserDeviceTokenRequesr

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"绑定推送token";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/bindToken"];
}

@end

@implementation SetApplicationIconBadgeNumberRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置APP未读消息数量";
}

@end

@implementation VerifyPaymentPasswordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"校验支付密码";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/verifyPaymentPassword"];
}

@end

@implementation BindingUserMobileRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定手机号码";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/bindMobile"];
}
@end

@implementation BindingUserEmailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定邮箱";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/bindEmail"];
}


@end
@implementation BindThirdPartyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定第三方";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/bindThirdParty"];
}


@end
@implementation GetRongYunTokenRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取融云token";
}




@end
@implementation CheckUserOnlineRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"检查用户是否在线";
}
@end
@implementation UserDestroyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"注销用户";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/destroy"];
}
@end
@implementation UserWebLoginAgreeRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"同意桌面端登陆";
}
@end
@implementation GroupLoginRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"同意群主登陆";
}
@end
@implementation UserNearbyVisibleRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置附近的人是否可见";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/nearbyVisible"];
}

@end

@implementation UploadUserLocationRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"上报用户位置";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/userLocation/upload"];
}


@end


@implementation GetUserNearbyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"附近的人可以分性别获取";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/userLocation/nearby/v1"];
}



@end

@implementation SetUserBeFoundRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置用户是否被推荐";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/beFound"];
}


@end

@implementation GertUserRecommendRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"推荐用户";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/recommend"];
}


@end

@implementation ModifyUserSignatureRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改个性签名";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/signature"];
}


@end
@implementation IcanAIRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"删除消息";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/openAi/sendCommand"];
}


@end
@implementation UserServiceListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"客服列表";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/customerServices"];
}


@end

@implementation UserRemoveMessageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"删除消息";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/message/remove/v1"];
}


@end

@implementation UserGetNIMTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取云信token";
}



@end
@implementation GetPayHelperDisturbRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取助手免打扰";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/helperDisturb"];
}

@end

@implementation SettingPayHelperDisturbRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置助手免打扰";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/helperDisturb"];
}

@end
@implementation AutoAgreeFriendRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改是否自动同意好友请求";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/quickFriend"];
}


@end
@implementation GetMallLoginTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取商城token";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/mall/login"];
}

@end
@implementation BeInvitedListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"下线列表（分页）";
}

@end

@implementation GetBeInvitedCountRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"下线人数";
}

@end
@implementation BlockUserRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"拉黑用户";
}

@end

@implementation BlockUsersListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"拉黑列表";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/blockUsers"];
}

@end
@implementation CheckFileHasExistRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"文件是否存在";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/oss/exist"];
}

@end
@implementation OssAddFileRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"上传文件回调";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/oss/add"];
}

@end

@implementation GetPrepareAccessTokenInfoRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取预授权应用信息";
}

@end
@implementation PUTPrepareAccessTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"授权";
}

@end
@implementation GetCloudLetterNERTCTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取接受方的token";
}
-(BOOL)isHttpResponse{
    return YES;
}
@end

@implementation GetDialogListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据分组获取列表 /dialog/list";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/dialog/list"];
}

@end
@implementation PostCreateDialogOrderRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"手机号码是否合法？";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/dialog/create/order"];
}
@end


@implementation PostDialogPaymentRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"充值";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payments/payment"];
}

@end
@implementation GetDialogOrderListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"充值历史订单";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/dialog/orders"];
}


@end
@implementation GetExchangeByAmountRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据金额获取转换后的金额";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/exchange/byAmount"];
}
@end
@implementation GetCircleTokenRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取交友服务token";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/iCanCircle/token"];
}
@end

/**
 收藏或取消收藏
 GET
 /dialog/favorites/{id}
 */
@implementation PostDialogFavoritesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"收藏";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/dialog/favorites"];
}
@end
@implementation PutDialogFavoritesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"编辑收藏";
}
@end
@implementation DeleteDialogFavoritesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除收藏";
}
@end
@implementation CheckDialogFavoritesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"检查是否收藏";
}
@end

@implementation GetRechargeEnabledCountries
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收藏列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/recharge/enabledCountries"];
}
@end

/**
 GET
 /dialog/favorites
 */
@implementation GetDialogFavoritesListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收藏列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/dialog/favorites"];
}
@end
/**
 根据payType获取快捷支付的银行卡列表
 /quickPayInfo/list
 */
@implementation GetQuickPayInfoListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据payType获取快捷支付的银行卡列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/quickPayInfo/list"];
}
@end
/**
 清除快捷方式复制接口复制文档复制地址
 GET
 /quickPayInfo/{id}
 */
@implementation ClearQuickPayInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"清除快捷方式";
}
@end

@implementation UpdateFriendDestructionTimeRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置阅后即焚";
}
@end
@implementation PutReadReceiptRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"设置已读回执";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/readReceipt"];
}
@end

@implementation GetQuickMessageAllRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的快捷消息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/quickMessage/all"];
}
@end
@implementation PostQuickMessageRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/quickMessage"];
}
@end

@implementation PutQuickMessageRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改";
}
@end

@implementation PutUserMute
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"全部的会员";
}
@end

@implementation DeleteQuickMessageRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除";
}
@end


@implementation GetMemberCentreRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/memberCentre/member/all"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的会员";
}
@end
@implementation GetMemberCentreAllNumberIdRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/memberCentre/numberIdSell/all"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的出售中的账号";
}
@end
@implementation BuyMemberCentreRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/memberCentre/member/buy"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"买会员";
}
@end

@implementation BuyMemberCentreNumberIdRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/memberCentre/numberIdSell/buy"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 购买账号";
}
@end
@implementation CheckMemberCentreNumberIdRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 检查numberId是否可用";
}
@end
@implementation SettingPreventDeleteMessageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @" 设置是否开启阻止其他人删除消息";
}
@end


@implementation GetAllCountriesRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/public/countries"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @" 国家和地区";
}
@end

@implementation GetCountriesAvailableDataRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/public/countries/dialogEnabled"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @" 国家和地区";
}
@end

@implementation GetOneCountriesRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"单个国家和地区";
}
@end
@implementation UserAuthRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/userAuth"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 实名认证";
}
@end
@implementation GetC2CTokenRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/token"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"C2CToken";
}
@end

/**
 精准搜索用户 优先级 手机号 > 邮箱 > numberId
 GET
 /user/search
 */
@implementation GetUserInfoRequestByAccuracyRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/search"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"精准搜索用户 优先级 手机号 > 邮箱 > numberId";
}
@end
/**
 上报用户的语言
 PUT
 /user/upload/language/{language}
 */
@implementation UploadUserLanguageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"上报用户的语言";
}
@end

@implementation ChatCallPushNotificationRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}

-(NSString *)requestName{
    return @"Incoming call push notification";
}

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/directPush/call"];
}

@end

@implementation VerifySelfEmail
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}

-(NSString *)requestName{
    return @"Verify Self Email";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/user/verifySelfEmail"];
}

@end
