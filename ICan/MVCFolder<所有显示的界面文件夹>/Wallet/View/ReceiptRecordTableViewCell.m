//
//  ReceiptRecordTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptRecordTableViewCell.h"
@interface ReceiptRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation ReceiptRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor = UIColorThemeMainSubTitleColor;
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.moneyLabel.textColor = UIColorThemeMainSubTitleColor;
    self.lineView.backgroundColor = UIColorSeparatorColor;
    
}


-(void)setFlowsInfo:(ReceiveFlowsInfo *)flowsInfo{
    self.nameLabel.text=flowsInfo.payUserNickname;
    self.moneyLabel.text=[NSString stringWithFormat:@"￥%.2f",[flowsInfo.money doubleValue]];
    self.timeLabel.text=[GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",flowsInfo.payTime] dateFormmate:@"yyyy/MM/d/"];
}
@end
