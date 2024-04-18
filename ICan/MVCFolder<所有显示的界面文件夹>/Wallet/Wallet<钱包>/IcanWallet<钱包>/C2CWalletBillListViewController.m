//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  BillListViewController.m
 - Description:
 - Function List:
 */


#import "C2CWalletBillListViewController.h"
#import "BillListTableViewCell.h"
#import <BRPickerView.h>
#import "BillListSectionHeaderView.h"
#import "C2CBillDetailViewController.h"
@interface C2CWalletBillListViewController ()
@property(nonatomic,strong)BillListSectionHeaderView *sectionHeaderView;
@property(nonatomic,copy) NSString *year;
@property(nonatomic,copy) NSString *month;
@end

@implementation C2CWalletBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Transactions",账单);
    NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
    self.year = [GetTime stringFromDate:date withDateFormat:@"yyyy"];
    self.month = [GetTime stringFromDate:date withDateFormat:@"MM"];
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kBillListTableViewCell];
    [self.view addSubview:self.sectionHeaderView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.sectionHeaderView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
    
}


-(void)layoutTableView{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightBillListTableViewCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kBillListTableViewCell];
    cell.c2cFlowsInfo = [self.listItems objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    C2CBillDetailViewController*vc = [[C2CBillDetailViewController alloc]init];
    C2CFlowsInfo* c2cFlowsInfo = [self.listItems objectAtIndex:indexPath.row];
    vc.c2cFlowsInfo = c2cFlowsInfo;
    
    if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalWithdraw"]) {
       
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"QrcodePayFlow"]) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"TransferRecord"]) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"AdOrder"]) {
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"FundsTransfer"]) {
        vc.isWalletSwap = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalRecharge"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrder"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"OfflineRecharge"]){
        
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrderRefund"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([c2cFlowsInfo.flowType isEqualToString:@"CurrencyExchange"]){
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)showDatePickerView{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYM];
    // 2.设置属性
    datePickerView.title = @"Select period".icanlocalized;
    //    @"2019-10"
    datePickerView.selectValue = [NSString stringWithFormat:@"%@-%@",self.year,self.month];
    //    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:2010 month:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    //     datePickerView.addToNow = YES;  // 是否添加“至今”
    // datePickerView.showToday = YES; // 是否显示“今天”
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSArray * dateArray = [selectValue componentsSeparatedByString:@"-"];
        self.year = [dateArray objectAtIndex:0];
        self.month = [dateArray objectAtIndex:1];
        self.sectionHeaderView.timeLabel.text = [NSString stringWithFormat:@"%@/%@/",self.year,self.month];
        [self refreshList];
        
    };
    // 自定义主题样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColorBg243Color;
    customStyle.pickerTextColor = UIColor102Color;
    customStyle.separatorColor = UIColor102Color;
    datePickerView.pickerStyle = customStyle;
    customStyle.titleBarColor=UIColor.whiteColor;
    // 3.显示
    [datePickerView show];
    
}

-(BillListSectionHeaderView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[BillListSectionHeaderView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, 40)];
        @weakify(self);
        _sectionHeaderView.tapBlock = ^{
            @strongify(self);
            [self showDatePickerView];
        };
    }
    return _sectionHeaderView;
}

-(void)fetchListRequest{
    C2CTransferHistoryListRequest *request = [C2CTransferHistoryListRequest request];
    request.size=@(self.pageSize);
    request.current=@(self.current);
    request.start = [NSString stringWithFormat:@"%@-%@-01 00:00:00",self.year,self.month];
    NSString *count=[GetTime daysCountOfMonth:self.month year:self.year];
    request.end = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59",self.year,self.month,count];
    request.parameters = [request mj_JSONObject];
    
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CTransferHistoryListInfo class] contentClass:[C2CTransferHistoryListInfo class] success:^(C2CTransferHistoryListInfo*  _Nonnull response) {
        self.listInfo=response;
        
        if (self.current==1) {
            self.listItems=[NSMutableArray arrayWithArray:response.records];
        }else{
            [self.listItems addObjectsFromArray:response.records];
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}


@end
