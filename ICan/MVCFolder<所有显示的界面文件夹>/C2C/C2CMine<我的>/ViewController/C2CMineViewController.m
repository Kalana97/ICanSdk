//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2CMineViewController.m
- Description:
- Function List:
*/
        

#import "C2CMineViewController.h"
#import "CertificationViewController.h"
#import "SelectReceiveMethodViewController.h"
#import "C2CUserMoreViewController.h"
#import "C2CUserReceiveEvaluateViewController.h"
#import <MJRefresh.h>
@interface C2CMineViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorityLabel;
@property (weak, nonatomic) IBOutlet UIView *circleBgView;
//30日成单量
@property (weak, nonatomic) IBOutlet UILabel *quantityAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTitleLabel;

//30日成单率
@property (weak, nonatomic) IBOutlet UILabel *rateAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *timeBgView;
//30日平均放款时间
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//30日平均付款时间
@property (weak, nonatomic) IBOutlet UILabel *loanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeMoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveEvaluateLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightContranstraint;
@property (weak, nonatomic) IBOutlet UIImageView *kycImgView;
@property (nonatomic, strong) C2CUserInfo *userInfo;
@end

@implementation C2CMineViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (IBAction)backAction:(id)sender {
    if (self.shoulPopToRoot) {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMoreData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = -StatusBarHeight;
    self.backBtnTopConstraint.constant = StatusBarHeight;
    if (isIPhoneX) {
        self.imageViewTopConstraint.constant = StatusBarAndNavigationBarHeight;
        self.bgHeightContranstraint.constant = 224;
    }else{
        self.imageViewTopConstraint.constant = StatusBarAndNavigationBarHeight;
        self.bgHeightContranstraint.constant = 200;
    }
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [self.circleBgView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    [self.timeBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
   
    self.quantityTitleLabel.text = @"OrderVolume30th".icanlocalized;
    self.rateTitleLabel.text = @"30dayOrderRate".icanlocalized;
    self.timeTitleLabel.text = @"30DaySaverageLoantime".icanlocalized;
    self.loanTitleLabel.text = @"30DaysAveragePaymentTime".icanlocalized;
    self.seeMoreLabel.text = @"C2CMineViewControllerSeeMoreLabel".icanlocalized;
    self.receiveEvaluateLabel.text = @"C2CMineViewControllerReceiveEvaluateLabel".icanlocalized;
    self.receiveMoneyLabel.text = @"C2CMineViewControllerReceiveMoneyLabel".icanlocalized;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMoreData) name:KUserAuthPassNotification object:nil];
}

- (IBAction)seeMoreAction {
    C2CUserMoreViewController * vc = [[C2CUserMoreViewController alloc]init];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)receiveEvaluateAction {
    C2CUserReceiveEvaluateViewController * vc = [[C2CUserReceiveEvaluateViewController alloc]init];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)receiveMoneyAction {
    SelectReceiveMethodViewController * vc = [SelectReceiveMethodViewController new];
    vc.type = SelectReceiveMethodType_Mine;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)setData{
    self.nameLabel.text = self.userInfo.nickname;
    self.authorityLabel.text = self.userInfo.kyc?@"AuthedUser".icanlocalized:@"NoAuthedUser".icanlocalized;
    self.kycImgView.image =self.userInfo.kyc?UIImageMake(@"mine_authentication_select"):UIImageMake(@"mine_authentication_unselect");
    [self.iconImageView setImageWithString:self.userInfo.headImgUrl placeholder:BoyDefault];
    self.quantityAmountLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.clinchCount];
    float rate = (self.userInfo.clinchCount*1.0)/(self.userInfo.orderCount*1.0)*100;
    if (self.userInfo.clinchCount==0) {
        self.rateAmountLabel.text = [NSString stringWithFormat:@"%@%@",@"0",@"%"];
    }else{
        self.rateAmountLabel.text = [NSString stringWithFormat:@"%.2f%@",rate,@"%"];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f %@",self.userInfo.averageConfirmTime,@"minutes".icanlocalized];
    self.loanLabel.text = [NSString stringWithFormat:@"%.2f %@",self.userInfo.averagePayTime,@"minutes".icanlocalized];
    
}
-(void)getMoreData{
    C2CGetUserMoreDataRequest * request = [C2CGetUserMoreDataRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/user/data/%@",C2CUserManager.shared.userId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  response) {
        self.userInfo = response;
        [self.scrollView.mj_header endRefreshing];
        [self setData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self.scrollView.mj_header endRefreshing];
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

@end
