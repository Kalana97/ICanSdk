//
//  ModifySignatureViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/3.
//  Copyright © 2020 dzl. All rights reserved.
//  修改个性签名页面

#import "ModifySignatureViewController.h"

@interface ModifySignatureViewController ()<UITextViewDelegate>

@property(nonatomic,strong) UITextView * textView;
@property(nonatomic,strong) UIButton * rightBtn;
@property(nonatomic,strong) UILabel * numberLabel;
@end

@implementation ModifySignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.title=NSLocalizedString(@"friend.detail.listCell.Signature", 个性签名);
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UIAlertController.cancel.title".icanlocalized target:self action:@selector(cancelAction)];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavBarHeight+10));
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@131);
    }];
    
    [self.view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(self.textView.mas_bottom).offset(-20);
        
    }];
    
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@44);
    }];
    
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)[UserInfoManager sharedManager].signature.length];
    self.textView.text=[UserInfoManager sharedManager].signature;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    
    if ( (unsigned long)textView.text.length > 30) {
        // 对超出的部分进行剪切
        textView.text = [textView.text substringToIndex:30];
        
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
}

-(void)cancelAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sureAction{
    [self settting];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:@"CommonButton.Confirm".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:14 titleColor:UIColor.whiteColor target:self action:@selector(sureAction)];
        ViewRadius(_rightBtn, 22);
    }
    return _rightBtn;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]init];
        _textView.textColor=UIColorThemeMainSubTitleColor;
        _textView.backgroundColor=[UIColor whiteColor];
        _textView.font=[UIFont systemFontOfSize:16];
        _textView.delegate =self;
        
    }
    return _textView;
}

-(void)settting{
    ModifyUserSignatureRequest * request = [ModifyUserSignatureRequest request];
    request.signature  =self.textView.text;
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].signature=self.textView.text;
        !self.modifySucessBlock?:self.modifySucessBlock();
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel rightLabelWithTitle:@"" font:13 color:UIColorThemeMainTitleColor];
    }
    
    return _numberLabel;
}


@end
