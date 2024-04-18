//
//  BusinessDetailsViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-16.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessDetailsViewController.h"
#import "BusinessListImageCollectionViewCell.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "BusinessUserRequest.h"
#import "BusinessNetworkReqManager.h"
#import "BusinessListImageCollectionViewCell.h"
#import "YBImageBrowerTool.h"

@interface BusinessDetailsViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *businessTitle;
@property(nonatomic, strong) UIButton *loveButton;
@property(nonatomic, strong) UIView *navBarView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIStackView *verifiedBadge;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *iLikeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeMeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeMeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *viewPhotoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bigCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *photoWallLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTop;
@property(nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation BusinessDetailsViewController
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}

-(BOOL)preferredNavigationBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollViewTop.constant = -StatusBarHeight;
    [self.bigCollectionView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self.bigCollectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    self.currentSelectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.bigCollectionView.delegate = self;
    self.bigCollectionView.dataSource = self;
    [self.iconImgView layerWithCornerRadius:75/2 borderWidth:0 borderColor:nil];
    [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.followBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Follow".icanlocalized forState:UIControlStateNormal];
    [self.followBtn setTitleColor:UIColor153Color forState:UIControlStateSelected];
    [self.followBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Followed".icanlocalized forState:UIControlStateSelected];
    [self.messageBtn setTitle:@"Message".icanlocalized forState:UIControlStateNormal];
    self.iLikeTipLabel.text = @"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized;
    self.iLikeMeTipLabel.text = @"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized;
    self.favouriteTipLabel.text = @"CircleMineShowUserImgTableViewCell.favoriteTipLabel".icanlocalized;
    self.photoWallLabel.text = @"CircleUserDetailViewController.photoWallLabel".icanlocalized;
    self.viewPhotoLabel.text = @"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel".icanlocalized;
    [self.likeBtn sizeToFit];
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(NavBarHeight));
    }];
    [self.navBarView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    GetBusinessUserInfoRequest *request = [GetBusinessUserInfoRequest request];
    if(self.businessId){
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/business/info/%ld",(long)self.businessId];
    }else{
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/business/info/%ld",(long)self.userInfo.businessId];
    }
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessCurrentUserInfo class] contentClass:[BusinessCurrentUserInfo class] success:^(BusinessCurrentUserInfo *response) {
        [QMUITips hideAllTips];
        self.userInfo = response;
        [self setUserData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
    }];
}

-(void)setUserData{
    [self.iconImgView setDZIconImageViewWithUrl:self.userInfo.avatar gender:@""];
    self.businessTitle.text = self.userInfo.businessName;
    self.verifiedBadge.hidden = YES;
    self.descLbl.text = self.userInfo.businessDescription;
    if (self.userInfo.area) {
        self.areaView.hidden = NO;
        self.areaLbl.text = self.userInfo.areaEn;
    }else{
        self.areaView.hidden = YES;
    }
    if(self.userInfo.showDistance){
        self.distanceView.hidden = NO;
        self.distanceLbl.text = self.userInfo.showDistance;
    }else{
        self.distanceView.hidden = YES;
    }
    if(self.userInfo.photoWalls.count > 0){
        self.bigCollectionView.hidden = NO;
    }else{
        self.bigCollectionView.hidden = YES;
    }
    self.followBtn.selected = self.userInfo.isFollowingByMe;
    if(self.self.userInfo.isFollowingByMe){
        [self.followBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F6F6F6"]];
    }else{
        [self.followBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#006FEE"]];
    }
    if(self.userInfo.background.length > 0){
        [self.backgroundImg setImageWithString:self.userInfo.background placeholder:nil];
    }else{
        NSString *imgStr = [NSString stringWithFormat:@"bg%d",arc4random()%4+1];
        self.backgroundImg.image = UIImageMake(imgStr);
    }
    self.likeBtn.selected = self.userInfo.isLikeByMe;
    [self.likeBtn setImage:[UIImage imageNamed:@"icon_fabulous_n"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"icon_fabulous_y"] forState:UIControlStateSelected];
    self.iLikeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.followingCount];
    self.iLikeMeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.followerCount];
    self.favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.likeCount];
    [self reloadCollectionView];
    if (!self.userInfo.enable) {
        [UIAlertController alertControllerWithTitle:@"CircleOtherUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        }];
        return;
    }
}

