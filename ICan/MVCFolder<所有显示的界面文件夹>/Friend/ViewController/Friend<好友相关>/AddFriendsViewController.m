
#import "AddFriendsViewController.h"
#import "QRCodeController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "FriendDetailViewController.h"
#import "ShowUserIdTableViewCell.h"
#import "AddFriendDefaultTableViewCell.h"
#import "ImageSettingItem.h"
#import "QRCodeView.h"
#import "SearchResultTableViewCell.h"
#import "SearchHeadView.h"
#import "QrScanResultAddRoomController.h"
#import "FindNearbyPersonsViewController.h"
#import "PrivacyPermissionsTool.h"
#import <CoreLocation/CoreLocation.h>
#import "NewFriendRecommendController.h"

@interface AddFriendsViewController ()<QMUISearchControllerDelegate, CLLocationManagerDelegate>
@property(nonatomic, strong) NSMutableArray *typeArray;
@property(nonatomic,strong) NSMutableArray <UserMessageInfo *> *searchResultItems;
@property(nonatomic, strong) SearchHeadView *searchHeaderView;
@property(nonatomic, copy)    NSString *searchString;
@property(nonatomic, strong) SearchUserInfo *searchUserInfo;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLLocation *currentLocation;
@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataForView];
//    "Add Friends/Groups"="添加好友/群";
    self.titleView.title = @"Add Friends/Groups".icanlocalized;
    [self getCurrentLocation];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registNibWithNibName:kShowUserIdTableViewCell];
    [self.tableView registNibWithNibName:kAddFriendDefaultTableViewCell];
    self.tableView.tableHeaderView = self.searchHeaderView;
    [self.tableView registNibWithNibName:kSearchResultTableViewCell];
}

