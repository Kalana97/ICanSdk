//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/12/2021
- File name:  C2CWalleteRequest.m
- Description:
- Function List:
*/
        

#import "C2CWalleteRequest.h"

@implementation C2CWalleteRequest

@end
@implementation GetC2CBalanceListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"资产列表";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/wallet"];
}
@end
@implementation GetC2CExchangeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"牌价列表";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/currency/exchange/list"];
}
@end

@implementation PostC2CCurrencyExchangeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"兑换";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/currency/exchange/order"];
}
@end

@implementation GetC2CExchangeOrderListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"兑换记录";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/currency/exchange/order/page"];
}
@end
@implementation GetC2CMainNetworkByCurrencyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据货币获取主网";
}
@end
/**
 添加地址簿
 POST
 /api/address
 */
@implementation AddIcanWalletAddressRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加地址簿";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/address"];
}
@end
/**
 全部的钱包地址簿
 GET
 /api/address/list
 */
@implementation GetAllIcanWalletAddressRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的钱包地址簿";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/address/list"];
}
@end

/**
 删除
 DELETE
 /api/address/{id}
 */
@implementation DeleteIcanWalletAddressRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"全部的钱包地址簿";
}
@end
/**
 提现
 POST
 /api/ext/wallet/withdraw
 */
@implementation IcanWalletWithdrawRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"提现";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/ext/wallet/withdraw"];
}
@end

@implementation C2CGetWalletDetailsRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"扫描收款码进行付款";
}
@end
/**
 获取C2C收款二维码code
 POST
 /api/qrcodeReceive/init
 */
@implementation GetC2CQRCodeReceiveRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"获取C2C收款二维码code";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/qrcodeReceive/init"];
}
@end

/**
 扫描收款码进行付款
 POST
 /api/qrcodeReceive/pay
 */
@implementation C2CQRCodeReceivePayRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"扫描收款码进行付款";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/qrcodeReceive/pay"];
}
@end

/**
 扫描收款码进行付款
 POST
 /api/qrcodeReceive/pay
 */
@implementation GetQRCodeReceiveMessageRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"扫描收款码进行付款";
}
@end

/**
 c2c转账
 POST
 /api/transfer
 */
@implementation C2CTransferRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"c2c转账";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/transferToUser"];
}
@end

@implementation C2CAddWalletRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"c2c转账";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/observe"];
}
@end
/**
 c2c最近转账
 GET
 /api/transfer/history
 */

@implementation C2CAddWalletVerifyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"c2c转账";
}

@end

@implementation C2CAddWalletAsDefault

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"Default observe wallet";
}

@end

@implementation C2CTransferHistoryRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"c2c最近转账";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/transfer/history"];
}
@end
/**
 c2c流水列表
 GET
 /api/flows/page
 */
@implementation C2CTransferHistoryListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"c2c流水列表";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/flows/page"];
}
@end
/**
 wallet
 GET 获取某个资产
 /api/wallet/{code}
 */

@implementation GetAssetRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取某个资产";
}
@end

@implementation GetWatchWalletListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/observe"];
}
-(NSString *)requestName{
    return @"获取某个资产";
}
@end

@implementation DeleteWalletFromListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"获取某个资产";
}
@end
/**
 获取隐私参数
 GET
 /api/privateParameter
 */
@implementation GetC2CPrivateParameterRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取隐私参数";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/api/privateParameter"];
}
@end
/**
 获取c2c流水的广告订单详情
 GET
 /api/flows/adOrder/{orderId}
 */
@implementation GetC2CFlowsAdOrderDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的广告订单详情";
}

@end
@implementation GetC2CFlowsExtPayDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的第三方支付详情";
}

@end

@implementation GetC2CFlowsExternalWithdrawDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的提现详情";
}

@end
/**
 获取c2c流水的收款详情
 GET
 /api/flows/qrcodePayFlow/{orderId}
 */
@implementation GetC2CFlowsQrcodePayFlowDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的收款详情";
}

@end
/**
 账单外网充值流水详情
 GET
 /api/flows/externalRecharge/{orderId}
 */
@implementation GetC2CFlowsExternalRechargeDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的收款详情";
}

@end
/**
 获取c2c流水的退款详情
 GET
 /api/flows/extPayRefund/{orderId}
 */
@implementation GetC2CFlowsExternalRefundDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取c2c流水的退款详情";
}

@end
