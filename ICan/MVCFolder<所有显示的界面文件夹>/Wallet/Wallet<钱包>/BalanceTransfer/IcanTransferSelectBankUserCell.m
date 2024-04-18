//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectUserCell.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectBankUserCell.h"
@interface IcanTransferSelectBankUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *bankcardIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardidLabel;

@end
@implementation IcanTransferSelectBankUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setCardInfo:(BindingBankCardListInfo *)cardInfo{
    _cardInfo = cardInfo;
    [self.bankcardIcon setImageWithString:cardInfo.logo placeholder:@"icon_unionPay"];
    self.nameLabel.text = cardInfo.username;
    self.cardidLabel.text = [NSString stringWithFormat:@"%@（%@）",cardInfo.bankName,cardInfo.cardNo.encryptBankCardNum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
