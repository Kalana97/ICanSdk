//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  BillListTableViewCell.m
- Description:
- Function List:
*/
        

#import "WalletHistoryListTableViewCell.h"
#import "GetTime.h"
@interface WalletHistoryListTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation WalletHistoryListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyLabel.textColor=UIColorThemeMainColor;
    self.nameLabel.textColor=UIColor252730Color;
    self.timeLabel.textColor=UIColor153Color;
    [self.iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
}

-(void)setBillInfo:(BillInfo *)billInfo{
    _billInfo = billInfo;
    if (billInfo.amount>0) {
        if ([self.billInfo.unit isEqualToString:@"LKR"]) {
            self.moneyLabel.text = [NSString stringWithFormat:@"+Rs%.2f",billInfo.amount ];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"+￥%.2f",billInfo.amount ];
        }
        self.moneyLabel.textColor=UIColorThemeMainColor;
    }else{
         self.moneyLabel.textColor=UIColorMake(244, 81, 105);
        if ([self.billInfo.unit isEqualToString:@"LKR"]) {
           
            self.moneyLabel.text = [NSString stringWithFormat:@"-Rs%.2f",[[NSString stringWithFormat:@"%.2f",billInfo.amount] substringFromIndex:1].doubleValue];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",[[NSString stringWithFormat:@"%.2f",billInfo.amount] substringFromIndex:1].doubleValue];
        }
    }
    self.nameLabel.text = billInfo.listTitle;
    [self.iconImageView setImage:UIImageMake(billInfo.imageStr)];
    if (billInfo.time) {
        self.timeLabel.text =  self.timeLabel.text=[GetTime convertDateWithString:billInfo.time dateFormmate:@"yyyy-MM-dd HH:mm:ss"];;
    }else{
        self.timeLabel.text = billInfo.createTime;
    }
    
}

@end
