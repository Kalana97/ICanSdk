//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 27/4/2022
- File name:  C2CBillDetailViewController.m
- Description:
- Function List:
*/
        

#import "C2CBillDetailViewController.h"
#import "UserInfoManager.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif

@interface C2CBillDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *TransferLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *oneDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *twoDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *threeDetailLab;

@property (weak, nonatomic) IBOutlet UIStackView *fourStackView;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UILabel *fourDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *fourCopyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fourCopyIcon;

@property (weak, nonatomic) IBOutlet UILabel *fiveLab;
@property (weak, nonatomic) IBOutlet UILabel *fiveDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *fiveCopyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fiveCopyIcon;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIStackView *sixStackView;
@property (weak, nonatomic) IBOutlet UILabel *sixLab;
@property (weak, nonatomic) IBOutlet UILabel *sixDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *sixCopyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sixCopyIcon;
@property (weak, nonatomic) IBOutlet UIStackView *qrStackView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImg;
@property (weak, nonatomic) IBOutlet UILabel *queryLinkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconCopy;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackCopy;

@property (weak, nonatomic) IBOutlet UIStackView *sevenStackView;
@property (weak, nonatomic) IBOutlet UILabel *sevenLab;
@property (weak, nonatomic) IBOutlet UILabel *sevenDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *sevenCopyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sevenCopyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImg;

@property (weak, nonatomic) IBOutlet UILabel *eightLab;
@property (weak, nonatomic) IBOutlet UILabel *eightDetailLab;
@property (weak, nonatomic) IBOutlet UIStackView *eightStack;
@property(nonatomic, copy) NSString *qrCode;

@end

@implementation C2CBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.title = self.TransferLabel.text;
    self.bgView.hidden = YES;
    /**
     ExternalWithdraw => 提现  QrcodePayFlow => 二维码收款 TransferRecord => 转账 AdOrder => c2c交易 FundsTransfer => 划转  ExternalRecharge外网充值
     ExtPaymentOrder 第三方代付 OfflineRecharge->线下充值 ExtPaymentOrderRefund->第三方代付退款
     */
    self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = self.sevenCopyBtn.hidden = self.sevenCopyIcon.hidden = YES;
    self.eightDetailLab.hidden = self.eightLab.hidden = YES;
    
    if ([self.c2cFlowsInfo.flowType isEqualToString:@"ExternalWithdraw"]) {
        [self getC2CFlowsExternalWithdrawDetailRequest];
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"QrcodePayFlow"]) {
        [self getC2CFlowsQrcodePayFlowDetailRequest];
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"TransferRecord"]) {
        [self getC2CFlowsTransferRecordDetailRequest];
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"AdOrder"]) {
        [self getC2CFlowsAdOrderDetailRequest];
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"FundsTransfer"]) {
        [self setDataManualy:self.c2cFlowsInfo];
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"ExternalRecharge"]){
        [self getC2CFlowsExternalRechargeDetailRequest ];
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrder"]){
        [self setDataManualy:self.c2cFlowsInfo];
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"OfflineRecharge"]){
        
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrderRefund"]){
        [self getC2CFlowsExternalRefundDetailRequest];
    }else if ([self.c2cFlowsInfo.flowType isEqualToString:@"CurrencyExchange"]){
        [self getC2CFlowsCurrencyExchangeDetailRequest];
    }
    if(self.isFromOrgDetail){
        [self setOrgTransactionDetails:self.orgTransactionModel];
    }
}

