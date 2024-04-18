//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/12/2021
- File name:  WalletCapitalViewController.m
- Description:
- Function List:
*/

#import "WalletBalanceViewController.h"
#import "BillListTableViewCell.h"
#import "RechargeViewController.h"
#import "PayMoneyInputViewController.h"
#import "PayMentAgreementView.h"
#import "SettingPaymentPasswordViewController.h"
#import "ReceiptMoneyViewController.h"
#import "QRCodeController.h"
#import "PrivacyPermissionsTool.h"
#import "BillPageContentViewController.h"
#import "C2CTransferViewController.h"

#import "SelectTransferTypePopView.h"
#import <MJRefresh.h>
#import "CertificationViewController.h"
#import "BillListDetailViewController.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif
#import "EmailBindingViewController.h"
#import "WalletTopupViewController.h"

@interface WalletBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *banlanceLab;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBanlanceBtn;

@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLabIcon;
@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLabSymbol;
@property (weak, nonatomic) IBOutlet UIButton *saleListHistoryBtn;

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *huaZhuangBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *scanbel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
///最近交易
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *tableViewBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIControl *moreBgCon;
@property (weak, nonatomic) IBOutlet UILabel *seeMoreLabel;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property (nonatomic, strong) SelectTransferTypePopView *popView;
@end

@implementation WalletBalanceViewController
- (void)refreshList {
    [self fetchUserBalance];
    [self fetchListRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    [self refreshList];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:KC2CBalanceChangeNotification object:nil];
    [self.tableView registNibWithNibName:kBillListTableViewCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.payLabel.text = @"C2CWalletPayment".icanlocalized;
    [self.hiddenBanlanceBtn setBackgroundImage:UIImageMake(@"icon_hide_balance") forState:UIControlStateNormal];
    [self.hiddenBanlanceBtn setBackgroundImage:UIImageMake(@"icon_see_balance") forState:UIControlStateSelected];
    [self.rechargeBtn setTitle:@"Top Up".icanlocalized forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    ///划转
    [self.huaZhuangBtn setTitle:@"C2CTransfer".icanlocalized forState:UIControlStateNormal];
    [self.huaZhuangBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.huaZhuangBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    ///转账
    [self.transferBtn setTitle:@"C2CWalletCapitalTransfer".icanlocalized forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    
    self.scanbel.text = @"WalletScan".icanlocalized;
    self.payLabel.text = @"payment".icanlocalized;
    
    self.receiveLabel.text = @"receive".icanlocalized;
    [self.lastBtn setTitle:@"lastSale".icanlocalized forState:UIControlStateNormal];
    self.seeMoreLabel.text = @"SeeMore".icanlocalized;
    [self.rechargeBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.huaZhuangBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.transferBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
   
    //设置默认值
    self.rechargeBtn.selected = YES;
    self.huaZhuangBtn.selected = NO;
    self.transferBtn.selected = NO;
    [self.rechargeBtn setBackgroundColor:UIColorThemeMainColor];
    [self.huaZhuangBtn setBackgroundColor:UIColorBg243Color];
    [self.transferBtn setBackgroundColor:UIColorBg243Color];
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.banlanceLab.text = [NSString stringWithFormat:@"%@(CNY)",@"iCanbalance".icanlocalized];
        self.huaZhuangBtn.hidden = YES;
     }
    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.banlanceLab.text = [NSString stringWithFormat:@"%@(CNT)",@"iCanbalance".icanlocalized];
        if([[UserInfoManager sharedManager].vip integerValue] < 5){
            self.huaZhuangBtn.hidden = YES;
        }
    }
    self.banlanceLab.textColor = UIColorThemeMainSubTitleColor;
    self.banlanceMoneyLab.textColor = UIColorThemeMainTitleColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListCurrencies:) name:KRefreshCurrencyValuesNotification object:nil];
}

-(void)refreshListCurrencies:(NSNotification*)notifi{
    [self refreshList];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
}

- (IBAction)hiddenBanlanceAction {
    self.hiddenBanlanceBtn.selected = !self.hiddenBanlanceBtn.selected;
    if (self.hiddenBanlanceBtn.selected) {
        self.banlanceMoneyLab.text = @"*****";
    }else{
        self.banlanceMoneyLab.text = [NSString stringWithFormat:@"%.2f",self.userBalanceInfo.balance.doubleValue];
        self.banlanceMoneyLabIcon.text = @"≈";
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.banlanceMoneyLabSymbol.text = @"CNY";
        }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.banlanceMoneyLabSymbol.text = @"CNT";
        }
    }
}

