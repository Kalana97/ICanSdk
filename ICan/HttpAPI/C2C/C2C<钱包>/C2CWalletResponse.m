//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/12/2021
- File name:  C2CWalletResponse.m
- Description:
- Function List:
*/
        

#import "C2CWalletResponse.h"

@implementation C2CWalletResponse

@end

@implementation CurrencyExchangeInfo
- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    CurrencyExchangeInfo *copy = [[CurrencyExchangeInfo allocWithZone:zone] init];
    copy.createTime = [self.createTime mutableCopy];
    copy.fromCode = [self.fromCode mutableCopy];
    copy.toCode = [self.toCode mutableCopy];
    return copy;
}

@end

@implementation ExchangeOrderInfo


@end
@implementation ExchangeOrderListInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[ExchangeOrderInfo class]};
}
@end
@implementation ICanWalletMainNetworkInfo


@end

@implementation ICanWalletAddressInfo


@end

@implementation C2CQRCodeReceiveCodeInfo


@end

@implementation C2CWatchWalletInfo


@end

@implementation SimpleUserDTOInfo


@end

@implementation C2CTransferHistoryInfo


@end
@implementation C2CFlowsInfo

-(NSString *)showTitle{
    /**
     ExternalWithdraw => 提现  QrcodePayFlow => 二维码收款 TransferRecord => 转账 AdOrder => c2c交易 FundsTransfer => 划转  ExternalRecharge外网充值
     ExtPaymentOrder 第三方代付 OfflineRecharge->线下充值 ExtPaymentOrderRefund->第三方代付退款
     */
    NSString * show = self.flowType;
    if ([self.flowType isEqualToString:@"ExternalWithdraw"]) {
        show = @"Withdraw".icanlocalized;
    }else if ([self.flowType isEqualToString:@"QrcodePayFlow"]) {
        show = @"QRCodeCollection".icanlocalized;
    }else if ([self.flowType isEqualToString:@"TransferRecord"]) {
        show = @"C2CWalletTransfer".icanlocalized;
    }else if ([self.flowType isEqualToString:@"AdOrder"]) {
        show = @"C2CTransaction".icanlocalized;
    }else if ([self.flowType isEqualToString:@"FundsTransfer"]) {
        show = @"C2CTransfer".icanlocalized;
    }else if ([self.flowType isEqualToString:@"ExternalRecharge"]){
        show = @"Externalnetworkrecharge".icanlocalized;
    }else if ([self.flowType isEqualToString:@"ExtPaymentOrder"]){
        show = @"Thirdpartypayment".icanlocalized;
    }else if ([self.flowType isEqualToString:@"OfflineRecharge"]){
        show =@"Offline recharge".icanlocalized;
    }else if ([self.flowType isEqualToString:@"ExtPaymentOrderRefund"]){
        show =@"ThirdPartyRefund".icanlocalized;
    }else if ([self.flowType isEqualToString:@"CurrencyExchange"]){
        show =@"CurrencyExchange".icanlocalized;
    }
    return show;
    
}
@end

@implementation C2CTransferHistoryListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[C2CFlowsInfo class]};
}
@end
@implementation C2CPrivateParameterInfo

@end
@implementation GetC2CFlowsExternalWithdrawDetailInfo

@end

@implementation C2CQrcodePayFlowDetailInfo

@end

@implementation GetC2CFlowsExternalRechargeDetailInfo

@end

@implementation GetC2CFlowsExternalPayDetailInfo

@end

@implementation GetC2CFlowsExternalRefundDetailInfo

@end
