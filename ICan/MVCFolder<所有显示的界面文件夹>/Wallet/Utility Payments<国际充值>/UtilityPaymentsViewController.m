//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/4/2021
 - File name:  UtilityPaymentsViewController.m
 - Description:
 - Function List:
 */


#import "UtilityPaymentsViewController.h"
#import "TelecomListViewController.h"
#import "UtilityPaymentsRecordViewController.h"
#import "UtilityPaymentsFavoriteTableViewCell.h"
#import "UtilityPaymentsPayViewController.h"
#import "ShowEditUtilityFavoritesView.h"
#import "TelecomListCell.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"

@interface UtilityPaymentsViewController ()<QMUITableViewDelegate,QMUITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *coutryLabel;

@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UIView *serviceLineView;
@property (weak, nonatomic) IBOutlet UIView *favoriteLineView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;
/** 收藏的充值方式 */
@property(nonatomic, strong) NSMutableArray<DialogListInfo*> *dialogListItems;
/** 话费或者是缴费 */
@property(nonatomic, strong) NSArray<DialogListInfo*> *utilityItems;
@property(nonatomic, strong) ShowEditUtilityFavoritesView *editFavoritesView;
/** 是否是收藏 */
@property(nonatomic, assign) BOOL isCollect;
@property (nonatomic,strong) NSMutableArray<AllCountryInfo*> * countryItems;
@property (nonatomic,strong) AllCountryInfo* selectedCountryItemInfo;
@property (nonatomic,strong) NSString *defaultCountryCode;
@property (nonatomic,strong) NSString *selectedCountryCurrencyCode;
@property (nonatomic,strong) NSString *defaultCountryName;
@property (nonatomic,strong) NSString *defaultCurrencyCode;
@property (nonatomic,strong) NSLocale *countryLocale;
@end

@implementation UtilityPaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countryLocale = [NSLocale currentLocale];
    self.defaultCountryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    self.defaultCountryName = [self.countryLocale displayNameForKey:NSLocaleCountryCode value:self.defaultCountryCode];
    self.defaultCurrencyCode = [self.countryLocale objectForKey:NSLocaleCurrencyCode];
    self.selectedCountryCurrencyCode = self.defaultCurrencyCode;
    self.title = self.titleName;
    [self.serviceButton setTitle:self.titleName forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@"Favorite".icanlocalized forState:UIControlStateNormal];
    self.serviceButton.selected=YES;
    [self.serviceButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.serviceButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
    [self.favoriteButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.favoriteButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UtilityPaymentsViewController.rightBarItem".icanlocalized target:self action:@selector(toRecordAction)];
    [self.tableView registerClass:[QMUITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:QMUICommonTableViewControllerSectionHeaderIdentifier];
    [self.tableView registerClass:[QMUITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:QMUICommonTableViewControllerSectionFooterIdentifier];
    [self.tableView registNibWithNibName:kUtilityPaymentsFavoriteTableViewCell];
    [self.tableView registNibWithNibName:kTelecomListCell];
    [self getFavoriteRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFavoriteRequest) name:KClickDialogFavoriteButotnNotification object:nil];
    [self getCountriesAvailableData];
}

-(void)toRecordAction{
    [self.navigationController pushViewController:[UtilityPaymentsRecordViewController new] animated:YES];
}
/** 选择地区 */
- (IBAction)selectAreaAction {
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    vc.dialogClass = self.dialogClass;
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
    }];
    vc.isRecharge = YES;
    vc.selectAreaBlock = ^(AllCountryInfo * _Nonnull info) {
        self.coutryLabel.text = BaseSettingManager.isChinaLanguages?info.nameCn:info.nameEn;
        self.selectedCountryItemInfo = info;
        self.defaultCountryCode = info.code;
        self.selectedCountryCurrencyCode = info.currencyCode;
        [self getRequest];
    };
}

- (IBAction)servicesButtonAction {
    self.isCollect = NO;
    [self.tableView reloadData];
    self.serviceLineView.hidden=NO;
    self.favoriteLineView.hidden=YES;
    self.serviceButton.selected=YES;
    self.favoriteButton.selected=NO;
    
}
/** 收藏 */
- (IBAction)favoriteButtonAction {
    self.isCollect = YES;
    [self.tableView reloadData];
    self.serviceLineView.hidden=YES;
    self.favoriteLineView.hidden=NO;
    self.serviceButton.selected=NO;
    self.favoriteButton.selected=YES;
    
}
/**
 telecom
 */
- (IBAction)telecomAction:(id)sender {
    TelecomListViewController*vc=[TelecomListViewController new];
    vc.dialogClass=@"Telecom";
    vc.titleName=@"Telecom".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 Other utility
 */
- (IBAction)otherAction:(id)sender {
    TelecomListViewController*vc=[TelecomListViewController new];
    vc.dialogClass=@"OtherUtility";
//    Payment
    vc.titleName=@"Other utility".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    "CancelCollect"="取消收藏";
//    "WhetherCancelCollect"="是否取消收藏";
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"CancelCollect".icanlocalized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [UIAlertController alertControllerWithTitle:@"WhetherCancelCollect".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                DialogListInfo*info=self.dialogListItems[indexPath.row];
                DeleteDialogFavoritesRequest*request=[DeleteDialogFavoritesRequest request];
                request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@",info.ID];
                [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                    [self.dialogListItems removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                }];
            }
            
        }];
        
    }];
