//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletSelectVirtualViewController.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelectVirtualViewController.h"
#import "IcanWalletSelectVirtualTableViewCell.h"
#import "IcanWalletSelectVirtualHeadView.h"
#import "IcanWalletRechargeViewController.h"
#import "IcanWalletWithdrawViewController.h"
#import "IcanWalletRechargeQrCodeViewController.h"
@interface IcanWalletSelectVirtualViewController ()
/** 支持的全部法币 */
@property (nonatomic, strong) NSArray<CurrencyInfo*> *legalTenderItems;
@property (nonatomic, strong) NSArray<CurrencyInfo*> *showLegalTenderItems;
@property (nonatomic, strong) IcanWalletSelectVirtualHeadView *headView;
@end

@implementation IcanWalletSelectVirtualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    "Selectcurrency"="选择货币";
   
    self.title = @"Selectcurrency".icanlocalized;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"VirtualCurrency"];
    self.legalTenderItems =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate];
    self.showLegalTenderItems = _legalTenderItems;
    
    if (self.type == IcanWalletSelectVirtualTypeAvailabalCurrency ||
        self.type == IcanWalletSelectVirtualTypeAllCurrency) {
        self.showLegalTenderItems = NULL;
        self.showLegalTenderItems = self.fromOrToCurrencyList;
    }
    self.tableView.tableHeaderView = self.headView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kIcanWalletSelectVirtualTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


-(void)layoutTableView{
    
}

-(IcanWalletSelectVirtualHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelectVirtualHeadView" owner:self options:nil].firstObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 95);
        @weakify(self);
        _headView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        _headView.cancelBlcok = ^{
            @strongify(self);
            [self.view endEditing:YES];
            [self searFriendWithText:@""];
        };
    }
    return _headView;
}

-(void)searFriendWithText:(NSString*)searchText{
    
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nameCn CONTAINS[c] %@ || nameEn CONTAINS[c] %@ || code CONTAINS[c] %@ ",searchText,searchText,searchText];
    
    if(self.type == IcanWalletSelectVirtualTypeAvailabalCurrency || self.type == IcanWalletSelectVirtualTypeAllCurrency){
        self.showLegalTenderItems = nil;
        self.showLegalTenderItems = [self.fromOrToCurrencyList filteredArrayUsingPredicate:gpredicate];
        if ([NSString isEmptyString:searchText]) {
            self.showLegalTenderItems = self.fromOrToCurrencyList;
        }
    }else{
        self.showLegalTenderItems = [self.legalTenderItems filteredArrayUsingPredicate:gpredicate];
        if ([NSString isEmptyString:searchText]) {
            self.showLegalTenderItems = self.legalTenderItems;
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.showLegalTenderItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.type == IcanWalletSelectVirtualTypeAvailabalCurrency){
        
        IcanWalletSelectVirtualTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletSelectVirtualTableViewCell];
        cell.fromToOtherCode = @"from";
        cell.currencyInfo = self.showLegalTenderItems[indexPath.row];
        
        return cell;
    }else if(self.type == IcanWalletSelectVirtualTypeAllCurrency){
        
        IcanWalletSelectVirtualTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletSelectVirtualTableViewCell];
        cell.fromToOtherCode = @"to";
        cell.currencyInfo = self.showLegalTenderItems[indexPath.row];
        
        return cell;
    }else{
        
        IcanWalletSelectVirtualTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletSelectVirtualTableViewCell];
        cell.fromToOtherCode = @"other";
        cell.currencyInfo = self.showLegalTenderItems[indexPath.row];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case IcanWalletSelectVirtualTypeRecharge:{
            GetC2CMainNetworkByCurrencyRequest*request = [GetC2CMainNetworkByCurrencyRequest request];
                           request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/channel/byCurrency/%@",self.showLegalTenderItems[indexPath.row].code];
                           [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ICanWalletMainNetworkInfo class] success:^(NSArray* response) {
                               IcanWalletRechargeQrCodeViewController * vc = [[IcanWalletRechargeQrCodeViewController alloc]init];
                                       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",@"TRC20"];
                                       NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",@"ERC20"];
                               vc.mainNetworkInfo = [response filteredArrayUsingPredicate:predicate].firstObject == nil ? [response filteredArrayUsingPredicate:predicate2].firstObject : [response filteredArrayUsingPredicate:predicate].firstObject;
                               vc.mainNetworkItems = response;
                               vc.currencyInfo = self.showLegalTenderItems[indexPath.row];
                               [self.navigationController pushViewController:vc animated:YES];
                           } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                               [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                           }];
        }
            break;
        case IcanWalletSelectVirtualTypeWithdraw:{
            IcanWalletWithdrawViewController * vc = [[IcanWalletWithdrawViewController alloc]init];
            vc.currencyInfo = self.showLegalTenderItems[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case IcanWalletSelectVirtualTypeAddNewAddress:{
            !self.selectBlock?:self.selectBlock(self.showLegalTenderItems[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case IcanWalletSelectVirtualTypeSettingMoney:{
            !self.selectBlock?:self.selectBlock(self.showLegalTenderItems[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case IcanWalletSelectVirtualTypeAvailabalCurrency:{
            !self.selectBlock?:self.selectBlock(self.showLegalTenderItems[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case IcanWalletSelectVirtualTypeAllCurrency:{
            !self.selectBlock?:self.selectBlock(self.showLegalTenderItems[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
            
        default:
            break;
    }
}
@end

