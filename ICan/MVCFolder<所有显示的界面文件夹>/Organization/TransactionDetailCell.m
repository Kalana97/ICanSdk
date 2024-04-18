//
//  TransactionDetailCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "TransactionDetailCell.h"

@implementation TransactionDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(TransactionDataContentResponse *)modelVal{
    [self.bgViewCell layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.avatarImg setDZIconImageViewWithUrl:modelVal.headImgUrl gender:@""];
    self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.height/2;
    self.avatarImg.clipsToBounds = YES;
    self.userNameLbl.text = modelVal.nickName;
    self.payType.text = [self getTransaferType:modelVal.transactionType];
    self.dateLbl.text = [GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",modelVal.time] dateFormmate:@"dd/MM/yyyy HH:mm:ss"];
    NSString *originalString = [NSString stringWithFormat:@"%@ %@", [self getConvertedBalance:modelVal.amount],modelVal.unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    NSString *substring = [self getConvertedBalance:modelVal.amount];
    NSRange boldRange = [originalString rangeOfString:substring];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14.0]
                             range:boldRange];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor systemBlueColor]
                             range:boldRange];
    self.amtBalanceLbl.attributedText = attributedString;
    
    if(self.isNeedToAndBy){
        self.toStack.hidden  = NO;
        self.toLbl.text = [NSString stringWithFormat:@"%@:%@",@"To".icanlocalized,modelVal.to];
        if(self.transactionStatusType == 3){
            if(modelVal.lastOperateNickName != nil && ![modelVal.lastOperateNickName isEqualToString:@""]){
                self.remarkLbl.text = [NSString stringWithFormat:@"%@:%@",@"Rejected by".icanlocalized,modelVal.lastOperateNickName];
            }else{
                self.remarkLbl.hidden = YES;
            }
        }else if(self.transactionStatusType == 2){
            if(modelVal.lastOperateNickName != nil && ![modelVal.lastOperateNickName isEqualToString:@""]){self.remarkLbl.text = [NSString stringWithFormat:@"%@:%@",@"Approved by ".icanlocalized,modelVal.lastOperateNickName];
            }else{
                self.remarkLbl.hidden = YES;
            }
        }
    }else{
        if(self.isSeeMore){
            self.toStack.hidden  = NO;
            self.remarkLbl.hidden = YES;
        }
    }
}

-(NSString *)getConvertedBalance:(double)amt{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *formattedString = [numberFormatter stringFromNumber:@(amt)];
    return formattedString;
}

-(NSString *)getTransaferType:(NSString *)val{
    if([val isEqualToString:@"RED_PACKET"]){
        return @"chatView.function.redPacket".icanlocalized;
    }else if([val isEqualToString:@"TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"C2C_TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"C2C_WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"C2C_UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"P2P"]){
        return @"C2CTransaction".icanlocalized;
    }else{
        return @"";
    }
}

- (IBAction)didTapOnCell:(id)sender {
    if (self.tapBlock) {
                self.tapBlock();
     }
}

@end
