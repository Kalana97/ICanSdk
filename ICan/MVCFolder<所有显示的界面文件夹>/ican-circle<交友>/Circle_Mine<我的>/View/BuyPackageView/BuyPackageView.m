
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 13/7/2021
- File name:  BuyPackageView.m
- Description:
- Function List:
*/
        

#import "BuyPackageView.h"
#import "BuyPackageCollectionViewCell.h"

@interface BuyPackageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLalbe;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;




@end

@implementation BuyPackageView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.hidden=YES;
    self.titleLalbe.text=@"BuyPackageViewController.titleLalbe".icanlocalized;
    self.tipLabel.text=@"BuyPackageViewController.tipLabel".icanlocalized;
    [self.buyBtn setTitle:@"BuyPackageViewController.buyBtn".icanlocalized forState:UIControlStateNormal];
    [self.collectionView registNibWithNibName:kBuyPackageCollectionViewCell];
    [self.buyBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.iconImgView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
}
/*3.实现这个代理方法*/
#pragma mark Delegate for the gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //注意传入的参数是当前的CollectionView对象
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}
-(void)hidden{
    self.hidden=YES;
}
-(void)setPackagesItems:(NSArray<PackagesInfo *> *)packagesItems{
    _packagesItems=packagesItems;
    [self.collectionView reloadData];
}
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
    [QMUITipsTool showOnlyLodinginView:self isAutoHidden:NO];
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
                self.hidden=YES;
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
    return CGSizeMake((ScreenWidth-20)/3.0,170);
    
    
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
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

@end
