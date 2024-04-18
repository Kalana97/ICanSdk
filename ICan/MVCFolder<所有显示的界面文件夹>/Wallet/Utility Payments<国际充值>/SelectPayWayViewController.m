
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 1/7/2021
 - File name:  SelectPayWayViewController.m
 - Description:
 - Function List:
 */


#import "SelectPayWayViewController.h"
#import "SelectPayWayHeadView.h"
#import "RechargeChannelTableViewCell.h"
#import "PayManager.h"
#import "IcanThirdPayViewController.h"
#import "ShowUtilityFavoritesView.h"
#import "UtilityPaymentsSuccessViewController.h"
#import "UtilityPaymentsFailViewController.h"
#import "Select43PayWayViewController.h"
#import "PayResultWebViewController.h"
#import "WebPageVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SelectPayWayViewController ()
@property(nonatomic, strong)  UIButton *footerButton;
@property(nonatomic, strong)  NSArray * channelItems;
@property(nonatomic, assign)  NSInteger currentSelected;
@property(nonatomic, strong)  SelectPayWayHeadView *headerView;
@property(nonatomic, strong)  RechargeChannelInfo *selectChannelInfo;
@property(nonatomic, strong)  PayManager *payManager;
@property(nonatomic, strong) DialogPaymentInfo *dialogPaymentInfo;
@property(nonatomic, copy) NSString *paymentStatusResponse;
@property(nonatomic, strong)  ShowUtilityFavoritesView *favoritesView;
@property(nonatomic, strong) C2CPreparePayOrderDetailInfo *detailInfo;
@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property (nonatomic, assign) BOOL isSwitchOn;
@end

