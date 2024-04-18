//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 18/1/2022
 - File name:  IcanWalletPayViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletPayViewController.h"
#import "IcanWalletTransferInputUserTableViewController.h"
#import "IcanWalletReceiveViewController.h"
#import "IcanWalletPayViewControllerLatelyCell.h"
#import "C2CFlowsListViewController.h"
@interface IcanWalletPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *transferLabel;
@property(nonatomic, weak) IBOutlet UILabel *transferTipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *receiveLabel;
@property(nonatomic, weak) IBOutlet UILabel *receiveTipsLabel;


@property(weak, nonatomic) IBOutlet UIControl *seeMoreBgCon;
@property(nonatomic, weak) IBOutlet UILabel *seeMoreLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property(weak, nonatomic) IBOutlet UIView *tableViewBgView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
@property(nonatomic, strong) NSArray<C2CFlowsInfo*> *historyItems;
@end

@implementation IcanWalletPayViewController
- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollViewTopConstraint.constant = -StatusBarHeightConstant;
    self.titleTopConstraint.constant = StatusBarAndNavigationBarHeight;
    [self.tableView registNibWithNibName:kIcanWalletPayViewControllerLatelyCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
//    "C2CWalletTransfer"="转账";
//    "C2CWalletReceive"="收款";
//    "C2CWalletPayViewTitle"="~ ICAN 支付 ~";
//    "C2CWalletPayViewTips"="用数字货币首付款";
//    "C2CWalletPayViewTransferTips"="向其他用户转账数字货币";
//    "C2CWalletPayViewReceiveTips"="使用二维码收款";
//    "C2CWalletPayViewSeeMore"="查看更多";
    self.titleLabel.text = @"C2CWalletPayViewTitle".icanlocalized;
    self.tipsLabel.text = @"C2CWalletPayViewTips".icanlocalized;
    self.transferLabel.text = @"C2CWalletTransfer".icanlocalized;
    self.transferTipsLabel.text = @"C2CWalletPayViewTransferTips".icanlocalized;
    self.receiveLabel.text = @"C2CWalletReceive".icanlocalized;
    self.receiveTipsLabel.text = @"C2CWalletPayViewReceiveTips".icanlocalized;
    self.seeMoreLabel.text = @"C2CWalletPayViewSeeMore".icanlocalized;
    [self getC2CTransferHistoryListRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getC2CTransferHistoryListRequest) name:KC2CBalanceChangeNotification object:nil];
}
- (IBAction)transferAction {
    IcanWalletTransferInputUserTableViewController * vc = [[IcanWalletTransferInputUserTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)receiveAction {
    IcanWalletReceiveViewController * vc = [[IcanWalletReceiveViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)seeMoreAction {
    
    C2CFlowsListViewController * vc = [[C2CFlowsListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IcanWalletPayViewControllerLatelyCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletPayViewControllerLatelyCell];
    cell.info = self.historyItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(void)getC2CTransferHistoryListRequest{
    C2CTransferHistoryListRequest * request = [C2CTransferHistoryListRequest request];
    request.size = @(4);
    request.current = @(1);
    request.type = @"QrcodePayFlow,TransferRecord";
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CTransferHistoryListInfo class] contentClass:[C2CTransferHistoryListInfo class] success:^(C2CTransferHistoryListInfo*  response) {
        if (response.records.count == 0) {
            self.tableViewBgView.hidden = YES;
            self.seeMoreBgCon.hidden = YES;
        }else{
            self.historyItems = response.records;
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            self.tableViewHeight.constant = self.tableView.contentSize.height;
        }
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
