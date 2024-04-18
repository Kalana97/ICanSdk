//
//  AllTransactionsVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AllTransactionsVC.h"
#import "RecentTransactionCellWithButtons.h"
#import "BillPageViewController.h"
#import "JKPickerView.h"

@interface AllTransactionsVC ()
@property(nonatomic, strong) BillPageViewController *billPageVc;
@end

@implementation AllTransactionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.typeBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    [self.currencyBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.transactionTypeLbl.text = @"All".icanlocalized;
    self.currencyTypelbl.text = @"All".icanlocalized;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.billPageVc =  [[BillPageViewController alloc]init];
    self.billPageVc.isFromOrganization = YES;
    self.billPageVc.isFromAllTransactions = YES;
    self.billPageVc.dataTypeTrans = self.transactionTypeLbl.text;
    self.billPageVc.currencyType = self.currencyTypelbl.text;
    self.billPageVc.fromSeeMoreMy = self.fromSeeMoreMy;
    self.billPageVc.selectedIndex = self.selectedIndex;
    [self addChildViewController:self.billPageVc];
    self.billPageVc.view.frame = CGRectMake(0, NavBarHeight+35, ScreenWidth, ScreenHeight-35-NavBarHeight);
    [self.billPageVc didMoveToParentViewController:self];
    [self.view addSubview:self.billPageVc.view];
    [self.billPageVc reloadVc];
}

- (IBAction)didSelectTransType:(id)sender {
    [self showTransactionTypePickerView];
}

- (IBAction)didSelectCurrencyType:(id)sender {
    [self showCurrencyTypePickerView];
}

-(void)showTransactionTypePickerView{
    __block NSArray *array;
    [self.view endEditing:YES];
    if([self.currencyTypelbl.text isEqualToString:@"CNY"]){
        array = @[@"All".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"chatView.function.transfer".icanlocalized,@"Withdrawals".icanlocalized, @"Utility payments".icanlocalized];
    }else if([self.currencyTypelbl.text isEqualToString:@"USDT"]){
        array = @[@"All".icanlocalized,@"C2C Transfer".icanlocalized,@"C2C Withdrawal".icanlocalized,@"Utility Payments".icanlocalized,@"C2C".icanlocalized];
    }else{
        array = @[@"All".icanlocalized,@"C2C Transfer".icanlocalized,@"C2C Withdrawal".icanlocalized,@"Utility Payments".icanlocalized,@"C2C".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"chatView.function.transfer".icanlocalized,@"Withdrawals".icanlocalized, @"Utility payments".icanlocalized];
    }
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Select".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:array dataBlock:^(NSString* obj) {
        NSString *title = (NSString *)obj;
        self.transactionTypeLbl.text = title;
        self.billPageVc.dataTypeTrans = self.transactionTypeLbl.text;
        self.billPageVc.currencyType = self.currencyTypelbl.text;
        [self.billPageVc reloadVc];
    }];
}

-(void)showCurrencyTypePickerView{
    [self.view endEditing:YES];
    NSArray *array = @[@"All".icanlocalized,@"USDT",@"CNY"];
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Selectcurrency".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:array dataBlock:^(NSString* obj) {
        NSString *title = (NSString *)obj;
        self.currencyTypelbl.text = title;
        self.billPageVc.currencyType = self.currencyTypelbl.text;
        self.transactionTypeLbl.text = @"All".icanlocalized;
        self.billPageVc.dataTypeTrans = self.transactionTypeLbl.text;
        [self.billPageVc reloadVc];
    }];
}

- (void)removePick {
    [[JKPickerView sharedJKPickerView] removePickView];
}

- (void)sureAction {
    [[JKPickerView sharedJKPickerView] sureAction];
}

@end
