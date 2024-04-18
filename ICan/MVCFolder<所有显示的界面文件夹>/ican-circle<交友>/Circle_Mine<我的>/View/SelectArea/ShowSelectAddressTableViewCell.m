//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  ShowSelectAddressTableViewCell.m
- Description:
- Function List:
*/
        

#import "ShowSelectAddressTableViewCell.h"
@interface ShowSelectAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation ShowSelectAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden=YES;
    
}
-(void)setAreaInfo:(AreaInfo *)areaInfo{
    _areaInfo=areaInfo;
    self.titleLabel.text = areaInfo.areaName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
