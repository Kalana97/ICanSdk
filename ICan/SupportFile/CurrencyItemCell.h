//
//  CurrencyItemCell.h
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "MarketModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kCurrencyItemCell = @"CurrencyItemCell";

@interface CurrencyItemCell : BaseCell

@property (weak, nonatomic) IBOutlet UILabel *coinCode;
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *coinPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *coinPercentLbl;
@property (weak, nonatomic) IBOutlet DZIconImageView *coinLogoImg;
@property (weak, nonatomic) IBOutlet DZIconImageView *dropDownImg;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property(nonatomic, strong) MarketModel *marketValue;
@property (nonatomic,copy) void (^editSuccessBlock)(NSString *coinCode);
-(void)setCoinData:(MarketModel*)model;

@end

NS_ASSUME_NONNULL_END
