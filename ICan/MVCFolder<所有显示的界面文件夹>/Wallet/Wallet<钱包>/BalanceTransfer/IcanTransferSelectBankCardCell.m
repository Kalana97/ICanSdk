//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectBankCardCell.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectBankCardCell.h"
@interface IcanTransferSelectBankCardCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation IcanTransferSelectBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
}
-(void)setCardInfo:(CommonBankCardsInfo *)cardInfo{
    _cardInfo = cardInfo;
    [self.logoImgView setImageWithString:cardInfo.logo placeholder:@"icon_unionPay"];
    self.nameLabel.text = cardInfo.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
