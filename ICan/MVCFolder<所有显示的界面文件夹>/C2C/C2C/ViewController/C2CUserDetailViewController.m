//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 18/11/2021
 - File name:  C2CMineViewController.m
 - Description:
 - Function List:
 */


#import "C2CUserDetailViewController.h"
#import "C2CMyAdvertisingViewController.h"
#import "C2COptionalSaleViewController.h"
#import "C2CUserMoreViewController.h"
#import "WantToBuyListTableViewCell.h"
#import "C2CUserReceiveEvaluateViewController.h"
#import "C2CUserReceiveEvaluateTableViewCell.h"
@interface C2CUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorityLabel;
@property (weak, nonatomic) IBOutlet UIView *circleBgView;
///信息
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
///更多数据
@property (weak, nonatomic) IBOutlet UILabel *moreDataLabel;

///30日成单量
@property (weak, nonatomic) IBOutlet UILabel *quantityAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTitleLabel;

///30日成单率
@property (weak, nonatomic) IBOutlet UILabel *rateAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *timeBgView;
///30日平均放行时间
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

///30日平均放款
@property (weak, nonatomic) IBOutlet UILabel *loanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;

///评价背景
@property (weak, nonatomic) IBOutlet UIView *commentBgView;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentRateLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeight;

//评价上面的分割线
@property (weak, nonatomic) IBOutlet UIView *commentLineView;


///广告上面的分割线
@property (weak, nonatomic) IBOutlet UIView *adverLineView;
@property (weak, nonatomic) IBOutlet UIStackView *adverBgView;
@property (weak, nonatomic) IBOutlet UIView *oneLineSaleAdBgView;
@property (weak, nonatomic) IBOutlet UIView *oneLineBuyAdBgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITableView *saleTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTableViewHeight;
///在线广告
@property (weak, nonatomic) IBOutlet UILabel *onLineAdverLabel;
///在线出售广告
@property (weak, nonatomic) IBOutlet UILabel *onLineSellAdverLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineSellAdverMoreLabel;
///在线购买广告
@property (weak, nonatomic) IBOutlet UILabel *onLineBuyAdverLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineBuyAdverMoreLabel;

@property (weak, nonatomic) IBOutlet UITableView *onLineBuyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onLineBuyTableViewHeight;
@property (nonatomic, strong) C2CUserInfo *userInfo;

/// 在线购买的广告
@property(nonatomic, strong) NSArray<C2CAdverInfo*> *buyItems;

/// 在线出售的广告
@property(nonatomic, strong) NSArray<C2CAdverInfo*> *sellItems;
@property(nonatomic, strong) NSArray<C2COrderInfo*> *evluationItems;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;
///头像距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightContranstraint;

@end

