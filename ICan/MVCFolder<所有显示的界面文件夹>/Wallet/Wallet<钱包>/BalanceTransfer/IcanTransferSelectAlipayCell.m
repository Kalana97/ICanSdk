//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectBankCardCell.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectAlipayCell.h"
@interface IcanTransferSelectAlipayCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;

@end
@implementation IcanTransferSelectAlipayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setAlipayInfo:(BindingAliPayListInfo *)alipayInfo{
    _alipayInfo = alipayInfo;
    self.nameLab.text = alipayInfo.name;
    self.accountLab.text= alipayInfo.account;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
