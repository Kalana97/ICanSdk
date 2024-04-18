//
//  RechargeViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/8.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeHeaderView.h"
#import "RechargeChannelTableViewCell.h"
#import "BankCardRechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RechargeRecordListViewController.h"
#import "CommonWebViewController.h"
#import "QDNavigationController.h"
#import "Select43PayWayViewController.h"
#import "FlashExchangeViewController.h"
#import "RechargeTypeCell.h"
#import "DZUITextField.h"
#import "SelectMobileCodeViewController.h"

@interface RechargeViewController ()<QMUITextViewDelegate,DZUITextFieldDelegate>
@property (nonatomic,strong) RechargeHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet DZIconImageView *countryFlagImg;
@property (weak, nonatomic) IBOutlet UITableView *methodsTbl;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLbl;
@property (weak, nonatomic) IBOutlet DZUITextField *amountBalanceValLbl;
@property (weak, nonatomic) IBOutlet UILabel *convetedAmtLbl;
@property (weak, nonatomic) IBOutlet UIView *keyboardHideView;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLbl;
@property (weak, nonatomic) IBOutlet UILabel *addAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectCountryLbl;
@property(nonatomic, strong) NSArray<AllCountryInfo*> *countryListItems;
@property (nonatomic,strong) NSArray<RechargeChannelInfo*> *rechargeChannelItems;
@property (nonatomic,strong) RechargeChannelInfo *selectedRechargeChannelItem;
@property (nonatomic,strong) AllCountryInfo *selectedContryItem;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,assign) NSInteger currentSelected;
@property (nonatomic,strong) NSString *totalConvertedVal;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLocalizations];
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    self.country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    [self.confirmBtn layerWithCornerRadius:28 borderWidth:0.5 borderColor:UIColorSeparatorColor];
    self.title = NSLocalizedString(@"Top Up",充值);
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"RechargeRecord", 充值记录) target:self action:@selector(rechargeRecordAction)];
    [self.methodsTbl registNibWithNibName:RechargeTypeCellListTableViewCell];
    [self setDelegates];
    [self getEnabledCountryRequest];
    self.amountBalanceValLbl.floatLenth = 2;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:self.amountBalanceValLbl];
    self.confirmBtn.enabled = NO;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.amountBalanceValLbl.text.length > 0){
        if(self.selectedContryItem != nil && self.selectedRechargeChannelItem != nil){
            self.confirmBtn.enabled = YES;
        }else{
            self.confirmBtn.enabled = NO;
        }
    }else{
        self.confirmBtn.enabled = NO;
        [self resetConvertedLabels];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setLocalizations{
    [self.confirmBtn setTitle:@"ConfirmRecharge".icanlocalized forState:UIControlStateNormal];
    self.payMethodLbl.text = @"Recharge mode".icanlocalized;
    self.addAmtLbl.text = @"TotalAmount".icanlocalized;
    self.selectCountryLbl.text = @"Select country".icanlocalized;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.amountBalanceValLbl resignFirstResponder];
}

-(void)setDelegates{
    [self.methodsTbl setDelegate:self];
    [self.methodsTbl setDataSource:self];
}

