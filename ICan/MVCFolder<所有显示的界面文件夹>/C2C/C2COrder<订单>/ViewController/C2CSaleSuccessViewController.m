//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CSaleSuccessViewController.m
- Description:
- Function List:
*/
        

#import "C2CSaleSuccessViewController.h"
#import "C2COrderDetailViewController.h"
#import "UIViewController+Extension.h"
@interface C2CSaleSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UILabel *badLabel;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@end

@implementation C2CSaleSuccessViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"C2CConfirmReceiptMoneyViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C2CSaleSuccessViewControllerTitle".icanlocalized;
    [self.doneButton setTitle:@"C2CSaleSuccessViewControllerDoneButton".icanlocalized forState:UIControlStateNormal];
    self.tipsLabel.text = @"C2CSaleSuccessViewControllerTipsLabel".icanlocalized;
    self.goodLabel.text = @"C2CSaleSuccessViewControllerGoodLabel".icanlocalized;
    self.badLabel.text = @"C2CSaleSuccessViewControllerBadLabel".icanlocalized;
    CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.legalTender];
    self.symbolLabel.text = info.symbol;
    self.priceLabel.text = [self.orderInfo.totalCount calculateByNSRoundDownScale:2].currencyString;
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[self.orderInfo.quantity calculateByNSRoundDownScale:2].currencyString,self.orderInfo.virtualCurrency];
    
}

-(IBAction)doneBtnAction{
    C2COrderDetailViewController*vc = [[C2COrderDetailViewController alloc]init];
    vc.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)goodAction{
    [self postC2CEvaluateOrderRequest:@"true"];
}
-(IBAction)badAction{
    [self postC2CEvaluateOrderRequest:@"false"];
    
}
-(void)postC2CEvaluateOrderRequest:(NSString*)state{
    C2CEvaluateOrderRequest * request = [C2CEvaluateOrderRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/evaluate/%ld/%@",self.orderInfo.adOrderId,state];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
        [self doneBtnAction];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
