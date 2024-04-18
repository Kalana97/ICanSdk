//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 12/12/2019
- File name:  PayManager.h
- Description: 支付
- Function List:
*/
        

#import <Foundation/Foundation.h>
#import "SurePaymentView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PayManager : NSObject
@property (nonatomic,weak) UIViewController * showViewController;
@property (nonatomic,copy) NSString * balance;
@property (nonatomic,strong,nullable) SurePaymentView * surePaymentView;
@property(nonatomic, copy) void (^cancelBlock)(void);
-(instancetype)initWithShowViewController:(UIViewController*)showViewController fetchBalanceSuccessBlock:(void (^)(UserBalanceInfo*balance))successBlock;


+(instancetype )sharedManager;


/// 显示密码输入框
/// @param amount 价格
/// @param typeTitleStr 支付的类型
/// @param successBlock 密码回调
-(void)showPayViewWithAmount:(NSString*)amount  typeTitleStr:(NSString*)typeTitleStr SurePaymentViewType:(SurePaymentViewType)surePaymentViewType successBlock:(void (^)(NSString*password))successBlock ;

/// 显示密码输入框
/// @param amount 价格
/// @param typeTitleStr 支付的类型
/// @param successBlock 密码回调
-(void)payShowPayViewWithAmount:(NSString*)amount showViewController:(UIViewController *)showViewController typeTitleStr:(NSString*)typeTitleStr SurePaymentViewType:(SurePaymentViewType)surePaymentViewType successBlock:(void (^)(NSString*password))successBlock cancelBlock:(void (^)(void))cancelBlock;

-(instancetype)initWithExhangeViewCurrencyShowViewController:(UIViewController *)showViewController successBlock:(void (^)(NSArray*balance))successBlock;
-(void)showExhangeViewCurrencyExchangeInfo:(CurrencyExchangeInfo*)exchangeInfo amount:(NSString*)amount successBlock:(void (^)(NSString*password))successBlock;

/// 点击划转界面的确认按钮
/// @param balance 余额
/// @param amount 需要划转的金额
/// @param successBlock 成功回调密码
-(void)showWalletTransfer:(NSString*)balance amount:(NSString*)amount isCalled:(BOOL)isCalled successBlock:(void (^)(NSString*password))successBlock;
-(void)showC2CInputPasswordWith:(NSString*)amount  typeStr:(NSString*)typeStr currencyInfo:(CurrencyInfo*)currencyInfo  successBlock:(void (^)(NSString*password))successBlock;

-(void)showWithdrawWithAmount:(NSString*)amount successBlock:(void (^)(NSString*password))successBlock;

-(void)checkPaymentPassword:(NSString*)amount successBlock:(void (^)(NSString*password))successBlock;
-(void)checkPaymentPasswordWithOther:(NSString*)title needSub:(NSString*)needSub successBlock:(void (^)(NSString*password))successBlock;
-(void)showC2CPrepareOrderWithCurrencyInfo:(CurrencyInfo*)currencyInfo c2cBalanceListInfo:(C2CBalanceListInfo*)c2cBalanceListInfo actualPay:(NSDecimalNumber*)actualPay  successBlock:(void (^)(NSString*password))successBlock;

/// c2c界面 确认收款的时候，显示的密码框校验界面
/// @param successBlock <#successBlock description#>
-(void)showC2CConfirmReceiptMoney:(NSString*)quantity SuccessBlock:(void (^)(NSString*password))successBlock;
@end

NS_ASSUME_NONNULL_END
