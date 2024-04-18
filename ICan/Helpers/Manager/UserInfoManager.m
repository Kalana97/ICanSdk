//
//  UserInfoManager.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/5.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "UserInfoManager.h"
#import "OSSManager.h"
@interface UserInfoManager ()

@end

@implementation UserInfoManager
//IMPLEMENT_SINGLETON(UserInfoManager, sharedManager);
+ (instancetype)sharedManager{
    static UserInfoManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[UserInfoManager alloc] init];
    });
    return api;
}
-(void)setLoginStatus:(BOOL)loginStatus{
    [self setUserDefaultsWithObject:@(loginStatus) key:KloginStatus];
}
-(BOOL)loginStatus{
    NSNumber * b=[self gainObjectWithKey:KloginStatus];
    return [b boolValue];
}
-(void)setMobile:(NSString *)mobile{
    [self setUserDefaultsWithObject:mobile key:kmobile];
}
-(void)setLastLoginTime:(NSString *)lastLoginTime{
    [self setUserDefaultsWithObject:lastLoginTime key:klastLoginTime];
}
-(NSString *)lastLoginTime{
    return [self gainObjectWithKey:klastLoginTime];
}
-(NSString *)mobile{
    return [self gainObjectWithKey:kmobile];
}
-(void)setToken:(NSString *)token{
    [self setUserDefaultsWithObject:token key:KToken];
}
-(NSString *)token{
    return [self gainObjectWithKey:KToken];
}
-(void)setChatID:(NSString *)chatid{
    [self setUserDefaultsWithObject:chatid key:KChatId];
}
-(NSString *)chatID{
    return [self gainObjectWithKey:KChatId];
}
-(void)setUserId:(NSString *)userId{
     [self setUserDefaultsWithObject:userId key:KuserId];
}
-(void)setFontSize:(NSString *)fontsize{
    [self setUserDefaultsWithObject:fontsize key:kfont];
}
-(NSString *)fontSize{
    return [self gainObjectWithKey:kfont];
}
-(void)setSelectedFont:(NSString *)fontsize{
    [self setUserDefaultsWithObject:fontsize key:kselectedfont];
}
-(NSString *)selectedFont{
    return [self gainObjectWithKey:kselectedfont];
}
-(void)setWallpaperName:(NSString *)fontsize{
    [self setUserDefaultsWithObject:fontsize key:kwallpaper];
}
-(NSString *)wallpaperName{
    return [self gainObjectWithKey:kwallpaper];
}
-(NSString *)userId{
    return [self gainObjectWithKey:KuserId];
}
-(void)setNumberId:(NSString *)numberId{
    [self setUserDefaultsWithObject:numberId key:knumberId];
}
-(NSString *)numberId{
    return [self gainObjectWithKey:knumberId];
}
-(void)setHeadImgUrl:(NSString *)headImgUrl{
    [self setUserDefaultsWithObject:headImgUrl key:kheadImageUrl];
}
-(NSString *)headImgUrl{
    return [self gainObjectWithKey:kheadImageUrl];
}
-(void)setLoginType:(NSString *)loginType{
    [self setUserDefaultsWithObject:loginType key:KLoginType];

}
-(NSString *)loginType{
    return [self gainObjectWithKey:KLoginType];
}
-(void)setNickname:(NSString *)nickname{
    [self setUserDefaultsWithObject:nickname key:Knickname];
}
-(NSString *)nickname{
    return [self gainObjectWithKey:Knickname];
}

-(NSString *)realname{
    if (self.firstName) {
        if (BaseSettingManager.isChinaLanguages) {
            return  [NSString stringWithFormat:@"%@ %@",UserInfoManager.sharedManager.lastName,UserInfoManager.sharedManager.firstName];
        }else{
            return [NSString stringWithFormat:@"%@ %@",UserInfoManager.sharedManager.firstName,UserInfoManager.sharedManager.lastName];
        }
    }
    return @"";
}
-(void)setCertification:(NSString *)certification{
    [self setUserDefaultsWithObject:certification key:Kcertification];
}
-(NSString *)certification{
    return [self gainObjectWithKey:Kcertification];
}

