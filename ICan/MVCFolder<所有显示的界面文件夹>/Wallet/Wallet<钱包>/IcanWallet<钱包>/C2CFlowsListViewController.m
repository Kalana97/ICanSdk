//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  C2CFlowsListViewController.m
- Description:
- Function List:
*/
        

#import "C2CFlowsListViewController.h"
#import "C2CFlowsListTableViewCell.h"
#import "C2CBillDetailViewController.h"
@interface C2CFlowsListViewController ()

@end

@implementation C2CFlowsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"C2CFlowListTitle".icanlocalized;
    self.listClass = [C2CTransferHistoryListInfo class];
    C2CTransferHistoryListRequest * request = [C2CTransferHistoryListRequest request];
    request.type = @"QrcodePayFlow,TransferRecord";
    self.listRequest = request;
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kC2CFlowsListTableViewCell];
    self.tableView.backgroundColor = UIColorBg243Color;
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
    C2CFlowsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CFlowsListTableViewCell];
    cell.flowsInfo = self.listItems[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CBillDetailViewController*vc = [[C2CBillDetailViewController alloc]init];
    C2CFlowsInfo* c2cFlowsInfo = [self.listItems objectAtIndex:indexPath.row];
    vc.c2cFlowsInfo = c2cFlowsInfo;
    
    if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalWithdraw"]) {
       
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"QrcodePayFlow"]) {
        
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"TransferRecord"]) {
        
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"AdOrder"]) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"FundsTransfer"]) {
        
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalRecharge"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrder"]){
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"OfflineRecharge"]){
        
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrderRefund"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
@end
