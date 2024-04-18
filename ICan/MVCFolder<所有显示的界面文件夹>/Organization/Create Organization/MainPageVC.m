//
//  MainPageVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "MainPageVC.h"
#import "SettingsPageVC.h"
#import <QuartzCore/QuartzCore.h>
#import "TransactionDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "InviteVC.h"
#import "MembersVC.h"
#import "AllTransactionsVC.h"
#import "JKPickerView.h"
#import "C2CBillDetailViewController.h"
#import "ViewPendingTransactionVC.h"
#import "RecentTransactionCell.h"

@interface MainPageVC ()
@property(nonatomic,strong)UIButton * leftBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet DZIconImageView *orgLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *orgVerifyStatusLbl;
@property (weak, nonatomic) IBOutlet UIView *orgDetailsBgView;
@property (weak, nonatomic) IBOutlet UIView *pendingAppBgView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *currencyBgView;
@property (weak, nonatomic) IBOutlet UIView *inOutBgView;
@property (weak, nonatomic) IBOutlet UIStackView *currencyStack;
@property (weak, nonatomic) IBOutlet UILabel *currencyNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *timePeriodLblTitle;
@property (weak, nonatomic) IBOutlet UILabel *transactionTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *inAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *outAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *pendingAprrovalsCount;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *pendingAppLbl;
@property (weak, nonatomic) IBOutlet UILabel *approvedLbl;
@property (weak, nonatomic) IBOutlet UILabel *rejectedLbl;
@property (weak, nonatomic) IBOutlet UILabel *membersLbl;
@property (weak, nonatomic) IBOutlet UILabel *inviteLbl;
@property (weak, nonatomic) IBOutlet UILabel *inLbl;
@property (weak, nonatomic) IBOutlet UILabel *outLbl;
@property (weak, nonatomic) IBOutlet UILabel *recentTransactionLbl;
@property (weak, nonatomic) IBOutlet UIView *box2InsideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblViewHeightCons;
@property (weak, nonatomic) IBOutlet UIButton *settingsIcon;
@property (weak, nonatomic) IBOutlet UIView *emptyImg;
@property (weak, nonatomic) IBOutlet UIView *statusPenAprView;
@property (weak, nonatomic) IBOutlet UIView *membersUIView;
@property (weak, nonatomic) IBOutlet UIView *inviteUIView;
@property (weak, nonatomic) IBOutlet UIView *rejectUIView;
@property (weak, nonatomic) IBOutlet UIView *aproveUIView;
@property (nonatomic, strong) NSArray<InOutCurrencyResponse *> *currencytypes;
@property (nonatomic, strong) NSArray<TransactionDataContentResponse *> *transactionList;
@property (nonatomic, strong) NSMutableArray<NSString *> *currenciesNameList;
@property (weak, nonatomic) IBOutlet UILabel *popUpLbl;
@property (weak, nonatomic) IBOutlet UIView *manageUsersAndTransactionsUIViewStack;
@property (weak, nonatomic) IBOutlet UIView *pendingApprovalsStackUIView;
@property (weak, nonatomic) IBOutlet UIView *inOutUIView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;
@property (weak, nonatomic) IBOutlet UIStackView *btnStack;
@property (weak, nonatomic) IBOutlet UIView *btnStackUiView;
@property (weak, nonatomic) IBOutlet UIStackView *pendingStack;
@property (weak, nonatomic) IBOutlet UIImageView *aprImg;
@property (weak, nonatomic) IBOutlet UIImageView *rejImg;
@property (weak, nonatomic) IBOutlet UIImageView *memberImg;
@property (weak, nonatomic) IBOutlet UIImageView *inviteImg;

@end

@implementation MainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Organization".icanlocalized;
    [self setupUI];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"RecentTransactionCell"];
    self.timePeriodLblTitle.text = @"Last 24 Hr".icanlocalized;
    self.transactionTypeLbl.text = @"All".icanlocalized;
    [self addLocalizations];
    if(self.needBack){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    }
}

