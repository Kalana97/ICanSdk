//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CUserManager.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
@class C2CExchangeRateInfo;
@class C2CUserInfo;
@class CurrencyInfo;
@class CurrencyExchangeInfo;
@class C2CBalanceListInfo;
@class C2CCollectCurrencyInfo;
@class NetworkErrorInfo;
@class C2CTokenInfo;

@interface C2CUserManager : NSObject
/// 当前用户选择的法币
@property(nonatomic, strong) CurrencyInfo *currentCurrencyInfo;
@property(nonatomic, copy) NSString * headImgUrl;
@property(nonatomic, copy) NSString* userId;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, strong) C2CUserInfo *userInfo;
/** 支持的全部法币 */
@property(nonatomic, strong) NSArray<CurrencyInfo*> *allSupportedLegalTenderCurrencyItems;
/** 支持的全部货币 */
@property(nonatomic, strong) NSArray<CurrencyInfo*> *allSupportedCurrencyItems;
/** 全部的汇率 */
@property(nonatomic, strong) NSArray<C2CExchangeRateInfo*> *allExchangenRateItems;
/** 牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *currencyExchangeItems;
/** 资产列表 */
@property(nonatomic, strong) NSArray<C2CBalanceListInfo*> *c2cBalanceListItems;
/** 收藏的货币 */
@property(nonatomic, strong) NSArray<C2CCollectCurrencyInfo*> *collectCurrencyItems;
@property(nonatomic, strong) NSNumber *sellerAppealTime;
@property(nonatomic, strong) NSNumber *buyerAppealTime;
@property(nonatomic, copy) NSString *countriesCode;
/** c2cosstoken的过期时间 */
@property(nonatomic, copy) NSString *expiration;
-(void)getC2CCurrentUser:(void(^)(C2CUserInfo*info))successBlock;
-(CurrencyInfo*)getCurrecyInfoWithCode:(NSString*)code;

/// 获取钱包资产
/// @param successBlock successBlock description
/// @param failureBlock failureBlock description
-(void)getC2CBalanceRequest:(void(^)(NSArray* response))successBlock failure:(void(^)(NetworkErrorInfo*info))failureBlock;
/**
 获取ossToken
 */
-(void)getC2COssTokenRequest:(void(^)(void))successBlock;

-(void)getC2CAllMessage;

/// 获取是否收藏
/// @param code code description
-(BOOL)getIsCollectCurrencyWithCode:(NSString*)code;
/** 全部的汇率列表 */
-(void)getC2CAllExchangeListRequest:(void(^)(NSArray* response))successBlock failure:(void(^)(NetworkErrorInfo*info))failureBlock;

/// 拿c2cToken
-(void)getC2cToken:(void(^)(C2CTokenInfo* response))successBlock failure:(void(^)(NetworkErrorInfo*info,NSInteger statusCode))failureBlock;
+ (instancetype)shared;
@end

