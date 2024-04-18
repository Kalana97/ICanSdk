//
//  RechargeChannelTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "RechargeChannelTableViewCell.h"

@implementation RechargeChannelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor =UIColorThemeMainTitleColor;
}

-(void)setUserBalanceInfo:(UserBalanceInfo *)userBalanceInfo{
    _userBalanceInfo = userBalanceInfo;
}

-(void)setCurrentInfo:(C2CBalanceListInfo *)currentInfo{
    _currentInfo = currentInfo;
}

-(void)setRechargeChannelInfo:(RechargeChannelInfo *)rechargeChannelInfo{
    _rechargeChannelInfo= rechargeChannelInfo;
    self.nameLabel.text = rechargeChannelInfo.channelName;
    if ([rechargeChannelInfo.channelCode isEqualToString:@"USDT"]){
        self.balanceLbl.hidden = NO;
        self.desc.hidden = YES;
        self.stackSwitch.hidden = YES;
        if(self.currentInfo == nil){
            self.balanceLbl.text = [NSString stringWithFormat:@"(₮ %@)",@"0.00"];
        }else{
            self.balanceLbl.text = [NSString stringWithFormat:@"(₮ %@)",[self.currentInfo.money calculateByRoundingScale:8].currencyString];
        }
        self.secondaryView.hidden = NO;
    }else if ([rechargeChannelInfo.payType isEqualToString:@"balance"]){
        self.balanceLbl.hidden = NO;
        self.desc.hidden = YES;
        self.stackSwitch.hidden = YES;
        self.balanceLbl.text = [NSString stringWithFormat:@"(￥%.2f)",self.userBalanceInfo.balance.doubleValue];
    }else if ([rechargeChannelInfo.payType isEqualToString:@"LankaPay"]){
        self.balanceLbl.hidden = YES;
        self.desc.hidden = NO;
        self.secondaryView.hidden = YES;
        self.stackSwitch.hidden = YES;
    }else if([rechargeChannelInfo.payType isEqual:@"BankCard"]){
        self.balanceLbl.hidden = YES;
        self.stackSwitch.hidden = NO;
        self.secondaryView.hidden = YES;
        self.desc.hidden = YES;
        [self.iconImageView setImage:[UIImage imageNamed:@"bankCardN"]];
    }else{
        self.balanceLbl.hidden = YES;
    }
    
    if (rechargeChannelInfo.logo) {
        [self.iconImageView setImageWithString:rechargeChannelInfo.logo placeholder:nil];
    }else{
        if ([rechargeChannelInfo.payType isEqualToString:@"ALIPAY"]) {
            [self.iconImageView setImage:[UIImage imageNamed:@"icon_recharge_alipay"]];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"WECHAT"]){
            [self.iconImageView setImage:[UIImage imageNamed:@"icon_recharge_wechat"]];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"USDT"]){
            [self.iconImageView setImage:[UIImage imageNamed:@"icon_usdt"]];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"BANK"]){
            [self.iconImageView setImage:[UIImage imageNamed:@"icon_unionPay"]];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"balance"]){
            [self.iconImageView setImage:[UIImage imageNamed:@"wallet_payView_balance"]];
        }
        else{
            [self.iconImageView setImage:[UIImage imageNamed:@"icon_unionPay"]];
        }
    }
    
    if ([rechargeChannelInfo.payType isEqualToString:@"LankaPay"]){
        [self.iconImageView setImageWithString:rechargeChannelInfo.logo placeholder:nil];
   }else if([rechargeChannelInfo.payType isEqual:@"BankCard"]){
       [self.iconImageView setImage:[UIImage imageNamed:@"bankCardN"]];
   }
    [self.swtitchBtn setImage:[UIImage imageNamed:@"switchOn"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"wallet_recharge_way_select"] forState:UIControlStateNormal];
    
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.rightBtn.hidden =NO;
    }else{
        self.rightBtn.hidden =YES;
    }
}
- (IBAction)SWitchAct:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (IBAction)rightBtnOnClick:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