-(void)addLocalizations{
    self.pendingAppLbl.text = @"PENDING APPROVELS".icanlocalized;
    self.approvedLbl.text = @"Completed".icanlocalized;
    self.rejectedLbl.text = @"Rejected".icanlocalized;
    self.membersLbl.text = @"Members".icanlocalized;
    self.inviteLbl.text = @"Invite".icanlocalized;
    self.inLbl.text = @"IN".icanlocalized;
    self.outLbl.text = @"OUT".icanlocalized;
    self.recentTransactionLbl.text = @"Recent Transactions".icanlocalized;
    self.popUpLbl.text = @"There are no any transactions available in this moment".icanlocalized;
    [self.seeMoreBtn setTitle:@"SeeMore".icanlocalized forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self checkOrgStatus];
    [self getInOutValues:@"Last 24 Hr".icanlocalized currencyFilter:@"" success:^{
        [self setDefaultData];
        [self setData];
        self.pendingAprrovalsCount.text = [NSString stringWithFormat:@"%02ld", (long)self.organizationInfoModel.pendingApprovals];
    }];
    [self getRecentTransactions:1 successBlock:^{
        NSLog(@"completion");
    }];
}


-(void)setDefaultData{
    [self.currenciesNameList removeAllObjects];
    for (InOutCurrencyResponse *val in self.currencytypes) {
        [self.currenciesNameList addObject:val.currencyCode];
        self.currencyNamelbl.text = self.currenciesNameList.firstObject;
        for (InOutCurrencyResponse *val in self.currencytypes) {
            if([self.currencyNamelbl.text isEqualToString:val.currencyCode]){
                self.inAmtLbl.text = [self getConvertedBalance:val.inAmount];
                self.outAmtLbl.text = [self getConvertedBalance:val.outAmount];
            }
        }
    }
}

-(void)setCurrenciesOnChange{
    [self.currenciesNameList removeAllObjects];
    for (InOutCurrencyResponse *val in self.currencytypes) {
        [self.currenciesNameList addObject:val.currencyCode];
        for (InOutCurrencyResponse *val in self.currencytypes) {
            if([self.currencyNamelbl.text isEqualToString:val.currencyCode]){
                self.inAmtLbl.text = [self getConvertedBalance:val.inAmount];
                self.outAmtLbl.text = [self getConvertedBalance:val.outAmount];
            }
        }
    }
}

-(void)setupUI{
    [self.orgDetailsBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.pendingAppBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.box2InsideView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.currencyStack layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

-(void)setData{
    [self.orgLogoImg setDZIconImageViewWithUrl:self.organizationInfoModel.organizationImageUrl gender:@""];
    self.orgLogoImg.layer.cornerRadius = self.orgLogoImg.frame.size.height/2;
    self.orgLogoImg.clipsToBounds = YES;
    self.statusPenAprView.layer.cornerRadius = self.statusPenAprView.frame.size.height/2;
    self.statusPenAprView.clipsToBounds = YES;
    self.orgNameLbl.text = self.organizationInfoModel.name;
    if(self.organizationInfoModel.isVerified == true){
        self.orgVerifyStatusLbl.text = @"Verified".icanlocalized;
        self.statusImg.image = [UIImage imageNamed:@"verified3x"];
    }else{
        self.orgVerifyStatusLbl.text = @"Unverified".icanlocalized;
        self.statusImg.image = [UIImage imageNamed:@"questionIcon"];
    }
    if(self.organizationInfoModel.pendingApprovals > 0){
        self.statusPenAprView.hidden = NO;
    }else{
        self.statusPenAprView.hidden = YES;
    }
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton dzButtonWithTitle:nil image:@"cheveron-down" backgroundColor:UIColor.clearColor titleFont:18 titleColor:UIColor153Color target:self action:@selector(goBackVc)];
        _leftBtn.frame = CGRectMake(_leftBtn.frame.origin.x, _leftBtn.frame.origin.y, 40, 40);
    }
    return _leftBtn;
}