@implementation C2CUserDetailViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = @"C2CUserDetailViewControllerInfoLabel".icanlocalized;
    self.moreDataLabel.text = @"C2CUserDetailViewControllerMoreDataLabel".icanlocalized;
    self.onLineAdverLabel.text = @"C2CUserDetailViewControllerOnLineAdverLabel".icanlocalized;
    self.onLineSellAdverLabel.text = @"C2CUserDetailViewControllerOnLineSellAdverLabel".icanlocalized;
    self.onLineBuyAdverLabel.text = @"C2CUserDetailViewControllerOnLineBuyAdverLabel".icanlocalized;
    self.quantityTitleLabel.text = @"OrderVolume30th".icanlocalized;
    self.rateTitleLabel.text = @"30dayOrderRate".icanlocalized;
    self.timeTitleLabel.text = @"30DaySaverageLoantime".icanlocalized;
    self.loanTitleLabel.text = @"30DaysAveragePaymentTime".icanlocalized;
    self.onLineBuyAdverMoreLabel.text = @"C2CMineViewControllerSeeMoreLabel".icanlocalized;
    self.onLineSellAdverMoreLabel.text = @"C2CMineViewControllerSeeMoreLabel".icanlocalized;
    
    self.topConstraint.constant = -StatusBarHeight;
    self.backBtnTopConstraint.constant = StatusBarHeight;
    if (isIPhoneX) {
        self.imageViewTopConstraint.constant = StatusBarAndNavigationBarHeight;
        self.bgHeightContranstraint.constant = 224;
    }else{
        self.imageViewTopConstraint.constant = StatusBarAndNavigationBarHeight;
        self.bgHeightContranstraint.constant = 200;
    }
    if (@available(iOS 15.0, *)) {
        self.commentTableView.sectionHeaderTopPadding = 0;
        self.onLineBuyTableView.sectionHeaderTopPadding = 0;
        self.saleTableView.sectionHeaderTopPadding = 0;
    }
    [self.circleBgView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    [self.timeBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.onLineBuyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.saleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.saleTableView registNibWithNibName:kWantToBuyListTableViewCell];
    [self.onLineBuyTableView registNibWithNibName:kWantToBuyListTableViewCell];
    [self.commentTableView registNibWithNibName:kC2CUserReceiveEvaluateTableViewCell];
    [self getUserAvailableBuyAdverRequest];
    [self getUserAvailableSellAdverRequest];
    [self getMoreData];
    [self getUserEvluationRequest];
    
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
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.commentTableView) {
        return 60;
    }
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.onLineBuyTableView) {
        return self.buyItems.count;
    }else if (tableView == self.saleTableView){
        return self.sellItems.count;
    }
    return self.evluationItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.onLineBuyTableView) {
        WantToBuyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kWantToBuyListTableViewCell];
        cell.isOptionBuy = YES;
        cell.cellLineView.hidden = indexPath.row!=0;
        cell.isUserDetail = YES;
        cell.adverInfo = self.buyItems[indexPath.row];
        return cell;
    }else if (tableView == self.saleTableView){
        WantToBuyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kWantToBuyListTableViewCell];
        cell.cellLineView.hidden = indexPath.row!=0;
        cell.isOptionBuy = NO;
        cell.isUserDetail = YES;
        cell.adverInfo = self.sellItems[indexPath.row];
        return cell;
    }
    C2CUserReceiveEvaluateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CUserReceiveEvaluateTableViewCell];
    
    cell.c2cOrderInfo = self.evluationItems[indexPath.row];
    cell.leadingContraint.constant = 0;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.onLineBuyTableView) {
        C2COptionalSaleViewController * vc = [C2COptionalSaleViewController  new];
        vc.adverInfo = [self.buyItems objectAtIndex:indexPath.row];
        vc.isBuy = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        C2COptionalSaleViewController * vc = [C2COptionalSaleViewController  new];
        vc.adverInfo = [self.sellItems objectAtIndex:indexPath.row];
        vc.isBuy = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (IBAction)userMoreAction:(id)sender {
    C2CUserMoreViewController * vc = [[C2CUserMoreViewController alloc]init];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看更多
- (IBAction)seeMoreAction {
    
}

/// 查看更多评论
- (IBAction)commentAction {
    C2CUserReceiveEvaluateViewController * vc = [[C2CUserReceiveEvaluateViewController alloc]init];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看在线出售广告
- (IBAction)oneLineSaleAction {
    C2CMyAdvertisingViewController * vc = [ C2CMyAdvertisingViewController new];
    vc.type = AdvertisingViewTypeOnLineSell;
    vc.userId = self.userInfo.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 查看在线购买广告
- (IBAction)oneLineBuyAction {
    C2CMyAdvertisingViewController * vc = [ C2CMyAdvertisingViewController new];
    vc.type = AdvertisingViewTypeOnLineBuy;
    vc.userId = self.userInfo.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setData{
    [self.iconImageView setImageWithString:self.userInfo.headImgUrl placeholder:BoyDefault];
    self.nameLabel.text = self.userInfo.nickname;
    
    self.authorityLabel.text = self.userInfo.kyc?@"AuthedUser".icanlocalized:@"NoAuthedUser".icanlocalized;
    self.quantityAmountLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.clinchCount];
    if (self.userInfo.orderCount==0) {
        self.rateAmountLabel.text = @"0%";
    }else{
        float rate = (self.userInfo.clinchCount*1.0)/(self.userInfo.orderCount*1.0)*100;
        self.rateAmountLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];
    }
   
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f %@",self.userInfo.averageConfirmTime,@"minutes".icanlocalized];
    self.loanLabel.text = [NSString stringWithFormat:@"%.2f %@",self.userInfo.averagePayTime,@"minutes".icanlocalized];
    
    
    if (self.userInfo.praiseCount==0) {
        self.commentRateLabel.text = [NSString stringWithFormat:@"%@ 100%%",@"PraiseRate".icanlocalized];
    }else{
        float evluateRate = (self.userInfo.praiseCount*1.0)/((self.userInfo.praiseCount+self.userInfo.negativeCount)*1.0)*100;
        self.commentRateLabel.text = [NSString stringWithFormat:@"%@ %.2f%%",@"PraiseRate".icanlocalized,evluateRate];
    }
    self.commentTitleLabel.text =[NSString stringWithFormat:@"%@(%ld)",@"C2CUserDetailComment".icanlocalized,self.userInfo.praiseCount+self.userInfo.negativeCount];
   
}
-(void)getMoreData{
    C2CGetUserMoreDataRequest * request = [C2CGetUserMoreDataRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/user/data/%ld",self.userId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  response) {
        self.userInfo = response;
        [self setData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}


/// 获取在线购买的广告
-(void)getUserAvailableBuyAdverRequest{
    C2CGetUserAdverListRequest * request = [C2CGetUserAdverListRequest request];
    request.available = @(true);
    request.transactionType = @"Sell";
    request.current = @(1);
    request.size = @(2);
    request.userId = [NSString stringWithFormat:@"%ld",self.userId];
    request.parameters = [request mj_JSONObject];
    
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COptionalListInfo class] contentClass:[C2COptionalListInfo class] success:^(C2COptionalListInfo*  _Nonnull response) {
        self.buyItems = response.records;
        if (self.buyItems.count == 0) {
            self.oneLineBuyAdBgView.hidden = YES;
        }else{
            self.oneLineBuyAdBgView.hidden = NO;
            [self.onLineBuyTableView reloadData];
            [self.onLineBuyTableView layoutIfNeeded];
            self.onLineBuyTableViewHeight.constant = self.onLineBuyTableView.contentSize.height;
        }
        [self shouldHiddenadverBgView];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
/// 获取在线出售的广告
-(void)getUserAvailableSellAdverRequest{
    C2CGetUserAdverListRequest * request = [C2CGetUserAdverListRequest request];
    request.available = @(true);
    request.transactionType = @"Buy";
    request.current = @(1);
    request.size = @(2);
    request.userId = [NSString stringWithFormat:@"%ld",self.userId];
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COptionalListInfo class] contentClass:[C2COptionalListInfo class] success:^(C2COptionalListInfo*  _Nonnull response) {
        self.sellItems = response.records;
        if (self.sellItems.count == 0) {
            self.oneLineSaleAdBgView.hidden = YES;
        }else{
            self.oneLineSaleAdBgView.hidden = NO;
            [self.saleTableView reloadData];
            [self.saleTableView layoutIfNeeded];
            self.saleTableViewHeight.constant = self.saleTableView.contentSize.height;
        }
        [self shouldHiddenadverBgView];
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)shouldHiddenadverBgView{
    if (self.sellItems.count==0&&self.buyItems.count==0) {
        self.adverBgView.hidden = YES;
    }else{
        self.adverBgView.hidden = NO;
    }
}
-(void)getUserEvluationRequest{
    C2CGetEvaluateRequest * request = [C2CGetEvaluateRequest request];
    request.size = @(2);
    request.current = @(1);
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/evaluate/%ld",self.userId];
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderListInfo class] contentClass:[C2COrderListInfo class] success:^(  C2COrderListInfo* response) {
        self.evluationItems = response.records;
        if (self.evluationItems.count == 0) {
            self.commentBgView.hidden = YES;
            self.commentLineView.hidden = YES;
        }else{
            self.commentBgView.hidden = NO;
            [self.commentTableView reloadData];
            
            self.commentTableHeight.constant = response.records.count*60;
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
