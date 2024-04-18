//
//  TransactionCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(TransactionDataContentResponse*) model{
    self.toUserLbl.text = model.to;
    self.transTypeLbl.text = [self getTransaferType:model.transactionType];
    self.dateLbl.text = [GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",model.time] dateFormmate:@"dd/MM/yyyy HH:mm:ss"];
    NSString *originalString = [NSString stringWithFormat:@"%@ %@", [self getConvertedBalance:model.amount],model.unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    NSString *substring = [self getConvertedBalance:model.amount];
    NSRange boldRange = [originalString rangeOfString:substring];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14.0]
                             range:boldRange];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor systemBlueColor]
                             range:boldRange];
    self.amtLbl.attributedText = attributedString;
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

@end
