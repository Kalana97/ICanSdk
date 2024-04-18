//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/11/2019
- File name:  WithdrawRecordListTableViewCell.m
- Description:
- Function List:
*/
#import "WithdrawRecordListTableViewCell.h"

@implementation WithdrawRecordListTableViewCell
-(void)setWithdrawRecordInfo:(WithdrawRecordInfo *)withdrawRecordInfo{
    if ([withdrawRecordInfo.withdrawStatus isEqualToString:@"Processing"]) {
         self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Withdraw", 提现),NSLocalizedString(@"Processing", 处理中)];
        self.moneyLabel.textColor=UIColor102Color;
    }else if ([withdrawRecordInfo.withdrawStatus isEqualToString:@"Success"]){
          self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Withdraw", 提现),NSLocalizedString(@"Success", 成功)];
        self.moneyLabel.textColor=UIColorThemeMainColor;
    }else if([withdrawRecordInfo.withdrawStatus isEqualToString:@"Fail"]){
        self.statusLabel.text=[NSString stringWithFormat:@"%@-%@-%@",NSLocalizedString(@"Withdraw", 提现),NSLocalizedString(@"fail", 失败),withdrawRecordInfo.reason];
        self.moneyLabel.textColor=UIColor244RedColor;
    }else if([withdrawRecordInfo.withdrawStatus isEqualToString:@"AuditPassed"]){
        self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Withdraw", 提现),@"AuditSuccess".icanlocalized];;
        
        self.moneyLabel.textColor=UIColor102Color;
    }else if([withdrawRecordInfo.withdrawStatus isEqualToString:@"PrePaying"]){
        self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Withdraw", 提现),@"Paying".icanlocalized];
        self.moneyLabel.textColor=UIColor102Color;
    }else if([withdrawRecordInfo.withdrawStatus isEqualToString:@"OfflinePaying"]){
        self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Withdraw", 提现),@"OfflinePaymentProcessing".icanlocalized];
        self.moneyLabel.textColor=UIColor102Color;
    }
    _withdrawRecordInfo=withdrawRecordInfo;
   
    self.moneyLabel.text=[NSString stringWithFormat:@"%.2f",[withdrawRecordInfo.amount doubleValue]];
    self.timeLabel.text=withdrawRecordInfo.createTime;
}
-(void)setBillInfo:(BillInfo *)billInfo{
    _billInfo=billInfo;
}
-(void)setRechargeRecordInfo:(RechargeRecordInfo *)rechargeRecordInfo{
    _rechargeRecordInfo=rechargeRecordInfo;
    self.timeLabel.text=rechargeRecordInfo.createTime;
    self.moneyLabel.text=[NSString stringWithFormat:@"%.2f",[rechargeRecordInfo.amount floatValue]];
    if ([rechargeRecordInfo.rechargeStatus isEqualToString:@"Processing"]) {
            self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Top Up", 提现),NSLocalizedString(@"Processing", 处理中)];
           self.moneyLabel.textColor=UIColor102Color;
       }else if ([rechargeRecordInfo.rechargeStatus isEqualToString:@"Success"]){
             self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Top Up", 提现),NSLocalizedString(@"Success", 成功)];
           self.moneyLabel.textColor=UIColorThemeMainColor;
       }else{
             self.statusLabel.text=[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Top Up", 提现),NSLocalizedString(@"fail", 失败)];
           self.moneyLabel.textColor=UIColorMake(244, 81, 105);
       }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusLabel.textColor=UIColor252730Color;
    self.timeLabel.textColor=UIColor153Color;
    self.moneyLabel.textColor=UIColor153Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