-(void)setOrgTransactionDetails: (TransactionDataContentResponse *)model{
    self.bgView.hidden = NO;
    self.title = [self getTransaferType:model.transactionType];
    self.amountLab.text = [NSString stringWithFormat:@"%@ %@",[self getConvertedBalance:model.amount],model.actualUnit];
    if(self.isApproved){
        self.statusLabel.text = @"APPROVED".icanlocalized;
        self.amountLab.textColor = UIColor.greenColor;
        self.statusLabel.textColor = UIColor.greenColor;
        self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
    }else{
        self.statusLabel.text = @"REJECTED".icanlocalized;
        self.amountLab.textColor = UIColor.redColor;
        self.statusLabel.textColor = UIColor.redColor;
        self.statusIcon.image = [UIImage imageNamed:@"rej_icon"];
    }
    
    self.oneLab.text = @"From".icanlocalized;
    self.oneDetailLab.text = model.nickName;
    
    self.twoLab.text = @"Amount".icanlocalized;
    self.twoDetailLab.text = [NSString stringWithFormat:@"%@ %@",[self getConvertedBalance:model.amount],model.actualUnit];
    
    self.threeLab.text = @"To".icanlocalized;
    self.threeDetailLab.text = model.to;
    
    self.fourLab.text = @"Type".icanlocalized;
    self.fourDetailLab.text = [self getTransaferType:model.transactionType];
    self.fourCopyIcon.hidden = self.fourCopyBtn.hidden = YES;
    
    self.fiveLab.text = @"Date & Time".icanlocalized;
    self.fiveDetailLab.text = [GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",model.time] dateFormmate:@"dd/MM/yyyy HH:mm:ss"];
    self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
    
    self.sixStackView.hidden = self.sevenStackView.hidden = self.eightStack.hidden = YES;
}

-(NSString *)getTransaferType:(NSString *)val{
    if([val isEqualToString:@"RED_PACKET"]){
        return @"chatView.function.redPacket".icanlocalized;
    }else if([val isEqualToString:@"TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"C2C_TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"C2C_WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"C2C_UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"P2P"]){
        return @"C2CTransaction".icanlocalized;
    }else{
        return @"";
    }
}

-(void)setDataManualy:(C2CFlowsInfo *)modelData{
    self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
    self.bgView.hidden = NO;
    self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
    self.TransferLabel.text = @"Thirdpartypayment".icanlocalized;
    self.amountLab.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    self.amountLab.text = [@"" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [modelData.amount calculateByNSRoundDownScale:8].currencyString,modelData.currencyCode]];
    self.fourStackView.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
    self.eightDetailLab.hidden = self.eightLab.hidden = self.eightDetailLab.hidden = NO;
    self.oneLab.text = @"Order Number".icanlocalized;
    self.oneDetailLab.text = modelData.orderId;
    self.twoLab.text = @"Currency".icanlocalized;
    self.twoDetailLab.text = modelData.currencyCode;
    self.threeLab.text = @"C2CWithdrawAmounttoAccount".icanlocalized;
    self.threeDetailLab.text = [@"" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [modelData.amount calculateByNSRoundDownScale:8].currencyString,modelData.currencyCode]];
    self.fiveDetailLab.text = [GetTime convertDateWithString:modelData.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
    self.sixStackView.hidden = YES;
    self.sevenStackView.hidden = YES;
    self.eightLab.text = @"C2CFlowListRemark".icanlocalized;
    if(self.isWalletSwap == YES){
        self.eightDetailLab.text = @"C2CTransfer".icanlocalized;
    }else{
        self.eightDetailLab.text = @"find.listView.cell.utilityPayment".icanlocalized;
    }
}
///Get the details of the insertion order to get the c2c flow
-(void)getC2CFlowsAdOrderDetailRequest{
    GetC2CFlowsAdOrderDetailRequest * request = [GetC2CFlowsAdOrderDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/adOrder/%@",self.c2cFlowsInfo.orderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo* orderInfo) {
        self.bgView.hidden = NO;
        self.amountLab.text = [NSString stringWithFormat:@"%@ %@",orderInfo.virtualCurrency,[orderInfo.quantity calculateByNSRoundDownScale:8].currencyString];
        self.oneLab.text = @"TotalAmount".icanlocalized;
        CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:orderInfo.legalTender];
        self.oneDetailLab.text = [NSString stringWithFormat:@"%@ %@",info.symbol,orderInfo.totalCount.stringValue.currencyString];
        self.twoLab.text = @"HandlingFeeRate".icanlocalized;
        self.twoDetailLab.text = [NSString stringWithFormat:@"%@%%",[[orderInfo.handlingFee decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] calculateByNSRoundDownScale:2].currencyString];
        self.threeLab.text = @"c2cWalletDetailOrderNumber".icanlocalized;
        self.threeDetailLab.text = orderInfo.orderId;
        self.fourLab.text = @"Transaction time".icanlocalized;
        self.fourDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.sixLab.text = @"TransactionType".icanlocalized;
        //如果购买的人和自己是同一个人 那么这个是一个购买订单
        if (orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
            self.sixDetailLab.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
            self.fiveLab.text = @"C2COptionalSaleViewControllerNicknameTitleLabelSell".icanlocalized;
            self.fiveDetailLab.text = orderInfo.sellUser.nickname;
        }else{
            self.sixDetailLab.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
            self.fiveLab.text = @"c2cWalletDetailBuyerNickname".icanlocalized;
            self.fiveDetailLab.text = orderInfo.buyUser.nickname;
        }
        self.sevenLab.hidden = self.sevenStackView.hidden = YES;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}
