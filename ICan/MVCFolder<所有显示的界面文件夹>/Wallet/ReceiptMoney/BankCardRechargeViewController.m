//
//  BankCardRechargeViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardRechargeViewController.h"
#import "BankCardRechargeHeaderView.h"
#import "BankCardRechargeTableViewCell.h"

@interface BankCardRechargeViewController ()

@property (nonatomic,strong)BankCardRechargeHeaderView * headerView;
@property (nonatomic,assign)NSInteger currentSelectd;
@property (nonatomic,strong)NSArray <BankCardsUsuallyInfo*>* usuallyBankCarItems;

@end

@implementation BankCardRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Cards",银行卡);
    [self fetchBankCardsUsuallyRequest];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registNibWithNibName:KBankCardRechargeTableViewCell];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KHeightBankCardRechargeTableViewCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.usuallyBankCarItems.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardRechargeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KBankCardRechargeTableViewCell];
    BankCardsUsuallyInfo * bankCardInfo =[self.usuallyBankCarItems objectAtIndex:indexPath.row];
    cell.cardNumberLabel.text = bankCardInfo.bankCardName;
    cell.isSelected = indexPath.row==self.currentSelectd;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelectd = indexPath.row;
    BankCardRechargeTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.headerView.cardNumTextfield.text = cell.cardNumberLabel.text;
    [self.tableView reloadData];
    
}


-(void)setBankCardNumber{
    if (self.usuallyBankCarItems.count==0) {
        return;
    }
    BankCardsUsuallyInfo * bankCardInfo =[self.usuallyBankCarItems objectAtIndex:0];
    self.headerView.cardNumTextfield.text = bankCardInfo.bankCardName;
}



-(BankCardRechargeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[BankCardRechargeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 230)];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            _headerView.moneyTextfield.text =[NSString stringWithFormat:@"%@ %@",self.orderAmount,NSLocalizedString(@"YuanChat",元)];
         }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            _headerView.moneyTextfield.text =[NSString stringWithFormat:@"%@ %@",self.orderAmount,NSLocalizedString(@"Yuan",元)];
        }
        @weakify(self);
        _headerView.nextStepBlock = ^{
            @strongify(self);
            [self rechargeWithBankCard];
        };
    }
    return _headerView;
}

//充值
-(void)rechargeWithBankCard{
//    NSNumber * orderAmount = @([self.orderAmount integerValue]);
    RechargeRequest * request =[RechargeRequest request];
    request.payType  =self.rechargeChannelInfo.channelCode;
    request.orderAmount = self.orderAmount;
    request.bankCardNo = self.headerView.cardNumTextfield.text;
    request.parameters  = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeInfo class] contentClass:[RechargeInfo class] success:^(RechargeInfo * response) {

        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:response.payUrl]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:response.payUrl] options:@{} completionHandler:nil];
            
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        
    }];
    
    
}

//获取常用银行卡列表

-(void)fetchBankCardsUsuallyRequest{
    GetBankCardsUsuallyRequest *request = [GetBankCardsUsuallyRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BankCardsUsuallyInfo class] success:^(NSArray* response) {
        self.usuallyBankCarItems = response;
        [self setBankCardNumber];
        [self.tableView reloadData];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}

@end
