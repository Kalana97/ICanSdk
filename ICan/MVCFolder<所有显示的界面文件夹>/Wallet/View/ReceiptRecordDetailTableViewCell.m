//
//  ReceiptRecordDetailTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptRecordDetailTableViewCell.h"
@interface ReceiptRecordDetailTableViewCell()
//状态
@property (weak, nonatomic) IBOutlet UILabel *statusTips;
@property (weak, nonatomic) IBOutlet UILabel *statusDetail;
//交易时间
@property (weak, nonatomic) IBOutlet UILabel *timeTips;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

//交易单号
@property (weak, nonatomic) IBOutlet UILabel *orderTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
//交易类型
@property (weak, nonatomic) IBOutlet UILabel *typeTipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;

//备注
@property (weak, nonatomic) IBOutlet UILabel *remarkTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;




@end

@implementation ReceiptRecordDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if ([BaseSettingManager isChinaLanguages]) {
        self.widthConstraint.constant =50.0;
    }else{
        self.widthConstraint.constant =80.0;
    }
    
    //当前状态
    self.statusTips.textColor = UIColorThemeMainSubTitleColor;
    self.statusTips.text = NSLocalizedString(@"Current state",当前状态);
    self.statusDetail.textColor = UIColorThemeMainTitleColor;
    self.statusDetail.text=@"Received".icanlocalized;
    
    //交易时间
    self.timeTips.textColor = UIColorThemeMainSubTitleColor;
    self.timeTips.text =NSLocalizedString(@"Transaction time",交易时间);
    self.timeDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    
    //交易单号
    self.orderTipsLabel.textColor = UIColorThemeMainSubTitleColor;
    self.orderTipsLabel.text=NSLocalizedString(@"Transaction order No",交易单号);
    self.orderDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    
    //交易类型
    self.typeTipsLabel.textColor = UIColorThemeMainSubTitleColor;
    self.typeTipsLabel.text =NSLocalizedString(@"TransactionType",交易类型);
    self.typeDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    
    //备注
    self.remarkTipsLabel.textColor = UIColorThemeMainSubTitleColor;
    self.remarkTipsLabel.text= NSLocalizedString(@"Remark",备注);
    self.remarkDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    
    
    self.lineView.backgroundColor = UIColorSeparatorColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setInfo:(ReceiveFlowsInfo *)info{
    _info=info;
    self.remarkDetailLabel.text=info.comment;
    self.typeDetailLabel.text=@"收款".icanlocalized;
    self.orderDetailLabel.text=info.orderId;
//    info.orderId?:@"";
    self.timeDetailLabel.text=[GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",info.payTime] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.statusDetail.text=@"Received".icanlocalized;
}

@end
