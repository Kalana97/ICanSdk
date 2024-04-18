//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/10
- System_Version_MACOS: 10.14
- EasyPay
- File name:  UserResponse.m
- Description:
- Function List: 
- History:
*/
        

#import "UserResponse.h"

@implementation UserResponse

@end

@implementation MessageOfflineInfo



@end

@implementation UploadInfo


@end


@implementation CredentialsInfo



@end

@implementation LanguageInfo

@end


@implementation OSSSecurityTokenInfo

+ (nullable NSDictionary<NSString *, id> *)ng_modelContainerPropertyGenericClass{
    return @{@"credentials":[CredentialsInfo class]};
}

@end

@implementation UserConfigurationInfo
-(NSString *)description{
    return [self mj_JSONObject];
}


@end

@implementation GetRongYunTokenInfo

@end

@implementation CheckUserOnlineInfo

@end

@implementation UserLocationNearbyInfo
-(NSString *)showDistance{
    if (self.distance < 0.1) {
        return  @"Within 100m".icanlocalized;
    }else if (self.distance>=0.1 && self.distance <=1){
        int edgeFloat = self.distance *1000;
        if (BaseSettingManager.isChinaLanguages) {
            return  [NSString stringWithFormat:@"距离%dm内",edgeFloat];
        }else{
            return  [NSString stringWithFormat:@"Within %d",edgeFloat];
        }
        
    }else if(self.distance >1&&self.distance<200){
        int edge = self.distance;
        if (BaseSettingManager.isChinaLanguages) {
            return  [NSString stringWithFormat:@"距离%dkm",edge];
        }else{
            return [NSString stringWithFormat:@"Within %dkm",edge];
        }
        
    }else{
        //这里没有说怎么处理，暂且先这样显示
        int edge = self.distance;
        if (BaseSettingManager.isChinaLanguages) {
            //                distance
            return [NSString stringWithFormat:@"距离%dkm",edge];
        }else{
            return [NSString stringWithFormat:@"Distance %dkm",edge];
        }
        
    }
}


@end

@implementation UserRecommendListInfo



@end
@implementation SearchUserInfo
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"users":[UserMessageInfo class]};
}

@end
@implementation GetPayHelperDisturbInfo
@end

@implementation GetMallLoginTokenInfo

@end
@implementation BeInvitedInfo
@end

@implementation BeInvitedListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[BeInvitedInfo class]};
}
@end
@implementation GetBeInvitedCountInfo
@end
@implementation BlockUsersListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[UserMessageInfo class]};
}

@end
@implementation ServicesInfo

@end
@implementation CustomerServicesInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"csUserList":[ServicesInfo class],@"csWebList":[ServicesInfo class]};
}


@end

@implementation AccessTokenInfo

@end
@implementation DialogListInfo



@end
@implementation DialogPaymentInfo
@end

@implementation PostCreateDialogOrderInfor
@end

@implementation RechargePaymentCountryInfo
@end

@implementation DialogOrderInfo
-(NSString *)payChannelTypeName{
//    Balance,BankCard,CreditCard,AliPay,WeChatPay
//    "payChannelTypeNameBalance"="余额";
//    "payChannelTypeNameBankCard"="银行卡";
//    "payChannelTypeNameCreditCard"="信用卡";
//    "payChannelTypeNameAliPay"="支付宝";
//    "payChannelTypeNameWeChatPay"="微信";
    if ([self.payChannelType isEqualToString:@"Balance"]) {
        return @"payChannelTypeNameBalance".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"BankCard"]) {
        return @"payChannelTypeNameBankCard".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"CreditCard"]) {
        return @"payChannelTypeNameCreditCard".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"AliPay"]) {
        return @"payChannelTypeNameAliPay".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"WeChatPay"]) {
        return @"payChannelTypeNameWeChatPay".icanlocalized;
    }
    return @"payChannelTypeNameBalance".icanlocalized;
}


@end
@implementation DialogOrdersListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[DialogOrderInfo class]};
}


@end
@implementation ExchangeByAmountInfo



@end
@implementation GetCircleToeknInfo



@end
@implementation Get43PaywayInfo



@end

@implementation QuickPayInfo


@end
@implementation QuickMessageInfo


@end


@implementation MemberCentreVipInfo


@end
@implementation MemberCentreNumberIdSellInfo


@end
@implementation AllCountryInfo


@end

@implementation C2CTokenInfo


@end

@implementation CloudLetterToken

@end

@implementation SelfEmailVerificationKey

@end
