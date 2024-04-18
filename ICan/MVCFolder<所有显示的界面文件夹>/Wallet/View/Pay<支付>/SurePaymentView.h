//
//  PaymentPassWordView.h
//  CaiHongApp
//
//  Created by lidazhi on 2019/4/11.
//  Copyright © 2019 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SelectPayWayView.h"
#import "RedEnvelopPayInPutView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SurePaymentView : UIView
/**z当前是面部支付还是密码支付*/
@property (nonatomic,weak)  IBOutlet UILabel * titleLabel;
/** 支付方式 */
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
/** 金额 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet  UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIStackView *balanceBgView;

@property (weak, nonatomic) IBOutlet UILabel *attemptsLabel;

@property (weak, nonatomic) IBOutlet UILabel *attemptHintLabel;

@property (weak, nonatomic) IBOutlet UILabel *blockInfoLabel;
/** 手续费 */
@property(nonatomic, strong) IBOutlet UILabel *handfeeLabel;
/** 提现费率label */
@property(nonatomic, strong) IBOutlet UILabel *withdrawRateLabel;
/**logo*/
@property (strong, nonatomic) IBOutlet UIImageView *payWayIconImageView;
/**密码输入框*/
@property (nonatomic,weak) IBOutlet RedEnvelopPayInPutView * payInputView;
/**金额*/
@property (nonatomic,copy)   NSString * amount;
/**当前的支付类型*/
@property (nonatomic,copy)   NSString * typeStr;

@property (nonatomic,copy)   NSString * attemptStr;

/**点击了使用密码支付*/
@property (nonatomic,copy)  void(^payViewPasswordBlock)(NSString *password);
/**面容或者其他支付*/
@property (nonatomic,copy)  void (^localAuthenSuccessBlock)(void);
/**面容或者其他支付*/
@property (nonatomic,copy)  void (^localAuthenfailBlock)(void);

@property (nonatomic,copy) void (^cancleButtonBlock)(void);
/** 支付密码错误 */
@property (nonatomic,copy) void (^failerBlock)(void);
@property(nonatomic, assign) SurePaymentViewType surePaymentViewType;

-(void)showSurePaymentView;
-(void)hiddenSurePaymentView;
@end

NS_ASSUME_NONNULL_END
