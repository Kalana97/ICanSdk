
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2021
- File name:  CircleMineHeadView.m
- Description:
- Function List:
*/
        

#import "CircleMineHeadView.h"
#import "CircleUserDetailImgeCollectionViewCell.h"

#import "CircleLikeOrDislikeListViewController.h"

#import "CircleFllowOrBeFllowPageViewController.h"
#import "YBImageBrowerTool.h"
@interface CircleMineHeadView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *checkBgImgBgView;
@property (weak, nonatomic) IBOutlet UILabel *checkBgImgLabel;
@property (weak, nonatomic) IBOutlet UIButton *camerBgImgViewButton;


@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIButton *camerIconButton;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *checkIconBgView;
@property (weak, nonatomic) IBOutlet UILabel *checkIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
//资料编辑
@property (weak, nonatomic) IBOutlet UIControl *editBgView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
//我喜欢的
@property (weak, nonatomic) IBOutlet UILabel *iLikeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeTipLabel;
//喜欢我的
@property (weak, nonatomic) IBOutlet UILabel *likeMeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeMeTipLabel;

//我的点赞
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTipLabel;
//全部照片
@property (weak, nonatomic) IBOutlet UILabel *myPhotoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//点击购买发布
@property (weak, nonatomic) IBOutlet UIControl *pushBgContol;
@property (weak, nonatomic) IBOutlet UILabel *  pushTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *viewAllPhotoBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
//编辑
@property (weak, nonatomic) IBOutlet UILabel *allphotoLabel;

/** 当前是否是显示所有图片 */
@property(nonatomic, assign) BOOL isShowAllPhoto;
@property (weak, nonatomic) IBOutlet UIView *signatureBgView;


@end

@implementation CircleMineHeadView
//点击显示照片
- (IBAction)buyAction:(id)sender {
    
    self.isShowAllPhoto=!self.isShowAllPhoto;
    self.pushTipsLabel.text=self.isShowAllPhoto?@"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel.hidden".icanlocalized:@"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel".icanlocalized;
    QMUITableView*tableView=(QMUITableView*)self.superview;
    [tableView reloadData];
    
    
}
-(void)reloadCollectionView{
    [self.collectionView reloadData];
    [self.collectionView layoutSubviews];
    [self.collectionView layoutIfNeeded];
    self.collectionViewHeight.constant=self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}
