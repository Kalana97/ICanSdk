//
//  BankCardRechargeTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/25.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseCell.h"


NS_ASSUME_NONNULL_BEGIN
static NSString * const KBankCardRechargeTableViewCell =@"BankCardRechargeTableViewCell";
static CGFloat KHeightBankCardRechargeTableViewCell = 50.0;

@interface BankCardRechargeTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (nonatomic,assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
