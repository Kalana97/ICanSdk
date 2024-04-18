//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectUserViewController.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectBankHistoryViewController.h"
#import "IcanTransferSelectBankUserCell.h"
@interface IcanTransferSelectBankHistoryViewController ()
@property(nonatomic, strong) NSArray<BindingBankCardListInfo*> *bankCardItems;

@end

@implementation IcanTransferSelectBankHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SelectPayee".icanlocalized;
    [self fetchBankCardsListRequest];
   
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kIcanTransferSelectUserCell];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    headview.backgroundColor = UIColor.whiteColor;
    UILabel * label = [UILabel leftLabelWithTitle:@"HistoryPayee".icanlocalized font:14 color:UIColorMakeHEXCOLOR(0X666666)];
    label.frame = CGRectMake(10, 0, ScreenWidth-10, 40);
    [headview addSubview:label];
    return headview;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankCardItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanTransferSelectBankUserCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanTransferSelectUserCell];
    cell.cardInfo = self.bankCardItems[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.selectBlock?:self.selectBlock(self.bankCardItems[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchBankCardsListRequest{
    BindingBankCardListRequest*request=[BindingBankCardListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingBankCardListInfo class] success:^(NSArray* response) {
        self.bankCardItems = response;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
