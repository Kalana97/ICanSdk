//
//  BankCardRechargeHeaderView.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardRechargeHeaderView : UIView
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UILabel *cardNumLabel;
@property (nonatomic,strong)UITextField * cardNumTextfield;

@property (nonatomic,strong)UIView * lineView;

@property (nonatomic,strong)UIView * bgView2;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UITextField * moneyTextfield;

@property (nonatomic,strong)UILabel *tipsLabel;
@property (nonatomic,strong)UIButton * nextBtn;

@property (nonatomic,strong)UILabel *bankCardListLabel;

@property (nonatomic,copy) void(^nextStepBlock)(void);

@end

NS_ASSUME_NONNULL_END
