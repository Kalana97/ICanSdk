//
//  AssetsDataCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-12.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AssetsDataCell.h"
#import "ChatViewHandleTool.h"

@implementation AssetsDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAssetData:(C2CWatchWalletInfo *)modelData{
    NSString *amt = [NSString stringWithFormat:@"%@",[modelData.money calculateByNSRoundDownScale:8].currencyString];
    self.moneyLbl.text = amt;
    self.codeLbl.text = modelData.code;
    [self.coinLogo sd_setImageWithURL:[NSURL URLWithString:modelData.logo]];
}

-(void)setAssetDataLogoManual:(C2CWatchWalletInfo *)modelData{
    NSString *amt = [NSString stringWithFormat:@"%@",[modelData.money calculateByNSRoundDownScale:8].currencyString];
    self.moneyLbl.text = amt;
    self.codeLbl.text = modelData.code;
    NSString *imgName = [ChatViewHandleTool getImageByCurrencyCode:modelData.code];
    UIImage *image = [UIImage imageNamed:@""];
    if(![imgName isEqualToString:@"Not_Auth_User"]){
        image = [UIImage imageNamed:imgName];
    }
    self.coinLogo.image = image;
}
@end
