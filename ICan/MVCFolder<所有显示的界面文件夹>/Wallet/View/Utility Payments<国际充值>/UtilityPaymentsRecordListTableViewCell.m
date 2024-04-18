
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/6/2021
- File name:  UtilityPaymentsRecordListTableViewCell.m
- Description:
- Function List:
*/
        

#import "UtilityPaymentsRecordListTableViewCell.h"

@interface UtilityPaymentsRecordListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;


@end

@implementation UtilityPaymentsRecordListTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.typeImgView layerWithCornerRadius:45/2 borderWidth:1 borderColor:UIColorMake(235, 234, 234)];
}
#pragma mark - Setter
-(void)setDialogOrderInfo:(DialogOrderInfo *)dialogOrderInfo{
    _dialogOrderInfo=dialogOrderInfo;
    [self.typeImgView setImageWithString:dialogOrderInfo.logo placeholder:nil];
    self.timeLabel.text=[GetTime convertDateWithString:dialogOrderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    if ([dialogOrderInfo.unit isEqualToString:@"LKR"]) {
        self.moneyLabel.text=[NSString stringWithFormat:@"Rs%.2f",dialogOrderInfo.txAmount];
    }else{
        self.moneyLabel.text=[NSString stringWithFormat:@"￥%.2f",dialogOrderInfo.txAmount];
    }
    //如果存在充值状态
    if (self.dialogOrderInfo.rechargeStatus == nil || [self.dialogOrderInfo.rechargeStatus  isEqual: @""]){
        if (self.dialogOrderInfo.status) {
            if (self.dialogOrderInfo.status.intValue == 5 || self.dialogOrderInfo.status.intValue == 42 || (self.dialogOrderInfo.status.intValue >= 95 && self.dialogOrderInfo.status.intValue <= 100)) {
                self.orderStatusLabel.text = @"Top-upSuccess".icanlocalized;
                self.orderStatusLabel.textColor = UIColor153Color;
            }else{
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"Top-upFailure".icanlocalized];
                self.orderStatusLabel.textColor = UIColorMake(234, 34, 36);
            }
        }else{
            self.orderStatusLabel.textColor = UIColor153Color;
            if ([self.dialogOrderInfo.payStatus isEqualToString:@"Paying"]) {
                self.orderStatusLabel.text = @"Paying".icanlocalized;
            }else  if ([self.dialogOrderInfo.payStatus isEqualToString:@"Success"]) {
                self.orderStatusLabel.text = @"payment successful".icanlocalized;;
                
            }else if ([self.dialogOrderInfo.payStatus isEqualToString:@"Fail"]) {
                self.orderStatusLabel.text = @"CircleUserDetailViewController.payFailTip".icanlocalized;
               
            }else if ([self.dialogOrderInfo.payStatus isEqualToString:@"Refund"]){
                self.orderStatusLabel.text = @"Refund".icanlocalized;
            }
        }
    }else{
        if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"SUCCESS"]){
            self.orderStatusLabel.text = @"Top-upSuccess".icanlocalized;
            self.orderStatusLabel.textColor = UIColor153Color;
        }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"FAILED"]){
            self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"Top-upFailure".icanlocalized];
            self.orderStatusLabel.textColor = UIColorMake(234, 34, 36);
        }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"PENDING"]){
            self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"C2COrderPending".icanlocalized];
            self.orderStatusLabel.textColor = UIColorMake(234, 34, 36);
        }
    }
    self.typeLabel.text = dialogOrderInfo.dialogName;
}
@end
