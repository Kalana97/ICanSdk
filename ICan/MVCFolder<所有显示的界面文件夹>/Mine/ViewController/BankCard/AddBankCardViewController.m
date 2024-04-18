//
//  AddBankCardViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "JKPickerView.h"
#import "AddSucessViewController.h"
#import "BankCardSearchViewController.h"
#import "CommonWebViewController.h"


@interface AddBankCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topTipsLabe;

@property (weak, nonatomic) IBOutlet UILabel *bankPeopleLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *bankPeopleTextField;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *bankNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *bankCardNoLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *bankCardNoTextField;
@property (weak, nonatomic) IBOutlet UILabel *lookProtocolLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property(nonatomic, strong) NSArray<CommonBankCardsInfo*> *bankCardsInfoItems;
@property(nonatomic, strong) NSMutableArray<NSString*> *bankCardsNameItems;
/** 当前选中的银行 */
@property(nonatomic, strong) CommonBankCardsInfo *selectBankCardInfo;
@end

@implementation AddBankCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString(@"AddBankCard", 添加银行卡);
    self.topTipsLabe.text=@"Please bind your bank card".icanlocalized;
    [self fetBankCardListRequest];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.bankPeopleLabel.text=NSLocalizedString(@"Cardholder",持卡人);
    self.bankPeopleLabel.textColor = UIColorThemeMainTitleColor;
    self.bankPeopleTextField.placeholder=@"AddBankCardViewController.bankPeopleTextField".icanlocalized;
    self.bankPeopleTextField.textColor = UIColorThemeMainSubTitleColor;

    self.bankNameLabel.text=NSLocalizedString(@"Card type",卡类型);
    self.bankNameLabel.textColor = UIColorThemeMainTitleColor;
    self.bankNameTextField.placeholder=NSLocalizedString(@"Please select your bank card type",请选择你的银行卡类型);
    self.bankNameTextField.textColor = UIColorThemeMainSubTitleColor;

    self.bankCardNoLabel.text=NSLocalizedString(@"CardNumber",卡号);
    self.bankCardNoLabel.textColor = UIColorThemeMainTitleColor;
    self.bankCardNoTextField.placeholder=NSLocalizedString(@"BankCard",请输入银行卡号);
    self.bankCardNoTextField.textColor = UIColorThemeMainSubTitleColor;
    
    self.lineView1.backgroundColor=
    self.lineView2.backgroundColor=
    self.lineView3.backgroundColor = UIColorSeparatorColor;
    
    
    [self.sureButton setTitle:NSLocalizedString(@"Agree to the agreement and bind the card", 同意协议并绑卡) forState:UIControlStateNormal];
    NSString*str=NSLocalizedString(@"See protocol", 查看协议);
    NSString*str1=@"WithdrawalAgreement".icanlocalized;
    NSString*str2=[NSString stringWithFormat:@"%@%@",str,str1];
    NSRange range1=[str2 rangeOfString:str];
    NSRange range2=[str2 rangeOfString:str1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str2];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12.0f] range:NSMakeRange(0, str2.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:range1];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:range2];
    self.lookProtocolLabel.attributedText=attributedString;
}
- (IBAction)selectBanck {
    [self showPickView];
}
- (IBAction)sureBtnAction {
    [self addBankCardRequest];
}
- (IBAction)lookProtocolAction {
    ////提现协议 ican_chat_withdrawal_agreement.pdf
    CommonWebViewController*web=[[CommonWebViewController alloc]init];
    NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:@"WithdrawalAgreement".icanlocalized];
    web.title = dict[@"title"];
    web.urlString = dict[@"url"];
    [self.navigationController pushViewController:web animated:YES];
}



-(void)showPickView{
    [self.view endEditing:YES];
    if(self.bankCardsNameItems.count < 1) {
        [self fetBankCardListRequest];
        return;
    }
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:NSLocalizedString(@"Choosebank",请选择银行卡) leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:self.bankCardsNameItems dataBlock:^(NSString* obj) {
        NSString * title = (NSString *)obj;
        if ([title isEqualToString:NSLocalizedString(@"other", 其他)]) {
            BankCardSearchViewController*vc=[BankCardSearchViewController new];
            @weakify(self);
            vc.searchBankcarBlock = ^(CommonBankCardsInfo * _Nonnull info) {
                @strongify(self);
                self.selectBankCardInfo=info;
                self.bankNameTextField.text=info.name;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            for (CommonBankCardsInfo* bancInfo in self.bankCardsInfoItems) {
                if ([bancInfo.name isEqualToString:title]) {
                    self.selectBankCardInfo=bancInfo;
                    break;
                }
            }
            self.bankNameTextField.text=title;
        }
    }];
    
}

- (void)removePick {
    [[JKPickerView sharedJKPickerView] removePickView];
}
- (void)sureAction {
    
    [[JKPickerView sharedJKPickerView] sureAction];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)checkSeviceAtion{
    CommonWebViewController*web=[[CommonWebViewController alloc]init];
    NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:@"WithdrawalAgreement".icanlocalized];
    web.title = dict[@"title"];
    web.urlString = dict[@"url"];
    [self.navigationController pushViewController:web animated:YES];
    
}


-(void)fetBankCardListRequest{
    CommonBankCardsRequest*request=[CommonBankCardsRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CommonBankCardsInfo class] success:^(NSArray* response) {
        self.bankCardsInfoItems=response;
        for (CommonBankCardsInfo*info in self.bankCardsInfoItems) {
            [self.bankCardsNameItems addObject:info.name];
        }
        [self.bankCardsNameItems addObject:NSLocalizedString(@"other", 其他)];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)addBankCardRequest{
    NSString*name=self.bankPeopleTextField.text.trimmingwhitespaceAndNewline;
    if (name.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddBankCardViewController.carno".icanlocalized inView:self.view];
        return;
    }
    
    NSString * careNumber = self.bankCardNoTextField.text.trimmingwhitespaceAndNewline;
    if (careNumber.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddBankCardViewController.bankCarNumberTips".icanlocalized inView:self.view];
        return;
    }
    if (!self.selectBankCardInfo) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddBankCardViewController.bankCarNameTips".icanlocalized inView:self.view];
        return;
    }
    BindingBankCardRequest*request=[BindingBankCardRequest request];
    request.bankTypeId=self.selectBankCardInfo.ID;
    request.account=careNumber;
    request.cardholderName=name;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITips hideAllTips];
        !self.addBankCardSuccessBlock?:self.addBankCardSuccessBlock();
        AddSucessViewController * vc = [AddSucessViewController new];
        vc.addSucessBlock = ^{
            self.bankCardNoTextField.text=@"";
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(NSMutableArray<NSString *> *)bankCardsNameItems{
    if (!_bankCardsNameItems) {
        _bankCardsNameItems=[NSMutableArray array];
    }
    return _bankCardsNameItems;
}
@end
