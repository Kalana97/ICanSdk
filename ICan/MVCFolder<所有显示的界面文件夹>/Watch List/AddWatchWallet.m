//
//  AddWatchWallet.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AddWatchWallet.h"
#import "QRCodeController.h"
#import "VerifyOTPVC.h"


@interface AddWatchWallet ()
@property (weak, nonatomic) IBOutlet UIView *nameTxtBgView;
@property (weak, nonatomic) IBOutlet UIView *addressTxtBgView;
@property (nonatomic, strong) C2CAddAddressResponse *addressInfo;
@end

@implementation AddWatchWallet

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    [self addLocalization];
}

-(void)addLocalization{
    self.title = @"Add new wallet".icanlocalized;
    self.watchOnlyLbl.text = @"Watch only wallet".icanlocalized;
    self.watchOnlyAccountLbl.text = @"Watch only wallet".icanlocalized;
    self.walletAddressTxt.placeholder = @"Enter wallet address/ID".icanlocalized;
    self.walletNameLbl.text = @"Wallet name".icanlocalized;
    self.walletNameTxt.placeholder = @"Enter a name for wallet".icanlocalized;
    [self.addWalletBtn setTitle:@"Add".icanlocalized forState:UIControlStateNormal];
    [self.nameTxtBgView layerWithCornerRadius:5 borderWidth:0.5 borderColor:UIColor.grayColor];
    [self.addressTxtBgView layerWithCornerRadius:5 borderWidth:0.5 borderColor:UIColor.grayColor];
    [self.addWalletBtn layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    // Check if the active text field is the walletNameTxt text field
    if ([self.walletNameTxt isFirstResponder]) {
        // Resign the first responder status of the text field to dismiss the keyboard
        [self.walletNameTxt resignFirstResponder];
    }
    if ([self.walletAddressTxt isFirstResponder]) {
        // Resign the first responder status of the text field to dismiss the keyboard
        [self.walletAddressTxt resignFirstResponder];
    }
}

-(void)qrBtnAction{
    QRCodeController *vc = [[QRCodeController alloc]init];
    vc.fromICanWallet = YES;
    vc.scanResultBlock = ^(NSString *result, BOOL isSucceed) {
        self.walletAddressTxt.text = result;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)validatTheData{
    NSString *walletName = self.walletNameTxt.text;
    NSString *walletAddress = self.walletAddressTxt.text;
    if(walletName.length > 0 && walletAddress.length > 0){
        [self submitData:walletName walletAddressEntered:walletAddress];
    }else{
        if(walletAddress.length > 0){
            [self submitData:walletAddress walletAddressEntered:walletAddress];
        }else{
            [QMUITipsTool showErrorWihtMessage:@"Please enter content".icanlocalized inView:self.view];
        }
    }
}

-(void)submitData:(NSString *)walletNameEntered walletAddressEntered :(NSString*)walletAddressEntered {
    [QMUITips showLoadingInView:self.view];
    C2CAddWalletVerifyRequest *request = [C2CAddWalletVerifyRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/observe/verify/%@",walletAddressEntered]];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAddAddressResponse class] contentClass:[C2CAddAddressResponse class] success:^(C2CAddAddressResponse* response) {
        [QMUITips hideAllTips];
        self.addressInfo = response;
        [self submitIfNeed:walletNameEntered walletAddressEntered:walletAddressEntered];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self handleErrorMessage:info.desc];
    }];
}

-(void)submitIfNeed:(NSString *)walletNameEntered walletAddressEntered :(NSString*)walletAddressEntered {
    if(self.addressInfo.verify == true){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        VerifyOTPVC *View = [board instantiateViewControllerWithIdentifier:@"VerifyOTPVC"];
        View.addBlock = ^(NSString * _Nonnull otp) {
            [QMUITips showLoadingInView:self.view];
            C2CAddWalletRequest *request = [C2CAddWalletRequest request];
            request.walletAddress = walletAddressEntered;
            request.verifyCode = otp;
            request.name = walletNameEntered;
            request.parameters = [request mj_JSONObject];
            [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
                [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfultransfer", 转账成功) inView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [self handleErrorMessage:info.desc];
            }];
        };
        View.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:View animated:YES completion:nil];
    }else{
        [QMUITips showLoadingInView:self.view];
        C2CAddWalletRequest *request = [C2CAddWalletRequest request];
        request.walletAddress = walletAddressEntered;
        request.name = walletNameEntered;
        request.parameters = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfultransfer", 转账成功) inView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [self handleErrorMessage:info.desc];
        }];
    }
}

-(void)handleErrorMessage:(NSString *)errorDesc{
    if([errorDesc isEqualToString:@"verify.error"]){
        [QMUITipsTool showErrorWihtMessage:@"Verification code incorrect".icanlocalized inView:self.view];
    }else if([errorDesc isEqualToString:@"duplicate.data"]){
        [QMUITipsTool showErrorWihtMessage:@"Account exist".icanlocalized inView:self.view];
    }else if([errorDesc isEqualToString:@"data.error"]){
        [QMUITipsTool showErrorWihtMessage:@"Account exist".icanlocalized inView:self.view];
    }else{
        [QMUITipsTool showErrorWihtMessage:errorDesc inView:self.view];
    }
}

- (IBAction)scanTheQrCode:(id)sender {
    [self qrBtnAction];
}

- (IBAction)addTheCardAction:(id)sender {
    [self validatTheData];
}

@end