///获取c2c流水的第三方支付详情
-(void)getC2CFlowsExtPayDetailRequest{
    
}
/**
 获取c2c流水的提现详情 GetC2CFlowsExternalWithdrawDetailInfo
 GET
 /api/flows/externalWithdraw/{orderId}
 */
-(void)getC2CFlowsExternalWithdrawDetailRequest{
    
    GetC2CFlowsExternalWithdrawDetailRequest * request = [GetC2CFlowsExternalWithdrawDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/externalWithdraw/%@",self.c2cFlowsInfo.orderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[GetC2CFlowsExternalWithdrawDetailInfo class] contentClass:[GetC2CFlowsExternalWithdrawDetailInfo class] success:^(GetC2CFlowsExternalWithdrawDetailInfo* orderInfo) {
        
        if([orderInfo.orderStatus isEqual:@"SUCCESS"]){
            
            self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
            
            self.amountLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
            
            self.twoDetailLab.textColor = self.statusLabel.textColor = [UIColor colorWithRed:(52/255.0) green:(199/255.0) blue:(89/255.0) alpha:1];
            
            self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
            self.twoDetailLab.text = @"Success".icanlocalized;
            
            
        }else if ([orderInfo.orderStatus isEqual:@"PROCESSING"]){
       
            self.statusIcon.image = [UIImage imageNamed:@"processing_icon"];
            
            self.amountLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
            
            self.twoDetailLab.textColor = self.statusLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(153/255.0) blue:(0/255.0) alpha:1];
            
            self.statusLabel.text = @"Network Transfer Processing".icanlocalized;
            self.twoDetailLab.text = @"Withdrawal Processing".icanlocalized;
            
            
        }else if ([orderInfo.orderStatus isEqual:@"FAILED"]){
            
            self.statusIcon.image = [UIImage imageNamed:@"icon_uitlity_recharge_fail"];
            
            self.amountLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
            
            self.twoDetailLab.textColor = self.statusLabel.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            
            self.statusLabel.text = @"Network Transfer Failed".icanlocalized;
            self.twoDetailLab.text = @"fail".icanlocalized;
            
        }
        
        self.bgView.hidden = NO;
        self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = self.sevenCopyBtn.hidden = self.sevenCopyIcon.hidden = self.sevenStackView.hidden = self.sixStackView.hidden = NO;
        self.amountLab.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        self.eightDetailLab.hidden = self.eightLab.hidden = NO;
        self.oneLab.text = @"OrderID".icanlocalized;
        self.oneDetailLab.text = orderInfo.orderId;
        self.TransferLabel.text = [NSString stringWithFormat:@"%@ %@", @"Withdraw".icanlocalized,orderInfo.channelCode];
        self.twoLab.text = @"C2CSaleSuccessViewControllerTitle".icanlocalized;
        if (!orderInfo.confirm) {
            self.fourLab.hidden = self.fourStackView.hidden = YES;
        }
        self.threeLab.text = @"WithdrawalTime".icanlocalized;
        self.threeDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.fourLab.text = @"AccountTime".icanlocalized;
        self.fourDetailLab.text = [GetTime convertDateWithString:orderInfo.confirmTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.fiveLab.text = @"CollecteAddress".icanlocalized;
        self.fiveDetailLab.text = orderInfo.toAddress;
        self.sixLab.text = @"PaymentAddress".icanlocalized;
        self.sixDetailLab.text = orderInfo.fromAddress;
        self.sevenLab.text = @"Hash".icanlocalized;
        self.sevenDetailLab.text = orderInfo.transactionHash;
        if ([orderInfo.channelCode containsString:@"TRC"]) {
            self.bottomView.hidden = NO;
            self.lowerImg.image = [UIImage imageNamed:@"icon_tronscan"];
        }
        if ([orderInfo.channelCode containsString:@"ERC"]) {
            self.bottomView.hidden = NO;
            self.lowerImg.image = [UIImage imageNamed:@"icon_etherscan"];
        }
        NSString *qrcode;
        if ([orderInfo.channelCode containsString:@"TRC"]) {
            qrcode = [NSString stringWithFormat:@"%@%@", @"https://tronscan.org/#/transaction/", orderInfo.transactionHash];
            
        }else if([orderInfo.channelCode containsString:@"ERC"]){
            qrcode = [NSString stringWithFormat:@"%@%@", @"https://etherscan.io/tx/", orderInfo.transactionHash];
        }
        UIImage *qrImage = [UIImage dm_QRImageWithString:qrcode size:ScreenWidth-80];
        self.qrStackView.hidden = NO;
        self.stackCopy.hidden = NO;
        self.qrImg.image = qrImage;
        self.qrCode = qrcode;
        self.queryLinkLabel.text = @"Copy link".icanlocalized;
        self.bottomLabel.text = @"View details".icanlocalized;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        UITapGestureRecognizer *bottomViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped:)];
        [self.iconCopy addGestureRecognizer:tapGesture];
        [self.bottomView addGestureRecognizer:bottomViewtapGesture];
        self.iconCopy.userInteractionEnabled = YES;
        self.bottomView.userInteractionEnabled = YES;
        
        self.eightLab.text = @"Fees".icanlocalized;
        self.eightDetailLab.text = [NSString stringWithFormat:@"%@ %@", [orderInfo.handlingFeeMoney calculateByNSRoundDownScale:2].currencyString,orderInfo.currencyCode];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}
