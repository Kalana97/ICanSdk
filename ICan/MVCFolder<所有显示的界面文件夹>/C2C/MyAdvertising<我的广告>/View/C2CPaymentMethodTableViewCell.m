//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/11/2021
 - File name:  C2CPaymentMethodTableViewCell.m
 - Description:
 - Function List:
 */


#import "C2CPaymentMethodTableViewCell.h"
#import "YBImageBrowerTool.h"
@interface C2CPaymentMethodTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIView *depositBankBgView;
@property (weak, nonatomic) IBOutlet UILabel *depositBankLabel;


@property (weak, nonatomic) IBOutlet UIView *branchBankBgView;
@property (weak, nonatomic) IBOutlet UILabel *branchBankLabel;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;

@property (weak, nonatomic) IBOutlet UIView *qrcodeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewLeadingConstraint;
@end
@implementation C2CPaymentMethodTableViewCell
- (IBAction)rightBtnAction:(id)sender {
    !self.rightBtnBlock?:self.rightBtnBlock();
}
-(void)setCellType:(enum C2CPaymentMethodTableViewCellType)cellType{
    switch (cellType) {
        case C2CPaymentMethodTableViewCellTypeMineList:{
            self.stackViewLeadingConstraint.constant = 20;
            self.stackViewTrailingConstraint.constant = 20;
            self.rightBtn.hidden = YES;
            [self.rightBtn setBackgroundImage:UIImageMake(@"icon_c2c_paymethod_edit") forState:UIControlStateNormal];
        }
            
            break;
        case C2CPaymentMethodTableViewCellTypePublishAdvert:{
            self.rightBtn.hidden = NO;
            [self.rightBtn setBackgroundImage:UIImageMake(@"icon_chat_delete_g") forState:UIControlStateNormal];
        }
            break;
        case C2CPaymentMethodTableViewCellTypeSelectMethodPopView:{
            self.rightBtn.hidden = YES;
            
        }
            break;
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showReceiveQRcode)];
    [self.qrCodeImageView addGestureRecognizer:tap];
    
}
-(void)showReceiveQRcode{
    YBImageBrowerTool * tool = [[YBImageBrowerTool alloc]init];
    [tool showC2CQrCodeImageWith:self.paymentMethodInfo.qrCode];
}
-(void)setPaymentMethodInfo:(C2CPaymentMethodInfo *)paymentMethodInfo{
    _paymentMethodInfo = paymentMethodInfo;
    self.branchBankBgView.hidden = !(paymentMethodInfo.branch.length>0);
    self.depositBankBgView.hidden = !(paymentMethodInfo.bankName.length>0);
    NSArray * nameItems = [paymentMethodInfo.name componentsSeparatedByString:@" "];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nameItems.lastObject,nameItems.firstObject];
    
    if(paymentMethodInfo.account){
        self.accountLabel.text = paymentMethodInfo.account;
        
    }else{
        if(self.isHashShows){ 
            NSString *address = paymentMethodInfo.address;
            for (int i = 0; i < address.length / 2 ; i++) {
                if (![[address substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                    NSRange range = NSMakeRange(i, 1);
                    address = [address stringByReplacingCharactersInRange:range withString:@"*"];
                }
            }
            self.accountLabel.text = address;
        }else{
            self.accountLabel.text = paymentMethodInfo.address;
        }
    }
    //"C2CAllTitle"="全部";
    //"C2CBankCard"="银行卡";
    //"C2CWeChat"="微信";
    //"C2CAlipay"="支付宝";
    if ([paymentMethodInfo.paymentMethodType isEqualToString:@"BankTransfer"]) {
        self.qrcodeBgView.hidden = YES;
        self.payTypeLabel.text = @"C2CBankCard".icanlocalized;
        self.leftLineView.backgroundColor = UIColorMakeHEXCOLOR(0Xf58220);
    }else if([paymentMethodInfo.paymentMethodType isEqualToString:@"Wechat"]) {
        if (paymentMethodInfo.qrCode) {
            self.qrcodeBgView.hidden = NO;
            [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:paymentMethodInfo.qrCode]];
        }else{
            self.qrcodeBgView.hidden = YES;
        }
        self.payTypeLabel.text = @"C2CWeChat".icanlocalized;
        self.leftLineView.backgroundColor = UIColorMakeHEXCOLOR(0X45b97c);
    }else if([paymentMethodInfo.paymentMethodType isEqualToString:@"AliPay"]) {
        self.payTypeLabel.text = @"C2CAlipay".icanlocalized;
        self.leftLineView.backgroundColor = UIColorMakeHEXCOLOR(0X2a5caa);
        if (paymentMethodInfo.qrCode) {
            self.qrcodeBgView.hidden = NO;
            [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:paymentMethodInfo.qrCode]];
        }else{
            self.qrcodeBgView.hidden = YES;
        }
    }
    
    else if([paymentMethodInfo.paymentMethodType isEqualToString:@"Cash"]) {
        self.payTypeLabel.text = @"Cash".icanlocalized;
        self.leftLineView.backgroundColor = UIColorMakeHEXCOLOR(0X2a5caa);
        if (paymentMethodInfo.qrCode) {
            self.qrcodeBgView.hidden = NO;
            [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:paymentMethodInfo.qrCode]];
        }else{
            self.qrcodeBgView.hidden = YES;
        }
    }
    
    self.branchBankLabel.text= paymentMethodInfo.branch;
    self.depositBankLabel.text = paymentMethodInfo.bankName;
}

@end
