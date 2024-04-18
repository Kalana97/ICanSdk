//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 9/10/2019
- File name:  HomeRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeRequest : BaseRequest

@end


/** 首页的新闻头条的分类 */
@interface NewsHeadlineClassifyRequest : BaseRequest

@end
//获取首页新闻头条某个分类下面的数据
@interface NewsHeadlineClassifyListRequest:BaseRequest
@property(nonatomic, copy) NSString *type;
@end
//货币汇率-外汇汇率
@interface ForeignRateRequest : BaseRequest
@property(nonatomic, copy) NSString *type;
@end
//货币汇率-人民币汇率
@interface RmbquotRateRequest : BaseRequest
//0:工商银行,1:招商银行,2:建设银行,3:中国银行,4:交通银行,5:农业银行,默认为:中国银行
@property(nonatomic, copy) NSString *bank;
@property(nonatomic, copy) NSString *type;
@end
//货币汇率-银行代码列表
@interface ExchangeBankRequest : BaseRequest

@end

@interface HomeTelqueryRequest : BaseRequest
//手机号码
@property(nonatomic, copy) NSString *phoneno;


@end

@interface GetMobileCardNumRequest : BaseRequest

@end


/// 充值话费
@interface MobileOnlineOrderRequest : BaseRequest
//手机号码
@property(nonatomic, copy) NSString *phoneno;
//充值金额,目前可选：1、2、5、10、20、30、50、100、200、300、500
@property(nonatomic, copy) NSString *cardnum;
//支付密码
@property(nonatomic, copy) NSString *paymentPassword;
/** 金额（折扣后的金额） */
@property(nonatomic, copy) NSString *amount;
@end

@interface GetMobileOrderStateRequest : BaseRequest
//手机号码
@property(nonatomic, copy) NSString *orderid;

@end

@interface GetGiftCardProductsRequest : BaseRequest

@end


@interface BuyGiftCardRequest : BaseRequest
//商品id
@property(nonatomic, copy) NSString *productId;
//数量
@property(nonatomic, strong) NSNumber *num;
//总金额
@property(nonatomic, copy) NSNumber *amount;
//支付密码
@property(nonatomic, copy) NSString *paymentPassword;


@end

@interface GetGiftCardRecordRequest : BaseRequest
//购买记录类型，不传则查询全部
@property(nonatomic,copy,nullable)NSString *code;

@end
@interface MobileRechargesListRequest : ListRequest
@property(nonatomic,copy,nullable) NSString *status;
@property(nonatomic,copy,nullable) NSString *startTime;
@property(nonatomic,copy,nullable) NSString *endTime;

@end
NS_ASSUME_NONNULL_END
