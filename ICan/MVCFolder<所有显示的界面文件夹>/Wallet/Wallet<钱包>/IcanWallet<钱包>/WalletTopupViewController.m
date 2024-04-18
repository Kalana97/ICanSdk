//
//  WalletTopupViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 19/10/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "WalletTopupViewController.h"
#import "OptionalPageViewController.h"
#import "C2CSelectLegalTenderViewController.h"
#import "AmountViewCollectionViewCell.h"
#import "C2CPConfirmOrderViewController.h"
#import "ChatUtil.h"
#import "WCDBManager+ChatModel.h"

@interface WalletTopupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (weak, nonatomic) IBOutlet UILabel *titleTop;
@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic, strong) OptionalPageViewController *optionalPageVc;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *op4;
@property (weak, nonatomic) IBOutlet UILabel *op2;
@property (weak, nonatomic) IBOutlet UILabel *op3;
@property (weak, nonatomic) IBOutlet UILabel *op1;
@property (weak, nonatomic) IBOutlet UILabel *selectedAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalInCNT;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *op6;
@property (weak, nonatomic) IBOutlet UILabel *op7;
@property (weak, nonatomic) IBOutlet UILabel *op5;
@property (weak, nonatomic) IBOutlet UILabel *opMore;
@property (nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
@property (nonatomic, strong) NSDictionary *selectedRechargeAmountObject;
@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic,strong) NSIndexPath * selectIndexPath;

@property (nonatomic,strong) NSArray *paymentInfo;
@end

@implementation WalletTopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTop.text = @"Recharge".icanlocalized;
    self.descLabel.text = @"Please select the rachrge amount".icanlocalized;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    UINib *cellNib = [UINib nibWithNibName:@"AmountViewCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AmountViewCollectionViewCell"];
    [self.rechargeBtn setTitle:@"Recharge".icanlocalized forState:UIControlStateNormal];
    [self getPriceListInfo];
    self.currency.hidden = YES;
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = 20.0;
    self.flag.layer.masksToBounds = YES;
    self.flag.layer.cornerRadius = 5.0;
    self.optionalPageVc =  [[OptionalPageViewController alloc]init];
    self.selectCurrencyInfo = C2CUserManager.shared.currentCurrencyInfo;
    if (!self.selectCurrencyInfo) {
        NSPredicate *predicate ;
        if (UserInfoManager.sharedManager.countriesCode.length>0) {
            predicate = [NSPredicate predicateWithFormat:@"countriesCode == [cd] %@ ",UserInfoManager.sharedManager.countriesCode];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"countriesCode == [cd] %@ ",C2CUserManager.shared.countriesCode];
        }
        NSArray * filterItems = [C2CUserManager.shared.allSupportedLegalTenderCurrencyItems filteredArrayUsingPredicate:predicate];
        if (filterItems.count>0) {
            self.selectCurrencyInfo = filterItems.firstObject;
        }else{
            self.selectCurrencyInfo = C2CUserManager.shared.allSupportedLegalTenderCurrencyItems.firstObject;
        }
        C2CUserManager.shared.currentCurrencyInfo = self.selectCurrencyInfo;
    }
    self.exchangeLabel.text = self.selectCurrencyInfo.code;
    [self.flag sd_setImageWithURL:[NSURL URLWithString:self.selectCurrencyInfo.flag]];

}
-(void)setOptionalPageVcWith:(CurrencyInfo*)info{
    self.exchangeLabel.text = info.code;
    [self.flag sd_setImageWithURL:[NSURL URLWithString:info.flag]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"legalTender contains [cd] %@ AND supportC2C== YES ",info.code];
    NSArray *countItems =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
    self.optionalPageVc.currencyInfo= info;
    self.optionalPageVc.titleItems = countItems;
    [self.optionalPageVc reloadPageView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)getPriceListInfo{
    C2CGetAdverPriceListRequest *request = [C2CGetAdverPriceListRequest request];
    request.legalTender = @"CNY";
    request.virtualCurrency = @"CNT";
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AdPriceInfo class] success:^(NSArray* response) {
        @strongify(self);
        self.priceArray = response;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"count != nil"];
        NSArray *filteredArray = [response filteredArrayUsingPredicate:predicate];
        self.paymentInfo = [filteredArray valueForKeyPath:@"count"];
        [self.collectionView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];

}