-(void)setUsername:(NSString *)username{
    [self setUserDefaultsWithObject:username key:Kusername];
}
-(NSString *)username{
    return [self gainObjectWithKey:Kusername];
}
-(void)setCountriesCode:(NSString *)countriesCode{
    [self setUserDefaultsWithObject:countriesCode key:@"countriesCode"];
}
-(NSString *)countriesCode{
    return [self gainObjectWithKey:@"countriesCode"];
}
-(NSString *)countryCode{
    return [self gainObjectWithKey:kcountriesCode] == nil ? @"LK" : [self gainObjectWithKey:kcountriesCode];
}
- (void)setCountryCode:(NSString *)countryCode{
    [self setUserDefaultsWithObject:countryCode key:kcountriesCode];
}
-(void)setGender:(NSString *)gender{
    [self setUserDefaultsWithObject:gender key:kgender];
}
-(NSString *)gender{
    return [self gainObjectWithKey:kgender];
}

-(void)setEmail:(NSString *)email{
    [self setUserDefaultsWithObject:email key:Kemial];
}
-(NSString *)email{
    return [self gainObjectWithKey:Kemial];
}

-(void)setCardId:(NSString *)cardId{
    [self setUserDefaultsWithObject:cardId key:KcardId];
}

-(NSString *)cardId{
    return [self gainObjectWithKey:KcardId];
}
-(void)setIsSetPayPwd:(BOOL)isSetPayPwd{
    [self setUserDefaultsWithObject:@(isSetPayPwd) key:kisSetPayPwd];
}
-(BOOL)isEmailBinded{
    return [[self gainObjectWithKey:kisEmailBinded] boolValue];
}
-(void)setIsEmailBinded:(BOOL)isEmailBinded{
    [self setUserDefaultsWithObject:@(isEmailBinded) key:kisEmailBinded];
}
-(BOOL)mustBindEmailPayPswd{
    return [[self gainObjectWithKey:kmustBindEmailPayPswd] boolValue];
}
-(void)setMustBindEmailPayPswd:(BOOL)mustBindEmailPayPswd{
    [self setUserDefaultsWithObject:@(mustBindEmailPayPswd) key:kmustBindEmailPayPswd];
}
-(BOOL)isSetPayPwd{
    return [[self gainObjectWithKey:kisSetPayPwd] boolValue];
}
-(void)setOpenPay:(BOOL)openPay{
     [self setUserDefaultsWithObject:@(openPay) key:kopenPay];
}
-(BOOL)openPay{
    return [[self gainObjectWithKey:kopenPay] boolValue];
}
-(void)setOpenExchange:(BOOL)openExchange{
    [self setUserDefaultsWithObject:@(openExchange) key:@"openExchange"];
}
-(BOOL)openExchange{
    NSNumber *openExchange =[self gainObjectWithKey:@"openExchange"];
    if(!openExchange){
        return NO;
    }
    return [openExchange boolValue];
}
-(BOOL)readReceipt{
    NSNumber *readReceipt =[self gainObjectWithKey:@"readReceipt"];
    //这样可以在赋值的时候给一个默认值
    BOOL shouldShowTutorial = NO;
    if(!readReceipt){
      shouldShowTutorial = YES;
    }else{
      shouldShowTutorial = [readReceipt boolValue];
    }
    return shouldShowTutorial;
}
-(void)setReadReceipt:(BOOL)readReceipt{
    [self setUserDefaultsWithObject:@(readReceipt) key:@"readReceipt"];
}
-(void)setOpenCloudPay:(BOOL)openCloudPay{
    [self setUserDefaultsWithObject:@(openCloudPay) key:kopenCloudPay];
}
-(BOOL)openCloudPay{
    return [[self gainObjectWithKey:kopenCloudPay] boolValue];
}

-(BOOL)tradePswdSet{
    return [[self gainObjectWithKey:ktradePswdSet] boolValue];
}
-(void)setTradePswdSet:(BOOL)tradePswdSet{
    [self setUserDefaultsWithObject:@(tradePswdSet) key:ktradePswdSet];
}

