
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2021
- File name:  SelectPayWayViewTableViewCell.m
- Description:
- Function List:
*/
        

#import "SelectPayWayViewTableViewCell.h"

@interface SelectPayWayViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *paywayImgView;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@end

@implementation SelectPayWayViewTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.paywayImgView layerWithCornerRadius:25/2 borderWidth:0 borderColor:nil];
}
- (IBAction)tap:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}
#pragma mark - Setter
-(void)setChannelInfo:(RechargeChannelInfo *)channelInfo{
    _channelInfo=channelInfo;
    self.selectImgView.hidden=!channelInfo.select;
    [self.paywayImgView setImage:[UIImage imageNamed:channelInfo.imageurl]];
    if ([channelInfo.payType isEqualToString:@"Banlance"]) {
        self.wayLabel.text = [NSString stringWithFormat:@"零钱(剩余￥%.2f)",channelInfo.maxAmount.floatValue];
    }else{
        self.wayLabel.text = channelInfo.channelName;
    }
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
