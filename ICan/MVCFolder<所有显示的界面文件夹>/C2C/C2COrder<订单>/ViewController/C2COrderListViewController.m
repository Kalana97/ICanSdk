//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2COrderListViewController.m
- Description:
- Function List:
*/
        

#import "C2COrderListViewController.h"
#import "C2COrderDetailViewController.h"
#import "C2COrderListCell.h"
#import "C2CPaymentViewController.h"
#import "C2CConfirmReceiptMoneyViewController.h"
#import "C2CPConfirmOrderViewController.h"
#import "WCDBManager+ChatList.h"

@interface C2COrderListViewController ()

@end

@implementation C2COrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:KChatListRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:kC2CRefreshOrderListNotification object:nil];
    C2CMyOrderListRequest *request = [C2CMyOrderListRequest request];
    request.orderStatus = self.orderStatus;
    self.listRequest =  request;
    self.listClass = [C2COrderListInfo class];
    [self refreshList];
    
}
-(void)handleFetchlistSuccess:(C2CListInfo *)response{
    [super handleFetchlistSuccess:response];
    if (self.current==1&&response.records.count==0) {
        [self showEmptyViewWithLoading:NO image:UIImageMake(@"img_c2c_order_empty") text:@"NoOrderTemporarily".icanlocalized detailText:nil buttonTitle:nil buttonAction:nil];
    }else{
        [self hideEmptyView];
        [self.tableView reloadData];
    }
    
}
-(void)reloadTableView{
    [self.tableView reloadData];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kC2COrderListCell];
    
    
}


-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
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

    C2COrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2COrderListCell];
    cell.orderInfo = self.listItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果用户没有付款 那么跳转到付款界面
    C2COrderInfo *orderInfo = self.listItems[indexPath.row];
    NSNumber *count = 0;
    BOOL haveUnreadMsg = NO;
    if(orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:orderInfo.sellUser.userId c2cOrderId:orderInfo.orderId icanUserId:orderInfo.sellUser.uid];
    }else {
        count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:orderInfo.buyUser.userId c2cOrderId:orderInfo.orderId icanUserId:orderInfo.buyUser.uid];
    }
    if([count intValue] > 0) {
        haveUnreadMsg = YES;
    }else {
        haveUnreadMsg = NO;
    }
    if ([orderInfo.status isEqualToString:@"Unpaid"]) {
        //如果购买的用户是自己 跳转到付款界面
        if (orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
            C2CPConfirmOrderViewController *vc = [[C2CPConfirmOrderViewController alloc]init];
            vc.orderInfo = orderInfo;
            [self getC2CAdverDetailInfo:orderInfo successBlock:^(C2CAdverInfo *adverInfo) {
                vc.adverInfo = adverInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }else{
            //订单详情
            C2COrderDetailViewController *vc = [[C2COrderDetailViewController alloc]init];
            vc.orderInfo = orderInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([orderInfo.status isEqualToString:@"Paid"]) {
        //如果购买的用户是自己 是购买
        if (orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
            //订单详情
            C2COrderDetailViewController *vc = [[C2COrderDetailViewController alloc]init];
            vc.orderInfo = orderInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//跳转到收款界面
            C2CConfirmReceiptMoneyViewController *vc = [[C2CConfirmReceiptMoneyViewController alloc]init];
            vc.orderInfo = orderInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        C2COrderDetailViewController *vc = [[C2COrderDetailViewController alloc]init];
        vc.orderInfo = orderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)getC2CAdverDetailInfo:(C2COrderInfo*)orderInfo successBlock:(void(^)(C2CAdverInfo*adverInfo))successBlcok{
    C2CGetAdverDetailRequest * request = [C2CGetAdverDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld",orderInfo.adId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAdverInfo class] contentClass:[C2CAdverInfo class] success:^(C2CAdverInfo*  _Nonnull response) {
        if (successBlcok) {
            successBlcok(response);
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
