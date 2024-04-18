//
//  BankCardRechargeHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardRechargeHeaderView.h"

@interface BankCardRechargeHeaderView()<UITextFieldDelegate>

@end

@implementation BankCardRechargeHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor= UIColorBg243Color;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    [self.bgView addSubview:self.cardNumLabel];
    [self.cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.bgView.mas_centerY);
        
    }];
    
    [self.bgView addSubview:self.cardNumTextfield];
    [self.cardNumTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.equalTo(@40);
        make.left.equalTo(@115);
        make.right.equalTo(@10);
        
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(self.bgView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.bgView2];
    [self.bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.equalTo(@50);
        
    }];
    
    [self.bgView2 addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.bgView2.mas_centerY);
    }];
     
    [self.bgView2 addSubview:self.moneyTextfield];
    [self.moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@115);
        make.centerY.equalTo(self.bgView2.mas_centerY);
        make.height.equalTo(@40);
        make.right.equalTo(@-10);
    }];
    
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.bgView2.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@45);
    }];
    
    [self addSubview:self.bankCardListLabel];
    [self.bankCardListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextBtn.mas_bottom).offset(17);
        make.left.equalTo(@10);
    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField ==self.moneyTextfield) {
        return NO;
    }
    return YES;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


-(UILabel *)cardNumLabel{
    if (!_cardNumLabel) {
        _cardNumLabel = [UILabel leftLabelWithTitle:NSLocalizedString(@"BankCardNumber",银行卡卡号) font:14 color:UIColor252730Color];
    }
    return _cardNumLabel;
}

-(UITextField *)cardNumTextfield{
    if (!_cardNumTextfield) {
        _cardNumTextfield = [[UITextField alloc]init];
        _cardNumTextfield.delegate = self;
        _cardNumTextfield.textColor  =UIColor252730Color;
         _cardNumTextfield.font = [UIFont systemFontOfSize:15.0];
        _cardNumTextfield.borderStyle = UITextBorderStyleNone;
        _cardNumTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return _cardNumTextfield;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorBg243Color;
    }
    return _lineView;
}

-(UIView *)bgView2{
    if (!_bgView2) {
        _bgView2 = [UIView new];
        _bgView2.backgroundColor = [UIColor whiteColor];
    }
    return _bgView2;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel leftLabelWithTitle:NSLocalizedString(@"PaymentAmount",付款金额) font:14 color:UIColor252730Color];
    }
    return _moneyLabel;
}

-(UITextField *)moneyTextfield{
    if (!_moneyTextfield) {
        _moneyTextfield = [[UITextField alloc]init];
        _moneyTextfield.delegate =self;
        _moneyTextfield.textColor = UIColorThemeMainColor;
        _moneyTextfield.font = [UIFont systemFontOfSize:15.0];
        _moneyTextfield.borderStyle = UITextBorderStyleNone;
    }
    return _moneyTextfield;
    
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel leftLabelWithTitle:NSLocalizedString(@"Remarks: Please fill in the information carefully to prevent the wrong order, easy to inquire",备注请认真填写信息防止错单方便查询) font:12.0 color:UIColor153Color];
        _tipsLabel.numberOfLines =0;
    }
    return _tipsLabel;
}


-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton functionButtonWithTitle:NSLocalizedString(@"NextStep",下一步) image:nil backgroundColor:UIColorThemeMainColor titleFont:14 target:self action:@selector(nextBtnOnClick)];
        _nextBtn.layer.cornerRadius = 8.0;
    }
    
    return _nextBtn;
}

-(void)nextBtnOnClick{
    !self.nextStepBlock?:self.nextStepBlock();
    
}

-(UILabel *)bankCardListLabel{
    if (!_bankCardListLabel) {
        _bankCardListLabel = [UILabel leftLabelWithTitle:NSLocalizedString(@"List of commonly used bank cards",c常用银行卡列表) font:12.0 color:UIColor153Color];
    }
    return _bankCardListLabel;
}


@end
