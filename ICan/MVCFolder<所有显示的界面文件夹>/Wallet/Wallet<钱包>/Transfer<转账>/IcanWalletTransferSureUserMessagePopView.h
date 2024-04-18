//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/1/2022
- File name:  IcanWalletTransferSureUserMessagePopView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletTransferSureUserMessagePopView : UIView
@property(nonatomic, weak) IBOutlet UILabel *amountLabel;

@property(nonatomic, weak) IBOutlet UILabel *receiveIdLabel;
@property(nonatomic, weak) IBOutlet UILabel *nicknameLabel;

@property(nonatomic, weak) IBOutlet UILabel *currencyDetailLabel;
@property(nonatomic, copy) void (^sureBlock)(void);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