/**
 获取c2c流水的收款详情 C2CQrcodePayFlowDetailInfo
 GET
 /api/flows/qrcodePayFlow/{orderId}
 */
-(void)getC2CFlowsQrcodePayFlowDetailRequest{
    GetC2CFlowsQrcodePayFlowDetailRequest * request = [GetC2CFlowsQrcodePayFlowDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/qrcodePayFlow/%@",self.c2cFlowsInfo.orderId];
    
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CQrcodePayFlowDetailInfo class] contentClass:[C2CQrcodePayFlowDetailInfo class] success:^(C2CQrcodePayFlowDetailInfo* orderInfo) {
        
        self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
        
        self.bgView.hidden = NO;
        self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
        self.TransferLabel.text = @"QR Pay".icanlocalized;
        
        if(orderInfo.receiveUid == [UserInfoManager sharedManager].userId) {
            self.amountLab.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
            self.fiveLab.text = @"C2CFlowListPay".icanlocalized;
            self.fiveDetailLab.text = orderInfo.payUid;
        }else {
            self.amountLab.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
            self.amountLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
            self.fiveLab.text = @"C2CFlowListReceive".icanlocalized;
            self.fiveDetailLab.text = orderInfo.receiveUid;
        }
        
        self.fourStackView.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
        self.eightDetailLab.hidden = self.eightLab.hidden = self.eightDetailLab.hidden = NO;
        self.oneLab.text = @"Order Number".icanlocalized;
        self.oneDetailLab.text = orderInfo.orderId;
        self.twoLab.text = @"C2CWithdrawAmounttoAccount".icanlocalized;
        self.twoDetailLab.text =  [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:2].currencyString,orderInfo.currencyCode]];
        
        self.threeLab.text = @"C2CFlowListTime".icanlocalized;
        self.threeDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.sixStackView.hidden = self.sevenLab.hidden = YES;
        self.sevenStackView.hidden = self.sevenLab.hidden = YES;
        self.eightLab.text = @"C2CFlowListRemark".icanlocalized;
        if(orderInfo.remark == nil) {
            self.eightDetailLab.text = @"--";
        }else {
            self.eightDetailLab.text = orderInfo.remark;
        }
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}