-(void)reloadCollectionView{
    [self.bigCollectionView reloadData];
    [self.bigCollectionView layoutSubviews];
    [self.bigCollectionView layoutIfNeeded];
    self.collectionViewHeight.constant = self.bigCollectionView.collectionViewLayout.collectionViewContentSize.height;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenty = scrollView.contentOffset.y + 80;
    CGFloat marightY = NavBarHeight;
    if (contenty > marightY) {
        self.navBarView.backgroundColor = UIColor.whiteColor;
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
    }else{
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_circle_back_white") forState:UIControlStateNormal];
        self.navBarView.backgroundColor = UIColorMakeWithRGBA(255, 255, 255, contenty / marightY);
    }
}

-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[UIView alloc]init];
        _navBarView.backgroundColor = UIColorMakeWithRGBA(255, 255, 255, 0.1);
    }
    return _navBarView;
}

-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_circle_back_white") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}

-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}

- (IBAction)followAction:(id)sender {
    if (!self.userInfo.enable) {
        return;
    }
    FollowOrUnfollowBusiness *request = [FollowOrUnfollowBusiness request];
    if(!self.userInfo.isFollowingByMe){
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/businessFollower/followOrUnfollow?businessId=%ld&isFollow=%d",(long)self.userInfo.businessId,true];
    }else{
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/businessFollower/followOrUnfollow?businessId=%ld&isFollow=%d",self.userInfo.businessId,false];
    }
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessBaseResponse class] contentClass:[BusinessBaseResponse class] success:^(id  _Nonnull response) {
        if (self.fllowBlock) {
            self.fllowBlock();
        }
        NSInteger followCount = self.userInfo.followerCount;
        if(!self.userInfo.isFollowingByMe){
            self.followBtn.selected = self.userInfo.isFollowingByMe = YES;
            [self.followBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F6F6F6"]];
            self.iLikeMeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)followCount + 1];
            self.userInfo.followerCount++;
        }else{
            self.followBtn.selected = self.userInfo.isFollowingByMe = NO;
            [self.followBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#006FEE"]];
            self.iLikeMeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)followCount - 1];
            self.userInfo.followerCount--;
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

- (IBAction)chatAction:(id)sender {
    if (!self.userInfo.enable) {
        return;
    }
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%zd",self.userInfo.icanId],kchatType:UserChat,kauthorityType:AuthorityType_friend}];
     [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)likeAction:(id)sender {
    LikeCancelLikeBusiness *request = [LikeCancelLikeBusiness request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/business/like/%ld",(long)self.userInfo.businessId];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessBaseResponse class] contentClass:[BusinessBaseResponse class] success:^(id  _Nonnull response) {
        NSInteger likeCount = self.userInfo.likeCount;
        if(self.userInfo.isLikeByMe){
            self.likeBtn.selected = self.userInfo.isLikeByMe = NO;
            self.userInfo.likeCount--;
            self.favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",(long)likeCount
            -1];
        }else{
            self.likeBtn.selected = self.userInfo.isLikeByMe = YES;
            self.userInfo.likeCount++;
            self.favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",(long)likeCount
            +1];
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userInfo.photoWalls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBusinessListImageCollectionViewCell forIndexPath:indexPath];
    BusinessPhotoWallList *info = self.userInfo.photoWalls[indexPath.row];
    cell.wallInfo = info;
    cell.addBgView.hidden = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BusinessPhotoWallList *photoWall = self.userInfo.photoWalls[indexPath.row];
    if(photoWall.photo.length > 0){
        YBImageBrowerTool *tool = [[YBImageBrowerTool alloc]init];
        [tool showBusinessPhotoWallImagesWith:self.userInfo.photoWalls urlArray:@[] currentIndex:indexPath.item canDelete:NO];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 25) / 3.0,(ScreenWidth - 25) / 3.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
@end
