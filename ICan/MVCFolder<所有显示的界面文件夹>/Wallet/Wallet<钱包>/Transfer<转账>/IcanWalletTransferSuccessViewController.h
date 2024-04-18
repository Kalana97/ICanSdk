//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  IcanWalletTransferSuccessViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletTransferSuccessViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *toIdLab;
@property (weak, nonatomic) IBOutlet UILabel *toNicknameLab;

@property(nonatomic, copy) NSString *amountLabelText;
@property(nonatomic, copy) NSString *currencyDetailLabText;
@property(nonatomic, copy) NSString *toIdLabText;
@property(nonatomic, copy) NSString *toNicknameText;
@end

NS_ASSUME_NONNULL_END
