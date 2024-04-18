
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 31/5/2021
 - File name:  BuyPackageViewController.m
 - Description:
 - Function List:
 */


#import "BuyPackageViewController.h"
#import "BuyPackageCollectionViewCell.h"
#import "PayManager.h"
@interface BuyPackageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLalbe;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property(nonatomic, strong) NSArray<PackagesInfo*> *packagesItems;

@property(nonatomic, strong) PayManager *packagePayManager;
@end

@implementation BuyPackageViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    "BuyPackageViewController.buyBtn"="立即购买";
//    "BuyPackageViewController.titleLalbe"="购买套餐";
//    "BuyPackageViewController.tipLabel"="解锁你与ta的邂逅吧";
    self.packagePayManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        
    }];
    self.titleLalbe.text=@"BuyPackageViewController.titleLalbe".icanlocalized;
    self.tipLabel.text=@"BuyPackageViewController.tipLabel".icanlocalized;
    [self.buyBtn setTitle:@"BuyPackageViewController.buyBtn".icanlocalized forState:UIControlStateNormal];
    [self.collectionView registNibWithNibName:kBuyPackageCollectionViewCell];
    [self getPackInfoRequest];
    [self.buyBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
}

#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
- (IBAction)buyAction:(id)sender {
    [self showSurePayView];
}

-(void)showSurePayView{
    PackagesInfo*selectInfo;
    for (PackagesInfo*info in self.packagesItems) {
        if (info.select) {
            selectInfo=info;
            break;
        }
    }
    PostMyPackagesRequest*request=[PostMyPackagesRequest request];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    request.packageId=selectInfo.packageId;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[PayMyPackagesInfo class] contentClass:[PayMyPackagesInfo class] success:^(PayMyPackagesInfo* response) {
        [QMUITips hideAllTips];
        [self.packagePayManager showPayViewWithAmount:[NSString stringWithFormat:@"%.2f",selectInfo.price] typeTitleStr:@"Top Up".icanlocalized SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            PayPreparePayOrderRequest*request=[PayPreparePayOrderRequest request];
            request.pathUrlString=[NSString stringWithFormat:@"%@/preparePayOrder/%@",request.baseUrlString,response.transactionId];
            request.password=password;
            request.parameters=[request mj_JSONString];
            [QMUITipsTool showLoadingWihtMessage:@"Paying".icanlocalized inView:nil isAutoHidden:NO];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id cresponse) {
                //"BuyPackageViewController.successTips"="购买成功";
//                [QMUITipsTool showSuccessWithMessage:@"BuyPackageViewController.successTips".icanlocalized inView:self.view];
                if (self.buySuccessBlock) {
                    self.buySuccessBlock(response.transactionId);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self showSurePayView];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self showSurePayView];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        DDLogInfo(@"error=%@",error);
                        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                    }
                } else {
                    DDLogInfo(@"error=%@",error);
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                }
            }];
        }];
       
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showLoadingWihtMessage:info.desc inView:self.view];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.packagesItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BuyPackageCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kBuyPackageCollectionViewCell forIndexPath:indexPath];
    cell.packagesInfo=self.packagesItems[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PackagesInfo*currentInfo=self.packagesItems[indexPath.item];
    if (!currentInfo.select) {
        for (PackagesInfo*info in self.packagesItems) {
            info.select=NO;
        }
        currentInfo.select=YES;
        [collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-20)/3.0,190);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking
-(void)getPackInfoRequest{
    GetPackagesRequest*request=[GetPackagesRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[PackagesInfo class] success:^(NSArray<PackagesInfo*>* response) {
        response.firstObject.select=YES;
        self.packagesItems=response;
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