//    "Edit"="编辑";
    UITableViewRowAction * edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit".icanlocalized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.editFavoritesView=[[NSBundle mainBundle]loadNibNamed:@"ShowEditUtilityFavoritesView" owner:self options:nil].firstObject;
        self.editFavoritesView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        DialogListInfo*info=self.dialogListItems[indexPath.row];
        self.editFavoritesView.info=info;
        [self.editFavoritesView showEditUtilityFavoritesView];
        @weakify(self);
        self.editFavoritesView.sureBlock = ^{
            //"UtilityPaymentsViewController.nameNullTips"="名字不能为空";
//            "UtilityPaymentsViewController.mobileNullTips"="号码不能为空";
            @strongify(self);
            if (self.editFavoritesView.nameTextField.text.trimmingwhitespaceAndNewline.length==0) {
                [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsViewController.nameNullTips".icanlocalized inView:self.view];
                return;
            }
            if (self.editFavoritesView.mobileTextField.text.trimmingwhitespaceAndNewline.length==0) {
                [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsViewController.mobileNullTips".icanlocalized inView:self.view];
                return;
            }
//            "UtilityPaymentsViewController.editLoading"="正在修改":
//            "UtilityPaymentsViewController.editSuccess"="修改成功":
            [QMUITipsTool showLoadingWihtMessage:@"UtilityPaymentsViewController.editLoading".icanlocalized inView:self.view isAutoHidden:NO];
            PutDialogFavoritesRequest*request=[PutDialogFavoritesRequest request];
            request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@",info.ID];
            request.accountNumber=self.editFavoritesView.mobileTextField.text;
            request.dialogId=info.dialogId;
            request.nickname=self.editFavoritesView.nameTextField.text;
            request.parameters=[request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsViewController.editSuccess".icanlocalized inView:self.view];
                [self.editFavoritesView hiddenEditUtilityFavoritesView];
                [self getFavoriteRequest];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }];
        };
        
        
    }];
    edit.backgroundColor=UIColorThemeMainColor;
    if (self.isCollect) {
        return @[deleted,edit];
    }
    return @[];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isCollect) {
        return self.dialogListItems.count;
    }
    return self.utilityItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isCollect?90:70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCollect) {
        UtilityPaymentsFavoriteTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kUtilityPaymentsFavoriteTableViewCell];
        cell.dialogInfo=self.dialogListItems[indexPath.row];
        return cell;
    }
    TelecomListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTelecomListCell];
    cell.dialogInfo=self.utilityItems[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilityPaymentsPayViewController*payVc=[[UtilityPaymentsPayViewController alloc]init];
    if (self.isCollect) {
        payVc.isFromFavorite=YES;
        payVc.dialogInfo=self.dialogListItems[indexPath.row];
        payVc.currencyCodeVal = self.selectedCountryCurrencyCode;
    }else{
        payVc.dialogInfo=self.utilityItems[indexPath.row];
        payVc.currencyCodeVal = self.selectedCountryCurrencyCode;
        for (DialogListInfo* itemData in self.dialogListItems) {
            if (itemData == self.utilityItems[indexPath.row]){
                payVc.isFromFavorite = YES;
            }else{
                payVc.isFromFavorite = NO;
            }
        }
    }
    for(AllCountryInfo *item in self.countryItems) {
        if(BaseSettingManager.isChinaLanguages) {
            if([item.nameCn isEqualToString:self.coutryLabel.text]) {
                payVc.countryCode = item.phoneCode;
            }
        }else {
            if([item.nameEn isEqualToString:self.coutryLabel.text]) {
                payVc.countryCode = item.phoneCode;
            }
        }
    }
    [self.navigationController pushViewController:payVc animated:YES];
}

/// 获取收藏的充值方式
-(void)getFavoriteRequest{
    GetDialogFavoritesListRequest*request=[GetDialogFavoritesListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[DialogListInfo class] success:^(NSArray* response) {
        self.dialogListItems=[NSMutableArray arrayWithArray:response];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)getRequest{
    GetDialogListRequest*request=[GetDialogListRequest request];
    request.dialogClass=self.dialogClass;
    request.countryCode = self.defaultCountryCode;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[DialogListInfo class] success:^(NSArray* response) {
        [QMUITips hideAllTips];
        self.utilityItems = response;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(statusCode == 403){
            [UIAlertController alertControllerWithTitle:@"Unauthorized action please contact customer service".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"ShowSelectAddressView.sureBtn".icanlocalized] handler:^(int index) {
                if(index == 0){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }
    }];
}

-(NSMutableArray *)countryItems{
    if (!_countryItems) {
        _countryItems=[NSMutableArray array];
    }
    return _countryItems;
}

-(void)getCountriesAvailableData{
    __block bool isFoundDefault = NO;
    GetCountriesAvailableDataRequest *request = [GetCountriesAvailableDataRequest request];
    request.dialogClass=self.dialogClass;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AllCountryInfo class] success:^(NSArray *response) {
        [QMUITips hideAllTips];
        [self.countryItems addObjectsFromArray:response];
        for (AllCountryInfo *countryVal  in self.countryItems) {
            if(countryVal.code == self.defaultCountryCode){
                isFoundDefault = YES;
            }
        }
        if(isFoundDefault == YES){
            self.coutryLabel.text = self.defaultCountryName;
            self.selectedCountryCurrencyCode = self.defaultCurrencyCode;
            [self getRequest];
        }else{
            if(self.countryItems.firstObject != nil){
                self.coutryLabel.text = BaseSettingManager.isChinaLanguages?self.countryItems.firstObject.nameCn:self.countryItems.firstObject.nameEn;
                self.selectedCountryCurrencyCode = self.countryItems.firstObject.currencyCode;
                self.defaultCountryCode = self.countryItems.firstObject.code;
                [self getRequest];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSLog(@"Error");
    }];
}
@end
