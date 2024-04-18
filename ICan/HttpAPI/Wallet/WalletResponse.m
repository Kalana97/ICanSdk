//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 13/11/2019
 - File name:  WalletResponse.m
 - Description:
 - Function List:
 */


#import "WalletResponse.h"
#import "MJExtension.h"
@implementation WalletResponse

@end
@implementation CommonBankCardsInfo

@end
@implementation AdPriceInfo

@end
@implementation BindingAliPayListInfo

@end
@implementation BindingBankCardListInfo

@end
@implementation RechargeChannelListNewInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"payChannels":[RechargeChannelInfo class]};
}
@end

@implementation UserBalanceInfo

@end

@implementation FlowsListInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[BillInfo class]};
}

@end

@implementation BillListInfo


@end

@implementation BillInfo
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
-(NSString *)imageStr{
    NSString*imgStr;
    if ([self.flowType isEqualToString:@"Transfer"]) {
        imgStr=@"mine_bill_list_tips_transfer";
    }else if ([self.flowType isEqualToString:@"RedPacket"]){
        
        imgStr=@"mine_bill_list_tips_red_envelopes";
    }else if ([self.flowType isEqualToString:@"RefundRedPacket"]){
        imgStr=@"mine_bill_list_tips_red_return";
        
    }else if ([self.flowType isEqualToString:@"BalancePayment"]){
        imgStr=@"mine_bill_list_tips_cashout";
        
    }else if ([self.flowType isEqualToString:@"BalanceRecharge"]){
        imgStr=@"mine_bill_list_tips_recharge";
        
    }else if ([self.flowType isEqualToString:@"Withdraw"]){
        imgStr=@"mine_bill_list_tips_cashout";
        
    }else if([self.flowType isEqualToString:@"TransactionPayment"]){//交易付款
        imgStr=@"mine_bill_list_tips_pay_yellow";
        
    }else if([self.flowType isEqualToString:@"TransactionRefund"]){//交易退款
        imgStr=@"mine_bill_list_tips_pay_yellow";
        
    }else if([self.flowType isEqualToString:@"ThirdPartyPayment"]){//第三方付款
        imgStr=@"mine_bill_list_tips_pay_yellow";
    }else if ([self.flowType isEqualToString:@"ReceiveRedPacket"]){
        imgStr=@"mine_bill_list_tips_red_envelopes";
    }else if ([self.flowType isEqualToString:@"ShopCommission"]){
        imgStr=@"mine_commission";
    }else if ([self.flowType isEqualToString:@"QRCode_Payment"]){
        imgStr=@"mine_bill_list_tips_pay";
    }else if ([self.flowType isEqualToString:@"QRCode_ReceivePayment"]){
        imgStr=@"mine_bill_list_tips_pay";
    }else if ([self.flowType isEqualToString:@"Dialog"]){
        imgStr=@"mine_bill_list_tips_recharge_yellow";
    }else if ([self.flowType isEqualToString:@"OfflineRecharge"]){//线下充值
        imgStr=@"mine_bill_list_tips_recharge";
    }else{
        if (self.amount >0) {
            imgStr=@"mine_bill_list_tips_pay";
        }else{
            imgStr=@"mine_bill_list_tips_cashout";
        }
        
    }
    return imgStr;
}
-(NSString *)flowTypeTitle{
    NSString*title;
    if (BaseSettingManager.isChinaLanguages) {
        title = self.flowTypeCn;
    }else{
        title = self.flowTypeEn;
    }
    if (title.length>0) {
        title = title;
    }else{
        if ([self.flowType isEqualToString:@"Transfer"]) {
             title =@"chatView.function.transfer".icanlocalized;
        }else if ([self.flowType isEqualToString:@"RedPacket"]){//发红包
             title =@"SendRedPacket".icanlocalized;
        }else if ([self.flowType isEqualToString:@"ReceiveRedPacket"]){//收红包
             title =@"Receive a red packet".icanlocalized;
        }else if ([self.flowType isEqualToString:@"RefundRedPacket"]){//退红包
             title =@"Return red packet".icanlocalized;;
        }else if ([self.flowType isEqualToString:@"BalancePayment"]){//余额支付
             title =@"Balance payment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"BalanceRecharge"]){//余额充值
            title =@"Balance recharge".icanlocalized;
        }else if ([self.flowType isEqualToString:@"Withdraw"]){//提现
            title =@"Withdraw".icanlocalized;
        }else if([self.flowType isEqualToString:@"TransactionPayment"]){//交易付款
            title =@"Transaction Payment".icanlocalized;
        }else if([self.flowType isEqualToString:@"TransactionRefund"]){//交易退款
            title =@"Transaction Refund".icanlocalized;
        }else if([self.flowType isEqualToString:@"ThirdPartyPayment"]){//第三方付款
            title =@"Third party payment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"QRCode_Payment"]){
            title =@"Payment Code Transaction".icanlocalized;
        }else if ([self.flowType isEqualToString:@"QRCode_ReceivePayment"]){
            title =@"Receipt Code Transaction".icanlocalized;
        }else if ([self.flowType isEqualToString:@"Dialog"]){
            title =@"find.listView.cell.utilityPayment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"OfflineRecharge"]){
            title =@"Offline recharge".icanlocalized;
        }else{
            title =self.content;
        }
    }
    return title;
}
-(NSString *)listTitle{
    NSString*title;
    if (BaseSettingManager.isChinaLanguages) {
        title = self.title;
    }else{
        title = self.titleEn;
    }
    if (title.length > 0 && !([self.flowType isEqualToString:@"C2CTransfer"])) {
        title = title;
    }else{
        if ([self.flowType isEqualToString:@"Transfer"]) {
            title = @"chatView.function.transfer".icanlocalized;
        }else if ([self.flowType isEqualToString:@"RedPacket"]){//发红包
            title = @"SendRedPacket".icanlocalized;
        }else if ([self.flowType isEqualToString:@"ReceiveRedPacket"]){//收红包
            title = @"Receive a red packet".icanlocalized;
        }else if ([self.flowType isEqualToString:@"RefundRedPacket"]){//退红包
            title = @"Return red packet".icanlocalized;;
        }else if ([self.flowType isEqualToString:@"BalancePayment"]){//余额支付
            title = @"Balance payment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"BalanceRecharge"]){//余额充值
            title = @"Balance recharge".icanlocalized;
        }else if ([self.flowType isEqualToString:@"Withdraw"]){//提现
            title = @"Withdraw".icanlocalized;
        }else if ([self.flowType isEqualToString:@"TransactionPayment"]){//交易付款
            title = @"Transaction Payment".icanlocalized;
        }else if([self.flowType isEqualToString:@"TransactionRefund"]){//交易退款
            title = @"Transaction Refund".icanlocalized;
        }else if ([self.flowType isEqualToString:@"ThirdPartyPayment"]){//第三方付款
            title = @"Third party payment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"QRCode_Payment"]){
            title = @"Payment Code Transaction".icanlocalized;
        }else if ([self.flowType isEqualToString:@"QRCode_ReceivePayment"]){
            title = @"Receipt Code Transaction".icanlocalized;
        }else if ([self.flowType isEqualToString:@"Dialog"]){
            title = @"find.listView.cell.utilityPayment".icanlocalized;
        }else if ([self.flowType isEqualToString:@"OfflineRecharge"]){
            title = @"Offline recharge".icanlocalized;
        }else if ([self.flowType isEqualToString:@"C2CTransfer"]){
            title = @"C2CTransfer".icanlocalized;
        }else{
            title =self.content;
        }
    }
    return title;
}
@end