- (IBAction)showAllPhoto:(id)sender {
    if (self.showAllBlock) {
        self.showAllBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    [self.editBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    self.editLabel.text=@"CircleMineShowUserImgTableViewCell.editLabel".icanlocalized;
    self.iLikeTipLabel.text=@"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized;
    self.likeMeTipLabel.text=@"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized;
    self.favoriteTipLabel.text=@"CircleMineShowUserImgTableViewCell.favoriteTipLabel".icanlocalized;
    self.myPhotoLabel.text=@"CircleUserDetailViewController.photoWallLabel".icanlocalized;
    self.checkIconLabel.text=@"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    [self.checkIconBgView layerWithCornerRadius:127/2 borderWidth:0 borderColor:nil];
    [self.iconBgView layerWithCornerRadius:137/2 borderWidth:0 borderColor:nil];
    [self.iconImageView layerWithCornerRadius:127/2 borderWidth:0 borderColor:nil];
    self.checkBgImgLabel.text=@"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    self.allphotoLabel.text=@"CircleMineHeadView.editLabel".icanlocalized;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.editBgView addTarget:self action:@selector(editDataAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)editDataAction{
    if (self.clickEditBlock) {
        self.clickEditBlock();
    }
}
-(void)setLikeMeOrMeLikeCountInfo:(LikeMeOrMeLikeCountInfo *)likeMeOrMeLikeCountInfo{
    _likeMeOrMeLikeCountInfo=likeMeOrMeLikeCountInfo;
    self.likeMeCountLabel.text=[NSString stringWithFormat:@"%ld",(long)likeMeOrMeLikeCountInfo.likeMe];
    self.iLikeCountLabel.text=[NSString stringWithFormat:@"%ld",(long)likeMeOrMeLikeCountInfo.meLike];
}
-(void)setUserGoodInfo:(UserGoodInfo *)userGoodInfo{
    self.favoriteCountLabel.text=[NSString stringWithFormat:@"%zd",userGoodInfo.goodCount];
}
-(void)setUserInfo:(CircleUserInfo *)userInfo{
    _userInfo=userInfo;
    self.pushBgContol.hidden=NO;
    self.nicknameLabel.text=userInfo.nickname;
    if (self.userInfo.checkSignature.length>0) {
        NSString*chekTips=@"Pending".icanlocalized;
        NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",chekTips,self.userInfo.checkSignature]];
        [string addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, string.length)];
        [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(0, chekTips.length)];
        self.signatureLabel.attributedText=string;
        self.signatureBgView.hidden=NO;
    }else{
        if (self.userInfo.signature.length>0) {
            self.signatureLabel.text=self.userInfo.signature;
            self.signatureBgView.hidden=NO;
        }else{
            self.signatureBgView.hidden=YES;
        }
    }
    if (userInfo.checkAvatar.length>0) {
        [self.iconImageView setCircleIconImageViewWithUrl:userInfo.checkAvatar gender:userInfo.gender];
        self.checkIconBgView.hidden=NO;
    }else{
        [self.iconImageView setCircleIconImageViewWithUrl:userInfo.avatar gender:userInfo.gender];
        self.checkIconBgView.hidden=YES;
    }
    if (userInfo.checkBackground.length>0) {
        [self.bgImageView setImageWithString:userInfo.checkBackground placeholder:DefaultImg];
        self.checkBgImgBgView.hidden=NO;
    }else{
        if (userInfo.background.length>0) {
            [self.bgImageView setImageWithString:userInfo.background placeholder:DefaultImg];
        }else{
            NSString*imgStr=[NSString stringWithFormat:@"bg%d",arc4random()%4+1];
            self.bgImageView.image=UIImageMake(imgStr);
        }
        self.checkBgImgBgView.hidden=YES;
    }
    if (self.userInfo.photoWalls.count>6) {
        self.viewAllPhotoBgView.hidden=NO;
    }else{
        self.viewAllPhotoBgView.hidden=YES;
    }
    [self reloadCollectionView];
}


- (IBAction)myLikeAction {
    CircleFllowOrBeFllowPageViewController*vc=[[CircleFllowOrBeFllowPageViewController alloc]initWithCircleListType:CircleListType_ILike];
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
- (IBAction)likeMeAction {
    CircleFllowOrBeFllowPageViewController*vc=[[CircleFllowOrBeFllowPageViewController alloc]initWithCircleListType:CircleListType_LikeMe];
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
//编辑头像
- (IBAction)editIconAction:(id)sender {
    if (self.editIconBlock) {
        self.editIconBlock();
    }
}
//编辑背景图片
- (IBAction)editBgAction:(id)sender {
    if (self.editBgImgBlock) {
        self.editBgImgBlock();
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.userInfo.photoWalls.count == 0) {
        return 1;
    }
    if (self.isShowAllPhoto) {
        return self.userInfo.photoWalls.count;
    }
    if (self.userInfo.photoWalls.count>6) {
        return 6;
    }
    return self.userInfo.photoWalls.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserDetailImgeCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleUserDetailImgeCollectionViewCell forIndexPath:indexPath];
    if (self.userInfo.photoWalls.count>0) {
        cell.wallInfo = self.userInfo.photoWalls[indexPath.row];
        cell.userImageView.contentMode=UIViewContentModeScaleAspectFill;
        cell.addBgView.hidden = YES;
    }else{
        cell.addBgView.hidden = NO;
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userInfo.photoWalls.count>0){
        YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
        [tool showCirclePhotoWallImagesWith:self.userInfo.photoWalls urlArray:@[] currentIndex:indexPath.row canDelete:NO];
    }else{
        if (self.addImageBlock) {
            self.addImageBlock();
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-25)/3.0,(ScreenWidth-25)/3.0);
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 2;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

@end
