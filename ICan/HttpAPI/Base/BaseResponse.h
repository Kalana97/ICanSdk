/**
- Copyright © 2019 LIMAOHUYU. All rights reserved.
- AUthor: Created  by DZL on 2019/9/5
- System_Version_MACOS: 10.14
- ChatIM
- File name:  BaseResponse.h
- Description: 网络请求返回的base类
- Function List: 
- History:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseResponse : NSObject

@end

@interface IDInfo : NSObject
@property (nonatomic,copy,nullable) NSString * ID;
@end

/**
 用户授权返回
 */
@interface ThirdPartyAuthorizationInfo : IDInfo

@end


/**
 注册返回
 */
@interface RegisterInfo : IDInfo
/** token */
@property (nonatomic,copy,nullable) NSString * token;
@end


/**
 登录成功返回
 */
@interface LoginInfo : IDInfo

/** 1实名  */
@property(nonatomic, copy,nullable) NSString *certification;
/** 性别 0 位置 1 男 2女     */
@property (nonatomic,copy,nullable) NSString * gender;
/**      */
@property (nonatomic,copy,nullable) NSString * numberId;
/** 手机号码 */
@property (nonatomic,copy,nullable) NSString * mobile;

@property (nonatomic,copy,nullable) NSString * maskedMobile;
/** 昵称     */
@property (nonatomic,copy,nullable) NSString * nickname;
/**  */
@property (nonatomic,copy,nullable) NSString * username;
/**  邮箱    */
@property (nonatomic,copy,nullable) NSString * email;

@property (nonatomic,copy,nullable) NSString * maskedEmail;
/** 第三方头像 */
@property (nonatomic,copy,nullable) NSString * headImgUrl;
/** 身份证号     */
@property (nonatomic,copy,nullable) NSString * cardId;
/**属性解释*/
@property (nonatomic,copy,nullable) NSString * token;
@property(nonatomic, assign) BOOL isSetPayPwd;
/** 微信授权登录      WeChat 支付宝授权登录      AliPay  游客登录      Visitor */
@property(nonatomic, copy) NSString *openIdType;
/** 是否设置了登陆密码     */
@property(nonatomic, assign) BOOL isSetPassword;
@property (nonatomic,copy,nullable) NSString * openId;

/** 是否推荐给其他用户(被其他用户发现) */
@property(nonatomic, assign) BOOL beFound;
/** 是否被附近的人可见 */
@property(nonatomic,assign)BOOL nearbyVisible;
/** 是否自动同意好友请求 */
@property(nonatomic, assign) BOOL requireFriendRequest;
/** 个性签名     */
@property(nonatomic, copy) NSString *signature;

@property(nonatomic, assign) NSInteger vip;
/**
 是否是新用户
 */
@property(nonatomic, assign) BOOL isNew;
/** 区号 */
@property(nonatomic, copy) NSString* areaNum;

/** 高级会员过期时间*/
@property(nonatomic, copy,nullable) NSString *seniorMemberExpiration;
/** 钻石会员过期时间  */
@property(nonatomic, copy,nullable) NSString *diamondMemberExpiration;
/** 阻止对方删除消息 */
@property(nonatomic, assign) BOOL preventDeleteMessage;

@property(nonatomic, assign) BOOL isNewDeviceLogin;

/// 国家code
@property(nonatomic, copy) NSString *countriesCode;
@end

@interface ErrorExtra:NSObject
@property(nonatomic, assign) BOOL isBlocked;
@property (nonatomic, assign) NSInteger errorCount;
@property (nonatomic, assign) NSInteger remainingCount;
@property (nonatomic, assign) NSInteger blockedTimeMillis;
@end

@interface NetworkErrorInfo:NSObject
@property (nonatomic,copy,nullable) NSString * code;
@property (nonatomic,copy,nullable) NSString * desc;
@property(nonatomic, strong) ErrorExtra *extra;
@end

@interface PageableInfo : BaseResponse
@property(nonatomic, copy) NSString *offset;
@property(nonatomic, copy) NSString *pageNumber;
@property(nonatomic, copy) NSString *pageSize;
@property(nonatomic, copy) NSString *paged;
@property(nonatomic, copy) NSString *sort;
@property(nonatomic, copy) NSString *unpaged;

@end

@interface SortInfo : BaseResponse
@property(nonatomic, copy) NSString *empty;
@property(nonatomic, copy) NSString *sorted;
@property(nonatomic, copy) NSString *unsorted;

@end
@interface ListInfo : BaseResponse

@property(nonatomic,strong) NSArray *content;
@property(nonatomic, copy) NSString *empty;
/** 是否是第一页 */
@property(nonatomic, assign) BOOL first;
/** 是否是最后一页 */
@property(nonatomic, assign) BOOL last;
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *numberOfElements;
@property(nonatomic, copy) NSString *pageable;
//每页条数
@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *sort;
//总条数
@property(nonatomic, copy) NSString *totalElements;
//总页数
@property(nonatomic, copy) NSString *totalPages;

@end
NS_ASSUME_NONNULL_END