-(void)getC2CFlowsTransferRecordDetailRequest{
        
    self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
        
    self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
    self.TransferLabel.text = @"chatView.function.transfer".icanlocalized;
        
    self.bgView.hidden = NO;
    self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = NO;
    
    if([self.c2cFlowsInfo.amount floatValue] > 0) {
        self.amountLab.textColor = UIColorSystemGreen;
        self.amountLab.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [self.c2cFlowsInfo.amount calculateByNSRoundDownScale:8].currencyString,self.c2cFlowsInfo.currencyCode]];
        self.threeLab.text = @"SenderID".icanlocalized;
        self.fourLab.text = @"SenderName".icanlocalized;
    }else{
        self.amountLab.textColor = UIColorSystemRed;
        self.amountLab.text = [NSString stringWithFormat:@"%@ %@", [self.c2cFlowsInfo.amount calculateByNSRoundDownScale:8].currencyString,self.c2cFlowsInfo.currencyCode];
        self.threeLab.text = @"ReceiverID".icanlocalized;
        self.fourLab.text = @"ReceiverName".icanlocalized;
    }
        
    self.oneLab.text = @"OrderID".icanlocalized;
    self.oneDetailLab.text = self.c2cFlowsInfo.orderId;
    self.twoLab.text = @"TransferTime".icanlocalized;
    self.twoDetailLab.text = [GetTime convertDateWithString:self.c2cFlowsInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
    
    self.threeDetailLab.text = self.c2cFlowsInfo.simpleUserDTO.numberId;
    self.fourDetailLab.text = self.c2cFlowsInfo.simpleUserDTO.nickname;
    self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = YES;
    self.fiveLab.hidden = YES;
    self.fiveDetailLab.hidden = YES;
    self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
    self.sixLab.hidden = YES;
    self.sixDetailLab.hidden = YES;
    self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = YES;
    self.sevenStackView.hidden = self.sevenLab.hidden = self.sevenCopyBtn.hidden = self.sevenCopyIcon.hidden = YES;
    self.eightDetailLab.hidden = self.eightLab.hidden = YES;
        
}

-(void)getC2CFlowsExtPaymentOrderDetailRequest{
    GetC2CFlowsExtPayDetailRequest * request = [GetC2CFlowsExtPayDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/extPay/%@",self.c2cFlowsInfo.orderId];
    
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[GetC2CFlowsExternalPayDetailInfo class] contentClass:[GetC2CFlowsExternalPayDetailInfo class] success:^(GetC2CFlowsExternalPayDetailInfo* orderInfo) {
        
        self.statusIcon.image = [UIImage imageNamed:@"icon_c2c_confirm_green"];
        
        self.bgView.hidden = NO;
        self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
        self.TransferLabel.text = @"Thirdpartypayment".icanlocalized;
        
        
        self.amountLab.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        self.amountLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
        
//        self.fiveLab.text = @"C2CFlowListReceive".icanlocalized;
//        self.fiveDetailLab.text = orderInfo.receiveUid;
        
        
        self.fourStackView.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
        self.eightDetailLab.hidden = self.eightLab.hidden = self.eightDetailLab.hidden = NO;
        self.oneLab.text = @"Order Number".icanlocalized;
        self.oneDetailLab.text = orderInfo.merchantOrderId;
        self.twoLab.text = @"Currency".icanlocalized;
        self.twoDetailLab.text = orderInfo.currencyCode;
        
        
        self.threeLab.text = @"C2CWithdrawAmounttoAccount".icanlocalized;
        self.threeDetailLab.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:2].currencyString,orderInfo.currencyCode]];
        
        
        self.sixStackView.hidden = self.sixLab.hidden = self.sixDetailLab.hidden = NO;
        self.sixLab.text = @"MerchantID".icanlocalized;
        self.sixDetailLab.text = orderInfo.appId;
        
        self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = self.sevenCopyBtn.hidden = self.sevenCopyIcon.hidden = YES;
        
        self.sevenStackView.hidden = self.sevenLab.hidden = self.sevenDetailLab.hidden = NO;
        
        self.sevenLab.text = @"C2CFlowListTime".icanlocalized;
        self.eightDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        
        self.eightLab.text = @"C2CFlowListRemark".icanlocalized;
        if(orderInfo.detail == nil) {
            self.eightDetailLab.text = @"--";
        }else {
            self.eightDetailLab.text = orderInfo.detail;
        }
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}

