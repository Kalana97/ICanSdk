//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleUserDetailViewController.m
 - Description:
 - Function List:
 */


#import "CircleUserDetailViewController.h"
#import "CircleMoreViewController.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "YBImageBrowerTool.h"
#import "BuyPackageViewController.h"
#import "SureChatTipsView.h"
#import "WCDBManager+CircleUserInfo.h"
#import "BuyPackageView.h"
@interface CircleUserDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UIButton *loveButton;
@property(nonatomic, strong) UIView *navBarView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property(nonatomic, weak) IBOutlet UIImageView *bgImageView;


@property (weak, nonatomic) IBOutlet UIView *iconBgView;

@property (weak, nonatomic) IBOutlet DZIconImageView *circleIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

//我喜欢的
@property (weak, nonatomic) IBOutlet UILabel *iLikeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *iLikeTipLabel;
//喜欢我的
@property (weak, nonatomic) IBOutlet UILabel *likeMeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeMeTipLabel;

//我的点赞
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTipLabel;
//照片墙
@property (weak, nonatomic) IBOutlet UILabel *photoWallLabel;
@property (weak, nonatomic) IBOutlet UIView *photowallBgView;
@property (weak, nonatomic) IBOutlet UIStackView *photoBgView;




@property (weak, nonatomic) IBOutlet UIStackView *birthdayBgView;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLab;

@property (weak, nonatomic) IBOutlet UIView *heightLineView;
@property (weak, nonatomic) IBOutlet UIStackView *heightBgView;
@property (weak, nonatomic) IBOutlet UILabel *heightLab;

@property (weak, nonatomic) IBOutlet UIView *weightLineView;
@property (weak, nonatomic) IBOutlet UIStackView *weightBgView;
@property (weak, nonatomic) IBOutlet UILabel *weightLab;
//星座
@property (weak, nonatomic) IBOutlet UIStackView *xingzuoBgView;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLab;

@property (weak, nonatomic) IBOutlet UIView *likeLineView;
@property (weak, nonatomic) IBOutlet UIStackView *likeBgView;
@property (weak, nonatomic) IBOutlet UILabel *likeLab;
//学历
@property (weak, nonatomic) IBOutlet UIView *educationLineView;
@property (weak, nonatomic) IBOutlet UIStackView *educationBgView;
@property (weak, nonatomic) IBOutlet UILabel *educationLab;
//职业
@property (weak, nonatomic) IBOutlet UIView *zhiyeLineView;
@property (weak, nonatomic) IBOutlet UIStackView *zhiyeBgView;
@property (weak, nonatomic) IBOutlet UILabel *zhiyeLab;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *fllowBtn;



