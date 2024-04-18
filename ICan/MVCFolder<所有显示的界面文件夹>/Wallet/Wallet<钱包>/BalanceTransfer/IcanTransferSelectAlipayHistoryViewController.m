//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectAlipayViewController.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectAlipayHistoryViewController.h"
#import "IcanTransferSelectAlipayCell.h"
@interface IcanTransferSelectAlipayHistoryViewController ()
@property(nonatomic, strong) NSArray<BindingAliPayListInfo*> *alipayInfoItems;
@end

@implementation IcanTransferSelectAlipayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SelectPayee".icanlocalized;
    [self fetchBindingAlipayRequest];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kIcanTransferSelectAlipayCell];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel * label = [UILabel leftLabelWithTitle:@"HistoryPayee".icanlocalized font:14 color:UIColorMakeHEXCOLOR(0X666666)];
    label.frame = CGRectMake(10, 0, ScreenWidth-10, 40);
    [headview addSubview:label];
    return headview;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanTransferSelectAlipayCell*cell = [tableView dequeueReusableCellWithIdentifier:kIcanTransferSelectAlipayCell];
    cell.alipayInfo = self.alipayInfoItems[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.selectBlock?:self.selectBlock(self.alipayInfoItems[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fetchBindingAlipayRequest{
    BindingAliPayListRequest*request=[BindingAliPayListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingAliPayListInfo class] success:^(NSArray* response) {
        self.alipayInfoItems=response;
        
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
