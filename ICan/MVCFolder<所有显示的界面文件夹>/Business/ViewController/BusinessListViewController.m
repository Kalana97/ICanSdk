//
//  BusinessListViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessListViewController.h"
#import "CircleHomeListViewController.h"
#import "CircleCommonListTableViewCell.h"
#import "CircleUserDetailViewController.h"
#import "CircleEditMydDataViewController.h"
#import "BusinessNavBarView.h"
#import "BusinessTableViewCell.h"
#import "HJCActionSheet.h"
#import "CircleHomeConditionCollectionViewCell.h"
#import "ConditionModel.h"
#import "ShowSelectAddressView.h"
#import "BusinessUserRequest.h"
#import "BusinessUserResponse.h"
#import "BusinessNetworkReqManager.h"
#import "BussinessInfoManager.h"
#import "BusinessDetailsViewController.h"
#import "SelectBusinessTypeView.h"

@interface BusinessListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HJCActionSheetDelegate>
@property(nonatomic, strong) BusinessNavBarView *navBarView;
@property(nonatomic, strong) UIView *topHeadView;
@property(nonatomic, strong) HJCActionSheet *hjcActionSheet;
@property(nonatomic, strong) NSArray *educationItems;
@property(nonatomic, strong) NSArray *bussinessTypes;
@property(nonatomic, strong) NSArray *ageItems;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *titleItems;
@property(nonatomic, strong) ConditionModel *areaModel;
@property(nonatomic, strong) ConditionModel *bussinessTypeModel;
@property(nonatomic, strong) ConditionModel *clearModel;
@property(nonatomic, strong) ShowSelectAddressView *selectAddressView;
@property(nonatomic, strong) SelectBusinessTypeView *selectBusinessTypeView;
@property(nonatomic, strong) NSMutableArray<AreaInfo *> *selectAreaItems;
@property(nonatomic, strong) NSMutableArray<BusinessTypeInfo *> *selectTypeItems;
@property(nonatomic, strong) GetBusinessRecommendListRequest *request;
@end

@implementation BusinessListViewController
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
    [self getItemListWithId];
    self.request = [GetBusinessRecommendListRequest request];
    self.listRequest = self.listRequest;
    self.listClass = [BusinessRecommendListInfo class];
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
    self.areaModel = [ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.area".icanlocalized isSelect:NO hiddenImg:NO];
    self.bussinessTypeModel = [ConditionModel initConditionModelWithTitle:@"Business Type".icanlocalized isSelect:NO hiddenImg:NO];
    self.clearModel = [ConditionModel initConditionModelWithTitle:@"CircleHomeListViewController.topHeadView.clear".icanlocalized isSelect:NO hiddenImg:YES];
    [self.titleItems addObject:self.areaModel];
    [self.titleItems addObject:self.bussinessTypeModel];
    [self.titleItems addObject:self.clearModel];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    self.tableView.frame = CGRectMake(0, NavBarHeight + 40, ScreenWidth, ScreenHeight - NavBarHeight - 40);
    [self.tableView registNibWithNibName:kBusinessTableViewCell];
}