- (IBAction)rechargeAction:(id)sender {

    C2CRechargeRequest *request = [C2CRechargeRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/suitable"];
    request.legalTender = @"CNY";
    request.virtualCurrency = @"CNT";
    request.amount = [self.selectedRechargeAmountObject valueForKeyPath:@"count"];
    request.adId = [self.selectedRechargeAmountObject valueForKeyPath:@"adId"];
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CAdverInfo class] success:^(NSArray*  _Nonnull response) {
        self.adverInfo = response.firstObject;
        C2CBuyAdverRequest * request = [C2CBuyAdverRequest request];
        request.adId = self.adverInfo.adId;
        request.buyPrice = [self.selectedRechargeAmountObject valueForKeyPath:@"count"];
        request.parameters = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
            C2CPConfirmOrderViewController * vc = [C2CPConfirmOrderViewController new];
            vc.orderInfo = response;
            vc.adverInfo = self.adverInfo;
            vc.fromTopup = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
            //创建文本消息
            if (self.adverInfo.autoMessage) {
                ChatModel *model = [[ChatModel alloc]init];
                model.authorityType = AuthorityType_c2c;
                model.c2cUserId = self.adverInfo.user.userId;
                model.chatID = self.adverInfo.user.uid;
                model.chatType = UserChat;
                model.c2cOrderId = response.orderId;
                ChatModel *textModel = [ChatUtil initTextMessage:self.adverInfo.autoMessage config:model];
                textModel.isOutGoing = NO;
                textModel.sendState = 1;
                [[WCDBManager sharedManager]cacheMessageWithChatModel:textModel isNeedSend:NO];
            }
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)exchangeAction {
    [self.optionalPageVc.amountPopView hiddenView];
    [self.optionalPageVc.tradingPopView hiddenView];
    [self.optionalPageVc.popView hiddenView];
//    self.popView.hidden = YES;
    C2CSelectLegalTenderViewController * vc = [[C2CSelectLegalTenderViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.selectCurrencyInfo = self.selectCurrencyInfo;
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        self.selectCurrencyInfo = info;
        self.exchangeLabel.text = info.code;
        [self.flag sd_setImageWithURL:[NSURL URLWithString:info.flag]];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:info.code forKey:@"P2PAddSelectCurrencyInfo"];
        [prefs synchronize];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"legalTender contains [cd] %@ AND supportC2C== YES ",info.code];
        NSArray *countItems =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
        self.optionalPageVc.titleItems = countItems;
        self.optionalPageVc.currencyInfo = info;
        [self.optionalPageVc reloadPageView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paymentInfo.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AmountViewCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:KIDAmountCollectionCell forIndexPath:indexPath];
    NSDictionary *info = self.priceArray[indexPath.item];
    NSNumber *amountString = [info valueForKeyPath:@"count"];
    float amount = [amountString floatValue];
    if([[info valueForKeyPath:@"supportWechat"] isEqual:@YES]){
        cell.badgeImg.image = [UIImage imageNamed:@"icon_login_wechat"];
    }else if ([[info valueForKeyPath:@"supportAliPay"] isEqual:@YES]){
        cell.badgeImg.image = [UIImage imageNamed:@"icon_login_alipay"];
    }else if ([[info valueForKeyPath:@"supportBankTransfer"] isEqual:@YES]){
        cell.badgeImg.image = [UIImage imageNamed:@"icon_balance_payway_union"];
    }else if ([[info valueForKeyPath:@"supportCash"] isEqual:@YES]){
        cell.badgeImg.image = [UIImage imageNamed:@"wallet_function_recharge"];
    }
    if (indexPath==self.selectIndexPath) {
        cell.amountLabel.layer.borderWidth = 1.0;
        cell.amountLabel.layer.borderColor = UIColorThemeMainColor.CGColor;
        cell.amountLabel.textColor = UIColorThemeMainSubTitleColor;
    }else{
        cell.amountLabel.layer.borderWidth = 1.0;
        cell.amountLabel.layer.borderColor = UIColor10PxClearanceBgColor.CGColor;
        cell.amountLabel.textColor = UIColorThemeMainSubTitleColor;
    }
    if((indexPath.item == 8 || indexPath.item == 17) && self.priceArray.count > 9){
        cell.amountLabel.text = @"mine.profile.title.more".icanlocalized;
        cell.badgeImg.image = [UIImage imageNamed:@""];
        cell.amountLabel.textColor = UIColor.orangeColor;
        cell.amountLabel.layer.borderWidth = 1.0;
        cell.amountLabel.layer.borderColor = UIColor.orangeColor.CGColor;
    }else if((indexPath.item == self.paymentInfo.count-1) && self.priceArray.count > 9){
        cell.amountLabel.text = @"Top".icanlocalized;
        cell.amountLabel.textColor = UIColor.orangeColor;
        cell.badgeImg.image = [UIImage imageNamed:@""];
        cell.amountLabel.layer.borderWidth = 1.0;
        cell.amountLabel.layer.borderColor = UIColor.orangeColor.CGColor;
    }else {
        cell.amountLabel.text = [NSString stringWithFormat:@"%d", (int)amount];
    }
    cell.infor = info;
    return cell;
}
#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndexPath!=indexPath) {
        self.selectIndexPath=indexPath;
        NSDictionary *info = self.priceArray[indexPath.item];
        NSNumber * amountString = [info valueForKeyPath:@"count"];
        float amount = [amountString floatValue];
        
        if(indexPath.item == 8 && self.priceArray.count > 9){
            NSInteger currentSection = 0;
            NSInteger currentItem = 9;
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currentItem inSection:currentSection];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }else if(indexPath.item == 17 && self.priceArray.count > 9){
            NSInteger nextItem = 26;
            NSIndexPath *nextIndexPath = nextItem > self.priceArray.count ? [NSIndexPath indexPathForItem:self.paymentInfo.count-1 inSection:indexPath.section] : [NSIndexPath indexPathForItem:nextItem inSection:indexPath.section];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }else if((indexPath.item == self.paymentInfo.count-1) && self.priceArray.count > 9){
            NSInteger nextItem = 0;
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:indexPath.section];
            [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }else {
            self.currency.hidden = NO;
            self.selectedAmount.text = [NSString stringWithFormat:@"%d%@", (int)amount, @".00"];
            self.selectedRechargeAmountObject = self.priceArray[indexPath.item];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-60)/3,50);
    
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
