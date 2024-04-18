//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 30/9/2021
- File name:  ExchangeOrderInfoListViewController.m
- Description:
- Function List:
*/
        

#import "ExchangeOrderInfoListViewController.h"
#import "WalletHistoryListTableViewCell.h"
@interface ExchangeOrderInfoListViewController ()

@end

@implementation ExchangeOrderInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"兑换记录".icanlocalized;
    self.listRequest=[GetC2CExchangeOrderListRequest request];
    self.listClass=[ExchangeOrderListInfo class];
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kWalletHistoryListTableViewCell];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletHistoryListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kWalletHistoryListTableViewCell];
    cell.orderInfo=[self.listItems objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
