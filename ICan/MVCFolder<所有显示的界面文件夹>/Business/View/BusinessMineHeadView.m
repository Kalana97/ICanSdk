//
//  BusinessMineHeadView.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-20.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CircleUserDetailImgeCollectionViewCell.h"
#import "CircleLikeOrDislikeListViewController.h"
#import "CircleFllowOrBeFllowPageViewController.h"
#import "BusinessListImageCollectionViewCell.h"
#import "YBImageBrowerTool.h"
#import "BusinessMineHeadView.h"
@interface BusinessMineHeadView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *checkBgImgBgView;
@property (weak, nonatomic) IBOutlet UILabel *checkBgImgLabel;
@property (weak, nonatomic) IBOutlet UIButton *camerBgImgViewButton;
@property (weak, nonatomic) IBOutlet UIButton *camerIconButton;
@property (weak, nonatomic) IBOutlet UIView *checkIconBgView;
@property (weak, nonatomic) IBOutlet UIStackView *verifiedBadge;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkIconLabel;
@property (weak, nonatomic) IBOutlet UIControl *editBgView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeMeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeMeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPhotoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *allphotoLabel;
@property(nonatomic, assign) BOOL isShowAllPhoto;
@property (weak, nonatomic) IBOutlet UIView *signatureBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@end

@implementation BusinessMineHeadView
- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *imgStr = [NSString stringWithFormat:@"bg%d",arc4random()%4+1];
    self.bgImageView.image = UIImageMake(imgStr);
    [self.collectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    [self.editBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    self.editLabel.text = @"CircleMineShowUserImgTableViewCell.editLabel".icanlocalized;
    self.iLikeTipLabel.text = @"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized;
    self.likeMeTipLabel.text = @"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized;
    self.favoriteTipLabel.text = @"CircleMineShowUserImgTableViewCell.favoriteTipLabel".icanlocalized;
    self.myPhotoLabel.text = @"CircleUserDetailViewController.photoWallLabel".icanlocalized;
    [self.iconImageView layerWithCornerRadius:75/2 borderWidth:0 borderColor:nil];
    self.checkBgImgLabel.text = @"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    self.checkIconLabel.text =  @"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    self.allphotoLabel.text = @"CircleMineHeadView.editLabel".icanlocalized;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.editBgView addTarget:self action:@selector(editDataAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)reloadCollectionView{
    [self.collectionView reloadData];
    [self.collectionView layoutSubviews];
    [self.collectionView layoutIfNeeded];
    self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

-(void)setUserInfo:(BusinessCurrentUserInfo *)userInfo{
    _userInfo = userInfo;
    self.titleLabel.text = self.userInfo.businessName;
    self.verifiedBadge.hidden = YES;
    if (self.userInfo.checkBusinessDescription.length > 0) {
        self.descLabel.text = self.userInfo.checkBusinessDescription;
    }else{
        if(self.userInfo.businessDescription.length > 0) {
            self.descLabel.text = self.userInfo.businessDescription;
        }
    }
    if (self.userInfo.area){
        self.areaView.hidden = NO;
        self.areaLabel.text = self.userInfo.areaEn;
    }else{
        self.areaView.hidden = YES;
    }
    if (self.userInfo.showDistance) {
        self.distanceView.hidden = NO;
        self.distanceLabel.text = self.userInfo.showDistance;
    }else{
        self.distanceView.hidden = YES;
    }
    if (userInfo.checkAvatar.length > 0) {
        [self.iconImageView setDZIconImageViewWithUrl:userInfo.checkAvatar gender:@""];
        self.checkIconBgView.hidden = NO;
    }else{
        [self.iconImageView setDZIconImageViewWithUrl:userInfo.avatar gender:@""];
        self.checkIconBgView.hidden = YES;
    }
    if (userInfo.checkBackground.length > 0) {
        [self.bgImageView setImageWithString:userInfo.checkBackground placeholder:DefaultImg];
        self.checkBgImgBgView.hidden = NO;
    }else{
        if(userInfo.background.length > 0){
            [self.bgImageView setImageWithString:userInfo.background placeholder:DefaultImg];
        }else{
            NSString *imgStr = [NSString stringWithFormat:@"bg%d",arc4random()%4+1];
            self.bgImageView.image=UIImageMake(imgStr);
        }
        self.checkBgImgBgView.hidden = YES;
    }
    self.iLikeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.followingCount];
    self.likeMeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.followerCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.likeCount];
    [self reloadCollectionView];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userInfo.photoWalls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBusinessListImageCollectionViewCell forIndexPath:indexPath];
    if(self.userInfo.photoWalls.count > 0) {
        cell.isMine = YES;
        cell.wallInfo = self.userInfo.photoWalls[indexPath.row];
        cell.userImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.addBgView.hidden = YES;
    }else{
        cell.addBgView.hidden = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userInfo.photoWalls.count > 0){
        YBImageBrowerTool *tool = [[YBImageBrowerTool alloc]init];
        [tool showBusinessPhotoWallImagesWith:self.userInfo.photoWalls urlArray:@[] currentIndex:indexPath.row canDelete:NO];
    }else{
        if (self.addImageBlock) {
            self.addImageBlock();
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-25)/3.0,(ScreenWidth-25)/3.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (IBAction)editBgAction:(id)sender {
    if (self.editBgImgBlock) {
        self.editBgImgBlock();
    }
}

- (IBAction)editIconAction:(id)sender {
    if (self.editIconBlock) {
        self.editIconBlock();
    }
}

-(void)editDataAction{
    if (self.clickEditBlock) {
        self.clickEditBlock();
    }
}

- (IBAction)showAllPhoto:(id)sender {
    if (self.showAllBlock) {
        self.showAllBlock();
    }
}
@end
