//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 19/1/2022
 - File name:  IcanWalletCurrencyViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletCurrencyViewController.h"
#import "IcanWalletRechargeViewController.h"
#import "IcanWalletWithdrawViewController.h"
#import "IcanWalletTransferInputUserTableViewController.h"
#import "IcanWalletReceiveViewController.h"
@interface IcanWalletCurrencyViewController ()
///总资产
@property (weak, nonatomic) IBOutlet UILabel *allAmountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *allAmountLab;

@property (weak, nonatomic) IBOutlet UILabel *canUseAmountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *canUseAmountLab;

@property (weak, nonatomic) IBOutlet UILabel *freezeAmountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *freezeAmountLab;

@property(nonatomic, weak) IBOutlet UILabel *transferLabel;
@property(nonatomic, weak) IBOutlet UILabel *transferTipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *receiveLabel;
@property(nonatomic, weak) IBOutlet UILabel *receiveTipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation IcanWalletCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self.withdrawBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    
    self.transferLabel.text = @"C2CWalletTransfer".icanlocalized;
    self.transferTipsLabel.text = @"C2CWalletPayViewTransferTips".icanlocalized;
    self.receiveLabel.text = @"C2CWalletReceive".icanlocalized;
    self.receiveTipsLabel.text = @"C2CWalletPayViewReceiveTips".icanlocalized;
    self.allAmountTitleLab.text = @"C2CAllAssest".icanlocalized;
    self.freezeAmountTitleLab.text = @"C2COrderFreeze".icanlocalized;
    self.canUseAmountTitleLab.text = @"C2CCanUseAssest".icanlocalized;
    [self.withdrawBtn setTitle:@"Withdraw".icanlocalized forState:UIControlStateNormal];
    [self.rechargeBtn setTitle:@"Top Up".icanlocalized forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrentAssetRequest) name:KC2CBalanceChangeNotification object:nil];
    
}
-(void)setData{
    self.title = self.balanceInfo.code;
    self.allAmountLab.text = [[self.balanceInfo.money decimalNumberByAdding:self.balanceInfo.frozenMoney] calculateByNSRoundDownScale:2].currencyString;
    self.freezeAmountLab.text = [self.balanceInfo.frozenMoney calculateByNSRoundDownScale:2].currencyString;
    self.canUseAmountLab.text = [self.balanceInfo.money calculateByNSRoundDownScale:2].currencyString;
}
- (IBAction)rechargeAction {
    IcanWalletRechargeViewController * VC = [[IcanWalletRechargeViewController alloc]init];
    VC.balanceInfo = self.balanceInfo;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (IBAction)withdraweAction {
    IcanWalletWithdrawViewController * VC = [[IcanWalletWithdrawViewController alloc]init];
    VC.balanceInfo = self.balanceInfo;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (IBAction)transferAction {
    IcanWalletTransferInputUserTableViewController * VC = [[IcanWalletTransferInputUserTableViewController alloc]init];
    VC.balanceInfo = self.balanceInfo;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (IBAction)receiveAction {
    IcanWalletReceiveViewController * VC = [[IcanWalletReceiveViewController alloc]init];
    VC.balanceInfo = self.balanceInfo;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)getCurrentAssetRequest{
    GetAssetRequest * request = [GetAssetRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/wallet/%@",self.balanceInfo.code];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CBalanceListInfo class] contentClass:[C2CBalanceListInfo class] success:^(C2CBalanceListInfo* response) {
        self.balanceInfo = response;
        [self setData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

@end
