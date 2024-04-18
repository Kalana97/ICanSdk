//
//  RecentTransactionCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-08-16.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentTransactionCell : BaseCell
@property (weak, nonatomic) IBOutlet DZIconImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *amtBalanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIStackView *toStack;
@property (weak, nonatomic) IBOutlet UILabel *toLbl;
@property (weak, nonatomic) IBOutlet UILabel *remarkLbl;
@property (weak, nonatomic) IBOutlet UIView *bgViewCell;
@property (assign, nonatomic)BOOL isNeedToAndBy;
@property(nonatomic,assign) NSInteger transactionStatusType;
-(void)setData:(TransactionDataContentResponse *)modelVal;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END