-(void)setOpenIdType:(NSString *)openIdType{
    [self setUserDefaultsWithObject:openIdType key:kopenIdType];
}
-(NSString *)openIdType{
    return [self gainObjectWithKey:kopenIdType];
}
-(void)setIsSetPassword:(BOOL)isSetPassword{
    [self setUserDefaultsWithObject:@(isSetPassword) key:kisSetPassword];
}
-(BOOL)isSetPassword{
    return [[self gainObjectWithKey:kisSetPassword] boolValue];
}

-(void)setOpenId:(NSString *)openId{
    [self setUserDefaultsWithObject:openId key:kOpenId];
}
-(NSString *)openId{
    return [self gainObjectWithKey:kOpenId];
}
-(void)setMallToken:(NSString *)mallToken{
    [self setUserDefaultsWithObject:mallToken key:kmallToken];
}
-(NSString *)mallToken{
    return [self gainObjectWithKey:kmallToken];
}


-(void)setSignature:(NSString *)signature{
    [self setUserDefaultsWithObject:signature key:KSignature];
}

-(NSString *)signature{
    return [self gainObjectWithKey:KSignature];
}


-(void)setLoginPassword:(NSString *)loginPassword{
    [self setUserDefaultsWithObject:loginPassword key:KloginPassword];
}

-(NSString *)loginPassword{
    return [self gainObjectWithKey:KloginPassword];
}

-(void)setBeFound:(BOOL)beFound{
    [self setUserDefaultsWithObject:@(beFound) key:kBeFound];
}

-(BOOL)beFound{
    
    return [[self gainObjectWithKey:kBeFound] boolValue];
}
-(void)setNearbyVisible:(BOOL)nearbyVisible{
    [self setUserDefaultsWithObject:@(nearbyVisible) key:knearbyVisible];
}
-(BOOL)nearbyVisible{
    return [[self gainObjectWithKey:knearbyVisible]boolValue];
}

-(void)setOpenRecommend:(BOOL)openRecommend{
    [self setUserDefaultsWithObject:@(openRecommend) key:KopenRecommend];
}

-(BOOL)openRecommend{
    return [[self gainObjectWithKey:KopenRecommend]boolValue];
}


-(void)setOpenNearbyPeople:(BOOL)openNearbyPeople{
    [self setUserDefaultsWithObject:@(openNearbyPeople) key:KopenNearby];
}

-(BOOL)openNearbyPeople{
    return [[self gainObjectWithKey:KopenNearby]boolValue];
}

-(void)setOpenRecharge:(BOOL)openRecharge{
    [self setUserDefaultsWithObject:@(openRecharge) key:KopenRecharge];
}

-(BOOL)openRecharge{
    return [[self gainObjectWithKey:KopenRecharge]boolValue];
}

-(void)setOpenTransfer:(BOOL)openTransfer{
    [self setUserDefaultsWithObject:@(openTransfer) key:KopenTransfer];
}

-(BOOL)openTransfer{
    return [[self gainObjectWithKey:KopenTransfer]boolValue];
}
-(void)setOpenWithdraw:(BOOL)openWithdraw{
    [self setUserDefaultsWithObject:@(openWithdraw) key:KopenWithdraw];
}

-(BOOL)openWithdraw{
    return [[self gainObjectWithKey:KopenWithdraw]boolValue];
}

-(void)setIsSecret:(BOOL)isSecret{
    [self setUserDefaultsWithObject:@(isSecret) key:@"isSecret"];
}
-(BOOL)isSecret{
    return [[self gainObjectWithKey:@"isSecret"] boolValue];
}
-(void)setIsNew:(BOOL)isNew{
    [self setUserDefaultsWithObject:@(isNew) key:@"isNew"];
}
-(BOOL)isNew{
    return [[self gainObjectWithKey:@"isNew"] boolValue];
}

