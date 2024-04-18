//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2019
- File name:  CloudWalletRequest.m
- Description:
- Function List:
*/
        

#import "CloudWalletRequest.h"

@implementation CloudWalletRequest

@end

@implementation CloudWalletOpenEBaoRequest
-(NSString *)requestName{
    return @"云钱包开户";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/open"];
}
@end
@implementation CloudWalletBalanceRequest
-(NSString *)requestName{
    return @"云钱包账户查询";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/balance"];
}
@end
@implementation CloudWalletManagePasswordRequest
-(NSString *)requestName{
    return @"支付密码管理";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/managePassword"];
}
-(BOOL)isHttpResponse{
    return YES;
}
@end
@implementation CloudWalletManageBankCardRequest
-(NSString *)requestName{
    return @"银行卡管理";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/manageBankCard"];
}
-(BOOL)isHttpResponse{
    return YES;
}
@end
@implementation CloudWalletRechargeRequest
-(NSString *)requestName{
    return @"云钱包充值";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/recharge"];
}
-(BOOL)isHttpResponse{
    return YES;
}

///easyPay/cloudWallet/withdraw
@end
@implementation CloudWalletWithdrawRequest
-(NSString *)requestName{
    return @"云钱包提现";
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/easyPay/cloudWallet/withdraw"];
}
-(BOOL)isHttpResponse{
    return YES;
}

///easyPay/cloudWallet/withdraw
@end
