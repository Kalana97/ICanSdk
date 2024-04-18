//
//  AddWatchWallet.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddWatchWallet : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *watchOnlyLbl;
@property (weak, nonatomic) IBOutlet UILabel *watchOnlyAccountLbl;
@property (weak, nonatomic) IBOutlet UITextField *walletAddressTxt;
@property (weak, nonatomic) IBOutlet UIButton *qrscanBtn;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *walletNameTxt;
@property (weak, nonatomic) IBOutlet UIButton *addWalletBtn;
@end

NS_ASSUME_NONNULL_END
