//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleHomeListViewController.m
 - Description:
 - Function List:
 */


#import "CircleHomeListViewController.h"
#import "CircleCommonListTableViewCell.h"
#import "CircleUserDetailViewController.h"
#import "CircleEditMydDataViewController.h"
#import "CircleHomeListViewNavView.h"

#import "HJCActionSheet.h"
#import "CircleHomeConditionCollectionViewCell.h"
#import "ConditionModel.h"
#import "ShowSelectAddressView.h"

@interface CircleHomeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HJCActionSheetDelegate>
@property(nonatomic, strong) CircleHomeListViewNavView *navBarView;
@property(nonatomic, strong) UIView *topHeadView;
@property(nonatomic, strong) HJCActionSheet *hjcActionSheet;
@property(nonatomic, strong) NSArray *educationItems;
@property(nonatomic, strong) NSArray *genderItems;
@property(nonatomic, strong) NSArray *ageItems;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *titleItems;

@property(nonatomic, strong) ConditionModel *areaModel;
@property(nonatomic, strong) ConditionModel *genderModel;
@property(nonatomic, strong) ConditionModel *ageModel;
@property(nonatomic, strong) ConditionModel *mengxinModel;
@property(nonatomic, strong) ConditionModel *clearModel;

@property(nonatomic, strong) ShowSelectAddressView *selectAddressView;
@property(nonatomic, strong) NSMutableArray<AreaInfo*> *selectAreaItems;
@property(nonatomic, strong) GetCircleRecommendListRequest *request;
@end

