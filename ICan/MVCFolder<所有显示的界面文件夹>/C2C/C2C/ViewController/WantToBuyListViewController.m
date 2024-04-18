//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyListViewController.m
- Description:
- Function List:
*/
        

#import "WantToBuyListViewController.h"
#import "WantToBuyListTableViewCell.h"
#import "C2COptionalSaleViewController.h"
#import "CertificationViewController.h"
@interface WantToBuyListViewController ()

@end

@implementation WantToBuyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFetchRequest];
}
-(void)resetFetchRequest{
    C2CGetOptionalListRequest *request = [C2CGetOptionalListRequest request];
    request.legalTender = self.currencyInfo.code;
    request.virtualCurrency = self.exchangeRateIno.virtualCurrency;
    if (self.isOptionBuy) {
        request.transactionType = @"Sell";
    }else{
        request.transactionType = @"Buy";
    }
    if (self.amount) {
        request.money = self.amount;
    }
    //Wechat,AliPay,BankTransfer
    if ([self.paymentMethodType isEqualToString:@"C2CBankCard".icanlocalized]) {
        request.paymentMethodType = @"BankTransfer";
    }else if ([self.paymentMethodType isEqualToString:@"C2CAlipay".icanlocalized]) {
        request.paymentMethodType = @"AliPay";
    }else if ([self.paymentMethodType isEqualToString:@"C2CWeChat".icanlocalized]) {
        request.paymentMethodType = @"Wechat";
    }
    self.listRequest =  request;
    self.listClass = [C2COptionalListInfo class];
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kWantToBuyListTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WantToBuyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kWantToBuyListTableViewCell];
    cell.adverInfo = [self.listItems objectAtIndex:indexPath.row];
    cell.isOptionBuy = self.isOptionBuy;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 认证状态,可用值:NotAuth,Authing,Authed */
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        C2CAdverInfo * info = [self.listItems objectAtIndex:indexPath.row];
        if (info.userId == C2CUserManager.shared.userId.integerValue) {
            return;
        }
        if (info.count.floatValue - info.finishCount.floatValue == 0) {
            [QMUITipsTool showOnlyTextWithMessage:@"QuantityisNullTips".icanlocalized inView:self.view];
            return;
        }
        if (self.isOptionBuy) {
            C2COptionalSaleViewController * vc = [C2COptionalSaleViewController  new];
            vc.adverInfo = [self.listItems objectAtIndex:indexPath.row];
            vc.isBuy = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            C2COptionalSaleViewController * vc = [C2COptionalSaleViewController  new];
            vc.isBuy = NO;
            vc.adverInfo = [self.listItems objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        [UIAlertController alertControllerWithTitle:@"RealnameNoAuthTip".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                CertificationViewController *vc =[[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
       
    }
    
    
    
}

@end
