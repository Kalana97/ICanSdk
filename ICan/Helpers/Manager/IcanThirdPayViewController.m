//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 29/3/2022
 - File name:  IcanThirdPayViewController.m
 - Description:
 - Function List:
 */


#import "IcanThirdPayViewController.h"
#import "IcanThirdPayTableViewCell.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
@interface IcanThirdPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;

@property (weak, nonatomic) IBOutlet UILabel *idLab;

@property (weak, nonatomic) IBOutlet UILabel *bodyLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *yueAmountLab;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
///
@property (nonatomic, strong) C2CBalanceListInfo *currentAssetBalanceInfo;
///支持支付的资产列表
@property (nonatomic, strong) NSMutableArray<C2CBalanceListInfo*> * showAssetItems;
///实际需要支付的对应货币的金额
@property (nonatomic, strong) NSDecimalNumber *actualPay;

@property(nonatomic, strong) CurrencyInfo *currentCurrencyInfo;
@end

@implementation IcanThirdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"ICanPay".icanlocalized;
    [self.sureBtn setTitle:@"C2CConfirmPayment".icanlocalized forState:UIControlStateNormal];
    [self.iconImgView setDZIconImageViewWithUrl:UserInfoManager.sharedManager.headImgUrl gender:UserInfoManager.sharedManager.gender];
    self.nicknameLab.text = UserInfoManager.sharedManager.nickname;
    self.idLab.text = [NSString stringWithFormat:@"ID:%@",UserInfoManager.sharedManager.numberId];
    NSString*amount = [NSString stringWithFormat:@"%@ %@",self.prepareDetailInfo.currency.symbol,self.prepareDetailInfo.amount.currencyString];
    NSMutableAttributedString * amountAtt = [[NSMutableAttributedString alloc]initWithString:amount];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, self.prepareDetailInfo.currency.symbol.length)];
    self.amountLab.attributedText = amountAtt ;
    self.bodyLab.text = self.prepareDetailInfo.body;
    ///筛选符合的汇率数据
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender == [cd] %@ AND supportPay == YES ",self.prepareDetailInfo.currencyCode];
    NSArray*fillterItems = [self.allExchangeRateItems filteredArrayUsingPredicate:predicate];
    ///筛选符合的资产列表
    for (C2CBalanceListInfo*assetInfo in self.assetItems) {
        for (C2CExchangeRateInfo*rateInfo in fillterItems) {
            if ([assetInfo.code isEqualToString:rateInfo.virtualCurrency]) {
                [self.showAssetItems addObject:assetInfo];
                break;
            }
        }
    }
    
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        ///预设的支付货币
        if (self.prepareDetailInfo.presetCurrencyCodes.length>0) {
            NSArray * presetCurrencyCodesItems = [self.prepareDetailInfo.presetCurrencyCodes componentsSeparatedByString:@","];
            if ([presetCurrencyCodesItems containsObject:@"CNY"]) {
                ///判断符合规则的汇率里面是否有CNT的汇率兑换，如果有的话需要把我行余额添加进去
                NSPredicate * cntpredicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ ",@"CNY"];
                NSArray*cntfillterItems = [fillterItems filteredArrayUsingPredicate:cntpredicate];
                if (cntfillterItems.count>0) {
                    C2CBalanceListInfo* info = [[C2CBalanceListInfo alloc]init];
                    info.money = self.balanceInfo.balance;
                    info.code = @"CNY";
                    [self.showAssetItems insertObject:info atIndex:0];
                }
            }else{
                NSMutableArray * endAssetItems = [NSMutableArray array];
                for (NSString* presetCurrencyCode in presetCurrencyCodesItems) {
                    for (C2CBalanceListInfo*assetInfo in self.showAssetItems) {
                        if ([presetCurrencyCode isEqualToString:assetInfo.code]) {
                            [endAssetItems addObject:assetInfo];
                            break;
                        }
                    }
                }
                self.showAssetItems = [NSMutableArray arrayWithArray:endAssetItems];
            }
        }else{
            ///判断符合规则的汇率里面是否有CNT的汇率兑换，如果有的话需要把我行余额添加进去
            NSPredicate * cntpredicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ ",@"CNY"];
            NSArray*cntfillterItems = [fillterItems filteredArrayUsingPredicate:cntpredicate];
            if (cntfillterItems.count>0) {
                C2CBalanceListInfo* info = [[C2CBalanceListInfo alloc]init];
                info.money = self.balanceInfo.balance;
                info.code = @"CNY";
                [self.showAssetItems insertObject:info atIndex:0];
            }
        }     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        ///预设的支付货币
        if (self.prepareDetailInfo.presetCurrencyCodes.length>0) {
            NSArray * presetCurrencyCodesItems = [self.prepareDetailInfo.presetCurrencyCodes componentsSeparatedByString:@","];
            NSMutableArray * userAssetCurrencyCodesItems = [NSMutableArray array];
            for (C2CBalanceListInfo*userAssetInfo in self.showAssetItems) {
                [userAssetCurrencyCodesItems addObject:userAssetInfo.code];
            }
            if ([presetCurrencyCodesItems containsObject:@"CNT"]) {
                ///判断符合规则的汇率里面是否有CNT的汇率兑换，如果有的话需要把我行余额添加进去
                NSPredicate * cntpredicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ ",@"CNT"];
                NSArray*cntfillterItems = [fillterItems filteredArrayUsingPredicate:cntpredicate];
                if (cntfillterItems.count>0) {
                    C2CBalanceListInfo* info = [[C2CBalanceListInfo alloc]init];
                    info.money = self.balanceInfo.balance;
                    info.code = @"CNT";
                    [self.showAssetItems insertObject:info atIndex:0];
                }
            }else if ([presetCurrencyCodesItems containsObject:@"USDT"] && ![userAssetCurrencyCodesItems containsObject:@"USDT"] ) {
                ///if usdt is not in the user assets
                NSMutableArray * endAssetItems = [NSMutableArray array];
                NSPredicate * cntpredicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ ",@"USDT"];
                NSArray*cntfillterItems = [fillterItems filteredArrayUsingPredicate:cntpredicate];
                if (cntfillterItems.count>0) {
                    C2CBalanceListInfo* info = [[C2CBalanceListInfo alloc]init];
                    NSDecimalNumber *decimalNumber = [NSDecimalNumber zero];
                    info.money = decimalNumber;
                    info.code = @"USDT";
                    [endAssetItems insertObject:info atIndex:0];
                    self.showAssetItems = [NSMutableArray arrayWithArray:endAssetItems];
                }
            }else{
                NSMutableArray * endAssetItems = [NSMutableArray array];
                for (NSString* presetCurrencyCode in presetCurrencyCodesItems) {
                    for (C2CBalanceListInfo*assetInfo in self.showAssetItems) {
                        if ([presetCurrencyCode isEqualToString:assetInfo.code]) {
                            [endAssetItems addObject:assetInfo];
                            break;
                        }
                    }
                }
                self.showAssetItems = [NSMutableArray arrayWithArray:endAssetItems];
            }
        }else{
            ///判断符合规则的汇率里面是否有CNT的汇率兑换，如果有的话需要把我行余额添加进去
            NSPredicate * cntpredicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ ",@"CNT"];
            NSArray*cntfillterItems = [fillterItems filteredArrayUsingPredicate:cntpredicate];
            if (cntfillterItems.count>0) {
                C2CBalanceListInfo* info = [[C2CBalanceListInfo alloc]init];
                info.money = self.balanceInfo.balance;
                info.code = @"CNT";
                [self.showAssetItems insertObject:info atIndex:0];
            }
        }
    }
   
    if (self.showAssetItems.count>0) {
        self.currentAssetBalanceInfo = self.showAssetItems[0];
    }
    
    self.tableViewHeight.constant = 50*self.showAssetItems.count;
    [self.tableView reloadData];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.tableView registNibWithNibName:kIcanThirdPayTableViewCell];
    [self setShowYueAmountLab];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showAssetItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanThirdPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanThirdPayTableViewCell];
    C2CBalanceListInfo * assetInfo = self.showAssetItems[indexPath.row];
    cell.selectImgView.hidden = self.currentAssetBalanceInfo!=assetInfo;
    cell.assetInfo = self.showAssetItems[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CBalanceListInfo * assetInfo = self.showAssetItems[indexPath.row];
    if (self.currentAssetBalanceInfo!=assetInfo) {
        self.currentAssetBalanceInfo= assetInfo;
        [tableView reloadData];
        [self setShowYueAmountLab];
    }
    
    
}
-(void)setShowYueAmountLab{
    if (self.currentAssetBalanceInfo) {
        CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:self.currentAssetBalanceInfo.code];
        self.currentCurrencyInfo = info;
        C2CExchangeRateInfo * rateInfo;
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            if ([self.currentAssetBalanceInfo.code isEqualToString:@"CNY"]) {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender == [cd] %@ AND virtualCurrency  == [cd] %@ AND supportPay == YES",self.prepareDetailInfo.currencyCode,@"CNY"];
                rateInfo = [self.allExchangeRateItems filteredArrayUsingPredicate:predicate].firstObject;
            }else{
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender == [cd] %@ AND virtualCurrency  == [cd] %@ AND supportPay == YES ",self.prepareDetailInfo.currencyCode,self.currentAssetBalanceInfo.code];
                rateInfo = [self.allExchangeRateItems filteredArrayUsingPredicate:predicate].firstObject;
            }
        }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            if ([self.currentAssetBalanceInfo.code isEqualToString:@"CNT"]) {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender == [cd] %@ AND virtualCurrency  == [cd] %@ AND supportPay == YES",self.prepareDetailInfo.currencyCode,@"CNT"];
                rateInfo = [self.allExchangeRateItems filteredArrayUsingPredicate:predicate].firstObject;
            }else{
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender == [cd] %@ AND virtualCurrency  == [cd] %@ AND supportPay == YES ",self.prepareDetailInfo.currencyCode,self.currentAssetBalanceInfo.code];
                rateInfo = [self.allExchangeRateItems filteredArrayUsingPredicate:predicate].firstObject;
            }        }
       
        self.actualPay = [self.prepareDetailInfo.amount.decimalNumber decimalNumberByDividingBy:rateInfo.fixedPrice];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            if ([self.currentAssetBalanceInfo.code isEqualToString:@"CNY"]||[self.currentAssetBalanceInfo.code isEqualToString:@"CNY"]) {
                self.yueAmountLab.text = [NSString stringWithFormat:@"≈￥ %@",[self.actualPay calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.yueAmountLab.text = [NSString stringWithFormat:@"≈%@  %@",info.symbol,[self.actualPay calculateByNSRoundDownScale:2].currencyString];
            }
        }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            if ([self.currentAssetBalanceInfo.code isEqualToString:@"CNT"]||[self.currentAssetBalanceInfo.code isEqualToString:@"CNT"]) {
                self.yueAmountLab.text = [NSString stringWithFormat:@"≈￥ %@",[self.actualPay calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.yueAmountLab.text = [NSString stringWithFormat:@"≈%@  %@",info.symbol,[self.actualPay calculateByNSRoundDownScale:2].currencyString];
            }
        }
    }else{
        self.yueAmountLab.text = @"";
    }
}

