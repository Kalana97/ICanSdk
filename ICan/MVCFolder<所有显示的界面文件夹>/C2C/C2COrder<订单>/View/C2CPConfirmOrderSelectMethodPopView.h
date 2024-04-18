//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/12/2021
- File name:  C2CPConfirmOrderSelectMethodPopView.h
- Description: 购买的时候 选择对方的收款方式
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2CPConfirmOrderSelectMethodPopView : UIView
@property (nonatomic, strong) C2CAdverInfo *adverDetailInfo;
@property(nonatomic, strong) C2COrderInfo *orderInfo;
@property (nonatomic, strong) NSArray<C2CPaymentMethodInfo*> *minePaymentMethods;
@property(nonatomic, assign) BOOL isBuyer;
@property(nonatomic, copy) void (^selectBlock)(C2CPaymentMethodInfo*info);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
-(void)hiddenView;
-(void)showView:(BOOL)isBuyer;
@end

NS_ASSUME_NONNULL_END
