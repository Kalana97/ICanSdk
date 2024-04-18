//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CUserManager.m
- Description:
- Function List:
*/
        

#import "C2CUserManager.h"
#import "C2COssWrapper.h"
@implementation C2CUserManager
+ (instancetype)shared{
    static C2CUserManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[C2CUserManager alloc] init];
    });
    return api;
}
-(void)setCurrentCurrencyInfo:(CurrencyInfo *)currentCurrencyInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentCurrencyInfo];
    [self setUserDefaultsWithObject:data key:@"currentCurrencyInfo"];
}
-(CurrencyInfo *)currentCurrencyInfo{
    @try {
        NSData *data = [self gainObjectWithKey:@"currentCurrencyInfo"];
        CurrencyInfo *student = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return student;
    } @catch (NSException *exception) {
        [self removeObjectWithKey:@"currentCurrencyInfo"];
    } @finally {
        
    }
    
}

-(CurrencyInfo*)getCurrecyInfoWithCode:(NSString*)code{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"code == [cd] %@ ",code];
    CurrencyInfo * info =  [self.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate].firstObject;
    return info;
}
-(BOOL)getIsCollectCurrencyWithCode:(NSString*)code{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"code == [cd] %@ ",code];
    C2CCollectCurrencyInfo * info =  [self.collectCurrencyItems filteredArrayUsingPredicate:predicate].firstObject;
    return info?YES:NO;
}
-(void)setUserId:(NSString *)userId{
    [self setUserDefaultsWithObject:userId key:@"c2cuserId"];
}
-(NSString *)userId{
    return [self gainObjectWithKey:@"c2cuserId"];
}
-(void)setHeadImgUrl:(NSString *)headImgUrl{
    [self setUserDefaultsWithObject:headImgUrl key:@"c2cheadImgUrl"];
}
-(NSString *)headImgUrl{
     return [self gainObjectWithKey:@"c2cheadImgUrl"];;
}
-(void)setToken:(NSString *)token{
    [self setUserDefaultsWithObject:token key:@"C2CToken"];
}
-(NSString *)token{
    return [self gainObjectWithKey:@"C2CToken"];
}
-(void)setBuyerAppealTime:(NSNumber *)buyerAppealTime{
    [self setUserDefaultsWithObject:buyerAppealTime key:@"buyerAppealTime"];
}
-(NSNumber *)buyerAppealTime{
    return [self gainObjectWithKey:@"buyerAppealTime"];
}
-(NSNumber *)sellerAppealTime{
    return [self gainObjectWithKey:@"sellerAppealTime"];
}
-(void)setSellerAppealTime:(NSNumber *)sellerAppealTime{
    [self setUserDefaultsWithObject:sellerAppealTime key:@"sellerAppealTime"];
}
-(void)setCountriesCode:(NSString *)countriesCode{
    [self setUserDefaultsWithObject:countriesCode key:@"countriesCode"];
}
-(NSString *)countriesCode{
    return [self gainObjectWithKey:@"countriesCode"];
}
-(void)setExpiration:(NSString *)expiration{
    [self setUserDefaultsWithObject:expiration key:@"c2cexpiration"];
}
-(NSString *)expiration{
    return [self gainObjectWithKey:@"c2cexpiration"];
}
-(void)getC2CCurrentUser:(void(^)(C2CUserInfo*info))successBlock{
    C2CGetCurrentUserInfoRequest * request = [C2CGetCurrentUserInfoRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        if (successBlock) {
            successBlock(response);
        }
        self.userId = response.userId;
        self.headImgUrl = response.headImgUrl;
        self.userInfo = response;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getC2CBalanceRequest:(void(^)(NSArray* response))successBlock failure:(void(^)(NetworkErrorInfo*info))failureBlock{
    GetC2CBalanceListRequest * request = [GetC2CBalanceListRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CBalanceListInfo class] success:^(NSArray* response) {
        self.c2cBalanceListItems = response;
        !successBlock?:successBlock(response);
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        !failureBlock?:failureBlock(info);
    }];
}
-(void)getC2COssTokenRequest:(void(^)(void))successBlock{
    GetC2COssTokenRequest*request = [GetC2COssTokenRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[OSSSecurityTokenInfo class] contentClass:[OSSSecurityTokenInfo class] success:^(OSSSecurityTokenInfo* response) {
        [C2COssWrapper shared].bucket=response.bucket;
        [C2COssWrapper shared].urlBegin=response.urlBegin;
        OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
        cfg.maxRetryCount = 10;
        cfg.timeoutIntervalForRequest = 15;
        cfg.isHttpdnsEnable = NO;
        cfg.crc64Verifiable = YES;
        OSSFederationToken*token = [OSSFederationToken new];
        token.tAccessKey = response.credentials.accessKeyId;
        token.tSecretKey = response.credentials.accessKeySecret;
        token.tToken = response.credentials.securityToken;
        token.expirationTimeInGMTFormat = response.credentials.expiration;
        self.expiration = response.credentials.expiration;
        OSSStsTokenCredentialProvider *provider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:token.tAccessKey secretKeyId:token.tSecretKey securityToken:token.tToken];
        OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:response.ossEndpoint credentialProvider:provider clientConfiguration:cfg];
        [C2COssWrapper shared].defaultClient = defaultClient;
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getC2CAllMessage{
    [self getC2cToken:nil failure:nil];
}
/// 拿c2cToken
-(void)getC2cToken:(void(^)(C2CTokenInfo* response))successBlock failure:(void(^)(NetworkErrorInfo*info,NSInteger statusCode))failureBlock{
    GetC2CTokenRequest * request = [GetC2CTokenRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[C2CTokenInfo class] contentClass:[C2CTokenInfo class] success:^(C2CTokenInfo* response) {
        if (successBlock) {
            successBlock(response);
        }
        C2CUserManager.shared.token = response.token;
        [self getC2CAllExchangeListRequest:^(NSArray * _Nonnull response) {
            
        } failure:^(NetworkErrorInfo * _Nonnull info) {
            
        }];
        [self getC2CAllSupportedCurrenciesRequest];
        [self getC2COssTokenRequest:^{
            
        }];
        [self getC2CCurrentUser:^(C2CUserInfo * _Nonnull info) {
                    
        }];
        [self getC2CBalanceRequest:^(NSArray * _Nonnull response) {
            
        } failure:^(NetworkErrorInfo * _Nonnull info) {
            
        }];
        [self getC2CPrivateParameter];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if (failureBlock) {
            failureBlock(info,statusCode);
        }
    }];
}
-(void)getC2CPrivateParameter{
    GetC2CPrivateParameterRequest * request  = [GetC2CPrivateParameterRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CPrivateParameterInfo class] contentClass:[C2CPrivateParameterInfo class] success:^(C2CPrivateParameterInfo* response) {
        C2CUserManager.shared.sellerAppealTime = @(response.sellerAppealTime);
        C2CUserManager.shared.buyerAppealTime = @(response.buyerAppealTime);
        C2CUserManager.shared.countriesCode = response.defaultCountriesCode;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)setAllExchangenRateItems:(NSArray<C2CExchangeRateInfo *> *)allExchangenRateItems{
    NSMutableArray * array =[NSMutableArray array];
    for (C2CExchangeRateInfo*info in allExchangenRateItems) {
        NSData*data = [NSKeyedArchiver archivedDataWithRootObject:info];
        [array addObject:data];
    }
    NSArray * saveArray = [array copy];
    [self setUserDefaultsWithObject:saveArray key:@"C2CallExchangenRateItems"];
}
-(NSArray<C2CExchangeRateInfo *> *)allExchangenRateItems{
    NSArray * array = [self gainObjectWithKey:@"C2CallExchangenRateItems"];
    NSMutableArray * items = [NSMutableArray array];
    for (NSData*date in array) {
        C2CExchangeRateInfo * info = [NSKeyedUnarchiver unarchiveObjectWithData:date];
        [items addObject:info];
    }
    return [items copy];
}
-(void)setAllSupportedLegalTenderCurrencyItems:(NSArray<CurrencyInfo *> *)allSupportedLegalTenderCurrencyItems{
    NSMutableArray * array =[NSMutableArray array];
    for (CurrencyInfo*info in allSupportedLegalTenderCurrencyItems) {
        NSData*data = [NSKeyedArchiver archivedDataWithRootObject:info];
        [array addObject:data];
    }
    NSArray * saveArray = [array copy];
    [self setUserDefaultsWithObject:saveArray key:@"C2CAllSupportedLegalTenderCurrencyItems"];
}
-(NSArray<CurrencyInfo *> *)allSupportedLegalTenderCurrencyItems{
    NSArray * array = [self gainObjectWithKey:@"C2CAllSupportedLegalTenderCurrencyItems"];
    NSMutableArray * items = [NSMutableArray array];
    for (NSData*date in array) {
        CurrencyInfo * info = [NSKeyedUnarchiver unarchiveObjectWithData:date];
        [items addObject:info];
    }
    return [items copy];
}
-(void)setAllSupportedCurrencyItems:(NSArray<CurrencyInfo *> *)allSupportedCurrencyItems{
    NSMutableArray * array =[NSMutableArray array];
    for (CurrencyInfo*info in allSupportedCurrencyItems) {
        NSData*data = [NSKeyedArchiver archivedDataWithRootObject:info];
        [array addObject:data];
    }
    NSArray * saveArray = [array copy];
    [self setUserDefaultsWithObject:saveArray key:@"C2CAllSupportedCurrencyItems"];
}
-(NSArray<CurrencyInfo *> *)allSupportedCurrencyItems{
    NSArray * array = [self gainObjectWithKey:@"C2CAllSupportedCurrencyItems"];
    NSMutableArray * items = [NSMutableArray array];
    for (NSData*date in array) {
        CurrencyInfo * info = [NSKeyedUnarchiver unarchiveObjectWithData:date];
        [items addObject:info];
    }
    return [items copy];
}
/// 获取支持的全部货币
-(void)getC2CAllSupportedCurrenciesRequest{
    GetC2CAllSupportedCurrenciesRequest * request = [GetC2CAllSupportedCurrenciesRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyInfo class] success:^(NSArray<CurrencyInfo*>* response) {
        C2CUserManager.shared.allSupportedCurrencyItems = response;
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"LegalTender"];
        C2CUserManager.shared.allSupportedLegalTenderCurrencyItems =[response filteredArrayUsingPredicate:predicate];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
/** 全部的汇率列表 */
-(void)getC2CAllExchangeListRequest:(void(^)(NSArray* response))successBlock failure:(void(^)(NetworkErrorInfo*info))failureBlock{
    GetC2CAllExchangeListRequest * request = [GetC2CAllExchangeListRequest request];
    request.support = @"all";
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CExchangeRateInfo class] success:^(NSArray<C2CExchangeRateInfo*>* response) {
        C2CUserManager.shared.allExchangenRateItems = response;
        if (successBlock) {
            successBlock(response);
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        if (failureBlock) {
            failureBlock(info);
        }
    }];
}
-(void)setUserDefaultsWithObject:(id)object key:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}
- (id)gainObjectWithKey:(NSString *)key {
    id object = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return object;
}
- (void)removeObjectWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
