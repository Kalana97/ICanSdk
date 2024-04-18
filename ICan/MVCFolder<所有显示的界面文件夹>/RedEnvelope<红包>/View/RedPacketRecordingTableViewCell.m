//
//  ReceiveRedRedcordingTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "RedPacketRecordingTableViewCell.h"
@interface RedPacketRecordingTableViewCell()
/** 发出的红包显示的是拼手气红包或者是普通红包 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 发出的红包不会显示拼手气的图标 */
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/** 状态label 收到的不会显示 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@end
@implementation RedPacketRecordingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.typeLabel.textColor = UIColorThemeMainTitleColor;
    self.moneyLabel.textColor = UIColorThemeMainTitleColor;
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.stateLabel.textColor = UIColorThemeMainSubTitleColor;

}

-(void)setRedPacketRecordGrabInfo:(RedPacketRecordGrabInfo *)redPacketRecordGrabInfo{
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[redPacketRecordGrabInfo.money doubleValue],@"CNYChat".icanlocalized];
     }
    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[redPacketRecordGrabInfo.money doubleValue],@"CNY".icanlocalized];
    }
    self.timeLabel.text = [GetTime convertDateWithString:redPacketRecordGrabInfo.grabTime dateFormmate:@"MM-dd"];
    //需要显示某个人
    if ([redPacketRecordGrabInfo.type isEqualToString:@"RANDOM"]) {//是拼手气
         self.typeLabel.text = NSLocalizedString(@"Random Amount", 拼手气红包);
        self.pinImageView.hidden = NO;
    }else{
        self.typeLabel.text = NSLocalizedString(@"Identical Amount", 普通红包);
        self.pinImageView.hidden = YES;
    }
    self.stateLabel.hidden = YES;
    
}
-(void)setRedPacketRecordSendInfo:(RedPacketRecordSendInfo *)redPacketRecordSendInfo{
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[redPacketRecordSendInfo.money doubleValue],@"CNYChat".icanlocalized];
     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[redPacketRecordSendInfo.money doubleValue],@"CNY".icanlocalized];
    }
    
    self.timeLabel.text = [GetTime convertDateWithString:redPacketRecordSendInfo.createTime dateFormmate:@"MM-dd"];
    self.pinImageView.hidden = YES;
    if ([redPacketRecordSendInfo.type isEqualToString:@"RANDOM"]) {//是拼手气
        self.typeLabel.text = NSLocalizedString(@"Random Amount", 拼手气红包);
    }else{
       
        self.typeLabel.text = NSLocalizedString(@"Identical Amount", 普通红包);
    }
    self.stateLabel.hidden = NO;
    self.stateLabel.text = redPacketRecordSendInfo.statesLabelText;
}
@end
