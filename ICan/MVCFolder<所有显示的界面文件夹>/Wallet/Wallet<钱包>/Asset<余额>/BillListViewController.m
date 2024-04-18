//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  BillListViewController.m
 - Description:
 - Function List:
 */


#import "BillListViewController.h"
#import "BillListTableViewCell.h"
#import "BillListDetailViewController.h"
#import "TransactionCell.h"
#import "RecentTransactionCellWithButtons.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "ViewPendingTransactionVC.h"
#import "TransactionDetailCell.h"
#import "ConfirmPopUp.h"
#import "C2CBillDetailViewController.h"
#import "EmailBindingViewController.h"
@interface BillListViewController ()
@property (nonatomic,weak) UIViewController * showViewController;
@property (nonatomic, strong) UIStackView *verticalStackView;
@end

@implementation BillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshList];
    [self setupVerticalStackView];
    self.verticalStackView.hidden = YES;
}

-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kBillListTableViewCell];
    [self.tableView registNibWithNibName:@"TransactionCell"];
    [self.tableView registNibWithNibName:@"TransactionDetailCell"];
    [self.tableView registNibWithNibName:@"RecentTransactionCellWithButtons"];
}

-(void)setupVerticalStackView {
   // Create the image view
   UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_mode"]];
   imageView.frame = CGRectMake(0, 0, 100, 100);
   imageView.contentMode = UIViewContentModeScaleAspectFit;

   // Create the label
   UILabel *label = [[UILabel alloc] init];
   label.text = @"There are no any transactions available in this moment".icanlocalized;
   label.textAlignment = NSTextAlignmentCenter;

   // Create the vertical stack view
   self.verticalStackView = [[UIStackView alloc] init];
   self.verticalStackView.axis = UILayoutConstraintAxisVertical;
   self.verticalStackView.spacing = 8.0; // Adjust spacing as needed
   self.verticalStackView.alignment = UIStackViewAlignmentCenter;
   
   // Add subviews to the stack view
   [self.verticalStackView addArrangedSubview:imageView];
   [self.verticalStackView addArrangedSubview:label];

   // Add the stack view to the view hierarchy
   [self.view addSubview:self.verticalStackView];
   
   // Configure auto layout constraints to center the stack view
   self.verticalStackView.translatesAutoresizingMaskIntoConstraints = NO;
   [self.verticalStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
   [self.verticalStackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.verticalStackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [self.verticalStackView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:20].active = YES;
}

-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isFromOrganization){
        if(self.isFromOrganizationAllTransactions){
            if(self.fromSeeMoreMy){
                return  130;
            }else{
                if(self.transactionStatusType == 1){
                    NSArray *userPermissionList = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPermissions"];
                    BOOL APR_TRANSACTION_Level = [userPermissionList containsObject:@"APR_TRANSACTION"];
                    if(APR_TRANSACTION_Level){
                        return 190;
                    }else{
                        return 160;
                    }
                }else{
                    return 160;
                }
            }
        }else{
            return kHeightBillListTableViewCell;
        }
    }else{
        return kHeightBillListTableViewCell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isFromOrganization){
        if(self.isFromOrganizationAllTransactions){
            self.tableView.backgroundColor = UIColorMakeHEXCOLOR(0XF2F1F6);
            if(self.fromSeeMoreMy){
                TransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionDetailCell"];
                TransactionDataContentResponse *model = [self.listItems objectAtIndex:indexPath.row];
                cell.isSeeMore = YES;
                [cell setData:model];
                cell.tapBlock = ^{
                    if([model.status isEqualToString:@"PENDING"]){
                        ViewPendingTransactionVC *homeVc = [[ViewPendingTransactionVC alloc]init];
                        homeVc.hidesBottomBarWhenPushed = YES;
                        homeVc.model = model;
                        [self.navigationController pushViewController:homeVc animated:YES];
                    }else if([model.status isEqualToString:@"APPROVED"]){
                        C2CBillDetailViewController * detailVc = [[C2CBillDetailViewController alloc]init];
                        detailVc.isFromOrgDetail = YES;
                        detailVc.isApproved = YES;
                        detailVc.orgTransactionModel = model;
                        [self.navigationController pushViewController:detailVc animated:YES];
                    }else if ([model.status isEqualToString:@"REJECTED"]){
                        C2CBillDetailViewController * detailVc = [[C2CBillDetailViewController alloc]init];
                        detailVc.isFromOrgDetail = YES;
                        detailVc.isApproved = NO;
                        detailVc.orgTransactionModel = model;
                        [self.navigationController pushViewController:detailVc animated:YES];
                    }
                };
                return cell;
            }else{
                if(self.transactionStatusType == 1){
                    RecentTransactionCellWithButtons *cell=[tableView dequeueReusableCellWithIdentifier:@"RecentTransactionCellWithButtons"];
                    TransactionDataContentResponse *model = [self.listItems objectAtIndex:indexPath.row];
                    [cell setData:model];
                    cell.acceptBlock = ^{
                        [self acceptTransactionNetworkRequest:model];
                    };
                    cell.rejectBlock = ^{
                        [self rejectTransactionNetworkRequest:model];
                    };
                    cell.tapBlock= ^{
                        ViewPendingTransactionVC *homeVc = [[ViewPendingTransactionVC alloc]init];
                        homeVc.hidesBottomBarWhenPushed = YES;
                        homeVc.model = model;
                        [self.navigationController pushViewController:homeVc animated:YES];
                    };
                    return cell;
                }else{
                    TransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionDetailCell"];
                    TransactionDataContentResponse *model = [self.listItems objectAtIndex:indexPath.row];
                    cell.isNeedToAndBy = YES;
                    cell.transactionStatusType = self.transactionStatusType;
                    cell.tapBlock = ^{
                        C2CBillDetailViewController * detailVc = [[C2CBillDetailViewController alloc]init];
                        detailVc.isFromOrgDetail = YES;
                        if(self.transactionStatusType == 3){
                            detailVc.isApproved = NO;
                        }else if (self.transactionStatusType == 2){
                            detailVc.isApproved = YES;
                        }
                        detailVc.orgTransactionModel = model;
                        [self.navigationController pushViewController:detailVc animated:YES];
                    };
                    [cell setData:model];
                    return cell;
                }
            }
            
        }else{
            TransactionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
            TransactionDataContentResponse *model = [self.listItems objectAtIndex:indexPath.row];
            [cell setData:model];
            return cell;
        }
    }else{
        BillListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kBillListTableViewCell];
        cell.billInfo = [self.listItems objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isFromOrganization){
        NSLog(@"clicked");
    }else{
        BillListDetailViewController *vc = [BillListDetailViewController new];
        vc.billInfo = [self.listItems objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)acceptTransactionNetworkRequest:(TransactionDataContentResponse *) model{
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [[PayManager sharedManager]checkPaymentPasswordWithOther: @"Password".icanlocalized needSub: @"Enter the payment password".icanlocalized successBlock:^(NSString * _Nonnull password) {
            ApproveOrRejectTransaction *request = [ApproveOrRejectTransaction request];
            request.isApproved = TRUE;
            request.payPassword = password;
            request.transactionId = model.transactionId;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
                [QMUITips hideAllTips];
                [UserInfoManager sharedManager].attemptCount = nil;
                [UserInfoManager sharedManager].isPayBlocked = NO;
                [QMUITipsTool showOnlyTextWithMessage:@"Success".icanlocalized inView:nil];
                double delayInSeconds = 1.5;
                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                       [self fetchListRequest];
                       [self refreshList];
                   });
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self acceptTransactionNetworkRequest:model];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self acceptTransactionNetworkRequest:model];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                    }
                } else {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                }
            }];
        }];
    }else {
        [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
            if (index == 0) {
                if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                    EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }else{
                    SettingPaymentPasswordViewController*vc=[[SettingPaymentPasswordViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }
        }];
    }
}

