//
//  BusinessTableViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessTableViewCell.h"
#import "BusinessListImageCollectionViewCell.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "BusinessUserRequest.h"
#import "BusinessNetworkReqManager.h"

@interface BusinessTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *businessTitle;
@property (weak, nonatomic) IBOutlet UILabel *decsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLbl;
@property (weak, nonatomic) IBOutlet UIImageView *followIcon;
@property (weak, nonatomic) IBOutlet UILabel *townLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet DZIconImageView *businessImg;
@property (weak, nonatomic) IBOutlet UIStackView *verfiedArea;
@property (weak, nonatomic) IBOutlet UIView *areaLbelView;
@property (weak, nonatomic) IBOutlet UIView *distanceLblView;
@property (weak, nonatomic) IBOutlet UIStackView *followContainer;
@property (nonatomic, assign) BOOL isFollowed;
@end

@implementation BusinessTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.businessImg layerWithCornerRadius:50/2 borderWidth:0 borderColor:nil];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    [self.imageCollectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    UITapGestureRecognizer *followAction =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(followAction)];
    [self.followContainer addGestureRecognizer:followAction];
}

-(void)setUserInfo:(BusinessUserInfo *)userInfo{
    _userInfo = userInfo;
    [self.businessImg setDZIconImageViewWithUrl:userInfo.businessLogo gender:@""];
    self.businessTitle.text = userInfo.businessName;
    self.verfiedArea.hidden = YES;
    self.decsLabel.hidden = NO;
    self.decsLabel.text = userInfo.businessDescription;
    self.isFollowed = userInfo.isFollowedByMe;
    if(userInfo.area) {
        self.areaLbelView.hidden = NO;
        self.townLbl.text = userInfo.areaEn;
    }else{
        self.areaLbelView.hidden = YES;
    }
    if(userInfo.showDistance) {
        self.distanceLblView.hidden = NO;
        self.distanceLbl.text = userInfo.showDistance;
    }else{
        self.distanceLblView.hidden = YES;
    }
    if(userInfo.businessPhotoWallList.count > 0){
        self.imageCollectionView.hidden = NO;
    }else{
        self.imageCollectionView.hidden = YES;
    }
    if(self.isFollowed){
        self.followIcon.hidden = YES;
        self.followLbl.text = @"Following".icanlocalized;
        self.followLbl.textColor = [UIColor qmui_colorWithHexString:@"#979797"];
    }else{
        self.followIcon.hidden = NO;
        self.followLbl.text = @"Follow".icanlocalized;
        self.followLbl.textColor = [UIColor qmui_colorWithHexString:@"#0065D7"];
    }
    [self.imageCollectionView reloadData];
}

-(UICollectionView *)imageCollectionView{
    if (_imageCollectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _imageCollectionView.dataSource = self;
        _imageCollectionView.delegate = self;
        _imageCollectionView.showsVerticalScrollIndicator = NO;
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        _imageCollectionView.scrollEnabled = YES;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        [_imageCollectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    }
    return _imageCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userInfo.businessPhotoWallList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBusinessListImageCollectionViewCell forIndexPath:indexPath];
    BusinessPhotoWallList *photowalllist = self.userInfo.businessPhotoWallList[indexPath.row];
    cell.wallInfo = photowalllist;
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //handleclickevent
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-50)/3.0,(ScreenWidth-50)/3.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)followAction{
    FollowOrUnfollowBusiness *request = [FollowOrUnfollowBusiness request];
    if(!self.isFollowed){
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/businessFollower/followOrUnfollow?businessId=%ld&isFollow=%d",(long)self.userInfo.businessId,true];
    }else{
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/businessFollower/followOrUnfollow?businessId=%ld&isFollow=%d",self.userInfo.businessId,false];
    }
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
        if(!self.isFollowed){
            self.followIcon.hidden = YES;
            self.followLbl.text = @"Following".icanlocalized;
            self.followLbl.textColor = [UIColor qmui_colorWithHexString:@"#979797"];
        }else{
            self.followIcon.hidden = NO;
            self.followLbl.text = @"Follow".icanlocalized;
            self.followLbl.textColor = [UIColor qmui_colorWithHexString:@"#0065D7"];
        }
        self.isFollowed = !self.isFollowed;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSLog(@"");
    }];
}
@end
