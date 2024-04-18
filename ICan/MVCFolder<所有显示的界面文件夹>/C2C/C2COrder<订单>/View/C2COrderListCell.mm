//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2COrderListCell.m
- Description:
- Function List:
*/
        

#import "C2COrderListCell.h"
#import "WCDBManager+ChatList.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
@interface C2COrderListCell ()
@property (weak, nonatomic) IBOutlet UILabel *saleOrBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *countAmountLabel;

@property (weak, nonatomic) IBOutlet UIControl *serviceBgCon;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
//未读消息数量
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;

@end
@implementation C2COrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceTitleLabel.text = @"C2COptionalSaleViewControllerUnitPriceTitleLabel".icanlocalized;
    self.countTitleLabel.text = @"C2COptionalSaleViewControllerCountTitleLabel".icanlocalized;
    [self.serviceBgCon layerWithCornerRadius:17 borderWidth:0 borderColor:nil];
    [self.unReadLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    self.lineView.hidden = YES;
}
-(void)setOrderInfo:(C2COrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    
    /**
     "C2COrderStateAll"="全部";
     "C2COrderStateUnpaid"="未付款";
     "C2COrderStatePaid"="已付款";
     "C2COrderStateAppeal"="申诉";
     "C2COrderStateCompleted"="已完成";
     "C2COrderStateCancelled"="已取消";
     */
    NSString*stateStr;
    if ([self.orderInfo.status isEqualToString:@"Unpaid"]) {
        stateStr = @"C2COrderStateUnpaid".icanlocalized;
        self.stateLabel.textColor = UIColorMakeHEXCOLOR(0X999999);
    }else if ([self.orderInfo.status isEqualToString:@"Paid"]) {
        self.stateLabel.textColor = UIColorMakeHEXCOLOR(0X999999);
        stateStr = @"C2COrderStatePaid".icanlocalized;
    }else if ([self.orderInfo.status isEqualToString:@"Appeal"]) {
        self.stateLabel.textColor = UIColorMakeHEXCOLOR(0Xef334f);
        stateStr = @"C2COrderStateAppeal".icanlocalized;
    }else if ([self.orderInfo.status isEqualToString:@"Completed"]) {
        self.stateLabel.textColor = UIColorMakeHEXCOLOR(0X19a143);
        stateStr = @"C2COrderStateCompleted".icanlocalized;
    }else if ([self.orderInfo.status isEqualToString:@"Cancelled"]) {
        stateStr = @"C2COrderStateCancelled".icanlocalized;
        self.stateLabel.textColor = UIColorMakeHEXCOLOR(0Xef334f);
    }
    self.stateLabel.text = stateStr;
    self.currencyLabel.text = orderInfo.virtualCurrency;
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:orderInfo.legalTender];
    self.symbolLabel.text = info.symbol;
    self.priceLabel.text = [orderInfo.unitPrice calculateByNSRoundDownScale:2].currencyString;
    self.updateTimeLabel.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"MM-dd HH:mm"];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[orderInfo.quantity calculateByNSRoundDownScale:2].currencyString,orderInfo.virtualCurrency];
    NSMutableAttributedString * countAmountAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",info.symbol,[orderInfo.totalCount calculateByNSRoundDownScale:2].currencyString]];
    [countAmountAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(info.symbol.length+1, [orderInfo.totalCount calculateByNSRoundDownScale:2].currencyString.length)];
    self.countAmountLabel.attributedText =  countAmountAtt;
    //如果购买的人和自己是同一个人
    if (orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        self.saleOrBuyLabel.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
        self.saleOrBuyLabel.textColor = UIColorThemeMainColor;
        self.serviceLabel.text = orderInfo.sellUser.nickname;
        NSNumber * count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:self.orderInfo.sellUser.userId c2cOrderId:self.orderInfo.orderId icanUserId:self.orderInfo.sellUser.uid];
        self.unReadLabel.text = count.stringValue;
        self.unReadLabel.hidden = count.integerValue==0;
    }else{

        self.saleOrBuyLabel.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
        self.saleOrBuyLabel.textColor = UIColorMake(239, 51, 79);
        self.serviceLabel.text = orderInfo.buyUser.nickname;
        NSNumber * count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:self.orderInfo.buyUser.userId c2cOrderId:self.orderInfo.orderId icanUserId:self.orderInfo.buyUser.uid];
        self.unReadLabel.text = count.stringValue;
        self.unReadLabel.hidden = count.integerValue==0;
    }
   
}
-(IBAction)stateAction{
    
}
-(IBAction)serviceAction{
    //如果购买的人和自己是同一个人说明订单是自己创建的
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.sellUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.sellUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [[AppDelegate shared] pushViewController:vc animated:YES];
    }else{
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.buyUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.buyUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [[AppDelegate shared] pushViewController:vc animated:YES];
    }
    
    
}


@end
