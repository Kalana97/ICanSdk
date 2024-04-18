//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/10/2019
 - File name:  WalletViewController.m
 - Description:
 - Function List:
 */


#import "WalletViewController.h"
#import "WithdrawViewController.h"
#import "WalletViewHeadView.h"
#import "WalletViewTableViewCell.h"
#import "WalletHistoryListTableViewCell.h"

#import "TransferInputIdViewController.h"

#import <MJRefresh.h>
#import "C2CTransferViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "C2CTabBarViewController.h"
#import "IcanWalletPayViewController.h"
#import "IcanWalletCurrencyViewController.h"
#import "IcanWalletTransferInputUserTableViewController.h"
#import "IcanWalletReceiveViewController.h"
#import "FlashExchangeViewController.h"
#import "WalletTopupViewController.h"
#import "IcanWalletRechargeQrCodeViewController.h"

@interface WalletViewController ()

@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property (nonatomic,copy)   NSString * balance;


@property(nonatomic, strong) NSArray<CurrencyInfo*> *allSupportedCurrenciesItems;

@property(nonatomic, strong) NSArray *orerListItems;

@property(nonatomic, strong) WalletViewHeadView *headView;
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"mine.listView.cell.banlance", 余额);
    self.view.backgroundColor= UIColorViewBgColor;
    [self getCurrencyRequest];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrencyRequest) name:kBuyCurrencySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrencyRequest) name:KC2CBalanceChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshListCurrencies:) name:KRefreshCurrencyValuesNotification object:nil];
}

-(void)refreshListCurrencies:(NSNotification*)notifi{
    [self getCurrencyRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCurrencyRequest];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
   
}

-(void)refreshAction{
    [self getCurrencyRequest];
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kWalletViewTableViewCell];
    [self.tableView registNibWithNibName:kWalletHistoryListTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    @weakify(self);
    self.headView.functionBlock = ^(WalletFunctionType type) {
        @strongify(self);
        switch (type) {
            case WalletFunctionTypeRecharge:{
                IcanWalletSelectVirtualViewController*vc = [IcanWalletSelectVirtualViewController new];
                vc.type = IcanWalletSelectVirtualTypeRecharge;
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case WalletFunctionTypeWithdraw:{
                IcanWalletSelectVirtualViewController*vc = [IcanWalletSelectVirtualViewController new];
                vc.type = IcanWalletSelectVirtualTypeWithdraw;
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case WalletFunctionTypeTransfer:{
                [self gotoTranferController];
            }
                break;
            case WalletFunctionTypeC2C:{
                IcanWalletTransferInputUserTableViewController * vc = [[IcanWalletTransferInputUserTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case WalletFunctionTypePay:{
                IcanWalletReceiveViewController * vc = [[IcanWalletReceiveViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case WalletFunctionTypeFast:{
                
                FlashExchangeViewController *vc = [[FlashExchangeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case WalletFunctionTypeCurrency:
                
                break;
            case WalletFunctionTypeHistory:
                
                break;
            default:
                break;
        }
    };
   
    return self.headView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currencyBalanceListItems.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletViewTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:kWalletViewTableViewCell];
    cell.listInfo = self.currencyBalanceListItems[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GetC2CMainNetworkByCurrencyRequest*request = [GetC2CMainNetworkByCurrencyRequest request];
                   request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/channel/byCurrency/%@",self.currencyBalanceListItems[indexPath.row].code];
                   [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ICanWalletMainNetworkInfo class] success:^(NSArray* response) {
                       IcanWalletRechargeQrCodeViewController * vc = [[IcanWalletRechargeQrCodeViewController alloc]init];
                               NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",@"TRC20"];
                               NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",@"ERC20"];
                       vc.mainNetworkInfo = [response filteredArrayUsingPredicate:predicate].firstObject == nil ? [response filteredArrayUsingPredicate:predicate2].firstObject : [response filteredArrayUsingPredicate:predicate].firstObject;
                       vc.mainNetworkItems = response;
                       vc.balanceInfo = self.currencyBalanceListItems[indexPath.row];
                       [self.navigationController pushViewController:vc animated:YES];
                   } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                       [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                   }];
}
/**
 跳转转账页面
 */
-(void)gotoTranferController{
    C2CTransferViewController*vc = [C2CTransferViewController new];
    vc.isCapitalToWallet = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
/**
 跳转到提现界面
 */
-(void)gotoWithdrawController{
    
    
}

/** 获取资产列表 */
-(void)getCurrencyRequest{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        self.currencyBalanceListItems = response;
        self.headView.currencyBalanceListItems = response;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(WalletViewHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"WalletViewHeadView" owner:self options:nil].firstObject;
    }
    return _headView;
}
@end