-(NSMutableArray<C2CBalanceListInfo *> *)showAssetItems{
    if (!_showAssetItems) {
        _showAssetItems = [NSMutableArray array];
    }
    return _showAssetItems;
}
- (IBAction)cancelAction {
    [self dismissViewControllerAnimated:YES completion:^{
        NSURL * payUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://c2cpay?errCode=-2",self.appId]];
        UIApplication*app = [UIApplication sharedApplication];
        [app openURL:payUrl options:@{} completionHandler:nil];
    }];
}
- (IBAction)sureAction {
    if (self.currentCurrencyInfo) {
        if ([UserInfoManager sharedManager].tradePswdSet) {
            [[[PayManager alloc]init]showC2CPrepareOrderWithCurrencyInfo:self.currentCurrencyInfo c2cBalanceListInfo:self.currentAssetBalanceInfo actualPay:self.actualPay successBlock:^(NSString * _Nonnull password) {
                VerifyPaymentPasswordRequest * vRequest = [VerifyPaymentPasswordRequest request];
                vRequest.paymentPassword = password;
                vRequest.parameters = [vRequest mj_JSONObject];
                [[NetworkRequestManager shareManager]startRequest:vRequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                    [UserInfoManager sharedManager].attemptCount = nil;
                    [UserInfoManager sharedManager].isPayBlocked = NO;
                    PutC2CPreparePayOrderRequest * request = [PutC2CPreparePayOrderRequest request];
                    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/preparePayOrder/%@",self.prepareDetailInfo.transactionId];
                    request.actualCurrencyCode = self.currentAssetBalanceInfo.code;
                    request.parameters = [request mj_JSONObject];
                    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class]  success:^(id  _Nonnull response) {
                        [QMUITipsTool showOnlyTextWithMessage:@"C2CTransferSuccessViewPaySuccess".icanlocalized inView:self.view];
                        [self dismissViewControllerAnimated:YES completion:^{
                            NSURL * payUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://c2cpay?errCode=0",self.appId]];
                            UIApplication*app = [UIApplication sharedApplication];
                            [app openURL:payUrl options:@{} completionHandler:nil];
                        }];
                    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                    }];
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    if ([info.code isEqual:@"pay.password.error"]) {
                        if (info.extra.isBlocked) {
                            [UserInfoManager sharedManager].isPayBlocked = YES;
                            [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                            [self sureAction];
                        } else if (info.extra.remainingCount != 0) {
                            [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                            [self sureAction];
                        } else {
                            [UserInfoManager sharedManager].attemptCount = nil;
                            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                        }
                    } else {
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }
                }];
            }];
        }else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password"
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
                SettingPaymentPasswordViewController * vc = [SettingPaymentPasswordViewController  new];
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                vc.navBarStatus = YES;
                [self presentViewController:vc animated:YES completion:nil];
            }];
            UIAlertAction* seconderyAction = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
            }];

            [alert addAction:defaultAction];
            [alert addAction:seconderyAction];
                        [self presentViewController:alert animated:YES completion:nil];
        }

    }
    
}


@end