@property(nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@property(nonatomic, strong) UserGoodInfo *userGoodInfo;
@property(nonatomic, strong) SureChatTipsView *sureChatTipsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property(nonatomic, weak) IBOutlet UICollectionView *bigCollectionView;
@property (weak, nonatomic) IBOutlet UIControl *viewAllPhotoBgCon;
@property (weak, nonatomic) IBOutlet UILabel *viewAllPhotoLabel;
@property (weak, nonatomic) IBOutlet UIView *viewAllPhotoBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewTop;
/** 当前是否是显示所有图片 */
@property(nonatomic, assign) BOOL isShowAllPhoto;
@property(nonatomic, strong) BuyPackageView *buyPackView;
@end

@implementation CircleUserDetailViewController
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;;
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (IBAction)viewAllPhotoAction:(id)sender {
    self.isShowAllPhoto=!self.isShowAllPhoto;
//    "CircleMineShowUserImgTableViewCell.viewAllPhotoLabel.hidden"="收起照片";
    self.viewAllPhotoLabel.text=self.isShowAllPhoto?@"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel.hidden".icanlocalized:@"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel".icanlocalized;
    [self reloadCollectionView];
}
-(void)reloadCollectionView{
    [self.bigCollectionView reloadData];
    [self.bigCollectionView layoutSubviews];
    [self.bigCollectionView layoutIfNeeded];
    self.collectionViewHeight.constant=self.bigCollectionView.collectionViewLayout.collectionViewContentSize.height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PayManager*manager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        
    }];
   
    self.buyPackView.packagePayManager=manager;
    [self.buyPackView.iconImgView setCircleIconImageViewWithUrl:self.userInfo.avatar gender:self.userInfo.gender];
    [self getPackInfoRequest];
    self.scrollviewTop.constant=-StatusBarHeight;
    [self.bigCollectionView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    
    [self.bigCollectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    
    self.currentSelectIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    self.bigCollectionView.delegate=self;
    self.bigCollectionView.dataSource=self;
    
    [self.iconBgView layerWithCornerRadius:137/2 borderWidth:0 borderColor:nil];
    [self.circleIconImgView layerWithCornerRadius:127/2 borderWidth:0 borderColor:nil];
    
    [self.fllowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.fllowBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Follow".icanlocalized forState:UIControlStateNormal];
    [self.fllowBtn setTitleColor:UIColor153Color forState:UIControlStateSelected];
    [self.fllowBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Followed".icanlocalized forState:UIControlStateSelected];
    [self.chatBtn setTitle:@"CircleUserDetailViewController.chatbtn".icanlocalized forState:UIControlStateNormal];
    
    [self.fllowBtn layerWithCornerRadius:22.5 borderWidth:0 borderColor:nil];
    [self.chatBtn layerWithCornerRadius:22.5 borderWidth:1 borderColor:UIColorThemeMainColor];
    self.iLikeTipLabel.text=@"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized;
    self.likeMeTipLabel.text=@"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized;
    self.favoriteTipLabel.text=@"CircleMineShowUserImgTableViewCell.favoriteTipLabel".icanlocalized;
    self.photoWallLabel.text=@"CircleUserDetailViewController.photoWallLabel".icanlocalized;
//    "CircleMineShowUserImgTableViewCell.viewAllPhotoLabel"="查看全部照片";
//    "CircleMineHeadView.editLabel"="编辑";
    self.viewAllPhotoLabel.text=@"CircleMineShowUserImgTableViewCell.viewAllPhotoLabel".icanlocalized;
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
    [self.navBarView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.centerX.equalTo(self.navBarView);
    }];
    [self.navBarView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.width.equalTo(@23);
        make.height.equalTo(@23);
        make.right.equalTo(@-10);
    }];
    [self.navBarView addSubview:self.loveButton];
    [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.width.equalTo(@23);
        make.height.equalTo(@23);
        make.right.equalTo(self.rightButton.mas_left).offset(-10);
    }];
    [self.viewAllPhotoBgCon layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    GetCircleUserInfoRequest*request=[GetCircleUserInfoRequest request];
    if (self.userId) {
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/info/%@",self.userId];
    }else{
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/info/%@",self.userInfo.userId];
    }
    
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        [[WCDBManager sharedManager]insertCircleUserInfoWithArray:@[response]];
        self.userInfo=response;
        [self setUserData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    [self getOtherLikeOrUnLikeRequest];
    
}
- (IBAction)chatAction {
    if (!self.userInfo.enable) {
       
        return;
    }
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%zd",self.userInfo.icanId],kchatType:UserChat,kauthorityType:AuthorityType_circle,kcircleUserId:self.userInfo.userId}];
     [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkPaySuccessStatus:(NSString*)transactionId{
    CheckMyPackagesPaySuccessRequest*cRequest=[CheckMyPackagesPaySuccessRequest request];
    cRequest.pathUrlString=[cRequest.baseUrlString stringByAppendingFormat:@"/api/myPackages/pay/%@",transactionId];
    [[CircleNetRequestManager shareManager]startRequest:cRequest responseClass:[PayMyPackagesInfo class] contentClass:[PayMyPackagesInfo class] success:^(PayMyPackagesInfo* response) {
        if ([response.payStatus isEqualToString:@"Success"]) {
            [self usePackgeRequest];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkPaySuccessStatus:transactionId];
            });
            
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
//        、、"CircleUserDetailViewController.payFailTip"="支付失败";
        [QMUITipsTool showErrorWihtMessage:@"CircleUserDetailViewController.payFailTip".icanlocalized inView:self.view];
    }];
}
-(void)usePackgeRequest{
    UsePackageRequest*request=[UsePackageRequest request];
    request.type=2;
    request.targetUserId=self.userInfo.userId;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CheckMyPackagesInfo class] contentClass:[CheckMyPackagesInfo class] success:^(CheckMyPackagesInfo*  response) {
        [QMUITips hideAllTips];
        if (response.available) {
            UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%zd",self.userInfo.icanId],kchatType:UserChat,kauthorityType:AuthorityType_circle,kcircleUserId:self.userInfo.userId}];
             [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
- (IBAction)fllowAction:(id)sender {
    if (!self.userInfo.enable) {
        
        return;
    }
    if (self.userInfo.isMeLike) {
        PUTLikeUsersRequest*request=[PUTLikeUsersRequest request];
        request.likeUserId=self.userInfo.userId;
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
            self.userInfo.isMeLike=NO;
            if (self.fllowBlock) {
                self.fllowBlock();
            }
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
            if (self.fllowBlock) {
                self.fllowBlock();
            }
            [self checkIsLike];
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }];
    }
}
-(void)checkIsLike{
    self.fllowBtn.selected=self.userInfo.isMeLike;
    if (self.userInfo.isMeLike) {
        [self.fllowBtn setBackgroundColor:UIColorBg243Color];
    }else{
        [self.fllowBtn setBackgroundColor:UIColorThemeMainColor];
        
    }
    [self getOtherLikeOrUnLikeRequest];
}


-(void)setUserData{
    [self.circleIconImgView setCircleIconImageViewWithUrl:_userInfo.avatar gender:_userInfo.gender];
    self.nicknameLabel.text=_userInfo.nickname;
    /**
     "CircleUserDetailViewController.Age"="年龄";
     "CircleUserDetailViewController.Height"="身高";
     "CircleUserDetailViewController.Weight"="体重";
     "CircleUserDetailViewController.Constellation"="星座";
     "CircleUserDetailViewController.Education"="学历";
     "CircleUserDetailViewController.Occupation"="职业";
     "CircleUserDetailViewController.Hobbies"="爱好";
     */
    self.birthdayLab.text=_userInfo.dateOfBirth;
    NSMutableAttributedString*ageStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %zd",@"CircleUserDetailViewController.Age".icanlocalized,_userInfo.age]];
    [ageStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, ageStr.length)];
    [ageStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Age".icanlocalized.length)];
    self.birthdayLab.attributedText=ageStr;
    if (!self.userInfo.bodyHeight) {
        self.heightBgView.hidden=self.heightLineView.hidden=YES;
    }
    NSMutableAttributedString*heightStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@cm",@"CircleUserDetailViewController.Height".icanlocalized,_userInfo.bodyHeight]];
    [heightStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, heightStr.length)];
    [heightStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Height".icanlocalized.length)];
    self.heightLab.attributedText=heightStr;
    if (!self.userInfo.bodyWeight) {
        self.weightBgView.hidden=self.weightLineView.hidden=YES;
    }
    NSMutableAttributedString*weightStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@kg",@"CircleUserDetailViewController.Weight".icanlocalized,_userInfo.bodyWeight]];
    [weightStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, weightStr.length)];
    [weightStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Weight".icanlocalized.length)];
    self.weightLab.attributedText=weightStr;
    
    
    NSMutableAttributedString*constellationStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",@"CircleUserDetailViewController.Constellation".icanlocalized,[CircleUserInfo getXingZuoName:_userInfo.constellation]]];
    [constellationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, constellationStr.length)];
    [constellationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Constellation".icanlocalized.length)];
    self.xingzuoLab.attributedText=constellationStr;
    if (!self.userInfo.education) {
        self.educationBgView.hidden=self.educationLineView.hidden=YES;
    }
    NSMutableAttributedString*educationStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",@"CircleUserDetailViewController.Education".icanlocalized,[CircleUserInfo getShowEducationStringByString:_userInfo.education]]];
    [educationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, educationStr.length)];
    [educationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Education".icanlocalized.length)];
    self.educationLab.attributedText=educationStr;
    self.titleLabel.text=self.userInfo.nickname;
    for (ProfessionInfo*info in CircleUserInfoManager.shared.professionArray) {
        if (info.professionId==_userInfo.professionId) {
            NSMutableAttributedString*occupationStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",@"CircleUserDetailViewController.Occupation".icanlocalized,info.showProfessionName]];
            [occupationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, occupationStr.length)];
            [occupationStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Occupation".icanlocalized.length)];
            self.zhiyeLab.attributedText=occupationStr;
            break;
        }
    }
    if (self.userInfo.userHobbyTags.count>0) {
        NSArray*array=[self.userInfo.userHobbyTags valueForKeyPath:@"showName"];
        NSString*string=[array componentsJoinedByString:@"、"];
        NSMutableAttributedString*hobbiesStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",@"CircleUserDetailViewController.Hobbies".icanlocalized,string]];
        [hobbiesStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(153, 153, 153) range:NSMakeRange(0, hobbiesStr.length)];
        [hobbiesStr addAttribute:NSForegroundColorAttributeName value:UIColorMake(25, 27, 30) range:NSMakeRange(0, @"CircleUserDetailViewController.Hobbies".icanlocalized.length)];
        self.likeLab.attributedText=hobbiesStr;
        
    }else{
        self.likeBgView.hidden=self.likeLineView.hidden=YES;
    }
    self.signatureLabel.hidden=!(self.userInfo.signature.length>0);
    self.signatureLabel.text=self.userInfo.signature;
    [self checkIsLike];
    [self getGoodCountRequest];
    if (self.userInfo.background.length>0) {
        [self.bgImageView setImageWithString:self.userInfo.background placeholder:nil];
    }else{
        NSString*imgStr=[NSString stringWithFormat:@"bg%d",arc4random()%4+1];
        self.bgImageView.image=UIImageMake(imgStr);
    }
    if (self.userInfo.photoWalls.count>0) {
        if (self.userInfo.photoWalls.count>6) {
            self.viewAllPhotoBgView.hidden=NO;
        }else{
            self.viewAllPhotoBgView.hidden=YES;
        }
    }else{
        self.photoBgView.hidden=YES;
        self.photowallBgView.hidden=YES;
    }
    
    [self reloadCollectionView];
    if (!self.userInfo.enable) {
        [UIAlertController alertControllerWithTitle:@"CircleOtherUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            
            
        }];
        return;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenty=scrollView.contentOffset.y;
    CGFloat marightY=NavBarHeight;
    if (contenty>marightY) {
        self.titleLabel.hidden=NO;
        self.navBarView.backgroundColor=UIColor.whiteColor;
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_circle_user_setting_black"] forState:UIControlStateNormal];
        [_loveButton setBackgroundImage:[UIImage imageNamed:@"icon_fabulous_n"] forState:UIControlStateNormal];
        
    }else{
        self.titleLabel.hidden=YES;
        [self.leftArrowButton setBackgroundImage:UIImageMake(@"icon_circle_back_white") forState:UIControlStateNormal];
        self.navBarView.backgroundColor=UIColorMakeWithRGBA(255, 255, 255, contenty/marightY);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_circle_user_setting_white"] forState:UIControlStateNormal];
        [_loveButton setBackgroundImage:[UIImage imageNamed:@"icon_fabulous_w"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //如果点击了显示全部图片
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
    PhotoWallInfo * info = self.userInfo.photoWalls[indexPath.row];
    cell.wallInfo = info;
    cell.addBgView.hidden=YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
    [tool showCirclePhotoWallImagesWith:self.userInfo.photoWalls urlArray:@[] currentIndex:indexPath.item canDelete:NO];
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
-(SureChatTipsView *)sureChatTipsView{
    if (!_sureChatTipsView) {
        _sureChatTipsView=[[NSBundle mainBundle]loadNibNamed:@"SureChatTipsView" owner:self options:nil].firstObject;
        _sureChatTipsView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _sureChatTipsView;
}
-(void)getGoodCountRequest{
    GetUserGoodRequest*request=[GetUserGoodRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/users/good/%@",self.userInfo.userId]];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[UserGoodInfo class] contentClass:[UserGoodInfo class] success:^(UserGoodInfo* response) {
        self.userGoodInfo=response;
        [self setLoveBtnStatus];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getOtherLikeOrUnLikeRequest{
    GetOtherlikeMeOrMeLikeCountRequest*request=[GetOtherlikeMeOrMeLikeCountRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/likeMeOrMeLikeCount/%@",self.userInfo.userId];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[LikeMeOrMeLikeCountInfo class] contentClass:[LikeMeOrMeLikeCountInfo class] success:^(LikeMeOrMeLikeCountInfo* response) {
        self.likeMeCountLabel.text=[NSString stringWithFormat:@"%zd",response.likeMe];
        self.iLikeCountLabel.text=[NSString stringWithFormat:@"%zd",response.meLike];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    
}
-(void)postUserGoodRequest{
    PostUserGoodRequest*request=[PostUserGoodRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/users/good/%@",self.userInfo.userId]];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[UserGoodInfo class] contentClass:[UserGoodInfo class] success:^(UserGoodInfo* response) {
        self.userGoodInfo.isGood=!self.userGoodInfo.isGood;
        if (self.userGoodInfo.isGood) {
            self.userGoodInfo.goodCount++;
        }else{
            self.userGoodInfo.goodCount--;
        }
        [self setLoveBtnStatus];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)setLoveBtnStatus{
    self.loveButton.selected=self.userGoodInfo.isGood;
    self.favoriteCountLabel.text=[NSString stringWithFormat:@"%zd",self.userGoodInfo.goodCount];
}
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc]init];
        _navBarView.backgroundColor=UIColorMakeWithRGBA(255, 255, 255, 0.1);
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//        effectview.frame = CGRectMake(0, 0, ScreenWidth, NavBarHeight);
//        [_navBarView addSubview:effectview];
     
    }
    return _navBarView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel centerLabelWithTitle:@"CircleHomeListViewController.title".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
        _titleLabel.hidden=YES;
    }
    return _titleLabel;
}
-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_circle_back_white") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightBarButtonItemAction)];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_circle_user_setting_white"] forState:UIControlStateNormal];
        
    }
    return _rightButton;
}
-(void)rightBarButtonItemAction{
    CircleMoreViewController*vc=[CircleMoreViewController new];
    vc.userInfo=self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIButton *)loveButton{
    if (!_loveButton) {
        _loveButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(postUserGoodRequest)];
        [_loveButton setBackgroundImage:[UIImage imageNamed:@"icon_fabulous_n"] forState:UIControlStateNormal];
        [_loveButton setBackgroundImage:[UIImage imageNamed:@"icon_fabulous_y"] forState:UIControlStateSelected];
        
    }
    return _loveButton;
}
-(BuyPackageView *)buyPackView{
    if (!_buyPackView) {
        _buyPackView=[[NSBundle mainBundle]loadNibNamed:@"BuyPackageView" owner:self options:nil].firstObject;
        _buyPackView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _buyPackView.buySuccessBlock = ^(NSString * _Nonnull transactionId) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self checkPaySuccessStatus:transactionId];
            });
        };
    }
    return _buyPackView;
}
-(void)getPackInfoRequest{
    GetPackagesRequest*request=[GetPackagesRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[PackagesInfo class] success:^(NSArray<PackagesInfo*>* response) {
        response.firstObject.select=YES;
        self.buyPackView.packagesItems=response;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