#pragma mark -- 创建数据（写死的数据）
- (void)getDataForView {
    ImageSettingItem *scanItem = [[ImageSettingItem alloc]initWithLeftTitle:NSLocalizedString(@"Scan QR Code", 扫一扫) rightTitle:NSLocalizedString(@"Scan your friend's QR code", 扫一扫二维码可添加为好友) imgUrl:@"icon_addfriend_scan"];
  
    ImageSettingItem *nearItem = [[ImageSettingItem alloc]initWithLeftTitle:[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"] rightTitle:@"Can view nearby users".icanlocalized imgUrl:@"icon_nearby_people"];
    
    ImageSettingItem *recoItem = [[ImageSettingItem alloc]initWithLeftTitle:[@"find.listView.cell.recommended" icanlocalized:@"推荐的人"] rightTitle:@"Can view recommended people".icanlocalized imgUrl:@"icon_addfriend_recommend"];
    [self.typeArray addObject:scanItem];
    if ([UserInfoManager sharedManager].openNearbyPeople) {
        [self.typeArray addObject:nearItem];
    }
    if (UserInfoManager.sharedManager.openRecommend) {
        [self.typeArray addObject:recoItem];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchUserInfo) {
        if (self.searchUserInfo.users.count>0) {
            return self.searchUserInfo.users.count;
        }
        return 1;
    }
    return section == 0?1:self.typeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchUserInfo) {
        if (self.searchUserInfo.users.count>0 && self.searchUserInfo.group) {
            return 2;
        }
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchUserInfo) {
        return 40;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchUserInfo) {
        if (section == 0) {
            if (self.searchUserInfo.users.count>0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                view.backgroundColor = UIColor.whiteColor;
                UILabel *label = [UILabel leftLabelWithTitle:@"timeline.limit.tip.friend".icanlocalized font:16 color:UIColor153Color];
                label.frame = CGRectMake(15, 0, 300, 30);
                [view addSubview:label];
                return view;
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                view.backgroundColor = UIColor.whiteColor;
                UILabel *label = [UILabel leftLabelWithTitle:@"chatlist.menu.list.group".icanlocalized font:16 color:UIColor153Color];
                label.frame = CGRectMake(15, 0, 300, 30);
                [view addSubview:label];
                return view;
            }
            
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            view.backgroundColor = UIColor.whiteColor;
            UILabel *label = [UILabel leftLabelWithTitle:@"chatlist.menu.list.group".icanlocalized font:16 color:UIColor153Color];
            label.frame = CGRectMake(15, 0, 300, 30);
            [view addSubview:label];
            return view;
        }
    }
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchUserInfo) {
        return 55;
    }
    return indexPath.section == 0?30.0:70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchUserInfo) {
        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultTableViewCell];
        if (indexPath.section == 0) {
            if (self.searchUserInfo.users.count>0) {
                cell.userMessageInfo =self.searchUserInfo.users[indexPath.row];
            }else{
                cell.groupListInfo=self.searchUserInfo.group;
            }
        }else{
            cell.groupListInfo=self.searchUserInfo.group;
        }
        return cell;
    }
    if (indexPath.section == 0) {
        ShowUserIdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowUserIdTableViewCell];
        cell.tapQrBlock = ^{
            QRCodeView *view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
            view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            view.qrCodeViewTyep = QRCodeViewTyep_user;
            [self.view endEditing:YES];
            [view showQRCodeView];
        };
        return cell;
    }
    AddFriendDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddFriendDefaultTableViewCell];
    cell.imageSettingItem=self.typeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchUserInfo) {
        //如果当前是搜索用户 - If the current search user
        if (indexPath.section == 0) {
            if (self.searchUserInfo.users.count>0) {
                UserMessageInfo *info = self.searchUserInfo.users[indexPath.row];
                FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
                vc.userMessageInfo = info;
                vc.friendDetailType = FriendDetailType_push;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self goToGroupDetailOrQrRoomWith:self.searchUserInfo.group];
            }
        }else{
            [self goToGroupDetailOrQrRoomWith:self.searchUserInfo.group];
        }
    }else{
        [self.view endEditing:YES];
        if (indexPath.section == 0) {
            QRCodeView *view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
            view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            view.qrCodeViewTyep=QRCodeViewTyep_user;
            [view showQRCodeView];
        }else{
            ImageSettingItem *item = self.typeArray[indexPath.row];
            if ([item.leftTitle isEqualToString:NSLocalizedString(@"Mobile phone address book match", 手机通讯录匹配)]) {
                [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Function not open yet", 功能暂未开放) inView:self.view];
            }else if ([item.leftTitle isEqualToString:NSLocalizedString(@"Scan QR Code", 扫一扫)]){
                QRCodeController *scanVc = [[QRCodeController alloc]init];
                [self.navigationController pushViewController:scanVc animated:YES];
            }else if ([item.leftTitle isEqualToString:NSLocalizedString(@"Invite Mobile Contacts", 邀请手机联系人)]){
                [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Function not open yet", 功能暂未开放) inView:self.view];
            }else if ([item.leftTitle isEqualToString:[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"]]){
                [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation];
            }else{
                NewFriendRecommendController *vc = [NewFriendRecommendController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)goToGroupDetailOrQrRoomWith:(GroupListInfo*)listInfo {
    if (listInfo.isInGroup) {
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:listInfo.groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend,kshowName:listInfo.name}];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        QrScanResultAddRoomController *vc = [QrScanResultAddRoomController new];
        vc.groupDetailInfo = self.searchUserInfo.group;
        vc.fromAddFriend=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (SearchHeadView *)searchHeaderView {
    if (!_searchHeaderView) {
        //"Search Friends/Groups"="搜索好友/群";
        _searchHeaderView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _searchHeaderView.searchTextFiledPlaceholderString=@"Search Friends/Groups".icanlocalized;
        _searchHeaderView.shouShowKeybord=YES;
        @weakify(self);
        _searchHeaderView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            if ([search isEqualToString:@""]) {
                [self.searchResultItems removeAllObjects];
                self.searchUserInfo=nil;
                [self.tableView reloadData];
            }
        };
        _searchHeaderView.searchBlock = ^{
            @strongify(self);
            [self.view endEditing:YES];
            [self serachUser];
        };
    }
    return _searchHeaderView;
}

- (NSMutableArray<UserMessageInfo *> *)searchResultItems {
    if (!_searchResultItems) {
        _searchResultItems = [NSMutableArray array];
    }
    return _searchResultItems;
}

- (NSMutableArray *)typeArray {
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (void)serachUser {
    if (self.searchHeaderView.searTextField.text.length>0) {
        SearchUserAndGroupRequest *request = [SearchUserAndGroupRequest request];
        request.value = self.searchHeaderView.searTextField.text;
        request.parameters = [request mj_JSONObject];
        [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[SearchUserInfo class] contentClass:[SearchUserInfo class] success:^(SearchUserInfo *response) {
            [QMUITips hideAllTips];
            self.searchUserInfo = nil;
            if (response.group||response.users.count>0) {
                if (response.group&&!response.users.count) {//群聊
                    QrScanResultAddRoomController *vc = [QrScanResultAddRoomController new];
                    vc.groupDetailInfo = response.group;
                    vc.fromAddFriend=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if (response.users.count == 1 && !response.group){
                    UserMessageInfo *info = response.users.firstObject;
                    FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
                    vc.userMessageInfo = info;
                    vc.friendDetailType = FriendDetailType_push;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                self.searchUserInfo=response;
                
            }else{
                // "User or group does not exist"="用户或群不存在" / "User or group does not exist";
                [QMUITipsTool showErrorWihtMessage:@"User or group does not exist".icanlocalized inView:nil];
            }
            [self.tableView reloadData];
            
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
}

//Get the current location and report the user's current location
- (void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation {
    if (![UserInfoManager sharedManager].nearbyVisible) {
        [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Is it visible to nearby people?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index == 1) {
                [UserInfoManager sharedManager].nearbyVisible = YES;
                [self start];
            }
        }];
    }else {
        [self start];
    }
}

- (void)start {
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:YES];
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        UploadUserLocationRequest *request = [UploadUserLocationRequest request];
        request.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
        request.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            [QMUITips hideAllTips];
            FindNearbyPersonsViewController *vc = [[FindNearbyPersonsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    } failure:^{
        [QMUITips hideAllTips];
    }];
}

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations firstObject]) {
        [self.locationManager stopUpdatingLocation];
        self.currentLocation = [locations firstObject];
    }
}
@end
