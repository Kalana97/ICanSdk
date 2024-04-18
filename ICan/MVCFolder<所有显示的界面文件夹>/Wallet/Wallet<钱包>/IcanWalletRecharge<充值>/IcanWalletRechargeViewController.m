//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 12/1/2022
 - File name:  IcanWalletRechargeViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletRechargeViewController.h"
#import "IcanWalletSelecMainNetworkView.h"
#import "IcanWalletRechargeQrCodeViewController.h"
#import "UIViewController+Extension.h"
@interface IcanWalletRechargeViewController ()
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *mainNerworkLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *mainNerworkDetailLabel;
@property(nonatomic, strong) IcanWalletSelecMainNetworkView *mainNetworkView;
@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, copy) NSString *code;
@end

@implementation IcanWalletRechargeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanWalletSelectVirtualViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.code = self.balanceInfo?self.balanceInfo.code:self.currencyInfo.code;
    
    [self getMainNetworkViewRequest];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",@"Top Up".icanlocalized,self.code];
//    "WalletRechargeTips"="选择主网即可获取充值地址";
//    "WalletRechargeMainnet"="主网";
//    "WalletRechargeSelectMainnet"="请选择主网";
    self.tipsLabel.text = @"WalletRechargeTips".icanlocalized;
    self.mainNerworkLabel.text = @"WalletRechargeMainnet".icanlocalized;
    self.mainNerworkDetailLabel.text = @"WalletRechargeSelectMainnet".icanlocalized;
    ///为了防止c2c用户信息没有获取成功
    [C2CUserManager.shared getC2CCurrentUser:nil];
}

-(void)getMainNetworkViewRequest{
    GetC2CMainNetworkByCurrencyRequest*request = [GetC2CMainNetworkByCurrencyRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/channel/byCurrency/%@",self.code];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ICanWalletMainNetworkInfo class] success:^(NSArray* response) {
        self.mainNetworkItems = response;
        self.mainNetworkView.mainNetworkItems = response;
        [self selectMainNetworkAction];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
///选择主网
- (IBAction)selectMainNetworkAction {
    [self.mainNetworkView showView];
}
-(IcanWalletSelecMainNetworkView *)mainNetworkView{
    if (!_mainNetworkView) {
        _mainNetworkView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelecMainNetworkView" owner:self options:nil].firstObject;
        _mainNetworkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _mainNetworkView.selectBlock = ^(ICanWalletMainNetworkInfo * _Nonnull info) {
            @strongify(self);
            IcanWalletRechargeQrCodeViewController * vc = [[IcanWalletRechargeQrCodeViewController alloc]init];
            vc.mainNetworkInfo = info;
            vc.mainNetworkItems = self.mainNetworkItems;
            vc.currencyInfo = self.currencyInfo;
            vc.balanceInfo = self.balanceInfo;
            [self.navigationController pushViewController:vc animated:YES];
        };
       
    }
    return _mainNetworkView;
}
@end
