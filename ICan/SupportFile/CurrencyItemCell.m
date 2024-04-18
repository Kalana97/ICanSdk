//
//  CurrencyItemCell.m
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CurrencyItemCell.h"

@implementation CurrencyItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCoinData:(MarketModel*)model{
    self.marketValue = model;
    self.coinLogoImg.image = [UIImage imageNamed:model.coinImageName];
    self.coinCode.text = model.coinCode;
    self.coinName.text = model.coinName;
    if([model.coinPrice floatValue] > 1){
        self.coinPriceLbl.text = [NSString stringWithFormat:@"$%.2f ", [model.coinPrice floatValue]];
    }else{
        self.coinPriceLbl.text = [NSString stringWithFormat:@"$%.8f ", [model.coinPrice floatValue]];
    }
    if([model.coinPercentage floatValue] > 1){
        self.coinPercentLbl.textColor = [UIColor systemGreenColor];
        self.dropDownImg.image = [UIImage imageNamed:@"goUp"];
    }else{
        self.coinPercentLbl.textColor = [UIColor redColor];
        self.dropDownImg.image = [UIImage imageNamed:@"goDown"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2.0 animations:^{
            self.colorView.backgroundColor = model.cellChangeColor;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                self.colorView.backgroundColor = [UIColor whiteColor];
                model.cellChangeColor = [UIColor whiteColor];
            }];
        }];
    });
    self.coinPercentLbl.text = [NSString stringWithFormat:@"%.2f %@", [model.coinPercentage floatValue],@"%"];
}

- (IBAction)didSelect:(id)sender {
    if (self.editSuccessBlock) {
        self.editSuccessBlock(self.marketValue.coindId);
    }
}

@end