-(void)layoutTableView{
//should be there otherwise layouts will be overlap
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
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBusinessTableViewCell];
    cell.userInfo = [self.listItems objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessDetailsViewController *vc = [BusinessDetailsViewController new];
    BusinessUserInfo *info = self.listItems[indexPath.row];
    vc.businessId = info.businessId;
    vc.fllowBlock = ^{
        [self resetFetchList];
        [tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(BusinessNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[BusinessNavBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    }
    return _navBarView;
}

-(UIView *)topHeadView{
    if (!_topHeadView) {
        _topHeadView = [[UIView alloc]init];
    }
    return _topHeadView;
}

-(NSMutableArray *)titleItems{
    if (!_titleItems) {
        _titleItems = [NSMutableArray array];
    }
    return _titleItems;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
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
    CircleHomeConditionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCircleHomeConditionCollectionViewCell forIndexPath:indexPath];
    cell.conditionModel = self.titleItems[indexPath.item];
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
            [self.selectBusinessTypeView didShowSelectAddressView];
        }
            break;
        case 2:{
            self.areaModel.isSelect = self.bussinessTypeModel.isSelect = NO;
            self.areaModel.title = @"CircleHomeListViewController.topHeadView.area".icanlocalized;
            self.bussinessTypeModel.title = @"Business Type".icanlocalized;
            [self.selectAreaItems removeAllObjects];
            [self.selectTypeItems removeAllObjects];
            [self.collectionView reloadData];
            self.current = 1;
            self.request = [GetBusinessRecommendListRequest request];
            self.listRequest = self.request;
            [self resetFetchList];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ConditionModel *model = [self.titleItems objectAtIndex:indexPath.item];
    return CGSizeMake(model.width,25);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 101){
        NSString *title = [self.bussinessTypes objectAtIndex:buttonIndex-1];
        self.bussinessTypeModel.isSelect = YES;
        [self.collectionView reloadData];
        self.current = 1;
        [self resetFetchList];
    }
}

-(ShowSelectAddressView *)selectAddressView{
    if (!_selectAddressView) {
        _selectAddressView = [[ShowSelectAddressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _selectAddressView.addressViewType = AddressViewType_Home;
        @weakify(self);
        _selectAddressView.successBlock = ^(NSArray<AreaInfo *> * _Nonnull selectAreaItems) {
            @strongify(self);
            self.selectAreaItems = [NSMutableArray arrayWithArray:selectAreaItems];
            if (self.selectAreaItems.count > 0) {
                self.areaModel.isSelect = YES;
                self.areaModel.title = selectAreaItems.lastObject.areaName;
                [self.collectionView reloadData];
                self.current = 1;
                [self resetFetchList];
            }
        };
    }
    return _selectAddressView;
}

-(void)getItemListWithId{
    GetBusinessTypeId *request = [GetBusinessTypeId request];
    request.pid = [NSNumber numberWithInteger:0];
    request.parameters = [request mj_JSONObject];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BusinessTypeInfo class] success:^(NSArray<BusinessTypeInfo *> *response) {
        [self.selectBusinessTypeView.numberItems addObject:response];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        //Handle failure
    }];
}

-(SelectBusinessTypeView *)selectBusinessTypeView{
    if (!_selectBusinessTypeView) {
        _selectBusinessTypeView = [[SelectBusinessTypeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _selectBusinessTypeView.successBlock = ^(NSArray<BusinessTypeInfo *> * _Nonnull selectTypes) {
            @strongify(self);
            self.selectTypeItems = [NSMutableArray arrayWithArray:selectTypes];
            if (self.selectTypeItems.count > 0) {
                self.bussinessTypeModel.isSelect = YES;
                if (BaseSettingManager.isChinaLanguages) {
                    self.bussinessTypeModel.title = self.selectTypeItems.lastObject.businessType;
                }else{
                    self.bussinessTypeModel.title = self.selectTypeItems.lastObject.businessTypeEn;
                }
                [self.collectionView reloadData];
                self.current = 1;
                [self resetFetchList];
            }
        };
    }
    return _selectBusinessTypeView;
}

-(void)getUserRequest{
    GetBusinessCurrentUserInfoRequest *request = [GetBusinessCurrentUserInfoRequest request];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessCurrentUserInfo class] contentClass:[BusinessCurrentUserInfo class] success:^(BusinessCurrentUserInfo *response) {
        BussinessInfoManager.shared.businessId = [NSString stringWithFormat:@"%zd",response.businessId];
        BussinessInfoManager.shared.icanId = response.icanId;
        BussinessInfoManager.shared.businessName = response.businessName;
        BussinessInfoManager.shared.avatar = response.avatar;
        BussinessInfoManager.shared.checkAvatar = response.checkAvatar;
        BussinessInfoManager.shared.deleted = response.deleted;
        BussinessInfoManager.shared.enable = response.enable;
        if (!response.enable) {
            [UIAlertController alertControllerWithTitle:@"Your business account has been restricted.Please contact the administrator.".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        if (response.deleted) {
            [UIAlertController alertControllerWithTitle:@"Your account has been removed.Please contact the administrator.".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            }];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateBusinessIconNotificatiaon object:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        //handle failure
    }];
}

-(void)resetFetchList{
    self.request = [GetBusinessRecommendListRequest request];
    if (self.areaModel.isSelect) {
        switch (self.selectAreaItems.count) {
            case 1:{
                self.request.countryId = @(self.selectAreaItems.firstObject.areaId);
            }
                break;
            case 2:{
                self.request.countryId = @(self.selectAreaItems.firstObject.areaId);
                self. request.provinceId = @(self.selectAreaItems[1].areaId);
            }
                break;
            case 3:{
                self.request.countryId = @(self.selectAreaItems.firstObject.areaId);
                self.request.provinceId = @(self.selectAreaItems[1].areaId);
                self.request.cityId = @(self.selectAreaItems.lastObject.areaId);
            }
                break;
            case 4:{
                self.request.countryId = @(self.selectAreaItems.firstObject.areaId);
                self.request.provinceId = @(self.selectAreaItems[1].areaId);
                self.request.cityId = @(self.selectAreaItems.lastObject.areaId);
                self.request.areaId = @(self.selectAreaItems.lastObject.areaId);
            }
                break;
            default:
                break;
        }
    }
    if (self.bussinessTypeModel.isSelect) {
        switch (self.selectTypeItems.count) {
            case 1:{
                self.request.businessTypeId = @(self.selectTypeItems.firstObject.businessTypeId);
            }
                break;
            case 2:{
                self.request.businessTypeId = @(self.selectTypeItems.firstObject.businessTypeId);
                self.request.businessSubTypeId = @(self.selectTypeItems[1].businessTypeId);
            }
                break;
            default:
                break;
        }
    }
    self.listRequest = self.request;
    [self refreshList];
}
@end
