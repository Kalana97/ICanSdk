//
//  RecentTransactionCellWithButtons.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "RecentTransactionCellWithButtons.h"

@implementation RecentTransactionCellWithButtons

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setUI{
    [self.cellBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.approveBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    [self.rejectBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.iconImg.layer.cornerRadius = self.iconImg.frame.size.height/2;
    self.iconImg.clipsToBounds = YES;
    [self addLocalization];
    
    NSArray *userPermissionList = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPermissions"];
    BOOL APR_TRANSACTION_Level = [userPermissionList containsObject:@"APR_TRANSACTION"];
    if(APR_TRANSACTION_Level){
        self.btnStack.hidden = NO;
    }else{
        self.btnStack.hidden = YES;
    }
}

-(void)addLocalization{
    [self.rejectBtn setTitle:@"Reject".icanlocalized forState:UIControlStateNormal];
    [self.approveBtn setTitle:@"Approve".icanlocalized forState:UIControlStateNormal];
}

-(void)setData:(TransactionDataContentResponse*) model{
    [self setUI];
    self.userNameLbl.text = model.nickName;
    [self.iconImg setDZIconImageViewWithUrl:model.headImgUrl gender:@""];
    self.tolbl.text = [NSString stringWithFormat:@"%@ : %@",@"To".icanlocalized,model.to];
    self.payTypeLbl.text = [self getTransaferType:model.transactionType];
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

- (IBAction)rejectTransactionRequest:(id)sender {
    if (self.rejectBlock) {
        self.rejectBlock();
    }
}

- (IBAction)approveTransactionRequest:(id)sender {
    if (self.acceptBlock) {
        self.acceptBlock();
    }
}

- (IBAction)didSelectRow:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
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
