//
//  WatchWalletCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"


NS_ASSUME_NONNULL_BEGIN
static NSString * const kWalletWatchCell = @"WatchWalletCell";

@interface WatchWalletCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *walletNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *ownedCopyExtAddress1Btn;
@property (weak, nonatomic) IBOutlet UIButton *ownedCopyExtAddress2Btn;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *imhViewCard;
@property (weak, nonatomic) IBOutlet UILabel *currencyType1;
@property (weak, nonatomic) IBOutlet UILabel *currencyType2;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack1;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack2;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack;
-(void)setWatchWalletData:(WatchWalletListInfo*)WatchWalletModel;
@property(nonatomic, strong) WatchWalletListInfo *walletModel;
@property (nonatomic,copy) void (^viewPageBlock)(WatchWalletListInfo *modelData);
@end

NS_ASSUME_NONNULL_END
