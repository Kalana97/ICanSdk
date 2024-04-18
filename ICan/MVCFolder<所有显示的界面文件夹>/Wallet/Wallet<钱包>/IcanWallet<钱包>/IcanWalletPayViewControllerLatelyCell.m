//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  IcanWalletPayViewControllerLatelyCell.m
- Description:
- Function List:
*/
        

#import "IcanWalletPayViewControllerLatelyCell.h"
@interface IcanWalletPayViewControllerLatelyCell()
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation IcanWalletPayViewControllerLatelyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
}
-(void)setInfo:(C2CFlowsInfo *)info{
    _info = info;
    //    "C2CWalletTransfer"="转账";
    //    "C2CWalletReceive"="收款";
//    "C2CWalletPayViewTo"="转给";
//    "C2CWalletPayViewReceive"="收到";
    self.timeLabel.text = [GetTime convertDateWithString:info.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    NSString * amount = [[info.amount calculateByNSRoundDownScale:2].currencyString componentsSeparatedByString:@"-"].lastObject;
    if ([info.flowType isEqualToString:@"TransferRecord"]) {
        self.typeLabel.text = @"C2CWalletTransfer".icanlocalized;
        
        if ([info.amount.stringValue containsString:@"-"]) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@",@"C2CWalletPayViewTo".icanlocalized,info.simpleUserDTO.nickname,amount,info.currencyCode];
        }else{
            self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@",@"C2CWalletPayViewReceive".icanlocalized,info.simpleUserDTO.nickname,amount,info.currencyCode];
        }
        self.typeLabel.textColor = UIColorMakeHEXCOLOR(0X1d80f3);
        self.circleView.backgroundColor = UIColorMakeHEXCOLOR(0X1d80f3);
    }else{
        self.typeLabel.text = @"C2CWalletReceive".icanlocalized;
        if ([info.amount.stringValue containsString:@"-"]) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@",@"C2CWalletPayViewTo".icanlocalized,info.simpleUserDTO.nickname,amount,info.currencyCode];
        }else{
            self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@",@"C2CWalletPayViewReceive".icanlocalized,info.simpleUserDTO.nickname,amount,info.currencyCode];
        }
        self.typeLabel.textColor = UIColorMakeHEXCOLOR(0Xe49204);
        self.circleView.backgroundColor = UIColorMakeHEXCOLOR(0Xe49204);
    }
    
    
}


@end
