//
//  AssetsDataCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-12.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDataCell : BaseCell
@property (weak, nonatomic) IBOutlet DZIconImageView *coinLogo;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
-(void)setAssetData:(C2CWatchWalletInfo *)modelData;
-(void)setAssetDataLogoManual:(C2CWatchWalletInfo *)modelData;
@end

NS_ASSUME_NONNULL_END
