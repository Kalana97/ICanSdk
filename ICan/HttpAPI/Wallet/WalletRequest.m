//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  WalletRequest.m
- Description:
- Function List:
*/
        

#import "WalletRequest.h"

@implementation WalletRequest

@end
@implementation CommonBankCardsRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"常用银行列表";
}
@end
@implementation BindingAliPayListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/aliPayList"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"绑定的支付宝列表";
}
@end

@implementation BindingAliPayRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/aliPay"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定支付宝";
}
@end
@implementation DeleteAlipayRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"解除绑定支付宝";
}
@end
@implementation BindingBankCardListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/bankCardList"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"绑定的银行卡列表";
}
@end
@implementation BindingBankCardRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/bankCard"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定银行卡";
}
@end
@implementation DeleteBankCardRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除银行卡";
}

@end
@implementation UserBalanceRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/user/balance"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"用户余额";
}

@end


@implementation TransferRequest

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/transfers/v2"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"转账";
}

@end

@implementation GetFlowsRequest

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/flows"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"交易流水";
}

@end

@implementation RechargeRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/recharge"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"充值";
}



@end

@implementation RechargeChannelRequest

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/recharge/channel"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"充值渠道";
}

@end

@implementation RechargeChannelListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payments/orderDetails"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"充值渠道";
}

@end


@implementation GetBankCardsUsuallyRequest

-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/usually"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"常用的银行卡账号";
}




@end

@implementation WithdrawsRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/withdraws"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"提现";
}
@end
@implementation WithdrawRecordRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/withdraws"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"提现记录";
}
@end
@implementation RechargeRecordListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/recharge"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"充值记录";
}
@end
@implementation GetPreparePayOrderDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取第三方代付订单详情";
}


@end
@implementation PayPreparePayOrderRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"第三方代付";
}

@end
@implementation GetCodeRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取code";
}

@end
@implementation PayQRCodeReceivePaymentRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 通过收款码付款";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payQRCode/receivePayment"];
}
@end
@implementation C2CGetAdverPriceListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 通过收款码付款";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/ad/price"];
}
@end
@implementation PayQRCodePaymentRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @" 通过付款码收款";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payQRCode/payment"];
}
@end
@implementation PayQRCodereceiveFlowsRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收款记录";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payQRCode/receiveFlows"];
}
@end
@implementation GetPayQRCodePaymentListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"付款码页面的金额";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/payQRCode/payment/list"];
}
@end
@implementation GetAllSupportedCurrenciesRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"支持的全部货币";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/currency/allSupportedCurrencies"];
}
@end

@implementation WalletTransferRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"划转";
}
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/transfer"];
}
@end
@implementation BindingBankCardRequestV2
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/bankCard/v2"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定银行卡";
}
@end
@implementation BindingAliPayRequestV2
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/aliPay/v2"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定支付宝";
}
@end

@implementation BindingAccountRequestV2
- (NSString *)pathUrlString {
    return [self.baseUrlString stringByAppendingString:@"/bankCards/bindAccount"];
}
- (RequestMethod)requestMethod {
    return RequestMethod_Post;
}

- (NSString *)requestName {
    return @"Bind bank card";
}
@end

@implementation IcanAllBankCardsRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/bankCards/all"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的银行卡";
}
@end

@implementation C2CTransferSwipeRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/c2c/transferAll"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"绑定银行卡";
}
@end

//Organizations
@implementation AddOrganizationRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/create"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"AddOrganizationRequest";
}
@end

@implementation GetOrganizationInfoForUserRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/infoForUser"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"绑定的银行卡列表";
}
@end

@implementation PutOrganizationRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/updateDetails"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"PutOrganizationRequest";
}
@end

@implementation SendInviteRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/inviteMembers"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"SendInviteRequestMember";
}
@end

@implementation GetInOutTransactionAmountsRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/getTransactionAmounts"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"GetInOutTransactionAmountsRequest";
}
@end

@implementation GetTransactionsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"GetTransactionsRequest";
}
@end

@implementation GetMemeberListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/allMembers"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"GetMemeberListRequest";
}
@end

@implementation GetContactListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/invitableFriends"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"GetContactListRequest";
}
@end

@implementation GetPermissionsListRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/allAvailablePermissions"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"GetPermissionsListRequest";
}
@end

@implementation OrganizationRemoveUserRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/removeUser"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"OrganizationRemoveUserRequest";
}
@end

@implementation GetInvitedOTPUsers
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/invitedUsers"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"GetInvitedOTPUsers";
}
@end

@implementation ConfirmUserByOtpRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/confirmMember"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"ConfirmUserByOtpRequest";
}
@end

@implementation DeleteOrganizationRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/disband"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"DeleteOrganizationRequest";
}
@end

@implementation AddEditLevelRequest
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/editTransactionAprLevel"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"AddEditLevelRequest";
}
@end

@implementation ApproveOrRejectTransaction
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/approveTransaction"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"ApproveOrRejectTransaction";
}
@end

@implementation GetOrgUserInfoRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"GetOrgUserInfoRequest";
}
@end

@implementation ChangeUserPermissions
-(NSString *)pathUrlString{
    return [self.baseUrlString stringByAppendingString:@"/organization/changePermission"];
}
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"ChangeUserPermissions";
}
@end
