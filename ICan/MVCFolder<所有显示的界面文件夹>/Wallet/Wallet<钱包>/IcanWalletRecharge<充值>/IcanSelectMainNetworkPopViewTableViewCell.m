//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 24/2/2022
- File name:  IcanSelectMainNetworkPopViewTableViewCell.m
- Description:
- Function List:
*/
        

#import "IcanSelectMainNetworkPopViewTableViewCell.h"
@interface IcanSelectMainNetworkPopViewTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *networkLab;

@end
@implementation IcanSelectMainNetworkPopViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.contentView addGestureRecognizer:tap];
}
- (void)tap {
    !self.didSelectBlock?:self.didSelectBlock();
}
-(void)setMainNetworkInfo:(ICanWalletMainNetworkInfo *)mainNetworkInfo{
    _mainNetworkInfo = mainNetworkInfo;
    self.networkLab.text = mainNetworkInfo.channelName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
