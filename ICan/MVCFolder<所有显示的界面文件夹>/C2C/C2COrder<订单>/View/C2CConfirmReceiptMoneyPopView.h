//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.h
- Description:选择支付限时的View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2CConfirmReceiptMoneyPopView : UIView
@property(nonatomic, copy) void (^sureBlock)(void);
@property(nonatomic, copy) void (^hiddenBlock)(void);
@property(nonatomic, copy) void (^cancelBlock)(void);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