-(void)rechargeRecordAction{
    RechargeRecordListViewController*vc= [[RechargeRecordListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getEnabledCountryRequest{
    __block AllCountryInfo *isExistData = nil;
    GetRechargeEnabledCountries *request = [GetRechargeEnabledCountries request];
    request.scope = @"Balance";
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AllCountryInfo class] success:^(NSArray *response){
        __block BOOL isExist = NO;
        self.countryListItems = response;
        for (AllCountryInfo *dataInfo in self.countryListItems) {
            if(dataInfo.nameEn == self.country){
                isExist = YES;
                isExistData = dataInfo;
            }else{
                isExist = NO;
            }
        }
        if (isExist == YES){
            [self fetctRechargeChannelWays:isExistData.code];
            self.selectedContryItem = isExistData;
            self.countryNameLbl.text = BaseSettingManager.isChinaLanguages?isExistData.nameCn:isExistData.nameEn;
            self.currencyCodeLbl.text = isExistData.currencyCode;
            [self resetConvertedLabels];
            [self.countryFlagImg sd_setImageWithURL:[NSURL URLWithString:isExistData.flagUrl]];
        }else{
            if(self.countryListItems.count > 0){
                [self fetctRechargeChannelWays:self.countryListItems.firstObject.code];
                self.selectedContryItem = self.countryListItems.firstObject;
                self.countryNameLbl.text = BaseSettingManager.isChinaLanguages?self.countryListItems.firstObject.nameCn:self.countryListItems.firstObject.nameEn;
                self.currencyCodeLbl.text = self.countryListItems.firstObject.currencyCode;
                [self resetConvertedLabels];
                [self.countryFlagImg sd_setImageWithURL:[NSURL URLWithString:self.countryListItems.firstObject.flagUrl]];
            }else{
                NSLog(@"");
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)fetctRechargeChannelWays:(NSString *)countryCode{
    RechargeChannelRequest *request = [RechargeChannelRequest request];
    request.scope = @"Balance";
    request.countryCode = countryCode;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray  class] contentClass:[RechargeChannelInfo class] success:^(NSArray * response) {
        self.rechargeChannelItems = response;
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            RechargeChannelInfo *cntInfo = [[RechargeChannelInfo alloc]init];
            cntInfo.payType = @"USDT";
            cntInfo.channelName = @"USDT";
            self.rechargeChannelItems = [self.rechargeChannelItems arrayByAddingObject:cntInfo];
        }
        for (RechargeChannelInfo *info in self.rechargeChannelItems) {
            info.isSelected = NO;
        }
        if(self.rechargeChannelItems.count > 0 ){
            self.rechargeChannelItems.firstObject.isSelected = YES;
            self.selectedRechargeChannelItem = self.rechargeChannelItems.firstObject;
        }
        self.tblHeightConstraint.constant = 50 * self.rechargeChannelItems.count;
        [self.methodsTbl reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(void)textFiledDidChange:(NSNotification*)noti{
    NSString *convertedAmount = @"0";
    self.convetedAmtLbl.text = [NSString stringWithFormat:@"%@ %@ = CNT %@",self.currencyCodeLbl.text,self.amountBalanceValLbl.text,convertedAmount];
    if(self.amountBalanceValLbl.text.length > 0){
        if(self.selectedContryItem != nil && self.selectedRechargeChannelItem != nil){
            self.confirmBtn.enabled = YES;
            self.totalConvertedVal = [NSString stringWithFormat:@"%@",[[self.amountBalanceValLbl.text.decimalNumber decimalNumberByMultiplyingBy:self.selectedContryItem.rateToCNY.decimalNumber]calculateByNSRoundDownScale:2].currencyString];
            self.convetedAmtLbl.text = [NSString stringWithFormat:@"%@ %@ = CNT %@ ",self.selectedContryItem.currencyCode,self.amountBalanceValLbl.text,self.totalConvertedVal];
        }else{
            self.confirmBtn.enabled = NO;
        }
    }else{
        self.confirmBtn.enabled = NO;
        [self resetConvertedLabels];
    }
}

-(void)resetConvertedLabels{
    self.convetedAmtLbl.text = [NSString stringWithFormat:@"%@ 0 = CNT 0",self.currencyCodeLbl.text];
}

-(void)topUpWithChannelWay{
    self.confirmBtn.enabled = NO;
    if (self.rechargeChannelItems.count) {
        RechargeChannelInfo *rechargeChannelInfo = self.selectedRechargeChannelItem;
        if ([rechargeChannelInfo.channelCode isEqualToString:@"CloudPayCorp"]) {
            Select43PayWayViewController *vc = [[Select43PayWayViewController alloc]initWithStyle:UITableViewStyleGrouped];
            vc.isRechargeBalance = YES;
            vc.selectChannelInfo = rechargeChannelInfo;
            vc.amount = self.totalConvertedVal;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"AliPay"]||[rechargeChannelInfo.payType isEqualToString:@"WeChatPay"]) {
            [self aliPayOrWechatPayWithRechargeChannelInfo:rechargeChannelInfo];
        }else if ([rechargeChannelInfo.payType isEqualToString:@"USDT"]) {
            FlashExchangeViewController *vc = [FlashExchangeViewController new];
            vc.hardC = true;
            vc.hAmount = self.totalConvertedVal;
            self.confirmBtn.enabled = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (rechargeChannelInfo.autoAddBank) {
                BankCardRechargeViewController *vc = [BankCardRechargeViewController new];
                vc.rechargeChannelInfo = rechargeChannelInfo;
                vc.orderAmount = self.totalConvertedVal;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self aliPayOrWechatPayWithRechargeChannelInfo:rechargeChannelInfo];
            }
        }
    }
}

-(void)aliPayOrWechatPayWithRechargeChannelInfo:(RechargeChannelInfo *)rechargeChannelInfo{
    NSString*orderAmount=[NSString stringWithFormat:@"%.2f",[self.amountBalanceValLbl.text doubleValue]];
    RechargeRequest * request = [RechargeRequest request];
    request.payType = rechargeChannelInfo.channelCode;
    request.orderAmount = orderAmount;
    request.parameters  = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeInfo class] contentClass:[RechargeInfo class] success:^(RechargeInfo *response) {
        self.confirmBtn.enabled = YES;
        if (response.payUrl) {
            if ([rechargeChannelInfo.channelCode isEqualToString:@"CloudDPay"]||[rechargeChannelInfo.channelCode isEqualToString:@"CloudHiPayBTB"]) {
                CommonWebViewController *web = [[CommonWebViewController alloc]init];
                web.urlString = response.payUrl;
                web.isPresent = YES;
                QDNavigationController *nav = [[QDNavigationController alloc]initWithRootViewController:web];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:YES completion:^{
                }];
            }else{
                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:response.payUrl]]) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:response.payUrl] options:@{} completionHandler:^(BOOL success) {
                    }];
                }else{
                    CommonWebViewController *web = [[CommonWebViewController alloc]init];
                    web.urlString = response.payUrl;
                    web.isPresent = YES;
                    QDNavigationController *nav = [[QDNavigationController alloc]initWithRootViewController:web];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:nav animated:YES completion:^{
                    }];
                }
            }
        }else{
            [[AlipaySDK defaultService]payOrder:response.payInfo fromScheme:@"alipay2019090266798748" callback:^(NSDictionary *resultDic) {
            }];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        self.confirmBtn.enabled = YES;
    }];
}

