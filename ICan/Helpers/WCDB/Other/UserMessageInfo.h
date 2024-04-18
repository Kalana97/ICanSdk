//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  UserMessage.h
- Description: 用户信息表 判断是否是好友根据isRoster字段保存
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import <Foundation/Foundation.h>

static NSString * _Nonnull const KWCUserMessageInfoTable= @"UserMessageInfo";
@interface UserMessageInfo : NSObject
/** 头像地址 */
@property(nonatomic,retain,nullable) NSString * userId;
/** 用户昵称 */
@property(nonatomic,retain,nullable) NSString * chatType;
@property(nonatomic,retain,nullable) NSString *  nickname;
/** 用户备注 */
@property(nullable, nonatomic, copy) NSString *remarkName;
/**性别; null 未知; 1 男 2 女    */
@property(nullable,nonatomic,copy)   NSString * gender;
/** 用户的手机号码 */
@property(nullable,nonatomic,copy)   NSString * mobile;
/** 用户的真实姓名 */
@property(nullable,nonatomic,copy)   NSString * realName;
/**邮箱*/
@property(nonatomic,copy,nullable) NSString * email;
/** 1实名  */
@property(nonatomic, copy,nullable) NSString *certification;

/**      */
@property(nonatomic,copy,nullable) NSString * numberId;
/**  */
@property(nonatomic,copy,nullable) NSString * username;

/** 第三方头像 */
@property(nonatomic,copy,nullable) NSString * headImgUrl;

/** 身份证号     */
@property(nonatomic,copy,nullable) NSString * cardId;
/**属性解释*/
@property(nonatomic,copy,nullable) NSString * token;
/**  是否是好友 */
@property(nonatomic, assign) BOOL isFriend;
/** 个性签名 */
@property(nonatomic, copy,nullable) NSString *signature;
/** 是否是客服 */
@property(nonatomic, assign) BOOL cs;
/** 是否看他的朋友圈 */
@property(nonatomic, assign) BOOL shieldTimeLine;
/** 你是否被别人拉黑 */
@property(nonatomic, assign) BOOL beBlock;
/** 你是否把其他人拉黑 */
@property(nonatomic, assign) BOOL block;
@property(nonatomic, assign) NSInteger vip;
/**  是否开启已读回执 */
@property(nonatomic, assign) BOOL readReceipt;
/** 认证状态,可用值:NotAuth,Authing,Authed */
@property(nonatomic, copy,nullable) NSString *userAuthStatus;
/** 姓  */
@property(nonatomic, copy,nullable) NSString *lastName;
/** 名  */
@property(nonatomic, copy,nullable) NSString *firstName;
/** 第三方APPID 可以用来判断是不是第三方用户 */
@property(nonatomic, copy,nullable) NSString *thirdPartySystemAppId;
//以下字段不会保存在数据库中 
@property(nonatomic, assign) BOOL isNew;
/** 是否可以点击   Is it possible to click*/
@property(nonatomic, assign) BOOL canEnabled;
/** 当前是否是选中状态 */
@property(nonatomic, assign) BOOL isSelect;

@property(nonatomic, copy,nullable) NSString *areaNum;

/** 高级会员过期时间*/
@property(nonatomic, copy,nullable) NSString *seniorMemberExpiration;
/** 钻石会员过期时间  */
@property(nonatomic, copy,nullable) NSString *diamondMemberExpiration;
@property(nonatomic, assign) BOOL preventDeleteMessage;
@property(nonatomic, strong, nullable) NSDecimalNumber *balance;
///国家code
@property(nonatomic, copy,nullable) NSString *countriesCode;
@end