@implementation CircleHomeListViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    [self getUserRequest];
    self.request=[GetCircleRecommendListRequest request];
    self.listRequest=self.request;
    self.listClass=[CircleRecommendListInfo class];
    [self resetFetchList];
    
}
-(void)initSubviews{
    [super initSubviews];
    [self.view addSubview:self.topHeadView];
    [self.topHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavBarHeight));
        make.left.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    [self.topHeadView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topHeadView.mas_centerY);
    }];
    self.areaModel=[ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.area".icanlocalized isSelect:NO hiddenImg:NO];
    
    
    self.genderModel=[ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.gener".icanlocalized isSelect:NO hiddenImg:NO];
    self.ageModel=[ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.age".icanlocalized isSelect:NO hiddenImg:NO];
    self.mengxinModel=[ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.mengxin".icanlocalized isSelect:NO hiddenImg:YES];
    self.clearModel=[ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.clear".icanlocalized isSelect:NO hiddenImg:YES];
    [self.titleItems addObject:self.areaModel];
    [self.titleItems addObject:self.genderModel];
    [self.titleItems addObject:self.ageModel];
    [self.titleItems addObject:self.mengxinModel];
    [self.titleItems addObject:self.clearModel];
    
    self.genderItems=@[@"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.gender.Female".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.gender.Unknown".icanlocalized];
    //    18~25
    //    "CircleHomeListViewController.sheet.above45"="45以上";
    //    "CircleHomeListViewController.sheet.age.Unlimited"="不限";
    
    self.ageItems=@[@"18~25",@"25~30",@"30~45",@"CircleHomeListViewController.sheet.above45".icanlocalized,@"CircleHomeListViewController.sheet.age.Unlimited".icanlocalized];
}
-(void)initTableView{
    
    [super initTableView];
    self.tableView.frame=CGRectMake(0, NavBarHeight+40, ScreenWidth, ScreenHeight-NavBarHeight-40);
    [self.tableView registNibWithNibName:kCircleCommonListTableViewCell];
}
-(void)layoutTableView{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleCommonListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kCircleCommonListTableViewCell];
    cell.userInfo=[self.listItems objectAtIndex:indexPath.row];
    cell.isHome=YES;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserDetailViewController*vc=[CircleUserDetailViewController new];
    CircleUserInfo*info=self.listItems[indexPath.row];
    
    if (!info.deleted) {
        vc.userInfo=info;
        vc.fllowBlock = ^{
            [tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //"CircleHomeListViewController.deletedtips"="该用户已注销";
        [QMUITipsTool showOnlyTextWithMessage:@"CircleHomeListViewController.deletedtips" inView:self.view];
    }
    
}
-(CircleHomeListViewNavView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[CircleHomeListViewNavView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    }
    return _navBarView;
}


-(UIView *)topHeadView{
    if (!_topHeadView) {
        _topHeadView=[[UIView alloc]init];
        
    }
    return _topHeadView;
}
-(NSMutableArray *)titleItems{
    if (!_titleItems) {
        _titleItems=[NSMutableArray array];
    }
    return _titleItems;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.scrollEnabled=YES;
        _collectionView.backgroundColor                 = [UIColor whiteColor];
        [_collectionView registNibWithNibName:kCircleHomeConditionCollectionViewCell];
        
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleHomeConditionCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleHomeConditionCollectionViewCell forIndexPath:indexPath];
    cell.conditionModel=self.titleItems[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.item) {
        case 0:{
            [self.selectAddressView didShowSelectAddressView];
        }
            
            break;
        case 1:{
            self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.genderItems];
            self.hjcActionSheet.tag=101;
            [self.hjcActionSheet show];
        }
            
            break;
        case 2:{
            self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.ageItems];
            self.hjcActionSheet.tag=102;
            [self.hjcActionSheet show];
        }
            
            break;
        case 3:{
            self.mengxinModel.isSelect=!self.mengxinModel.isSelect;
            [self.collectionView reloadData];
            self.current=1;
            [self resetFetchList];
            
        }
            
            break;
        case 4:{
            self.areaModel.isSelect=self.genderModel.isSelect=self.ageModel.isSelect=self.mengxinModel.isSelect=NO;
            self.areaModel.title=@"CircleHomeListViewController.topHeadView.area".icanlocalized;
            self.genderModel.title=@"CircleHomeListViewController.topHeadView.gener".icanlocalized;
            self.ageModel.title=@"CircleHomeListViewController.topHeadView.age".icanlocalized;
            [self.selectAreaItems removeAllObjects];
            [self.collectionView reloadData];
            self.current=1;
            self.request=[GetCircleRecommendListRequest request];
            self.listRequest=self.request;
            [self resetFetchList];
        }
            
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
////设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ConditionModel*model=[self.titleItems objectAtIndex:indexPath.item];
    return CGSizeMake(model.width,25);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==101) {//性别"CircleHomeListViewController.topHeadView.gener"
        NSString*title=[self.genderItems objectAtIndex:buttonIndex-1];
        self.genderModel.isSelect=YES;
        if ([title isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.gender.Unknown".icanlocalized]) {
            self.genderModel.isSelect=NO;
            self.genderModel.title=@"CircleHomeListViewController.topHeadView.gener".icanlocalized;
        }else{
            self.genderModel.title=title;
        }
        [self.collectionView reloadData];
        self.current=1;
        [self resetFetchList];
    }else if (actionSheet.tag==102){//年龄
        self.ageModel.isSelect=YES;
        NSString*age=[self.ageItems objectAtIndex:buttonIndex-1];
        if ([age isEqualToString:@"CircleHomeListViewController.sheet.age.Unlimited".icanlocalized]) {
            self.ageModel.isSelect=NO;
            self.ageModel.title=@"CircleHomeListViewController.topHeadView.age".icanlocalized;
        }else{
            self.ageModel.title=age;
        }
        [self.collectionView reloadData];
        self.current=1;
        [self resetFetchList];
    }
}
/**
 选择地区
 */
-(ShowSelectAddressView *)selectAddressView{
    if (!_selectAddressView) {
        _selectAddressView=[[ShowSelectAddressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _selectAddressView.addressViewType=AddressViewType_Home;
        @weakify(self);
        _selectAddressView.successBlock = ^(NSArray<AreaInfo *> * _Nonnull selectAreaItems) {
            @strongify(self);
            self.selectAreaItems=[NSMutableArray arrayWithArray:selectAreaItems];
            if (self.selectAreaItems.count>0) {
                self.areaModel.isSelect=YES;
                self.areaModel.title=selectAreaItems.lastObject.areaName;
                [self.collectionView reloadData];
                self.current=1;
                [self resetFetchList];
            }
        };
    }
    return _selectAddressView;
}
-(NSString*)getLocaliGenderWith:(NSString*)gender{
    if ([gender isEqualToString:@"Male"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized;
    }else if([gender isEqualToString:@"Female"]){
        return  @"CircleEditMydDataDetialInfoTableViewCell.gender.Female".icanlocalized;
    }
    return  @"CircleEditMydDataDetialInfoTableViewCell.gender.Unknown".icanlocalized;
}
-(NSString*)getPushGenderWith:(NSString*)gender{
    if ([gender isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized]) {
        return @"Male";
    }else if ([gender isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.gender.Female".icanlocalized]){
        return @"Female";
    }
    return  @"Unknown";
}
-(void)getUserRequest{
    GetCircleCurrenUserInfoRequest*request=[GetCircleCurrenUserInfoRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        CircleUserInfoManager.shared.age=response.age;
        CircleUserInfoManager.shared.icanId=[NSString stringWithFormat:@"%zd",response.icanId];
        CircleUserInfoManager.shared.userId=response.userId;
        CircleUserInfoManager.shared.gender=response.gender;
        CircleUserInfoManager.shared.dateOfBirth=response.dateOfBirth;
        CircleUserInfoManager.shared.avatar=response.avatar;
        CircleUserInfoManager.shared.checkAvatar=response.checkAvatar;
        CircleUserInfoManager.shared.nickname=response.nickname;
        CircleUserInfoManager.shared.enable=response.enable;
        CircleUserInfoManager.shared.yue=response.yue;
        if (!response.enable) {
            [UIAlertController alertControllerWithTitle:@"CircleUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
//重置搜索条件
-(void)resetFetchList{
    self.request=[GetCircleRecommendListRequest request];
    if (self.areaModel.isSelect) {
        switch (self.selectAreaItems.count) {
            case 1:{
                self.request.countryId=@(self.selectAreaItems.firstObject.areaId);
            }
                break;
            case 2:{
                self.request.countryId=@(self.selectAreaItems.firstObject.areaId);
                self. request.provinceId=@(self.selectAreaItems[1].areaId);
            }
                
                break;
            case 3:{
                self.request.countryId=@(self.selectAreaItems.firstObject.areaId);
                self.request.provinceId=@(self.selectAreaItems[1].areaId);
                self.request.cityId=@(self.selectAreaItems.lastObject.areaId);
            }
                break;
            default:
                break;
        }
    }
    if (self.genderModel.isSelect) {
        NSString*gender=[self getPushGenderWith:self.genderModel.title];
        self.request.gender=gender;
    }
    if (self.ageModel.isSelect) {
        if ([self.ageModel.title isEqualToString:@"CircleHomeListViewController.sheet.above45".icanlocalized]) {
            self.request.minAge=@(45);
        }else{
            NSArray*array=[self.ageModel.title componentsSeparatedByString:@"~"];
            NSString*min= array.firstObject;
            NSString*max=array.lastObject;
            self.request.minAge=@(min.integerValue);
            self.request.maxAge=@(max.integerValue);
        }
    }
    if (self.mengxinModel.isSelect) {
        self.request.isNewUser=@(1);
    }
    self.listRequest=self.request;
    [self refreshList];
}
@end