- (IBAction)confirmBtnAction:(id)sender {
    [self topUpWithChannelWay];
}

- (IBAction)didSelectCountry:(id)sender {
    SelectMobileCodeViewController *vc = [[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav = [[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.isTopUp = YES;
    vc.sentListOfCountries = self.countryListItems;
    vc.shouldShowFlag = YES;
    [self presentViewController:nav animated:YES completion:^{
    }];
    vc.selectAreaBlock = ^(AllCountryInfo * _Nonnull info) {
        [self fetctRechargeChannelWays:info.code];
        self.countryNameLbl.text = BaseSettingManager.isChinaLanguages?info.nameCn:info.nameEn;
        self.selectedContryItem = info;
        self.currencyCodeLbl.text = info.currencyCode;
        if(self.amountBalanceValLbl.text.length > 0){
            self.totalConvertedVal = [NSString stringWithFormat:@"%@",[[self.amountBalanceValLbl.text.decimalNumber decimalNumberByMultiplyingBy:self.selectedContryItem.rateToCNY.decimalNumber]calculateByNSRoundDownScale:2].currencyString];
            self.convetedAmtLbl.text = [NSString stringWithFormat:@"%@ %@ = CNT %@ ",self.selectedContryItem.currencyCode,self.amountBalanceValLbl.text,self.totalConvertedVal];
        }else{
            [self resetConvertedLabels];
        }
        [self.countryFlagImg sd_setImageWithURL:[NSURL URLWithString:info.flagUrl]];
    };
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rechargeChannelItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:RechargeTypeCellListTableViewCell];
    [cell.outerBoarderView layerWithCornerRadius:16 borderWidth:0.5 borderColor:UIColor.blackColor];
    [cell setData:self.rechargeChannelItems[indexPath.row]];
    cell.selectRechargeInfo = ^(RechargeChannelInfo * _Nonnull info) {
        self.selectedRechargeChannelItem = info;
        for (RechargeChannelInfo *dataVal in self.rechargeChannelItems) {
            if(info != dataVal){
                dataVal.isSelected = NO;
            }else{
                dataVal.isSelected = YES;
            }
        }
        [self.methodsTbl reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.rechargeChannelItems[indexPath.row].isSelected = YES;
    self.selectedRechargeChannelItem = self.rechargeChannelItems[indexPath.row];
    for (RechargeChannelInfo *info in self.rechargeChannelItems) {
        if(info != self.selectedRechargeChannelItem){
            info.isSelected = NO;
        }
    }
    [self.methodsTbl reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@synthesize floatLenth;
@end