- (IBAction)saleListHistoryAction {
    BillPageContentViewController *vc = [[BillPageContentViewController alloc]init];
    [[AppDelegate shared] pushViewController:vc animated:YES];
}

- (IBAction)rechargeAction {
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        WalletTopupViewController *vc = [WalletTopupViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        [UIAlertController alertControllerWithTitle:@"RealnameNoAuthTip".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index == 1) {
                CertificationViewController *vc =[[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

- (IBAction)huaZhuanAction {
    C2CTransferViewController *vc = [C2CTransferViewController new];
    vc.isCapitalToWallet = NO;
    [[AppDelegate shared] pushViewController:vc animated:YES];
}

- (IBAction)transferAction {
    [self.popView showView];
}

- (IBAction)scanAction {
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[AppDelegate shared] pushViewController:[QRCodeController new] animated:YES];
    } failure:^{
    }];
}

- (IBAction)payAction {
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].isSetPayPwd) {
            UserConfigurationInfo *info = [BaseSettingManager sharedManager].userConfigurationInfo;
            if (info.isAgreePayment) {
                PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }else{
                PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.agreeBlock = ^{
                    PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
        }else{
            [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index == 1) {
                    if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                        EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                        [[AppDelegate shared] pushViewController:vc animated:YES];
                    }else{
                        SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                        [[AppDelegate shared] pushViewController:vc animated:YES];
                    }
                }
            }];
        }
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
}

- (IBAction)receiveAction {
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].isSetPayPwd) {
            UserConfigurationInfo *info = [BaseSettingManager sharedManager].userConfigurationInfo;
            if (info.isAgreePayment) {
                ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }else{
                PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.agreeBlock = ^{
                    ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
        }else{
            [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index == 1) {
                    if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                        EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                        [[AppDelegate shared] pushViewController:vc animated:YES];
                    }else{
                        SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                        [[AppDelegate shared] pushViewController:vc animated:YES];
                    }
                }
            }];
        }
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
}

- (IBAction)moreAction {
    BillPageContentViewController*vc=[[BillPageContentViewController alloc]init];
    [[AppDelegate shared] pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightBillListTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.items.count>5?5:self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBillListTableViewCell];
    cell.billInfo = [self.items objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     BillListDetailViewController * vc = [[BillListDetailViewController alloc]init];
     vc.billInfo = [self.items objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetchListRequest {
    GetFlowsRequest *request = [GetFlowsRequest request];
    request.size=@(10);
    request.page=@(0);
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[FlowsListInfo class] contentClass:[FlowsListInfo class] success:^(FlowsListInfo* response) {
        @strongify(self);
        self.items = response.content;
        CGFloat height = self.items.count>5?kHeightBillListTableViewCell*5:self.items.count*kHeightBillListTableViewCell;
        self.tableViewHeight.constant = height;
        if (response.content.count==0) {
            self.tableViewBgView.hidden = self.moreBgCon.hidden = YES;
        }
        [QMUITips hideAllTips];
        
        [self.tableView reloadData];
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)fetchUserBalance {
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        self.userBalanceInfo = response;
        self.banlanceMoneyLab.text = [NSString stringWithFormat:@"%.2f",self.userBalanceInfo.balance.doubleValue];
        self.banlanceMoneyLabIcon.text = @"≈";
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.banlanceMoneyLabSymbol.text = @"CNY";
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.banlanceMoneyLabSymbol.text = @"CNT";
        }
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (SelectTransferTypePopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"SelectTransferTypePopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _popView.navigateToAuth = ^{
            CertificationViewController *vc = [[CertificationViewController alloc]init];
            @strongify(self);
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _popView;
}
@end
