//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 18/11/2021
 - File name:  C2CMyAdvertisingViewController.m
 - Description:
 - Function List:
 */


#import "C2CMyAdvertisingViewController.h"
#import "C2CMyAdvertisingListTableViewCell.h"
#import "C2CPublishAdvertFirstStepViewController.h"
#import "C2CAdverFilterCurrencyPopView.h"
#import "C2CAdverFilterTypePopView.h"
#import "C2CAdverFilterStatePopView.h"
#import "CertificationViewController.h"
#import "C2CHistoryAdvertisingViewController.h"
@interface C2CMyAdvertisingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//币种
@property (weak, nonatomic) IBOutlet UIControl * currencyCon;
@property (weak, nonatomic) IBOutlet UIImageView *currencyImgView;
@property (weak, nonatomic) IBOutlet UILabel * currencyLabel;
/**
 类型
 */
@property (weak, nonatomic) IBOutlet UIControl * typeCon;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel * typeLabel;
/**
 状态
 */
@property (weak, nonatomic) IBOutlet UIControl * stateCon;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UILabel * stateLabel;

@property (nonatomic, strong) C2CGetUserAdverListRequest *request;
@property (nonatomic, strong) C2CAdverFilterCurrencyPopView *currencyPopView;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, strong) C2CAdverFilterTypePopView *typePopView;
@property (nonatomic, copy) NSString *typeTitle;
@property (nonatomic, strong) C2CAdverFilterStatePopView *statePopView;
@property (nonatomic, copy) NSString *stateTitle;
@end

@implementation C2CMyAdvertisingViewController

