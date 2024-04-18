//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 27/9/2021
 - File name:  ExchangeCurrencyListViewController.m
 - Description:
 - Function List:
 */


#import "ExchangeCurrencyListViewController.h"
#import "ExchangeCurrencyListHead.h"
#import "ExchangeCurrencyListTableViewCell.h"

#import "ExchangeCurrencyViewController.h"
#import "HJCActionSheet.h"
#import <MJRefresh.h>
@interface ExchangeCurrencyListViewController ()<HJCActionSheetDelegate>
@property(nonatomic, strong) ExchangeCurrencyListHead *head;
/** 牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *currencyItems;
/** 牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *showCurrencyItems;
/** 支持的货币 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *allSupportCurrencyItems;
/** 支持的货币需要显示的中文 */
@property(nonatomic, strong) NSArray *allSupportCNCurrencyItems;
/** 支持的货币需要显示的英文*/
@property(nonatomic, strong) NSArray *allSupportENCurrencyItems;

@property(nonatomic, strong)   CurrencyInfo *currentSelectCurrencyInfo;
@end

@implementation ExchangeCurrencyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认情况下是CNY
    //    self.targetCurrencyCode = @"CNT";
    
    [self getAllCurrencyRequest];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCurrencyRequest)];
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kExchangeCurrencyListTableViewCell];
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.head = [[NSBundle mainBundle]loadNibNamed:@"ExchangeCurrencyListHead" owner:self options:@{}].firstObject;
    NSString*updateTime =  [[self.showCurrencyItems valueForKeyPath:@"updateTime"]valueForKeyPath:@"@max.floatValue"];
    self.head.timeLabel.text = [NSString stringWithFormat:@"%@：%@",@"UpdateTime".icanlocalized,[GetTime convertDateWithString:updateTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"]];
    if (self.currentSelectCurrencyInfo) {
        self.head.targetCurrencyLab.text = BaseSettingManager.isChinaLanguages?self.currentSelectCurrencyInfo.nameCn:self.currentSelectCurrencyInfo.nameCn;
    }
    @weakify(self);
    self.head.selectCurrencyBlock = ^{
        @strongify(self);
        HJCActionSheet * sheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:@"Cancel".icanlocalized otherTitles:BaseSettingManager.isChinaLanguages?self.allSupportCNCurrencyItems:self.allSupportENCurrencyItems];
        [sheet show];
    };
    return self.head;
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSString*title=[self.educationItems objectAtIndex:buttonIndex-1];
    NSString *title;
    CurrencyInfo*info;
    if (BaseSettingManager.isChinaLanguages) {
        title = [self.allSupportCNCurrencyItems objectAtIndex:buttonIndex-1];
        for (CurrencyInfo*cnInfo in self.allSupportCurrencyItems) {
            if ([cnInfo.nameCn isEqualToString:title]) {
                info = cnInfo;
                break;
            }
        }
    }else{
        title = [self.allSupportENCurrencyItems objectAtIndex:buttonIndex-1];
        for (CurrencyInfo*cnInfo in self.allSupportCurrencyItems) {
            if ([cnInfo.nameEn isEqualToString:title]) {
                info = cnInfo;
                break;
            }
        }
    }
    self.currentSelectCurrencyInfo = info;
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ ",info.code];
    self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showCurrencyItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeCurrencyListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kExchangeCurrencyListTableViewCell];
    cell.currencyInfo = self.showCurrencyItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UserInfoManager.sharedManager.openExchange) {
        ExchangeCurrencyViewController*vc = [[ExchangeCurrencyViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.currencyExchangeInfo = self.showCurrencyItems[indexPath.row];
        vc.currencyItems = self.currencyItems;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}
///获取支持的全部货币
-(void)getAllCurrencyRequest{
    GetC2CAllSupportedCurrenciesRequest * request = [GetC2CAllSupportedCurrenciesRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyInfo class] success:^(NSArray* response) {
        self.allSupportCurrencyItems = response;
        self.allSupportCNCurrencyItems = [response valueForKeyPath:@"nameCn"];
        self.allSupportENCurrencyItems = [response valueForKeyPath:@"nameEn"];
        __block NSPredicate * gpredicate;
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            gpredicate = [NSPredicate predicateWithFormat:@"code == %@",@"CNY"];
         }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            gpredicate = [NSPredicate predicateWithFormat:@"code == %@",@"CNT"];
        }
        NSArray *array = [response filteredArrayUsingPredicate:gpredicate];
        if (array.count > 0) {
            self.currentSelectCurrencyInfo = array.firstObject;
            [self.tableView reloadData];
        }
        [self getCurrencyRequest];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
/** 牌价列表 */
-(void)getCurrencyRequest{
    GetC2CExchangeRequest*request = [GetC2CExchangeRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyExchangeInfo class] success:^(NSArray* response) {
        self.currencyItems = response;
        __block NSPredicate * gpredicate;
        C2CUserManager.shared.currencyExchangeItems = response;
        NSMutableArray * hasCurrencyItems = [NSMutableArray array];
        //遍历判断本地的牌价列表是否存在该支持的货币
        for (CurrencyInfo * currencyInfo in self.allSupportCurrencyItems) {
            NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@",currencyInfo.code];
            NSArray*array = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
            if (array.count>0) {
                [hasCurrencyItems addObject:currencyInfo];
            }
        }
        self.allSupportCurrencyItems = hasCurrencyItems;
        self.allSupportCNCurrencyItems = [hasCurrencyItems valueForKeyPath:@"nameCn"];
        self.allSupportENCurrencyItems = [hasCurrencyItems valueForKeyPath:@"nameEn"];
        if (self.currentSelectCurrencyInfo) {
            NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@",self.currentSelectCurrencyInfo.code];
            self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        }else{
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@",@"CNY"];
             }

            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@",@"CNT"];
            }
            self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        }
        
        if (self.showCurrencyItems.count == 0) {
            self.showCurrencyItems = response;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
