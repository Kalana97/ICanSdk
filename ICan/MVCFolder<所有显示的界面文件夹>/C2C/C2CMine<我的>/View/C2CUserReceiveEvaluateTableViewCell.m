//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 2/12/2021
- File name:  C2CUserReceiveEvaluateTableViewCell.m
- Description:
- Function List:
*/
        

#import "C2CUserReceiveEvaluateTableViewCell.h"
@interface C2CUserReceiveEvaluateTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *evluateStateImgView;

@end
@implementation C2CUserReceiveEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
}
- (IBAction)iconAction:(id)sender {
    
}
-(void)setC2cUserDetailEvluateOrderInfo:(C2COrderInfo *)c2cUserDetailEvluateOrderInfo{
    _c2cUserDetailEvluateOrderInfo = c2cUserDetailEvluateOrderInfo;
    self.evluateStateImgView.image = c2cUserDetailEvluateOrderInfo.buyEvaluate?UIImageMake(@"icon_c2c_mine_praise_sel"):UIImageMake(@"mine_bad");
    [self.iconImgView setDZIconImageViewWithUrl:c2cUserDetailEvluateOrderInfo.sellUser.headImgUrl gender:@""];
    self.nicknameLabel.text = c2cUserDetailEvluateOrderInfo.sellUser.nickname;
}
-(void)setC2cOrderInfo:(C2COrderInfo *)c2cOrderInfo{
    _c2cOrderInfo = c2cOrderInfo;
    self.evluateStateImgView.image = c2cOrderInfo.buyEvaluate?UIImageMake(@"icon_c2c_mine_praise_sel"):UIImageMake(@"mine_bad");
    [self.iconImgView setDZIconImageViewWithUrl:c2cOrderInfo.sellUser.headImgUrl gender:@""];
    self.nicknameLabel.text = c2cOrderInfo.sellUser.nickname;
    self.timeLabel.text = [GetTime convertDateWithString:c2cOrderInfo.finishTime dateFormmate:@"yyyy-MM-dd HH:mm"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