@implementation SelectPayWayViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSwitchOn = YES;
    self.selectCurrencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:@"USDT"];
    self.headerView.moneyLbl.text=[NSString stringWithFormat:@"%@ %.2f",self.currencyCode,self.amount.doubleValue];
    //    "SelectPayWayViewController.title"="支付";
    
    self.title=@"SelectPayWayViewController.title".icanlocalized;
    self.view.backgroundColor=UIColorBg243Color;
    [self.view addSubview:self.footerButton];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@(-34));
        make.height.equalTo(@45);
    }];
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        
    }];
    [self fetchChannelRequest];
    
}
-(void)layoutTableView{
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@-65);
    }];
    self.tableView.backgroundColor = UIColorBg243Color;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registNibWithNibName:KRechargeChannelTableViewCell];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.channelItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeChannelInfo * rechargeChannelInfo = [self.channelItems objectAtIndex:indexPath.row];
    if([rechargeChannelInfo.payType isEqual:@"BankCard"]){
        return 80;
    }else if([rechargeChannelInfo.payType isEqual:@"LankaPay"]){
        return 70;
    }else if([rechargeChannelInfo.payType isEqual:@"CryptoPay"]){
        return 100;
    }
    return KHeightRechargeChannelTableViewCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeChannelInfo * rechargeChannelInfo = [self.channelItems objectAtIndex:indexPath.row];
    RechargeChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRechargeChannelTableViewCell];
    cell.userBalanceInfo = self.userBalanceInfo;
    cell.currentInfo = self.currentInfo;
    cell.rechargeChannelInfo = rechargeChannelInfo;
    cell.isSelected = indexPath.row==self.currentSelected;
    cell.lineView.hidden=indexPath.row==self.channelItems.count-1;
    cell.sureBlock = ^{
        self.isSwitchOn = !self.isSwitchOn;
        if (self.isSwitchOn) {
            NSLog(@"Switch is ON");
            [cell.swtitchBtn setImage:[UIImage imageNamed:@"switchOn"] forState:UIControlStateNormal];
            
        } else {
            NSLog(@"Switch is OFF");
            [cell.swtitchBtn setImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
        }
    };
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelected = indexPath.row;
    self.selectChannelInfo=[self.channelItems objectAtIndex:indexPath.row];
    [self.tableView reloadData];
}
#pragma mark - Lazy
-(UIButton *)footerButton{
    if (!_footerButton) {
        _footerButton=[UIButton dzButtonWithTitle:@"SelectPayWayViewController.title".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(payRequest)];
        _footerButton.enabled=YES;
        [_footerButton setEnabledBGColor:UIColorThemeMainColor unEnabledBGColoor:UIColor153Color];
        [_footerButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    }
    return _footerButton;
}
-(SelectPayWayHeadView *)headerView{
    if (!_headerView) {
        _headerView=[[NSBundle mainBundle]loadNibNamed:@"SelectPayWayHeadView" owner:self options:nil].firstObject;
        _headerView.frame=CGRectMake(0, 0, ScreenWidth, 270);
    }
    return _headerView;
}

///  根据payType获取快捷支付的银行卡列表
-(void)getQuickInfoRequest{
    GetQuickPayInfoListRequest*request=[GetQuickPayInfoListRequest request];
    request.channelCode=@"CloudPayCorp";
    request.amount = self.amount;
    request.currencyCode = self.currencyCode;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[QuickPayInfo class] success:^(NSArray<QuickPayInfo*>* response) {
        RechargeChannelInfo*cloudPayCorpInfo;
        for (RechargeChannelInfo*chann in self.channelItems) {
            if ([chann.channelCode isEqualToString:@"CloudPayCorp"]) {
                cloudPayCorpInfo=chann;
                break;
            }
        }
        NSMutableArray*array=[NSMutableArray array];
        //把快捷支付的银行卡列表对象转换成RechargeChannelInfo
        for (QuickPayInfo*info in response) {
            RechargeChannelInfo*balanceInfo=[[RechargeChannelInfo alloc]init];
            balanceInfo.payType=@"LankaPay";
            balanceInfo.channelName=info.bankNum;
            balanceInfo.ID=info.ID;
            balanceInfo.channelCode=info.channelCode;
            balanceInfo.logo=cloudPayCorpInfo.logo;
            balanceInfo.convertedAmount = cloudPayCorpInfo.convertedAmount;
            balanceInfo.acceptedCurrencyCode = cloudPayCorpInfo.acceptedCurrencyCode;
            [array addObject:balanceInfo];
        }
        NSMutableArray*result=[NSMutableArray arrayWithArray:self.channelItems];
        [result addObjectsFromArray:array];
        self.channelItems=result;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)payCryptoPayment{
    [self transferRequest];
}

//快捷支付
-(void)payCloudPayRequest{
    PostDialogPaymentRequest*request=[PostDialogPaymentRequest request];
    request.quickPayId = self.selectChannelInfo.ID;
    request.paymentId = self.paymentId;
    request.channelId = self.selectChannelInfo.ID;;
    request.parameters=[request mj_JSONObject];
    //正在充值...
    [QMUITipsTool showLoadingWihtMessage:@"Processing".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[DialogPaymentInfo class] contentClass:[DialogPaymentInfo class] success:^(DialogPaymentInfo* response) {
        [QMUITips hideAllTips];
        if(response.paymentHoldingStatus != 1){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:YES];
            });
        }else{
            self.paymentStatusResponse = response.status;
            if (![self.selectChannelInfo.payType isEqualToString:@"balance"]) {
                //如果支付成功
                if ([response.status isEqualToString:@"Paying"]) {
                    //检查是否收藏
                    CheckDialogFavoritesRequest*request=[CheckDialogFavoritesRequest request];
                    if (self.isFromFavorite) {
                        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.dialogId,self.mobile];
                    }else{
                        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.ID,self.mobile];
                    }
                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* sresponse) {
                        if ([sresponse isEqualToString:@"true"]) {//已经在收藏夹中
                            if ([self.paymentStatusResponse  isEqual: @"PendingToPay"]){
                                [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:YES];
                            }else{
                                [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:NO];
                            }
                        }else{
                            self.favoritesView=[[NSBundle mainBundle]loadNibNamed:@"ShowUtilityFavoritesView" owner:self options:nil].firstObject;
                            self.favoritesView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                            self.favoritesView.info=self.dialogInfo;
                            [self.favoritesView showFavoritesView];
                            @weakify(self);
                            self.favoritesView.sureBlock = ^{
                                @strongify(self);
                                if (self.favoritesView.nameTextField.text.trimmingwhitespaceAndNewline.length==0) {
                                    [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsPayViewController.tipError".icanlocalized inView:self.view];
                                    return;
                                }
                                PostDialogFavoritesRequest*request=[PostDialogFavoritesRequest request];
                                request.dialogId=self.dialogInfo.ID;
                                request.nickname=self.favoritesView.nameTextField.text;
                                request.accountNumber=self.mobile;
                                request.parameters=[request mj_JSONObject];
                                [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                                    [self.favoritesView hiddenFavoritesView];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
                                    [QMUITips showSucceed:@"AddSuccess".icanlocalized inView:self.view];
                                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                                    [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                                }];
                                if ([self.paymentStatusResponse  isEqual: @"PendingToPay"]){
                                    [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:YES];
                                }else{
                                    [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:NO];
                                }
                            };
                            self.favoritesView.cancelBlock = ^{
                                @strongify(self);
                                if ([self.paymentStatusResponse  isEqual: @"PendingToPay"]){
                                    [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:YES isPaymentSending:YES];
                                }else{
                                    [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:YES isPaymentSending:NO];
                                }
                            };
                            
                            
                            
                        }
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        
                    }];
                }else{
                    [QMUITipsTool showErrorWihtMessage:@"Top-upFailure".icanlocalized inView:self.view];
                }
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
    
    
}
-(void)checkPaySuccessWithDialogPaymentInfo:(DialogPaymentInfo*)info shouldCheck:(BOOL)shouldCheck isPaymentSending:(BOOL)isPaymentSending{
    NSString*payurl=info.redirectUrl.netUrlEncoded;
    PayResultWebViewController*vc=[[PayResultWebViewController alloc]init];
    if (payurl.length>0) {
        vc.payUrl=payurl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (isPaymentSending == YES){
            UtilityPaymentsSuccessViewController*vc=[[UtilityPaymentsSuccessViewController alloc]init];
            vc.dialogPaymentInfo=info;
            vc.dialogInfo=self.dialogInfo;
            vc.mobile=self.mobile;
            vc.isFromFavorite=self.isFromFavorite;
            vc.shouldCheck=shouldCheck;
            vc.isStatusPending = YES;
            if([self.selectChannelInfo.payType  isEqual: @"balance"]){
                self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                vc.selectChannelInfo = self.selectChannelInfo;
            }else{
                vc.selectChannelInfo = self.selectChannelInfo;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UtilityPaymentsSuccessViewController*vc=[[UtilityPaymentsSuccessViewController alloc]init];
            vc.dialogPaymentInfo=info;
            vc.dialogInfo=self.dialogInfo;
            vc.mobile=self.mobile;
            vc.isFromFavorite=self.isFromFavorite;
            vc.shouldCheck=shouldCheck;
            vc.isStatusPending = NO;
            if([self.selectChannelInfo.payType  isEqual: @"balance"]){
                self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                vc.selectChannelInfo = self.selectChannelInfo;
            }else{
                vc.selectChannelInfo = self.selectChannelInfo;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - Event
- (void)payUtiliRequest:(NSString *)password {
    PostDialogPaymentRequest*request=[PostDialogPaymentRequest request];
    request.paymentId = self.paymentId;
    if (![self.selectChannelInfo.payType isEqualToString:@"balance"]) {
        if (self.isSwitchOn) {
            request.saveCard = @YES;
        } else {
            request.saveCard = @NO;
        }
        request.channelId = self.selectChannelInfo.ID;
        if (![self.selectChannelInfo.payType isEqualToString:@"BankCard"]) {
            request.quickPayId = self.selectChannelInfo.ID;
        }
    }
    
    if (self.selectChannelInfo) {
        if ([self.selectChannelInfo.payType isEqualToString:@"balance"]) {
            request.payPassword=password;
        }else{
            request.payPassword = password;
        }
    }else{
        request.payPassword=password;
    }
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:@"Processing".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[DialogPaymentInfo class] contentClass:[DialogPaymentInfo class] success:^(DialogPaymentInfo* response) {
        [QMUITips hideAllTips];
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        if(response.paymentHoldingStatus != 1){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:YES];
            });
        }else{
            //如果选择了余额支付
            if ([self.selectChannelInfo.payType isEqualToString:@"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                if ([response.status  isEqual: @"PendingToPay"]){
                    UtilityPaymentsSuccessViewController*vc=[[UtilityPaymentsSuccessViewController alloc]init];
                    vc.dialogPaymentInfo=response;
                    vc.dialogInfo=self.dialogInfo;
                    vc.mobile=self.mobile;
                    vc.isFromFavorite=self.isFromFavorite;
                    vc.shouldCheck = YES;
                    vc.isStatusPending = YES;
                    if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                        self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                        self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                        vc.selectChannelInfo = self.selectChannelInfo;
                    }else{
                        vc.selectChannelInfo = self.selectChannelInfo;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    UtilityPaymentsSuccessViewController*vc=[[UtilityPaymentsSuccessViewController alloc]init];
                    vc.dialogPaymentInfo=response;
                    vc.dialogInfo=self.dialogInfo;
                    vc.mobile=self.mobile;
                    vc.isFromFavorite=self.isFromFavorite;
                    vc.shouldCheck = YES;
                    vc.isStatusPending = NO;
                    if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]){
                        self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                        self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                        vc.selectChannelInfo = self.selectChannelInfo;
                    }else{
                        vc.selectChannelInfo = self.selectChannelInfo;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                //有可能还会有其他的支付方式
                if ([response.status isEqualToString:@"Paying"]) {
                    //检查是否收藏
                    CheckDialogFavoritesRequest*request=[CheckDialogFavoritesRequest request];
                    if (self.isFromFavorite) {
                        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.dialogId,self.mobile];
                    }else{
                        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.ID,self.mobile];
                    }
                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* sresponse) {
                        if ([sresponse isEqualToString:@"true"]) {
                            NSString*payurl=response.redirectUrl.netUrlEncoded;
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:payurl] options:@{} completionHandler:^(BOOL success) {
                            }];
                        }else{
                            self.favoritesView=[[NSBundle mainBundle]loadNibNamed:@"ShowUtilityFavoritesView" owner:self options:nil].firstObject;
                            self.favoritesView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                            self.favoritesView.info=self.dialogInfo;
                            [self.favoritesView showFavoritesView];
                            @weakify(self);
                            self.favoritesView.sureBlock = ^{
                                @strongify(self);
                                if (self.favoritesView.nameTextField.text.trimmingwhitespaceAndNewline.length==0) {
                                    [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsPayViewController.tipError".icanlocalized inView:self.view];
                                    return;
                                }
                                PostDialogFavoritesRequest*request=[PostDialogFavoritesRequest request];
                                request.dialogId=self.dialogInfo.ID;
                                request.nickname=self.favoritesView.nameTextField.text;
                                request.accountNumber=self.mobile;
                                request.parameters=[request mj_JSONObject];
                                [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                                    [self.favoritesView hiddenFavoritesView];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
                                    [QMUITips showSucceed:@"AddSuccess".icanlocalized inView:self.view];
                                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                                    [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                                }];
                                UIStoryboard *board;
                                board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                                WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                                View.isPay = YES;
                                View.payUrlString = response.redirectUrl;
                                View.hidesBottomBarWhenPushed = YES;
                                [View setCloseButtonHandler:^{
                                    RechargeChannelListRequest *request = [RechargeChannelListRequest request];
                                    request.countryCode = UserInfoManager.sharedManager.countryCode;
                                    request.paymentId = self.paymentId;
                                    request.parameters = [request mj_JSONObject];
                                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeChannelListNewInfo  class] contentClass:[RechargeChannelListNewInfo class] success:^(RechargeChannelListNewInfo *response) {
                                        if ([response.paymentStatus isEqual:@"Expired"]) {
                                            UtilityPaymentsFailViewController*vc=[[UtilityPaymentsFailViewController alloc]init];
                                            vc.dialogPaymentAmount = self.amount;
                                            if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                                                self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                                                self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                                                vc.selectChannelInfo = self.selectChannelInfo;
                                            }else{
                                                vc.selectChannelInfo = self.selectChannelInfo;
                                            }
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                                        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                                    }];
                                }];
                                [self.navigationController pushViewController:View animated:YES];
                                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                            };
                            self.favoritesView.cancelBlock = ^{
                                UIStoryboard *board;
                                board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                                WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                                View.isPay = YES;
                                View.payUrlString = response.redirectUrl;
                                View.hidesBottomBarWhenPushed = YES;
                                [View setCloseButtonHandler:^{
                                    // This block will be executed when closeButtonHandler?() is called in Swift
                                    RechargeChannelListRequest *request = [RechargeChannelListRequest request];
                                    request.countryCode = UserInfoManager.sharedManager.countryCode;
                                    request.paymentId = self.paymentId;
                                    request.parameters = [request mj_JSONObject];
                                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeChannelListNewInfo  class] contentClass:[RechargeChannelListNewInfo class] success:^(RechargeChannelListNewInfo *response) {
                                        if ([response.paymentStatus isEqual:@"Expired"]) {
                                            UtilityPaymentsFailViewController*vc=[[UtilityPaymentsFailViewController alloc]init];
                                            vc.dialogPaymentAmount = self.amount;
                                            if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                                                self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                                                self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                                                vc.selectChannelInfo = self.selectChannelInfo;
                                            }else{
                                                vc.selectChannelInfo = self.selectChannelInfo;
                                            }
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                        
                                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                                        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                                    }];
                                }];
                                [self.navigationController pushViewController:View animated:YES];
                                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                            };
                        }
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        
                    }];
                }else{
                    [QMUITipsTool showErrorWihtMessage:@"Top-upFailure".icanlocalized inView:self.view];
                }
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self payRequest];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self payRequest];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                UtilityPaymentsFailViewController*vc=[[UtilityPaymentsFailViewController alloc]init];
                vc.dialogPaymentAmount = self.amount;
                if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                    self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                    self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                    vc.selectChannelInfo = self.selectChannelInfo;
                }else{
                    vc.selectChannelInfo = self.selectChannelInfo;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
            UtilityPaymentsFailViewController*vc=[[UtilityPaymentsFailViewController alloc]init];
            vc.dialogPaymentAmount = self.amount;
            if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]) {
                self.selectChannelInfo.convertedAmount = self.currentExchangeByAmountInfo.toAmount;
                self.selectChannelInfo.acceptedCurrencyCode = @"¥";
                vc.selectChannelInfo = self.selectChannelInfo;
            }else{
                vc.selectChannelInfo = self.selectChannelInfo;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(void)payRequest{
    //Is it balance payment
    if ([self.selectChannelInfo.payType isEqualToString:@"balance"]) {
        [self.payManager showPayViewWithAmount:self.currentExchangeByAmountInfo.toAmount typeTitleStr:@"Top Up".icanlocalized SurePaymentViewType:SurePaymentView_UtilityPay successBlock:^(NSString * _Nonnull password) {
            [self payUtiliRequest:password];
        }];
    }else if([self.selectChannelInfo.payType isEqualToString:@"LankaPay"]){
        //Select the quick payment with the saved card number
        [self payCloudPayRequest];
    }else if ([self.selectChannelInfo.payType isEqualToString:@"CryptoPay"]){
        [self payCryptoPayment];
    }else{
        [self payUtiliRequest:nil];
    }
}

#pragma mark - Networking
//Get recharge channel
-(void)fetchChannelRequest{
    RechargeChannelListRequest *request = [RechargeChannelListRequest request];
    request.countryCode = UserInfoManager.sharedManager.countryCode;
    request.paymentId = self.paymentId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeChannelListNewInfo  class] contentClass:[RechargeChannelListNewInfo class] success:^(RechargeChannelListNewInfo *response) {
        RechargeChannelInfo *balanceInfo = [[RechargeChannelInfo alloc]init];
        balanceInfo.select = YES;
        balanceInfo.payType = @"balance";
        balanceInfo.logo = @"https://oss.icanlk.com/system/pay/icon/icanbalance.png";
        balanceInfo.channelName = @"Balance payment".icanlocalized;
        self.selectChannelInfo = balanceInfo;
        NSMutableArray *array = [NSMutableArray arrayWithObject:balanceInfo];
        [array addObjectsFromArray:response.payChannels];
        self.channelItems = array;
        [self.tableView reloadData];
        [self getQuickInfoRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(void)getC2CPayOrderDetailRequest:(NSString *)c2cPaymentId{
    GetC2CPreparePayOrderDetailRequest *request = [GetC2CPreparePayOrderDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/preparePayOrder/%@",c2cPaymentId];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CPreparePayOrderDetailInfo class] contentClass:[C2CPreparePayOrderDetailInfo class] success:^(C2CPreparePayOrderDetailInfo *response) {
        self.detailInfo = response;
        @weakify(self);
        //Wait for all network requests to complete
        RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self fetchUserBalance:subscriber];
            return nil;
        }];
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self getCurrencyRequest:subscriber];
            return nil;
        }];
        RACSignal *signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self getC2CAllExchangeList:subscriber];
            return nil;
        }];
        [self rac_liftSelector:@selector(reloadComplationDataA:dataB:dataC:) withSignalsFromArray:@[signalA,signalB,signalC]];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        if (statusCode == 403) {
            [C2CUserManager.shared getC2cToken:^(C2CTokenInfo * _Nonnull response) {
                [self getC2CPayOrderDetailRequest:c2cPaymentId];
            } failure:^(NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            }];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }
    }];
}
///Get my bank balance
-(void)fetchUserBalance:(id<RACSubscriber>)singnal{
    UserBalanceRequest *request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo *response) {
        [singnal sendNext:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}
/** Get asset list */
-(void)getCurrencyRequest:(id<RACSubscriber>)singnal{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        [singnal sendNext:response];
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}
/** Get exchange rate list */
-(void)getC2CAllExchangeList:(id<RACSubscriber>)singnal{
    [[C2CUserManager shared]getC2CAllExchangeListRequest:^(NSArray <C2CExchangeRateInfo*> *response) {
        [singnal sendNext:response];
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        
    }];
}
-(void)reloadComplationDataA:(UserBalanceInfo *)dataA dataB:(NSArray *)dataB dataC:(NSArray<C2CExchangeRateInfo*>*)dataC{
    [QMUITips hideAllTips];
    IcanThirdPayViewController *vc = [[IcanThirdPayViewController alloc]init];
    vc.balanceInfo = dataA;
    vc.assetItems = dataB;
    vc.prepareDetailInfo = self.detailInfo;
    NSString *appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    vc.appId = appID;
    vc.allExchangeRateItems = dataC;
    [[AppDelegate shared]presentViewController:vc animated:YES completion:nil];
}


-(void)transferRequest{
    NSString *typeStr;
    typeStr = @"Top Up".icanlocalized;
    [[PayManager sharedManager]showC2CInputPasswordWith:self.selectChannelInfo.convertedAmount typeStr:typeStr currencyInfo:self.selectCurrencyInfo successBlock:^(NSString * _Nonnull password) {
        [self.view endEditing:YES];
        VerifyPaymentPasswordRequest *vRequest = [VerifyPaymentPasswordRequest request];
        vRequest.paymentPassword = password;
        vRequest.parameters = [vRequest mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:vRequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            PostDialogPaymentRequest *request = [PostDialogPaymentRequest request];
            request.payPassword = password;
            request.paymentId = self.paymentId;
            request.channelId = self.selectChannelInfo.ID;
            request.parameters = [request mj_JSONObject];
            //Recharging...
            [QMUITipsTool showLoadingWihtMessage:@"Processing".icanlocalized inView:self.view isAutoHidden:NO];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[DialogPaymentInfo class] contentClass:[DialogPaymentInfo class] success:^(DialogPaymentInfo *response) {
                if(response.paymentHoldingStatus != 1){
                    [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO isPaymentSending:YES];
                    });
                }else{
                    UtilityPaymentsSuccessViewController *vc = [[UtilityPaymentsSuccessViewController alloc]init];
                    vc.dialogPaymentInfo = response;
                    vc.dialogInfo = self.dialogInfo;
                    vc.mobile = self.mobile;
                    vc.isFromFavorite = self.isFromFavorite;
                    vc.shouldCheck = YES;
                    vc.isStatusPending = NO;
                    vc.selectChannelInfo = self.selectChannelInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self transferRequest];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self transferRequest];
                } else {
                    [UserInfoManager sharedManager].attemptCount = nil;
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                    UtilityPaymentsFailViewController *vc = [[UtilityPaymentsFailViewController alloc]init];
                    vc.dialogPaymentAmount = self.amount;
                    vc.selectChannelInfo = self.selectChannelInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }];
}

@end
