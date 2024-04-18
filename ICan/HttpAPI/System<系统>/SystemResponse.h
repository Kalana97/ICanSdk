//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/4/2020
- File name:  SystemResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemResponse : BaseResponse

@end
@interface PrivateParameterInfo : BaseResponse
/** 是否开启支付 */
@property(nonatomic, assign) BOOL openPay;
/** 是否开启云支付 */
@property(nonatomic, assign) BOOL openCloudPay;
/** 是否开启附近的人 */
@property(nonatomic, assign) BOOL openNearbyPeople;
/** 是否开启推荐的人 */
@property(nonatomic, assign) BOOL openRecommend;
/** 是否开启充值 */
@property(nonatomic, assign) BOOL openRecharge;
/** 是否开启转账 */
@property(nonatomic, assign) BOOL openTransfer;
/** 是否开启提现 */
@property(nonatomic, assign) BOOL openWithdraw;
/** 是否开启融云视频 */
@property(nonatomic, assign) BOOL cloudLetterVideo;
/** 是否开启融云语音 */
@property(nonatomic, assign) BOOL cloudLetterVoice;
/** 是否开启私聊 */
@property(nonatomic, assign) BOOL openSecretMessage;
/** 是否开启商城 */
@property(nonatomic, assign) BOOL openShop;
/** 是否开启兑换 */
@property(nonatomic, assign) BOOL openExchange;
@property(nonatomic, copy) NSString *mallH5Url;
@end

/** 版本控制返回 */
@interface VersionsInfo : NSObject
/** 版本号
 */
@property(nonatomic, copy) NSString *version;
/** 更新内容    
 */
@property(nonatomic, copy) NSString *content;
/** 是否强制更新
 */
@property(nonatomic, assign) BOOL forced;
@end

/** 公告列表 */
@interface AnnouncementsInfo : IDInfo
/** 标题
 */
@property(nonatomic, copy) NSString *title;
/** 类型
 */
@property(nonatomic, copy) NSString *announcementType;
/**  创建时间
 */
@property(nonatomic, copy) NSString *createTime;
/** 开始时间
 */
@property(nonatomic, copy) NSString *beginTime;
/** 开始时间
 */
@property(nonatomic, copy) NSString *endTime;
/** 内容
 */
@property(nonatomic, copy) NSString *context;
/** 是否启用
 */
@property(nonatomic, copy) NSString *display;
@end


@interface GetPublicStartInfo : BaseResponse<NSCoding>
/**URLURL,
 商品idProductId,
分类id
CategoryId,
分组id
 ProdTagId
 */
@property(nonatomic, copy) NSString *jumpType;
/** 备注 */
@property(nonatomic, copy) NSString *memo;
@property(nonatomic, copy) NSString *title;
/** URL或跳转商品的ID */
@property(nonatomic, copy) NSString *linkUrl;
/** 图片地址 */
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, assign) NSInteger startTime;
@property(nonatomic, assign) NSInteger endTime;
/**  几秒后关闭 */
@property(nonatomic, assign) NSInteger closeTime;
@end
NS_ASSUME_NONNULL_END
