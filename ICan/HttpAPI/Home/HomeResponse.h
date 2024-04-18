//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 9/10/2019
- File name:  HomeResponse.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeResponse : NSObject

@end
@interface NewsHeadlineClassifyListInfo : BaseResponse

@property(nonatomic, copy) NSString *uniquekey;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *category;
@property(nonatomic, copy) NSString *author_name;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *thumbnail_pic_s;
@property(nonatomic, copy) NSString *thumbnail_pic_s02;
@property(nonatomic, copy) NSString *thumbnail_pic_s03;
@end

@interface NewsHeadlineClassifyInfo : BaseResponse
@property(nonatomic,copy)NSString *name;
@property(nonatomic, copy) NSString *code;
@end
//货币汇率-人民币牌价
//name    string
//必须
//货币名称
//fBuyPri    string
//必须
//现汇买入价
//mBuyPri    string
//必须
//现钞买入价
//fSellPri    string
//必须
//现汇卖出价
//mSellPri    string
//必须
//现钞卖出价
//bankConversionPri    string
//必须
//银行折算价/中间价
//date    string
//必须
//发布日期
//time    string
//必须
//发布时间
@interface RmbquotInfo : NSObject
/** 货币名称 */
@property(nonatomic, copy) NSString *name;
/** 现汇买入价 */
@property(nonatomic, copy) NSString *fBuyPri;
/** 现钞买入价*/
@property(nonatomic, copy) NSString *mBuyPri;
/** 现汇卖出价 */
@property(nonatomic, copy) NSString *fSellPri;
/** 现钞卖出价 */
@property(nonatomic, copy) NSString *mSellPri;
/** 银行折算价/中间价 */
@property(nonatomic, copy) NSString *bankConversionPri;
/** 发布日期 */
@property(nonatomic, copy) NSString *date;
/** 发布时间 */
@property(nonatomic, copy) NSString *time;
@end
//货币汇率-外汇汇率
@interface ForeignRateInfo : NSObject
/** 货币代码     */
@property(nonatomic, copy) NSString *code;
/** 货币名称     */
@property(nonatomic, copy) NSString *currency;
/** 最新价     */
@property(nonatomic, copy) NSString *closePri;
/** 涨跌%     */
@property(nonatomic, copy) NSString *diffPer;
/** 涨跌金额     */
@property(nonatomic, copy) NSString *diffAmo ;
/** 开盘价     */
@property(nonatomic, copy) NSString *openPri;
/** 最高价     */
@property(nonatomic, copy) NSString *highPic;
/** 最低价     */
@property(nonatomic, copy) NSString *lowPic;
/** 震幅%     */
@property(nonatomic, copy) NSString *range;
/** 买入价     */
@property(nonatomic, copy) NSString *buyPic;
/** 卖出价     */
@property(nonatomic, copy) NSString *sellPic;
/** 昨收价     */
@property(nonatomic, copy) NSString *yesPic;
/** 日期 */
@property(nonatomic, copy) NSString *date;
/** 数据时间         */
@property(nonatomic, copy) NSString *datatime;
/** 货币代码（from）   */
@property(nonatomic, copy) NSString *fromCode;
/** 货币名称(from)     */
@property(nonatomic, copy) NSString *fromCurrency;
/** 货币代码（to）     */
@property(nonatomic, copy) NSString *toCode;
/** 货币名称(to)     */
@property(nonatomic, copy) NSString *toCurrency;
@property(nonatomic, assign) BOOL  isSelect;
@end
//货币汇率-银行代码列表
@interface ExchangeRateBankcardInfo : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *code;
@end


/// 根据手机号码 获取面额
@interface HomeTelqueryInfo : NSObject
//卡类ID
@property(nonatomic, copy) NSString *cardid;
//卡类名称
@property(nonatomic, copy) NSString *cardname;
//购买价格
@property(nonatomic, copy) NSString *inprice;
//手机号码归属地
@property(nonatomic, copy) NSString *game_area;
//卡面额
@property(nonatomic, copy) NSString *price;


@end

@interface MobileOnlineOrderInfo : NSObject
//充值的卡类ID
@property(nonatomic, copy) NSString *cardid;
//数量
@property(nonatomic, copy) NSString *cardnum;
//进货价格
@property(nonatomic, copy) NSString *ordercash;
//充值名称
@property(nonatomic, copy) NSString *cardname;
//聚合订单号
@property(nonatomic, copy) NSString *sporder_id;
//商户自定的订单号
@property(nonatomic, copy) NSString *uorderid;
//充值的手机号码
@property(nonatomic, copy) NSString *game_userid;
//充值状态:0充值中 1成功 9撤销，刚提交都返回0
@property(nonatomic, copy) NSString *game_state;