/**
 账单外网充值流水详情 GetC2CFlowsExternalRechargeDetailInfo
 GET
 /api/flows/externalRecharge/{orderId}
 */
-(void)getC2CFlowsExternalRechargeDetailRequest{
    
    GetC2CFlowsExternalRechargeDetailRequest * request = [GetC2CFlowsExternalRechargeDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/externalRecharge/%@",self.c2cFlowsInfo.orderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[GetC2CFlowsExternalRechargeDetailInfo class] contentClass:[GetC2CFlowsExternalRechargeDetailInfo class] success:^(GetC2CFlowsExternalRechargeDetailInfo* orderInfo) {
  
        self.statusIcon.image=[UIImage imageNamed:@"icon_c2c_confirm_green"];
        
        self.statusLabel.text = @"Transaction Succeeded".icanlocalized;
        self.TransferLabel.text = [NSString stringWithFormat:@"%@ %@", @"Network Transfer".icanlocalized, orderInfo.channelCode];
        self.bgView.hidden = NO;
        self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = NO;
        self.amountLab.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%@ %@", [orderInfo.amount calculateByNSRoundDownScale:8].currencyString,orderInfo.currencyCode]];
        self.oneLab.text = @"OrderID".icanlocalized;
        self.oneDetailLab.text = orderInfo.orderId;
        self.twoLab.text = @"RechargeTime".icanlocalized;
        self.twoDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.threeLab.text = @"RechargeID".icanlocalized;
        self.threeDetailLab.text = orderInfo.rechargeId;
        self.fourLab.text = @"PaymentAddress".icanlocalized;
        self.fourDetailLab.text = orderInfo.fromAddress;
        self.fiveLab.text = @"CollecteAddress".icanlocalized;
        self.fiveDetailLab.text = orderInfo.toAddress;
        self.sixLab.text = @"Hash".icanlocalized;
        self.sixDetailLab.text = orderInfo.transactionHash;
        if ([orderInfo.channelCode containsString:@"TRC"]) {
            self.bottomView.hidden = NO;
            self.lowerImg.image = [UIImage imageNamed:@"icon_tronscan"];
        }
        if ([orderInfo.channelCode containsString:@"ERC"]) {
            self.bottomView.hidden = NO;
            self.lowerImg.image = [UIImage imageNamed:@"icon_etherscan"];
        }
        NSString *qrcode;
        if ([orderInfo.channelCode containsString:@"TRC"]) {
            qrcode = [NSString stringWithFormat:@"%@%@", @"https://tronscan.org/#/transaction/", orderInfo.transactionHash];
            
        }else if([orderInfo.channelCode containsString:@"ERC"]){
            qrcode = [NSString stringWithFormat:@"%@%@", @"https://etherscan.io/tx/", orderInfo.transactionHash];
        }
        UIImage *qrImage = [UIImage dm_QRImageWithString:qrcode size:ScreenWidth-80];
        self.qrStackView.hidden = NO;
        self.stackCopy.hidden = NO;
        self.qrImg.image = qrImage;
        self.qrCode = qrcode;
        self.queryLinkLabel.text = @"Copy link".icanlocalized;
        self.bottomLabel.text = @"View details".icanlocalized;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        UITapGestureRecognizer *bottomViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped:)];
        [self.iconCopy addGestureRecognizer:tapGesture];
        [self.bottomView addGestureRecognizer:bottomViewtapGesture];
        self.iconCopy.userInteractionEnabled = YES;
        self.bottomView.userInteractionEnabled = YES;
        self.sevenStackView.hidden = self.sevenLab.hidden = YES;
        self.eightDetailLab.hidden = self.eightLab.hidden = YES;
       
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}
- (void)bottomViewTapped:(UIGestureRecognizer *)gesture {
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
    View.isCommon = YES;
    View.walletUrlString = self.qrCode;
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

/**
  退款详情
  GET
  /api/flows/extPayRefund/{orderId}
 @interface GetC2CFlowsExternalRefundDetailRequest : C2CBaseRequest
 @end
 */
-(void)getC2CFlowsExternalRefundDetailRequest{
    GetC2CFlowsExternalRefundDetailRequest * request = [GetC2CFlowsExternalRefundDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/flows/extPayRefund/%@",self.c2cFlowsInfo.orderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[GetC2CFlowsExternalRefundDetailInfo class] contentClass:[GetC2CFlowsExternalRefundDetailInfo class] success:^(GetC2CFlowsExternalRefundDetailInfo* orderInfo) {
        self.bgView.hidden = NO;
        self.amountLab.text = [NSString stringWithFormat:@"%@ %@",orderInfo.actualCurrencyCode,[orderInfo.actualAmount calculateByNSRoundDownScale:8].currencyString];
        self.oneLab.text = @"RefundTime".icanlocalized;
        self.oneDetailLab.text = [GetTime convertDateWithString:orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
        self.twoLab.text = @"MerchantID".icanlocalized;
        self.twoDetailLab.text = orderInfo.merchantOrderId;
        self.threeLab.text = @"ReasonForRefund".icanlocalized;
        self.threeDetailLab.text = orderInfo.refundReason;
        self.fourLab.text = @"OriginalOrderID".icanlocalized;
        self.fourDetailLab.text = orderInfo.refundTransactionId;
        self.fiveLab.text = @"RefundOrderID".icanlocalized;
        self.fiveDetailLab.text = orderInfo.transactionId;
        self.sixLab.hidden = self.sixStackView.hidden = self.sevenLab.hidden = self.sevenStackView.hidden = YES;
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.bgView.hidden = YES;
    }];
}

-(void)getC2CFlowsCurrencyExchangeDetailRequest{
    
    self.statusIcon.image=[UIImage imageNamed:@"icon_c2c_confirm_green"];
    
    self.statusLabel.text = @"ExchangeSucceeded".icanlocalized;
    self.TransferLabel.text = @"CurrencyExchange".icanlocalized;
    
    NSArray *fromToCurrency = [self.c2cFlowsInfo.remark componentsSeparatedByString:@" to "];
    
    self.bgView.hidden = NO;
    self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = NO;
    self.amountLab.text = [@"+" stringByAppendingString:fromToCurrency[1]];
    
    self.oneLab.text = @"OrderID".icanlocalized;
    self.oneDetailLab.text = self.c2cFlowsInfo.orderId;
    self.twoLab.text =  @"ExchangeTime".icanlocalized;
    self.twoDetailLab.text = [GetTime convertDateWithString:self.c2cFlowsInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
    self.threeLab.hidden = YES;
    self.threeDetailLab.hidden = YES;
    self.fourLab.text = @"PaymentAddress".icanlocalized;
    self.fourDetailLab.textColor = UIColorSystemRed;
    self.fourDetailLab.text = [@"-" stringByAppendingString:fromToCurrency[0]];
    self.fourCopyBtn.hidden = self.fourCopyIcon.hidden = YES;
    self.fiveLab.text = @"CollecteAddress".icanlocalized;
    self.fiveDetailLab.textColor = UIColorSystemGreen;
    self.fiveDetailLab.text = [@"+" stringByAppendingString:fromToCurrency[1]];
    self.fiveCopyBtn.hidden = self.fiveCopyIcon.hidden = YES;
    self.sixLab.hidden = YES;
    self.sixDetailLab.hidden = YES;
    self.sixCopyBtn.hidden = self.sixCopyIcon.hidden = YES;
    self.sevenStackView.hidden = self.sevenLab.hidden = YES;
    self.eightDetailLab.hidden = self.eightLab.hidden = YES;
}

- (void)imageTapped:(UIGestureRecognizer *)gesture {
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.qrCode;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)fourCopyBtnAction:(id)sender {
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.fourDetailLab.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)fiveCopyBtnAction:(id)sender {
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.fiveDetailLab.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)sixCopyBtnAction:(id)sender {
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.sixDetailLab.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)sevenCopyBtnAction:(id)sender {
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.sevenDetailLab.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

-(NSString *)getConvertedBalance:(double)amt{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *formattedString = [numberFormatter stringFromNumber:@(amt)];
    return formattedString;
}
@end