-(void)setAreaNum:(NSString *)areaNum{
    [self setUserDefaultsWithObject:areaNum key:@"areaNum"];
}
-(NSString *)areaNum{
    return  [self gainObjectWithKey:@"areaNum"];
}
-(void)setQuickFriend:(BOOL)quickFriend{
    [self setUserDefaultsWithObject:@(quickFriend) key:kquickFriend];
}
-(BOOL)quickFriend{
    return [[self gainObjectWithKey:kquickFriend]boolValue];
}
-(void)setCloudLetterVideo:(BOOL)cloudLetterVideo{
    [self setUserDefaultsWithObject:@(cloudLetterVideo) key:kcloudLetterVideo];
}
-(BOOL)cloudLetterVideo{
     return [[self gainObjectWithKey:kcloudLetterVideo]boolValue];
}
-(void)setCloudLetterVoice:(BOOL)cloudLetterVoice{
    [self setUserDefaultsWithObject:@(cloudLetterVoice) key:kcloudLetterVoice];
}
-(BOOL)cloudLetterVoice{
      return [[self gainObjectWithKey:kcloudLetterVoice]boolValue];
}
-(void)setRedPacketMaxMoney:(NSString *)redPacketMaxMoney{
    [self setUserDefaultsWithObject:redPacketMaxMoney key:kredPacketMaxMoney];
}
-(NSString *)redPacketMaxMoney{
    return [self gainObjectWithKey:kredPacketMaxMoney];
}
-(void)setHelperDisturb:(BOOL)helperDisturb{
     [self setUserDefaultsWithObject:@(helperDisturb) key:KhelperDisturb];
}
-(BOOL)helperDisturb{
    return [[self gainObjectWithKey:KhelperDisturb]boolValue];
}
-(void)setSystemHelperDisturb:(BOOL)systemHelperDisturb{
    [self setUserDefaultsWithObject:@(systemHelperDisturb) key:@"systemHelperDisturb"];
}
-(BOOL)systemHelperDisturb{
    NSNumber *readReceipt =[self gainObjectWithKey:@"systemHelperDisturb"];
    if(!readReceipt){
        return NO;
    }
    return [readReceipt boolValue];
}
-(void)setVip:(NSNumber *)vip{
    [self setUserDefaultsWithObject:vip key:@"vip"];
}
-(NSNumber *)vip{
    return [self gainObjectWithKey:@"vip"];
}
-(void)setLookTimelineTime:(NSString *)lookTimelineTime{
    [self setUserDefaultsWithObject:lookTimelineTime key:@"lookTimelineTime"];
}
-(NSString *)lookTimelineTime{
    return [self gainObjectWithKey:@"lookTimelineTime"];
}
-(void)hiddenmessageMenuView{
    [self.messageMenuView hiddenMessageMenuView];
}
-(void)setSeniorMemberExpiration:(NSString *)seniorMemberExpiration{
    [self setUserDefaultsWithObject:seniorMemberExpiration key:@"seniorMemberExpiration"];
}
-(NSString *)seniorMemberExpiration{
    return [self gainObjectWithKey:@"seniorMemberExpiration"];
}
-(BOOL)seniorValid{
    NSTimeInterval current = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval seniorTime = self.seniorMemberExpiration.floatValue;
    return seniorTime>current;
}
-(void)setDiamondMemberExpiration:(NSString *)diamondMemberExpiration{
    [self setUserDefaultsWithObject:diamondMemberExpiration key:@"diamondMemberExpiration"];
}
-(NSString *)diamondMemberExpiration{
    return [self gainObjectWithKey:@"diamondMemberExpiration"];
}
-(BOOL)diamondValid{
    NSTimeInterval current = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval diamondTime = self.diamondMemberExpiration.floatValue;
    return diamondTime>current;
}
-(void)setCs:(BOOL)cs{
    [self setUserDefaultsWithObject:@(cs) key:@"cs"];
}
-(BOOL)cs{
    return [[self gainObjectWithKey:@"cs"] boolValue];
}
-(void)setThirdPartySystemAppId:(NSString *)thirdPartySystemAppId{
    [self setUserDefaultsWithObject:thirdPartySystemAppId key:@"thirdPartySystemAppId"];
}
-(NSString *)thirdPartySystemAppId{
    return [self gainObjectWithKey:@"thirdPartySystemAppId"];
}
-(void)setPreventDeleteMessage:(BOOL)preventDeleteMessage{
    [self setUserDefaultsWithObject:@(preventDeleteMessage) key:@"preventDeleteMessage"];
}
-(BOOL)preventDeleteMessage{
    NSNumber *readReceipt =[self gainObjectWithKey:@"preventDeleteMessage"];
    if(!readReceipt){
        return  YES;
    }
    return [readReceipt boolValue];
}
-(void)setOpenShop:(BOOL)openShop{
    [self setUserDefaultsWithObject:@(openShop) key:@"openShop"];
}
-(BOOL)openShop{
    NSNumber *readReceipt =[self gainObjectWithKey:@"openShop"];
    if(!readReceipt){
        return  NO;
    }
    return [readReceipt boolValue];
}
-(void)setUserAuthStatus:(NSString *)userAuthStatus{
    [self setUserDefaultsWithObject:userAuthStatus key:@"userAuthStatus"];
}
-(NSString *)userAuthStatus{
    return  [self gainObjectWithKey:@"userAuthStatus"];
}
-(void)setFirstName:(NSString *)firstName{
    [self setUserDefaultsWithObject:firstName key:@"firstName"];
}
-(NSString *)firstName{
    return [self gainObjectWithKey:@"firstName"];
}
-(void)setLastName:(NSString *)lastName{
    [self setUserDefaultsWithObject:lastName key:@"lastName"];
}
-(NSString *)lastName{
    return  [self gainObjectWithKey:@"lastName"];
}
-(void)setMallH5Url:(NSString *)mallH5Url{
    [self setUserDefaultsWithObject:mallH5Url key:@"mallH5Url"];
}
-(NSString *)mallH5Url{
    return [self gainObjectWithKey:@"mallH5Url"];
}