@end

@interface MobileOrderStateInfo : NSObject
//订单扣除金额
@property(nonatomic, copy) NSString *uordercash;
//聚合订单号
@property(nonatomic, copy) NSString *sporder_id;
//状态 1:成功 9:失败 0：充值中
@property(nonatomic, copy) NSString *game_state;

@end

@interface GiftCardProductsInfo : NSObject
//代码
@property(nonatomic, copy) NSString *code;
//关键字
@property(nonatomic, copy) NSString *keyword;
//名称
@property(nonatomic, copy) NSString *name;
//无颜色图标url
@property(nonatomic, copy) NSString *imgUrl;
//有颜色的图标
@property(nonatomic, copy) NSString *imgUrl2;
//产品列表

@property(nonatomic, strong) NSArray *list;

@end

@interface GiftCardProductsListInfo : NSObject
//产品id
@property(nonatomic, copy) NSString *productId;
//名称
@property(nonatomic, copy) NSString *name;
//价格
@property(nonatomic, copy) NSString *value;
//折扣
@property(nonatomic, copy) NSString *discount;

@end
@interface BuyGiftCardDetailInfo : NSObject
//卡号
@property(nonatomic, copy) NSString *cardNo;
//密码
@property(nonatomic, copy) NSString *cardPws;
//有效日期
@property(nonatomic, copy) NSString *expireDate;

@end
@interface BuyGiftCardInfo : NSObject
//聚合订单号
@property(nonatomic, copy) NSString *juheOrderId;
//用户订单id
@property(nonatomic, copy) NSString *userOrderId;
//数量
@property(nonatomic, copy) NSString *num;
//最终扣费总额
@property(nonatomic, copy) NSString *deduction;
//
@property(nonatomic, strong) NSArray<BuyGiftCardDetailInfo*> *cards;
@property(nonatomic, copy) NSString*name;

@end




@interface GiftCardRecordInfo : NSObject
//订单号
@property(nonatomic, copy) NSString *orderId;
//聚合订单号
@property(nonatomic, copy) NSString *juheOrderId;
//金额
@property(nonatomic, copy) NSString *amount;
//原因
@property(nonatomic, copy) NSString *reason;
//代码
@property(nonatomic, copy) NSString *code;
//名称
@property(nonatomic, copy) NSString *name;
//单价
@property(nonatomic, copy) NSString *value;
//折扣价
@property(nonatomic, copy) NSString *discount;
//图标
@property(nonatomic, copy) NSString *imgUrl;
//创建时间
@property(nonatomic, copy) NSString *createTime;

@property(nonatomic, strong) NSArray *cards;
/** Success("成功"),   Cancel("取消")   Processed("处理完成"),  Refund("申请退款"), Refunding("退款中"), Refunded("已退款"), RefundFail("退款失败"), Create("创建"), Paid("已支付"), */
@property(nonatomic, copy) NSString *orderStatus;

@end



@interface MobileRechargesListInfo : IDInfo

//订单号
@property(nonatomic, copy) NSString *orderId;
//聚合订单号
@property(nonatomic, copy) NSString *sporderId;
//手机号
@property(nonatomic, copy) NSString *mobile;
//金额
@property(nonatomic, copy) NSString *amount;
//备注
@property(nonatomic, copy) NSString *reason;
//完成时间
@property(nonatomic, copy) NSString *finishTime;
//创建时间
@property(nonatomic, copy) NSString *createTime;
//状态 详细见备注
@property(nonatomic, copy) NSString *orderStatus;


@end


@interface MobileRechargesRecordInfo : ListInfo
//@property(nonatomic, copy) NSString *empty;
//@property(nonatomic, copy) NSString *first;
//@property(nonatomic, copy) NSString *last;
//@property(nonatomic, copy) NSString *number;
//@property(nonatomic, copy) NSString *numberOfElements;
//@property(nonatomic, copy) NSString *pageable;
//@property(nonatomic, copy) NSString *size;
//@property(nonatomic, copy) NSString *sort;
//@property(nonatomic, copy) NSString *totalElements;
//@property(nonatomic, copy) NSString *totalPages;
//@property(nonatomic, strong) NSArray *content;
@end
NS_ASSUME_NONNULL_END
