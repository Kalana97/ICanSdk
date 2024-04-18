//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletAddNewAddressViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletAddNewAddressViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "IcanWalletSelecMainNetworkView.h"
#import "QRCodeController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface IcanWalletAddNewAddressViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
///币种
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property(nonatomic, weak) IBOutlet UIImageView *currencyIconImgView;
@property(nonatomic, weak) IBOutlet QMUITextField *currencyTextField;
///地址
@property(nonatomic, weak) IBOutlet UILabel *addressTitleLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *addressTextField;
///主网
@property(nonatomic, weak) IBOutlet UILabel *mainNetworkLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *mainNetworkTextField;
///标签
@property(nonatomic, weak) IBOutlet UILabel *tagLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *tagTextField;
@property(nonatomic, weak) IBOutlet UIButton *addBtn;

@property(nonatomic, strong) IcanWalletSelecMainNetworkView *mainNetworkView;
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;

@end

@implementation IcanWalletAddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainNetworkView.mainNetworkItems = self.mainNetworkItems;
    [RACObserve(self, self.addBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.addBtn.backgroundColor=UIColorThemeMainColor;
            [self.addBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.addBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.addBtn.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.addBtn.enabled = NO;
    RAC(self.addBtn,enabled)=[RACSignal combineLatest:@[
        self.currencyTextField.rac_textSignal,
        self.addressTextField.rac_textSignal,
        self.mainNetworkTextField.rac_textSignal,self.tagTextField.rac_textSignal ]reduce:^(NSString *currency, NSString *address,NSString *mainNetwork,NSString*tag ) {
        return @(currency.length>0&&address.length>0&&mainNetwork.length>0&&tag.length>0);
    }];
//    "C2CAddNewAddressCurrency"="币种";
//    "C2CAddNewAddressPlac"="请输入地址";
//    "C2CAddNewAddressWallet"="钱包标签（选填）";
//    "C2CAddNewAddressWalletPlac"="输入钱包标签";
    self.titleLabel.text = @"C2CAddWithdrawAddress".icanlocalized;
    self.currencyLabel.text = @"C2CAddNewAddressCurrency".icanlocalized;
    self.addressTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
    self.addressTextField.placeholder = @"C2CAddNewAddressPlac".icanlocalized;
    self.mainNetworkLabel.text = @"C2CWithdrawNetwork".icanlocalized;
    self.mainNetworkTextField.placeholder = @"MainNetworkViewTitle".icanlocalized;
    self.tagLabel.text = @"C2CAddNewAddressWallet".icanlocalized;
    self.tagTextField.placeholder = @"C2CAddNewAddressWalletPlac".icanlocalized;
    [self.addBtn setTitle:@"Save".icanlocalized forState:UIControlStateNormal];
    self.currencyTextField.text = self.selectCurrencyInfo.code;
    [self.currencyIconImgView setImageWithString:self.selectCurrencyInfo.icon placeholder:@"icon_c2c_currency_default"];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(IBAction)selectCurrencyAction{
    IcanWalletSelectVirtualViewController * vc = [[IcanWalletSelectVirtualViewController alloc]init];
    vc.type = IcanWalletSelectVirtualTypeAddNewAddress;
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        self.selectCurrencyInfo = info;
        self.currencyTextField.text = info.code;
        [self.currencyIconImgView setImageWithString:info.icon placeholder:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)selectMainNetworkAction{
    [self.view endEditing:YES];
    [self.mainNetworkView showView];
}
-(IBAction)qrBtnAction{
    QRCodeController * vc = [[QRCodeController alloc]init];
    vc.fromICanWallet = YES;
    vc.scanResultBlock = ^(NSString *result, BOOL isSucceed) {
        
        self.addressTextField.text = result;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)addBtnAction{
    ///如果存在地址并且已经选择了主网
    if (self.mainNetworkInfo&&self.addressTextField.text.length>0) {
        if (self.mainNetworkInfo.walletAddressLength!=0) {
            if (self.addressTextField.text.length!=self.mainNetworkInfo.walletAddressLength) {
                [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@的长度为%ld",self.mainNetworkInfo.channelName,self.mainNetworkInfo.walletAddressLength] inView:self.view];
                return;
            }
        }
        if (self.mainNetworkInfo.walletAddressBegin) {
            if (![self.addressTextField.text hasPrefix:self.mainNetworkInfo.walletAddressBegin]) {
                [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@以%@开头",self.mainNetworkInfo.channelName,self.mainNetworkInfo.walletAddressBegin] inView:self.view];
                return;
            }
        }
    }
    AddIcanWalletAddressRequest * request = [AddIcanWalletAddressRequest request];
    request.address = self.addressTextField.text;
    request.channelCode = self.mainNetworkInfo.channelCode;
    request.currencyCode = self.selectCurrencyInfo.code;
    if (self.tagTextField.text) {
        request.tag = self.tagTextField.text;
    }
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddSuccess".icanlocalized inView:nil];
        !self.addSuccessBlock?:self.addSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(IcanWalletSelecMainNetworkView *)mainNetworkView{
    if (!_mainNetworkView) {
        _mainNetworkView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelecMainNetworkView" owner:self options:nil].firstObject;
        _mainNetworkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _mainNetworkView.selectBlock = ^(ICanWalletMainNetworkInfo * _Nonnull info) {
            @strongify(self);
            self.mainNetworkInfo = info;
            self.mainNetworkTextField.text = info.channelName;
        };
        
    }
    return _mainNetworkView;
}
@end