-(void)rejectTransactionNetworkRequest:(TransactionDataContentResponse *) model{
    ConfirmPopUp *vc = [[ConfirmPopUp alloc] init];
        vc.type = 1;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // Adjust alpha as needed
        vc.noBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        vc.sureBlock = ^{
            ApproveOrRejectTransaction *request = [ApproveOrRejectTransaction request];
            request.isApproved = FALSE;
            request.transactionId = model.transactionId;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
                [QMUITips hideAllTips];
                [self fetchListRequest];
                [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
            }];
        };
        [self presentViewController:vc animated:YES completion:nil];
}

-(void)fetchListRequest{
    if(self.isFromOrganization){
        if(self.isFromOrganizationAllTransactions){
            GetTransactionsRequest *request = [GetTransactionsRequest request];
            request.size = @(self.pageSize);
            request.page = @(self.current);
            //Status
            if(self.transactionStatusType == 1){
                request.status = @"PENDING";
                if(self.fromSeeMoreMy){
                    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/organization/transactions/self"];
                }else{
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/organization/transactions/toApprove?page=%lu&size=%lu", self.current, self.pageSize];
                }
            }else if(self.transactionStatusType == 2){
                if(self.fromSeeMoreMy){
                    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/organization/transactions/self"];
                }else{
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/organization/transactions/operatedByMe"];
                }
                request.status = @"APPROVED";
            }else if(self.transactionStatusType == 3){
                if(self.fromSeeMoreMy){
                    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/organization/transactions/self"];
                }else{
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/organization/transactions/operatedByMe"];
                }
                request.status = @"REJECTED";
            }
            
            if([self.dataTypeTrans isEqualToString:@"All".icanlocalized]){
                if([self.currencyType isEqualToString:@"USDT"]){
                    NSArray *typeArray = @[ @"C2C_TRANSFER",@"C2C_WITHDRAWAL",@"C2C_UTIL_PAY",@"P2P"];
                    request.types = typeArray;
                }else  if([self.currencyType isEqualToString:@"CNY"]){
                    NSArray *typeArray = @[ @"RED_PACKET",@"TRANSFER",@"WITHDRAWAL",@"UTIL_PAY"];
                    request.types = typeArray;
                }else{
                    NSArray *typeArray = @[];
                    request.types = typeArray;
                }
            }else if ([self.dataTypeTrans isEqualToString:@"chatView.function.redPacket".icanlocalized]){
                NSArray *typeArray = @[ @"RED_PACKET"];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"chatView.function.transfer".icanlocalized]){
                NSArray *typeArray = @[ @"TRANSFER" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"Withdrawals".icanlocalized]){
                NSArray *typeArray = @[ @"WITHDRAWAL" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"Utility payments".icanlocalized]){
                NSArray *typeArray = @[ @"UTIL_PAY" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"C2C Transfer".icanlocalized]){
                NSArray *typeArray = @[ @"C2C_TRANSFER" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"C2C Withdrawal".icanlocalized]){
                NSArray *typeArray = @[ @"C2C_WITHDRAWAL" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"Utility Payments".icanlocalized]){
                NSArray *typeArray = @[ @"C2C_UTIL_PAY" ];
                request.types = typeArray;
            }else if ([self.dataTypeTrans isEqualToString:@"C2C".icanlocalized]){
                NSArray *typeArray = @[ @"P2P" ];
                request.types = typeArray;
            }
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[TransactionData class] contentClass:[TransactionData class] success:^(TransactionData* response) {
                self.listInfo = response;
                if (self.current == 0) {
                    self.listItems = [NSMutableArray arrayWithArray:response.content];
                    if(self.listItems.count > 0){
                        self.verticalStackView.hidden = YES;
                    }else{
                        self.verticalStackView.hidden = NO;
                    }
                }else{
                    [self.listItems addObjectsFromArray:response.content];
                }
                [self checkHasFooter];
                [self endingRefresh];
                [self.tableView reloadData];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                DDLogInfo(@"error=%@",error);
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
            }];
        }else{
            GetTransactionsRequest *request = [GetTransactionsRequest request];
            if(self.memberInfo.userId == [UserInfoManager.sharedManager.userId integerValue]){
                request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/organization/transactions/self?page=%@&size=%@",@(self.current),@(self.pageSize)];
            }else{
                request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/organization/transactions/orgUser?page=%@&size=%@",@(self.current),@(self.pageSize)];
            }
            if (self.transactionType == 2){
                NSArray *typeArray = @[ @"RED_PACKET"];
                request.types = typeArray;
            }else if (self.transactionType == 3){
                NSArray *typeArray = @[ @"TRANSFER" ];
                request.types = typeArray;
            }else if (self.transactionType == 4){
                NSArray *typeArray = @[ @"WITHDRAWAL" ];
                request.types = typeArray;
            }else if (self.transactionType == 5){
                NSArray *typeArray = @[ @"UTIL_PAY" ];
                request.types = typeArray;
            }else if (self.transactionType == 6){
                NSArray *typeArray = @[ @"C2C_TRANSFER" ];
                request.types = typeArray;
            }else if (self.transactionType == 7){
                NSArray *typeArray = @[ @"C2C_WITHDRAWAL" ];
                request.types = typeArray;
            }else if (self.transactionType == 8){
                NSArray *typeArray = @[ @"C2C_UTIL_PAY" ];
                request.types = typeArray;
            }else if (self.transactionType == 9){
                NSArray *typeArray = @[ @"P2P" ];
                request.types = typeArray;
            }

            request.userId = self.memberInfo.userId;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[TransactionData class] contentClass:[TransactionData class] success:^(TransactionData* response) {
                self.listInfo = response;
                if (self.current == 0) {
                    self.listItems = [NSMutableArray arrayWithArray:response.content];
                }else{
                    [self.listItems addObjectsFromArray:response.content];
                }
                [self checkHasFooter];
                [self endingRefresh];
                [self.tableView reloadData];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                DDLogInfo(@"error=%@",error);
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
            }];
        }
    }else{
        GetFlowsRequest *request = [GetFlowsRequest request];
        request.size = @(self.pageSize);
        request.page = @(self.current);
        if (self.flowType == FlowTypeIncome) {
            request.income = @"true";
        }else if (self.flowType==FlowTypePay){
            request.income = @"false";
        }
        request.startTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",self.year,self.month];
        NSString *count = [GetTime daysCountOfMonth:self.month year:self.year];
        request.endTime = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59",self.year,self.month,count];
        request.parameters = [request mj_JSONObject];
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
        @weakify(self);
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[FlowsListInfo class] contentClass:[FlowsListInfo class] success:^(FlowsListInfo* response) {
            @strongify(self);
            self.listInfo = response;
            if (self.current == 0) {
                self.listItems = [NSMutableArray arrayWithArray:response.content];
            }else{
                [self.listItems addObjectsFromArray:response.content];
            }
            [self checkHasFooter];
            [self endingRefresh];
            [self.tableView reloadData];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}


@end
