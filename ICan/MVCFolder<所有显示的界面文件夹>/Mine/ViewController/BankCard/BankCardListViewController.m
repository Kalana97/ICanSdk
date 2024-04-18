//
//  BankCardListViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardListViewController.h"
#import "BankCardListAddTableViewCell.h"
#import "AddBankCardViewController.h"
#import "BankCardListTableViewCell.h"
@interface BankCardListViewController ()
@property(nonatomic, strong) NSMutableArray<BindingBankCardListInfo*> *bindingBankListItems;
@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchBankCardsListRequest];
    self.title =NSLocalizedString(@"mine.listView.cell.bankCard", 银行卡);
    if ([UserInfoManager sharedManager].openPay) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Add", 添加) style:UIBarButtonItemStyleDone target:self action:@selector(addBankCard)];
    }
    
    
}

-(void)addBankCard{
    AddBankCardViewController*vc=[AddBankCardViewController new];
    vc.addBankCardSuccessBlock = ^{
        [self fetchBankCardsListRequest];
    };
    [self.navigationController pushViewController:vc animated:YES];

    
    
}

-(void)initTableView{
    [super initTableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registNibWithNibName:kBankCardListTableViewCell];
}



-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[@"Delete" icanlocalized:@"删除"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"DeleteBankcardTips", 是否删除银行卡) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteBankCard:[self.bindingBankListItems objectAtIndex:indexPath.section]];
            [self.bindingBankListItems removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
            
        }];
        [alert addAction:cancel];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }];
    return @[deleted];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?44.0:0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        UIView*lineView=[[UIView alloc]init];
        lineView.backgroundColor=UIColorViewBgColor;
        view.backgroundColor = UIColor10PxClearanceBgColor;
        UILabel * label = [UILabel leftLabelWithTitle:NSLocalizedString(@"My bank card",我的银行卡) font:14 color:UIColorThemeMainSubTitleColor];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@11);
        }];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@10);
        }];
        return view;
    }
    return 0;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineView.backgroundColor=UIColorViewBgColor;
    return lineView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bindingBankListItems.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightBankCardListTableViewCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kBankCardListTableViewCell];
    cell.bindingBankCardListInfo=self.bindingBankListItems[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFromWithdraw) {
        [self.navigationController popViewControllerAnimated:YES]; !self.selectBankcardBlock?:self.selectBankcardBlock(self.bindingBankListItems[indexPath.section]);
    }
}

-(void)fetchBankCardsListRequest{
    BindingBankCardListRequest*request=[BindingBankCardListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingBankCardListInfo class] success:^(NSArray* response) {
        self.bindingBankListItems = [NSMutableArray arrayWithArray:response];
        [self.tableView reloadData];
        if (self.bindingBankListItems.count==0) {
            [self showEmptyView];
            [self showEmptyViewWithText:NSLocalizedString(@"No Data", 暂无数据) detailText:nil buttonTitle:nil buttonAction:nil];
        }else{
            [self hideEmptyView];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)deleteBankCard:(BindingBankCardListInfo*)info{
    DeleteBankCardRequest*request=[DeleteBankCardRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/bankCards/bankCard/%@/%@",info.bindId,info.cardNo];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [self fetchBankCardsListRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

@end