- (void)setAttemptCount:(NSString *)attemptCount{
    [self setUserDefaultsWithObject:attemptCount key:@"attemptCount"];
}

- (NSString *)attemptCount {
    return [self gainObjectWithKey:@"attemptCount"];
}

- (void)setIsPayBlocked:(BOOL)isPayBlocked{
    [self setUserDefaultsWithObject:@(isPayBlocked) key:@"isPayBlocked"];
}

- (BOOL)isPayBlocked{
    return [[self gainObjectWithKey:@"isPayBlocked"] boolValue];
}

- (void)setUnblockTime:(NSString *)unblockTime{
    [self setUserDefaultsWithObject:unblockTime key:@"unblockTime"];
}

- (NSString *)unblockTime{
    return [self gainObjectWithKey:@"unblockTime"];
}

-(void)fetchUserBalanceRequest:(void (^)(UserBalanceInfo*balance))successBlock{
    if ([UserInfoManager sharedManager].loginStatus) {
        UserBalanceRequest*request=[UserBalanceRequest request];
        [QMUITipsTool showLoadingWihtMessage:nil inView:nil isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
            [QMUITips hideAllTips];
            [UserInfoManager sharedManager].isEmailBinded=response.isEmailBound;
            [UserInfoManager sharedManager].mustBindEmailPayPswd=response.mustBindEmailPayPswd;
            [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
            successBlock(response);
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
    
}

-(void)getPrivateParameterRequest:(void (^)(PrivateParameterInfo * _Nonnull))successBlock{
    PrivateParameterRequest*request=[PrivateParameterRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[PrivateParameterInfo class] contentClass:[PrivateParameterInfo class] success:^(PrivateParameterInfo* response) {
        [UserInfoManager sharedManager].openPay = response.openPay;
        [UserInfoManager sharedManager].openCloudPay = response.openCloudPay;
        [UserInfoManager sharedManager].openNearbyPeople =response.openNearbyPeople;
        [UserInfoManager sharedManager].openRecommend = response.openRecommend;
        [UserInfoManager sharedManager].openRecharge = response.openRecharge;
        [UserInfoManager sharedManager].openTransfer = response.openTransfer;
        [UserInfoManager sharedManager].openWithdraw = response.openWithdraw;
        [UserInfoManager sharedManager].openShop = response.openShop;
        [UserInfoManager sharedManager].cloudLetterVoice = response.cloudLetterVoice;
        [UserInfoManager sharedManager].cloudLetterVideo = response.cloudLetterVideo;
        [UserInfoManager sharedManager].isSecret = response.openSecretMessage;
        [UserInfoManager sharedManager].openExchange = response.openExchange;
        UserInfoManager.sharedManager.mallH5Url = response.mallH5Url;
        if (successBlock) {
            successBlock(response);
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
/// 获取阿里云相关数据
-(void)getAliyunOSSSecurityToken:(void (^)(void))successBlock{
    GetAliyunOSSSecurityTokenRequest * request = [GetAliyunOSSSecurityTokenRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OSSSecurityTokenInfo class] contentClass:[OSSSecurityTokenInfo class] success:^(OSSSecurityTokenInfo * response) {
        BaseSettingManager.sharedManager.bucket = response.bucket;
        BaseSettingManager.sharedManager.ossEndpoint = response.ossEndpoint;
        CredentialsInfo * credentialsInfo = response.credentials;
        BaseSettingManager.sharedManager.urlBegin=response.urlBegin;
        BaseSettingManager.sharedManager.accessKeyId = credentialsInfo.accessKeyId;
        BaseSettingManager.sharedManager.accessKeySecret = credentialsInfo.accessKeySecret;
        BaseSettingManager.sharedManager.securityToken = credentialsInfo.securityToken;
        BaseSettingManager.sharedManager.expiration = credentialsInfo.expiration;
        OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
        cfg.maxRetryCount = 10;
        cfg.timeoutIntervalForRequest = 15;
        cfg.isHttpdnsEnable = NO;
        cfg.crc64Verifiable = YES;
        OSSFederationToken*token = [OSSFederationToken new];
        token.tAccessKey = BaseSettingManager.sharedManager.accessKeyId;
        token.tSecretKey = BaseSettingManager.sharedManager.accessKeySecret;
        token.tToken = BaseSettingManager.sharedManager.securityToken;
        token.expirationTimeInGMTFormat = BaseSettingManager.sharedManager.expiration;
        OSSStsTokenCredentialProvider *provider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:token.tAccessKey secretKeyId:token.tSecretKey securityToken:token.tToken];
        OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:[BaseSettingManager sharedManager].ossEndpoint credentialProvider:provider clientConfiguration:cfg];
        [OSSManager sharedManager].defaultClient = defaultClient;
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
- (BOOL)validateWithExpireTime:(NSString *)expireTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    NSInteger expiretimet = [expire timeIntervalSince1970];
    NSInteger nowTimet = [[NSDate date] timeIntervalSince1970];
    return  expiretimet > nowTimet;
    
}
-(void)getMineMessageRequest:(void (^)(UserMessageInfo * _Nonnull))successBlock{
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* info) {
        self.vip=@(info.vip);
        self.username=info.username;
        self.nickname=info.nickname;
        self.userId=info.userId;
        self.certification=info.certification;
        self.numberId=info.numberId;
        self.headImgUrl=info.headImgUrl;
        self.cardId = info.cardId;
        self.mobile = info.mobile;
        self.email = info.email;
        self.gender = info.gender;
        self.signature = info.signature;
        self.vip=@(info.vip);
        self.isNew=info.isNew;
        self.areaNum=info.areaNum;
        self.diamondMemberExpiration = info.diamondMemberExpiration;
        self.seniorMemberExpiration = info.seniorMemberExpiration;
        self.preventDeleteMessage = info.preventDeleteMessage;
        self.userAuthStatus = info.userAuthStatus;
        self.lastName = info.lastName;
        self.firstName = info.firstName;
        self.cs = info.cs;
        self.thirdPartySystemAppId = info.thirdPartySystemAppId;
        self.countriesCode = info.countriesCode;
        if (successBlock) {
            successBlock(info);
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
+(void)uploadAppLanguagesRequest{
    UploadUserLanguageRequest * request = [UploadUserLanguageRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/user/upload/language/%@",BaseSettingManager.uploadLanguages];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(NSString*)getSymbol:(NSString*)currencyCode{
    if (self.allSupportedCurrenciesItems) {
        for (CurrencyInfo * info in self.allSupportedCurrenciesItems) {
            if ([info.code isEqualToString:currencyCode]) {
                return info.symbol;
            }
        }
    }
    return @"￥";
    
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