-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.currencyPopView hiddenView];
    [self.typePopView hiddenView];
    [self.statePopView hiddenView];
    [self resetFetchList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //    "C2CMyAdvertisingViewControllerType"="类型";
    //    "C2CMyAdvertisingViewControllerCurrency"="币种";
    //    "C2CMyAdvertisingViewControllerState"="状态";
    
    //币种
    //所有货币
    self.titleLabel.text = @"MyAds".icanlocalized;
    self.currencyCode = @"C2CAdverFilterCurrencyPopViewAllCurrency".icanlocalized;
    //所有类型
    self.typeTitle = @"C2CAdverFilterTypePopViewAllType".icanlocalized;
    //所有状态
    self.stateTitle = @"C2CAdverFilterStatePopViewAllStateLabel".icanlocalized;
    self.currencyLabel.text = @"C2CMyAdvertisingViewControllerCurrency".icanlocalized;
    self.typeLabel.text = @"C2CMyAdvertisingViewControllerType".icanlocalized;
    self.stateLabel.text = @"C2CMyAdvertisingViewControllerState".icanlocalized;
    self.listClass = [C2COptionalListInfo class];
    [self resetFetchList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:kC2CPublishAdverSuccessNotification object:nil];
}
//重置搜索条件
-(void)resetFetchList{
    self.request = [C2CGetUserAdverListRequest request];
    self.listRequest=self.request;
    if (![self.currencyCode isEqualToString:@"C2CAdverFilterCurrencyPopViewAllCurrency".icanlocalized]) {
        self.request.virtualCurrency = self.currencyCode;
    }
    if (![self.typeTitle isEqualToString:@"C2CAdverFilterTypePopViewAllType".icanlocalized]) {
        if ([self.typeTitle isEqualToString:@"C2CAdverFilterTypePopViewBuy".icanlocalized]) {
            self.request.transactionType = @"Buy";
        }else{
            self.request.transactionType = @"Sell";
        }
    }
    if (![self.stateTitle isEqualToString:@"C2CAdverFilterStatePopViewAllStateLabel".icanlocalized]) {
        if ([self.stateTitle isEqualToString:@"C2CAdverFilterStatePopViewPutawayStateLabel".icanlocalized]) {
            self.request.available = @(1);
        }else{
            self.request.available = @(0);
        }
    }
    if (self.userId) {
        self.request.userId = self.userId;
    }
    self.request.deleted = @(0);
    [self refreshList];
}
- (IBAction)backAction {
    if (self.shoulPopToRoot) {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)currencyAction{
    /*关于M_PI
     #define M_PI    3.14159265358979323846264338327950288
     其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
     旋转方向为：顺时针旋转
     */
    [self.typePopView hiddenView];
    [self.statePopView hiddenView];
    if (self.currencyPopView.isHidden) {
        self.currencyLabel.textColor = UIColorThemeMainColor;
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
            self.currencyImgView.transform = transform;//旋转
        }];
        
        [self.currencyPopView showView];
    }else{
        [self.currencyPopView hiddenView];
    }
    
}
-(IBAction)typeAction{
    [self.currencyPopView hiddenView];
    [self.statePopView hiddenView];
    if (self.typePopView.isHidden) {
        self.typeLabel.textColor = UIColorThemeMainColor;
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
            self.typeImgView.transform = transform;//旋转
        }];
        
        [self.typePopView showView];
    }else{
        [self.typePopView hiddenView];
    }
    
}
-(IBAction)stateAction{
    [self.currencyPopView hiddenView];
    [self.typePopView hiddenView];
    if (self.statePopView.isHidden) {
        self.stateLabel.textColor = UIColorThemeMainColor;
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
            self.stateImgView.transform = transform;//旋转
        }];
        
        [self.statePopView showView];
    }else{
        [self.statePopView hiddenView];
    }
    
}
- (IBAction)moreBtnAction {
    C2CHistoryAdvertisingViewController * vc = [[C2CHistoryAdvertisingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)addButtonAction{
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        [self.navigationController pushViewController:[C2CPublishAdvertFirstStepViewController new] animated:YES];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        [UIAlertController alertControllerWithTitle:@"RealnameNoAuthTip".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                CertificationViewController *vc =[[CertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
       
    }
    
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorBg243Color;
    [self.tableView registNibWithNibName:kC2CMyAdvertisingListTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight+50));
    }];
}


-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CMyAdvertisingListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CMyAdvertisingListTableViewCell];
    cell.adverInfo = [self.listItems objectAtIndex:indexPath.row];
    cell.switchBlock = ^(BOOL open) {
        [self setAdverOnShelfOrOffShelfRequest:open adverInfo:[self.listItems objectAtIndex:indexPath.row]];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    C2CAdverInfo * info= [self.listItems objectAtIndex:indexPath.row];
//    C2CPublishAdvertFirstStepViewController*vc = [C2CPublishAdvertFirstStepViewController new];
//    vc.adverInfo = info;
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete".icanlocalized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"SureDeleteC2CAd".icanlocalized preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteAdver:indexPath];

        }];
        [alert addAction:cancel];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    C2CAdverInfo * info= [self.listItems objectAtIndex:indexPath.row];
    return info.available?@[]:@[deleted];
    
    
    
}
/** 虚拟货币弹框 */
-(C2CAdverFilterCurrencyPopView *)currencyPopView{
    if (!_currencyPopView) {
        _currencyPopView = [[NSBundle mainBundle]loadNibNamed:@"C2CAdverFilterCurrencyPopView" owner:self options:nil].firstObject;
        _currencyPopView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight+50, ScreenWidth, ScreenHeight);
        _currencyPopView.hidden = YES;
        @weakify(self);
        _currencyPopView.selectBlock = ^(NSString * _Nonnull limitTime) {
            @strongify(self);
            if ([self.currencyCode isEqualToString:limitTime]) {
                return;
            }
            self.currencyLabel.text = limitTime;
            self.currencyCode = limitTime;
            if ([limitTime isEqualToString:@"C2CAdverFilterCurrencyPopViewAllCurrency".icanlocalized]) {
                self.currencyLabel.textColor = UIColor252730Color;
                self.currencyLabel.text = @"C2CMyAdvertisingViewControllerCurrency".icanlocalized;
            }else {
                
                self.currencyLabel.textColor = UIColorThemeMainColor;
            }
            [self resetFetchList];
        };
        _currencyPopView.hiddenBlock = ^{
            @strongify(self);
            if ([self.currencyLabel.text isEqualToString:@"C2CMyAdvertisingViewControllerCurrency".icanlocalized]) {
                self.currencyLabel.textColor = UIColor252730Color;
            }else {
                self.currencyLabel.textColor = UIColorThemeMainColor;
            }
            [UIView animateWithDuration:0.3 animations:^{
                CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
                self.currencyImgView.transform = transform;//旋转
            }];
            
        };
    }
    return _currencyPopView;
}
/** 类型弹框 */
-(C2CAdverFilterTypePopView *)typePopView{
    if (!_typePopView) {
        _typePopView = [[NSBundle mainBundle]loadNibNamed:@"C2CAdverFilterTypePopView" owner:self options:nil].firstObject;
        _typePopView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight+50, ScreenWidth, ScreenHeight);
        ////    "C2CAdverFilterTypePopViewAllType"="所有类型";
        //    "C2CAdverFilterTypePopViewBuy"="购买";
        //    "C2CAdverFilterTypePopViewSale"="出售";
        @weakify(self);
        _typePopView.selectBlock = ^(NSString * _Nonnull limitTime) {
            @strongify(self);
            if ([self.typeTitle isEqualToString:limitTime]) {
                return;
            }
            self.typeTitle = limitTime;
            self.typeLabel.text = limitTime;
            if ([limitTime isEqualToString:@"C2CAdverFilterTypePopViewAllType".icanlocalized]) {
                self.typeLabel.textColor = UIColor252730Color;
                self.typeLabel.text = @"C2CMyAdvertisingViewControllerType".icanlocalized;
            }else {
                self.typeLabel.textColor = UIColorThemeMainColor;
            }
            [self resetFetchList];
        };
        _typePopView.hiddenBlock = ^{
            @strongify(self);
            if ([self.typeLabel.text isEqualToString:@"C2CMyAdvertisingViewControllerType".icanlocalized]) {
                self.typeLabel.textColor = UIColor252730Color;
            }else {
                self.typeLabel.textColor = UIColorThemeMainColor;
            }
            [UIView animateWithDuration:0.3 animations:^{
                CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
                self.typeImgView.transform = transform;//旋转
            }];
            
        };
    }
    return _typePopView;
}
/** 状态弹框 */
-(C2CAdverFilterStatePopView *)statePopView{
    if (!_statePopView) {
        _statePopView = [[NSBundle mainBundle]loadNibNamed:@"C2CAdverFilterStatePopView" owner:self options:nil].firstObject;
        _statePopView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight+50, ScreenWidth, ScreenHeight);
        //    "C2CAdverFilterStatePopViewAllStateLabel"="所有状态";
        //    "C2CAdverFilterStatePopViewPutawayStateLabel"="已上架";
        //    "C2CAdverFilterStatePopViewSoldawayStateLabel"="已下架";
        @weakify(self);
        _statePopView.selectBlock = ^(NSString * _Nonnull limitTime) {
            @strongify(self);
            if ([self.stateTitle isEqualToString:limitTime]) {
                return;
            }
            self.stateTitle = limitTime;
            self.stateLabel.text = limitTime;
            if ([limitTime isEqualToString:@"C2CAdverFilterStatePopViewAllStateLabel".icanlocalized]) {
                self.stateLabel.textColor = UIColor252730Color;
                self.stateLabel.text = @"C2CMyAdvertisingViewControllerState".icanlocalized;
            }else {
                self.stateLabel.textColor = UIColorThemeMainColor;
            }
            [self resetFetchList];
        };
        _statePopView.hiddenBlock = ^{
            @strongify(self);
            if ([self.stateLabel.text isEqualToString:@"C2CMyAdvertisingViewControllerState".icanlocalized]) {
                self.stateLabel.textColor = UIColor252730Color;
            }else {
                self.stateLabel.textColor = UIColorThemeMainColor;
            }
            [UIView animateWithDuration:0.3 animations:^{
                CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
                self.stateImgView.transform = transform;//旋转
            }];
            
        };
    }
    return _statePopView;
}
-(void)setAdverOnShelfOrOffShelfRequest:(BOOL)open adverInfo:(C2CAdverInfo*)info{
    __block C2CAdverInfo*dInfo = info;
    if (open) {
       
        C2COnShelfAdverRequest * request = [C2COnShelfAdverRequest request];
        request.parameters = [request mj_JSONObject];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld/onShelf",(long)info.adId];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            dInfo.available = NO;
            [self.tableView reloadData];
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }else{
        C2COffShelfAdverRequest * request = [C2COffShelfAdverRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld/offShelf",(long)info.adId];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            dInfo.available = YES;
            [self.tableView reloadData];
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }
    
    
}
-(void)deleteAdver:(NSIndexPath*)index{
    C2CAdverInfo * info = [self.listItems objectAtIndex:index.row];
   
    C2CDeleteAdverRequest * request = [C2CDeleteAdverRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld",info.adId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(C2CDeleteAdverRequest*  _Nonnull response) {
        [self.listItems removeObject:info];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
}
@end
