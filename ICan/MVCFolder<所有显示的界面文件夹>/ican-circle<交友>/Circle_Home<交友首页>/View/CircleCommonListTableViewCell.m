//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleCommonListTableViewCell.m
- Description:
- Function List:
*/
        

#import "CircleCommonListTableViewCell.h"
#import "CircleEditMydDataViewController.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "UIColor+DZExtension.h"
#import "YBImageBrowerTool.h"
#import "CircleUserDetailViewController.h"
@interface CircleCommonListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet DZIconImageView *circleIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *genderBgView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIView *bussiBgView;
@property (weak, nonatomic) IBOutlet UIView *distanceBgView;

//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//职业
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel *singutureLabel;

@property (weak, nonatomic) IBOutlet UIView *lastLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favotiteWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIStackView *realBgView;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UIStackView *svipBgView;
@property (weak, nonatomic) IBOutlet UILabel *svipCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yueImageVIew;




@end
@implementation CircleCommonListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.distanceBgView layerWithCornerRadius:15/2 borderWidth:0 borderColor:nil];
    [self.bussiBgView layerWithCornerRadius:15/2 borderWidth:0 borderColor:nil];
    
    [self.genderBgView layerWithCornerRadius:15/2 borderWidth:0 borderColor:nil];
    [self.circleIconImgView layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    self.genderBgView.backgroundColor=UIColorMakeWithRGBA(236, 67, 99, 0.1);
    self.lineView.hidden=YES;
    [self.favoriteBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.favoriteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.favoriteBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Follow".icanlocalized forState:UIControlStateNormal];
    
    [self.favoriteBtn setTitleColor:UIColor153Color forState:UIControlStateSelected];
    [self.favoriteBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Followed".icanlocalized forState:UIControlStateSelected];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    CGRect realRect=self.realBgView.bounds;
    CGRect svipFrame = self.svipBgView.bounds;
    CAGradientLayer *gradientLayer = [UIColor caGradientLayerWithFrame:realRect cornerRadius:5 colors:@[(__bridge id)UIColorMake(107, 64, 3).CGColor, (__bridge id)UIColorMake(84, 63, 7).CGColor, (__bridge id)UIColorMake(33, 39, 51).CGColor] locations:@[@0.0,@0.6,@1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self.realBgView.layer insertSublayer:gradientLayer atIndex:0];
    
    CAGradientLayer *sgradientLayer = [UIColor caGradientLayerWithFrame:svipFrame cornerRadius:5 colors:@[(__bridge id)UIColorMake(77,40,76).CGColor, (__bridge id)UIColorMake(53,25,50).CGColor, (__bridge id)UIColorMake(27,25,65).CGColor] locations:@[@0.0,@0.6,@1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self.svipBgView.layer insertSublayer:sgradientLayer atIndex:0];
    
}
-(void)setCircleListType:(CircleListType)circleListType{
    if (circleListType==CircleListType_Dislike) {
        self.favoriteBtn.hidden=YES;
    }
}
-(void)setUserInfo:(CircleUserInfo *)userInfo{
    _userInfo=userInfo;
    [self.circleIconImgView setCircleIconImageViewWithUrl:userInfo.avatar gender:userInfo.gender];
    self.genderLabel.text=[NSString stringWithFormat:@"%ld",(long)userInfo.age];
    self.nameLabel.text=userInfo.nickname;
    self.yueImageVIew.hidden=!userInfo.yue;
    if (userInfo.signature.length>0) {
        self.singutureLabel.hidden=self.lastLineView.hidden=NO;
    }else{
        self.singutureLabel.hidden=self.lastLineView.hidden=YES;
    }
    self.singutureLabel.text=userInfo.signature;
    if ([userInfo.gender isEqualToString:@"Male"]) {
        self.genderBgView.hidden=NO;
        self.genderImgView.image=UIImageMake(@"icon_circle_male");
//        rgb(113,162,255)
        self.genderBgView.backgroundColor=UIColorMakeWithRGBA(113, 162, 255, 1);
        self.genderLabel.textColor=UIColor.whiteColor;
    }else if([userInfo.gender isEqualToString:@"Female"]){
        //rgb(248,120,140)
        self.genderBgView.hidden=NO;
        self.genderImgView.image=UIImageMake(@"icon_circle_female");
        self.genderBgView.backgroundColor=UIColorMakeWithRGBA(248, 120, 140, 1);
        self.genderLabel.textColor=UIColor.whiteColor;
    }else{//Unknown
        self.genderBgView.hidden=YES;
    }
    if (userInfo.avatar.length>0) {
        self.realBgView.hidden=YES;
    }else{
        self.realBgView.hidden=YES;
    }
    //距离显示逻辑：
//    距离显示逻辑：
//    - 距离小于100m 显示具体距离，比如 25m、30m
//    - 距离100m<距离<1000m 显示  （距离+100） m，距离取百
//    - 1km<距离<200km 显示 （距离+1） km，距离取整
    self.distanceLabel.text=userInfo.showDistance;
    [self checkIsLike];
    
    [self.collectionView reloadData];
}
-(void)setIsHome:(BOOL)isHome{
    _isHome=isHome;
    if (isHome) {
        if (self.userInfo.photoWalls.count>0) {
            self.collectionView.hidden=NO;
        }else{
            self.collectionView.hidden=YES;
        }
    }else{
        self.collectionView.hidden=YES;
    }
    
}
-(void)checkIsLike{
    self.favoriteBtn.selected=self.userInfo.isMeLike;
    if (self.userInfo.isMeLike) {
        CGFloat width=[NSString widthForString:@"CircleCommonListTableViewCell.favoriteBtn.Followed".icanlocalized withFontSize:14 height:20];
        self.favotiteWidth.constant=width+30;
        [self.favoriteBtn setBackgroundColor:UIColorBg243Color];
    }else{
        CGFloat width=[NSString widthForString:@"CircleCommonListTableViewCell.favoriteBtn.Follow".icanlocalized withFontSize:14 height:20];
        self.favotiteWidth.constant=width+30;
        [self.favoriteBtn setBackgroundColor:UIColorThemeMainColor];

    }
}
- (IBAction)favoriteBtnAction {
    if (self.userInfo.isMeLike) {
        PUTLikeUsersRequest*request=[PUTLikeUsersRequest request];
        request.likeUserId=self.userInfo.userId;
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
            self.userInfo.isMeLike=NO;
            [self checkIsLike];
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }];
    }else{
        PostLikeUsersRequest*request=[PostLikeUsersRequest request];
        request.likeUserId=self.userInfo.userId;
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
            self.userInfo.isMeLike=YES;
            [self checkIsLike];
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }];
    }
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userInfo.photoWalls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserDetailImgeCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleUserDetailImgeCollectionViewCell forIndexPath:indexPath];
    PhotoWallInfo * info = self.userInfo.photoWalls[indexPath.row];
    cell.wallInfo = info;
    cell.addBgView.hidden=YES;
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleUserDetailViewController*vc=[[CircleUserDetailViewController alloc]init];
    vc.userInfo=self.userInfo;
    [[AppDelegate shared]pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-90)/3.0,(ScreenWidth-90)/3.0);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
