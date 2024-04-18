//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  C2CFlowsListTableViewCell.m
- Description:
- Function List:
*/
        

#import "C2CFlowsListTableViewCell.h"
@interface C2CFlowsListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *currencyImgView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
///付款人
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDetailLabel;
///收款人
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveDetailLabel;
///类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;
///时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;
///备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkDetailLabel;

@end
@implementation C2CFlowsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    self.payLabel.text = @"C2CFlowListPay".icanlocalized;
    self.receiveLabel.text = @"C2CFlowListReceive".icanlocalized;
    self.typeLabel.text = @"C2CFlowListPaytype".icanlocalized;
    self.timeLabel.text = @"C2CFlowListTime".icanlocalized;
    self.remarkLabel.text = @"C2CFlowListRemark".icanlocalized;
//    "C2CWalletTransfer"="转账";
//    "C2CWalletReceive"="收款";
//    "C2CFlowListPay"="付款方";
//    "C2CFlowListReceive"="收款方";
//    "C2CFlowListPaytype"="类型";
//    "C2CFlowListTime"="时间";
//    "C2CFlowListRemark"="备注";
//    "C2CFlowListNullRemark"="暂无备注";
}
-(void)setFlowsInfo:(C2CFlowsInfo *)flowsInfo{
    _flowsInfo = flowsInfo;
    CurrencyInfo * currencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:flowsInfo.currencyCode];
    [self.currencyImgView setImageWithString:currencyInfo.icon placeholder:nil];
    self.currencyLabel.text = currencyInfo.code;
    
    self.timeDetailLabel.text = [GetTime convertDateWithString:flowsInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    if (flowsInfo.remark) {
        self.remarkDetailLabel.text = flowsInfo.remark;
    }else{
        self.remarkDetailLabel.text = @"C2CFlowListNullRemark".icanlocalized;
    }
    NSMutableAttributedString * payDetailAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",UserInfoManager.sharedManager.numberId,UserInfoManager.sharedManager.nickname]];
    [payDetailAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(payDetailAtt.length- UserInfoManager.sharedManager.nickname.length, UserInfoManager.sharedManager.nickname.length)];
    [payDetailAtt addAttribute:NSForegroundColorAttributeName value:UIColorMakeHEXCOLOR(0X999999) range:NSMakeRange(payDetailAtt.length- UserInfoManager.sharedManager.nickname.length, UserInfoManager.sharedManager.nickname.length)];
   
    NSMutableAttributedString * receiveDetailAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",flowsInfo.simpleUserDTO.numberId,flowsInfo.simpleUserDTO.nickname]];
    
    [receiveDetailAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(receiveDetailAtt.length- flowsInfo.simpleUserDTO.nickname.length, flowsInfo.simpleUserDTO.nickname.length)];
    [receiveDetailAtt addAttribute:NSForegroundColorAttributeName value:UIColorMakeHEXCOLOR(0X999999) range:NSMakeRange(receiveDetailAtt.length- flowsInfo.simpleUserDTO.nickname.length, flowsInfo.simpleUserDTO.nickname.length)];
    self.amountLabel.text = [flowsInfo.amount calculateByNSRoundDownScale:2].currencyString;
    if ([flowsInfo.amount.stringValue containsString:@"-"] ) {
        self.payDetailLabel.attributedText = payDetailAtt ;
        self.receiveDetailLabel.attributedText = receiveDetailAtt ;
        self.amountLabel.textColor = UIColorMakeHEXCOLOR(0Xec2224);
    }else{
        self.payDetailLabel.attributedText = receiveDetailAtt ;
        self.receiveDetailLabel.attributedText = payDetailAtt ;
        self.amountLabel.textColor = UIColorMakeHEXCOLOR(0X191b1e);
    }
//    ExternalWithdraw 提现 QrcodePayFlow 二维码收款 TransferRecord 转账
    if ([flowsInfo.flowType isEqualToString:@"ExternalWithdraw"]) {
        self.typeDetailLabel.text = @"Withdraw".icanlocalized;
    }else if ([flowsInfo.flowType isEqualToString:@"QrcodePayFlow"]) {
        self.typeDetailLabel.text = @"QRCodeCollection".icanlocalized;
    }else if ([flowsInfo.flowType isEqualToString:@"TransferRecord"]) {
        self.typeDetailLabel.text = @"C2CWalletTransfer".icanlocalized;
    }
    
    
}


@end