-(void)goBackVc{
    [[AppDelegate shared].curNav popToRootViewControllerAnimated:NO];
}

- (void)getInOutValues:(NSString *)timeFilter currencyFilter:(NSString *)currencyFilter success:(void (^)(void))successBlock {
    GetInOutTransactionAmountsRequest *request = [GetInOutTransactionAmountsRequest request];
    request.filter = [self getFilterTypeByString:timeFilter];
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[InOutResponse class] contentClass:[InOutResponse class] success:^(InOutResponse* response) {
        if (response.currencyAmounts) {
            self.currencytypes = response.currencyAmounts;
            [self setCurrenciesOnChange];
            if (successBlock) {
                successBlock();
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",info.desc);
    }];
}

-(void)getRecentTransactions:(NSInteger)reqType successBlock:(void (^)(void))successBlock{
    GetTransactionsRequest *request = [GetTransactionsRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/organization/transactions/self"];
    if (reqType == 2){
        NSArray *typeArray = @[ @"RED_PACKET"];
        request.types = typeArray;
    }else if (reqType == 3){
        NSArray *typeArray = @[ @"TRANSFER" ];
        request.types = typeArray;
    }else if (reqType == 4){
        NSArray *typeArray = @[ @"WITHDRAWAL" ];
        request.types = typeArray;
    }else if (reqType == 5){
        NSArray *typeArray = @[ @"UTIL_PAY" ];
        request.types = typeArray;
    }else if (reqType == 6){
        NSArray *typeArray = @[ @"C2C_TRANSFER" ];
        request.types = typeArray;
    }else if (reqType == 7){
        NSArray *typeArray = @[ @"C2C_WITHDRAWAL" ];
        request.types = typeArray;
    }else if (reqType == 8){
        NSArray *typeArray = @[ @"C2C_UTIL_PAY" ];
        request.types = typeArray;
    }else if (reqType == 9){
        NSArray *typeArray = @[ @"P2P" ];
        request.types = typeArray;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TransactionData class] contentClass:[TransactionData class] success:^(TransactionData *response) {
        self.transactionList = response.content;
        if(response.content.count > 2){
            self.seeMoreBtn.hidden = NO;
        }else{
            self.seeMoreBtn.hidden = YES;
        }
        if(response.content.count < 1){
            self.emptyImg.hidden = FALSE;
        }else{
            self.emptyImg.hidden = TRUE;
        }
        [self.myTableView reloadData];
        NSLog(@"success");
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",info.desc);
    }];
}

-(void)showTimerPickerView{
    [self.view endEditing:YES];
    NSArray *array = @[@"Last 24 Hr".icanlocalized, @"Last Week".icanlocalized, @"Last Month".icanlocalized];
    NSInteger row = [array indexOfObject:self.timePeriodLblTitle.text];
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Select period".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:array dataBlock:^(NSString* obj) {
        NSString *title = (NSString *)obj;
        self.timePeriodLblTitle.text = title;
        [self getInOutValues:self.timePeriodLblTitle.text currencyFilter:self.currencyNamelbl.text success:^{
            for (InOutCurrencyResponse *val in self.currencytypes) {
                if([val.currencyCode isEqualToString:self.currencyNamelbl.text]){
                    self.inAmtLbl.text = [self getConvertedBalance:val.inAmount];
                    self.outAmtLbl.text = [self getConvertedBalance:val.outAmount];
                    break;
                }
            }
        }];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

-(void)showCurrencyPickerView{
    [self.view endEditing:YES];
    NSInteger row = [self.currenciesNameList indexOfObject:self.currencyNamelbl.text];
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Selectcurrency".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:self.currenciesNameList dataBlock:^(NSString* obj) {
        NSString *title = (NSString *)obj;
        self.currencyNamelbl.text = title;
        [self getInOutValues:self.timePeriodLblTitle.text currencyFilter:self.currencyNamelbl.text success:^{
            for (InOutCurrencyResponse *val in self.currencytypes) {
                if([val.currencyCode isEqualToString:self.currencyNamelbl.text]){
                    self.inAmtLbl.text = [self getConvertedBalance:val.inAmount];
                    self.outAmtLbl.text = [self getConvertedBalance:val.outAmount];
                    break;
                }
            }
        }];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

-(void)showTransactionTypePickerView{
    [self.view endEditing:YES];
    NSArray *array = @[@"All".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"chatView.function.transfer".icanlocalized,@"Withdrawals".icanlocalized, @"Utility payments".icanlocalized,@"C2C Transfer".icanlocalized,@"C2C Withdrawal".icanlocalized,@"Utility Payments".icanlocalized,@"C2C".icanlocalized];
    NSInteger row = [array indexOfObject:self.transactionTypeLbl.text];
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Select".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:array dataBlock:^(NSString* obj) {
        NSString * title = (NSString *)obj;
        self.transactionTypeLbl.text = title;
        if([title isEqualToString:@"All".icanlocalized]){
            [self getRecentTransactions:1 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"chatView.function.redPacket".icanlocalized]){
            [self getRecentTransactions:2 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"chatView.function.transfer".icanlocalized]){
            [self getRecentTransactions:3 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"Withdrawals".icanlocalized]){
            [self getRecentTransactions:4 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"Utility payments".icanlocalized]){
            [self getRecentTransactions:5 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"C2C Transfer".icanlocalized]){
            [self getRecentTransactions:6 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"C2C Withdrawal".icanlocalized]){
            [self getRecentTransactions:7 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"Utility Payments".icanlocalized]){
            [self getRecentTransactions:8 successBlock:^{
                NSLog(@"Completion");
            }];
        }else if ([title isEqualToString:@"C2C".icanlocalized]){
            [self getRecentTransactions:9 successBlock:^{
                NSLog(@"Completion");
            }];
        }
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

- (void)removePick {
    [[JKPickerView sharedJKPickerView] removePickView];
}

- (void)sureAction {
    [[JKPickerView sharedJKPickerView] sureAction];
}

-(NSInteger)getFilterTypeByString:(NSString *)filterString{
    if([filterString isEqualToString:@"Last 24 Hr".icanlocalized]){
        return 1;
    }else if([filterString isEqualToString:@"Last Week".icanlocalized]){
        return 2;
    }else if([filterString isEqualToString:@"Last Month".icanlocalized]){
        return 3;
    }
    return 0;
}

-(NSString *)getConvertedBalance:(double)amt{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *formattedString = [numberFormatter stringFromNumber:@(amt)];
    return formattedString;
}

- (IBAction)goToSettingsPage:(id)sender {
    SettingsPageVC *homeVc = [[SettingsPageVC alloc]init];
    homeVc.organizationInfoModel = self.organizationInfoModel;
    homeVc.goBackData = ^(OrganizationDetailsInfo * _Nonnull modelData) {
        self.organizationInfoModel.name = modelData.name;
        self.organizationInfoModel.organizationImageUrl = modelData.organizationImageUrl;
        [self setData];
    };
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)inviteAction:(id)sender {
    InviteVC *homeVc = [[InviteVC alloc]init];
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)memberAction:(id)sender {
    MembersVC *homeVc = [[MembersVC alloc]init];
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)filterOptionsRecentTransactions:(id)sender {
    [self showTransactionTypePickerView];
}

- (IBAction)timePeriodFilterAction:(id)sender {
    [self showTimerPickerView];
}

- (IBAction)currencyFilterAction:(id)sender {
    [self showCurrencyPickerView];
}

- (IBAction)didClickOnPendingApprovals:(id)sender {
    AllTransactionsVC *homeVc = [[AllTransactionsVC alloc]init];
    homeVc.selectedIndex = 0;
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)didClickOnApprovedApprovals:(id)sender {
    AllTransactionsVC *homeVc = [[AllTransactionsVC alloc]init];
    homeVc.selectedIndex = 1;
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)didClickOnRejectedApprovals:(id)sender {
    AllTransactionsVC *homeVc = [[AllTransactionsVC alloc]init];
    homeVc.selectedIndex = 2;
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)seeMoreAction:(id)sender {
    AllTransactionsVC *homeVc = [[AllTransactionsVC alloc]init];
    homeVc.fromSeeMoreMy = YES;
    homeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.transactionList.count > 2){
        return 2;
    }else{
        return self.transactionList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecentTransactionCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"RecentTransactionCell"];
    TransactionDataContentResponse *model = self.transactionList[indexPath.row];
    [cell setData:self.transactionList[indexPath.row]];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(NSMutableArray *)currenciesNameList{
    if (!_currenciesNameList) {
        _currenciesNameList = [NSMutableArray array];
    }
    return _currenciesNameList;
}

-(void)checkOrgStatus{
    GetOrganizationInfoForUserRequest *request = [GetOrganizationInfoForUserRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo* response){
        self.organizationInfoModel = response;
        [self setData];
        [self changeSetupView:self.organizationInfoModel];
        self.pendingAprrovalsCount.text = [NSString stringWithFormat:@"%02ld", (long)self.organizationInfoModel.pendingApprovals];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",info.desc);
    }];
}

-(void)changeSetupView:(OrganizationDetailsInfo *)model{
    NSArray *userPermissions = model.permissions;
    [[NSUserDefaults standardUserDefaults] setObject:userPermissions forKey:@"UserPermissions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *userPermissionList = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPermissions"];
    for (NSString *action in userPermissionList) {
        if([action isEqualToString:REMOVE_USERS]){
            self.membersUIView.hidden = FALSE;
        }else if([action isEqualToString:INVITE_USERS]){
            self.inviteUIView.hidden = FALSE;
        }else if([action isEqualToString:CONFIRM_USERS]){
            self.inviteUIView.hidden = FALSE;
        }else if([action isEqualToString:VIEW_TRANSACTION_ORG]){
            self.aproveUIView.hidden = FALSE;
            self.rejectUIView.hidden = FALSE;
            self.membersUIView.hidden = FALSE;
            self.inOutUIView.hidden = FALSE;
            self.pendingApprovalsStackUIView.hidden = FALSE;
        }else if([action isEqualToString:APR_TRANSACTION]){
            self.aproveUIView.hidden = FALSE;
            self.rejectUIView.hidden = FALSE;
            self.pendingApprovalsStackUIView.hidden = FALSE;
            self.inOutUIView.hidden = FALSE;
        }else if([action isEqualToString:CHANGE_PERMISSION]){
            self.membersUIView.hidden = FALSE;
        }else if([action isEqualToString:OWNER]){
            self.settingsIcon.hidden = FALSE;
        }
    }
    if(self.membersUIView.isHidden || self.inviteUIView.isHidden || self.aproveUIView.isHidden || self.rejectUIView.isHidden){
        self.trailingConst.active = NO;
        CGFloat newSpacing = 20.0; // Set your desired spacing value
        self.btnStack.spacing = newSpacing;
    }else{
        self.trailingConst.active = YES;
    }
    
    if(self.membersUIView.isHidden && self.inviteUIView.isHidden && self.aproveUIView.isHidden && self.rejectUIView.isHidden){
        self.btnStackUiView.hidden = TRUE;
    }
    
    if(self.aproveUIView.isHidden){
           if(self.rejectUIView.isHidden){
               if(self.membersUIView.isHidden){
                   if(self.inviteUIView.isHidden){
                       
                   }else{
                       [self.pendingStack mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.left.equalTo(self.inviteImg.mas_left);
                       }];
                   }
               }else{
                   [self.pendingStack mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.equalTo(self.memberImg.mas_left);
                   }];
               }
           }else{
               [self.pendingStack mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.rejImg.mas_left);
               }];
           }
       }else{
           [self.pendingStack mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.aprImg.mas_left);
           }];
       }
}

@end