@implementation RechargeInfo

@end
@implementation RechargeChannelListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"object":[RechargeChannelInfo class]};
}

@end

@implementation RechargeChannelInfo
-(NSString *)imageurl{
    if ([self.payType isEqualToString:@"ALIPAY"]) {
        return @"icon_recharge_alipay";
    }else if ([self.payType isEqualToString:@"WECHAT"]){
        return @"icon_recharge_wechat";
    }else if ([self.payType isEqualToString:@"BANK"]){
        return @"icon_unionPay";
    }else if ([self.payType isEqualToString:@"Banlance"]){
        return @"img_balance_tips";
    }
    return @"icon_unionPay";
}
@end

@implementation BankCardsUsuallyInfo


@end
@implementation WithdrawRecordListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[WithdrawRecordInfo class]};
}

@end
@implementation WithdrawRecordInfo


@end
@implementation RechargeRecordListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[RechargeRecordInfo class]};
}

@end
@implementation RechargeRecordInfo


@end
@implementation PreparePayOrderDetailInfo


@end

@implementation ReceiveFlowsInfo


@end
@implementation ReceiveFlowsListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[ReceiveFlowsInfo class]};
}

@end

@implementation GetPaymentListInfo


@end
@implementation PayQrcodeInfo


@end
@implementation CurrencyInfo
MJCodingImplementation
@end

@implementation GetCurrencyBalanceListInfo


@end

@implementation BindingBackInfo


@end

//Organization

@implementation OrganizationDetailsInfo

@end

@implementation InviteResponseInfo

@end

@implementation FailIdResponseInfo

@end

@implementation TransactionsResponseInfo


@end

@implementation MemebersResponseInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"permissions":[QTPermission class]};
}
@end

@implementation QTPermission
@end

@implementation PermissionResponse
// Custom initializer
- (instancetype)initWithShowName:(NSString *)showName permissionType:(NSString *)permissionType imageName:(NSString *)imageName isSelected:(BOOL)isSelected {
    self = [super init];
    if (self) {
        _showName = showName;
        _permission = permissionType;
        _isSelected = isSelected;
        _imageName = imageName;
    }
    return self;
}
@end

@implementation InOutResponse
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"currencyAmounts":[InOutCurrencyResponse class]};
}
@end

@implementation InOutCurrencyResponse

@end

@implementation TransactionData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[TransactionDataContentResponse class]};
}
@end

@implementation TransactionDataContentResponse

@end
