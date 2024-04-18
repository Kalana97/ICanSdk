//
//  ChangeNickNameViewController.m
//  EasyPay
//
//  Created by young on 30/9/2019.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "ChangeNicknameViewController.h"

@interface ChangeNicknameViewController ()<QMUITextFieldDelegate>
@property (nonatomic,strong) UIView * nickNameBgView;
@property (nonatomic,strong) QMUITextField * nickNameTextField;
@property(nonatomic,strong)UIButton * rightBtn;
@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
 
    self.nickNameTextField.delegate = self;
    self.nickNameTextField.text = self.nickName;
    self.nickNameTextField.textColor = UIColorThemeMainTitleColor;
    self.title=NSLocalizedString(@"nickname", 昵称);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.nickNameTextField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
}

-(void)textFieldDidChange:(NSNotification*)nofication{
    NSString* str=self.nickNameTextField.text;
//    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //2. 去掉所有空格和换行符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0) {
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    }else{
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
    }
    
}

-(void)setupView{
   
    [self.view addSubview:self.nickNameTextField];
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@45);
        make.top.equalTo(@(NavBarHeight+15));
    }];

}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string].trimmingwhitespaceAndNewline;
    int lenth= [checkStr getLenth];
    if (lenth>20) {
        [QMUITipsTool showErrorWihtMessage:@"circle.nameTextFieldlength".icanlocalized inView:self.view];
        return NO;
    }
    return YES;

}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:NSLocalizedString(@"Save", 保存) image:nil backgroundColor:UIColor.clearColor titleFont:18 titleColor:UIColorThemeMainColor target:self action:@selector(saveAction)];
        
    }
    return _rightBtn;
}


// 保存
- (void)saveAction {
    NSString* content=self.nickNameTextField.text.trimmingwhitespaceAndNewline;
    if (content.length>0) {
        EditUserMessageRequest*request=[EditUserMessageRequest request];
        request.nickname=content;
        request.parameters=[request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
             [UserInfoManager sharedManager].nickname=content;
            [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Nickname should be filled".icanlocalized inView:self.view];
    }
}



-(UIView *)nickNameBgView{
    if (!_nickNameBgView) {
        _nickNameBgView=[[UIView alloc]init];
        _nickNameBgView.backgroundColor=[UIColor whiteColor];
    }
    return _nickNameBgView;
}
-(QMUITextField *)nickNameTextField{
    if (!_nickNameTextField) {
        _nickNameTextField=[[QMUITextField alloc]init];
        _nickNameTextField.placeholder=NSLocalizedString(@"PleaseEnterNickname",请输入昵称);
        _nickNameTextField.placeholderColor=UIColor153Color;
        _nickNameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _nickNameTextField.textColor=[UIColor blackColor];
        ViewRadius(_nickNameTextField, 5);
        ViewBorder(_nickNameTextField, UIColorSeparatorColor, 1);
    }
    return _nickNameTextField;
}



@end
