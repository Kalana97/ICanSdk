//
//  AllTransactionsVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllTransactionsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *currencyBgView;
@property (weak, nonatomic) IBOutlet UILabel *transactionTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *currencyTypelbl;
@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL fromSeeMoreMy;
@end

NS_ASSUME_NONNULL_END
