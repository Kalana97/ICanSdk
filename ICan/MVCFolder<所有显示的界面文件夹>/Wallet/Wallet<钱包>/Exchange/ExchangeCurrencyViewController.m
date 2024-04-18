//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 24/9/2021
 - File name:  ExchangeCurrencyViewController.m
 - Description:
 - Function List:
 */


#import "ExchangeCurrencyViewController.h"

#import "PayManager.h"
#import "ExchangeCurrencyViewHead.h"
#import "ExchangeCurrencyTableViewCell.h"
@interface ExchangeCurrencyViewController ()
//我要买入
@property (weak, nonatomic) IBOutlet UIControl *buyCon;
@property (weak, nonatomic) IBOutlet UILabel *buyTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *buyCurrencyLab;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;
@property (weak, nonatomic) IBOutlet UITextField *buyTextField;


//我要卖出
@property (weak, nonatomic) IBOutlet UIControl *saleCon;
@property (weak, nonatomic) IBOutlet UILabel *saleTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *saleCurrencyLab;
@property (weak, nonatomic) IBOutlet UIImageView *saleDropDownImg;
@property (weak, nonatomic) IBOutlet UITextField *saleTextField;
//汇率提示label
@property (weak, nonatomic) IBOutlet UILabel *rateTipLabel;

//双箭头
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
//兑换
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
//更新时间
@property (weak, nonatomic) IBOutlet UILabel *updateLabe;

//我要卖出
@property (weak, nonatomic) IBOutlet UILabel *sellTitleLab;
//我要买入
@property (weak, nonatomic) IBOutlet UILabel *buyTitleLabel;


//需要兑换的货币 被兑换的货币
@property(nonatomic, strong) NSMutableArray<CurrencyInfo*> *fromCurrencyItems;
/** 目标货币的中文 */
@property(nonatomic, strong) NSArray *fromCurrencyCNItmes;
@property(nonatomic, strong) NSArray *fromCurrencyENItmes;
//兑换成的货币
//需要兑换的货币 被兑换的货币
@property(nonatomic, strong) NSMutableArray<CurrencyInfo*> *toCurrencyItems;
@property(nonatomic, strong) NSArray *toCurrencyCNItmes;
@property(nonatomic, strong) NSArray *toCurrencyENItmes;

@property(nonatomic, strong) PayManager *mange;
/** 显示牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *showCurrencyItems;
@property(nonatomic, strong) ExchangeCurrencyViewHead *head;
@end

@implementation ExchangeCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mange = [[PayManager alloc]initWithExhangeViewCurrencyShowViewController:self successBlock:^(NSArray * _Nonnull balance) {
        
    }];
    if (!self.currencyExchangeInfo) {
        [self getCurrencyRequest];
    }else{
        self.title = @"Exchange".icanlocalized;
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ ",self.currencyExchangeInfo.fromCode];
        self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        
        [self.tableView reloadData];
    }
    
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kExchangeCurrencyTableViewCell];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.head.currencyItems = self.currencyItems;
    self.head.currencyExchangeInfo = self.currencyExchangeInfo;
    NSString*updateTime =  [[self.showCurrencyItems valueForKeyPath:@"updateTime"]valueForKeyPath:@"@max.floatValue"];
    self.head.updateLabe.text = [NSString stringWithFormat:@"%@：%@",@"UpdateTime".icanlocalized,[GetTime convertDateWithString:updateTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"]];
    @weakify(self);
    self.head.exchangeBlock = ^{
        @strongify(self);
        [self exchangeBtnAction];
    };
    return self.head;
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
    ExchangeCurrencyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kExchangeCurrencyTableViewCell];
    cell.currencyInfo = self.showCurrencyItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ExchangeCurrencyViewController*vc = [ExchangeCurrencyViewController new];
//    vc.currencyExchangeInfo = self.showCurrencyItems[indexPath.row];
//    vc.currencyItems = self.currencyItems;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

/** 兑换 也就是购买 */
- (IBAction)exchangeBtnAction {
    NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:self.head.saleTextField.text];
    if (self.head.currencyExchangeInfo.min.doubleValue>amount.doubleValue||amount.doubleValue>=self.head.currencyExchangeInfo.max.doubleValue) {
        [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@%@ %@%@",self.head.currencyExchangeInfo.toCode,@"MaximumAmount".icanlocalized,self.head.currencyExchangeInfo.max,@"MinimumAmount".icanlocalized,self.head.currencyExchangeInfo.min] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"Sure".icanlocalized] handler:^(int index) {
            
        }];
        return;
    }
    [self.mange showExhangeViewCurrencyExchangeInfo:self.currencyExchangeInfo amount:amount.stringValue successBlock:^(NSString * _Nonnull password) {
        PostC2CCurrencyExchangeRequest * request =[PostC2CCurrencyExchangeRequest request];
        request.fromCode = self.head.currencyExchangeInfo.fromCode;
        request.toCode = self.head.currencyExchangeInfo.toCode;
        request.money = [NSDecimalNumber decimalNumberWithString:self.head.saleTextField.text];
        request.payPassword = password;
        request.parameters = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            [QMUITipsTool showOnlyTextWithMessage:@"ExchangeSuccessful".icanlocalized inView:self.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:kBuyCurrencySuccessNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            if ([info.code isEqual:@"pay.password.error"]) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self exchangeBtnAction];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self exchangeBtnAction];
                } else {
                    [UserInfoManager sharedManager].attemptCount = nil;
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                }
            } else {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }
        }];
    }];
    
    
}

-(NSMutableArray<CurrencyInfo *> *)fromCurrencyItems{
    if (!_fromCurrencyItems) {
        _fromCurrencyItems = [NSMutableArray array];
    }
    return _fromCurrencyItems;
}
/** 牌价列表 */
-(void)getCurrencyRequest{
    GetC2CExchangeRequest*request = [GetC2CExchangeRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyExchangeInfo class] success:^(NSArray* response) {
        self.currencyItems = response;
        self.currencyExchangeInfo = response.firstObject;
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ ",self.currencyExchangeInfo.fromCode];
        self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(ExchangeCurrencyViewHead *)head{
    if (!_head) {
        _head = [[NSBundle mainBundle]loadNibNamed:@"ExchangeCurrencyViewHead" owner:self options:@{}].firstObject;
        @weakify(self);
        _head.currencyCodeBlock = ^(CurrencyExchangeInfo * _Nonnull code) {
            @strongify(self);
            self.currencyExchangeInfo = code;
            NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ ",self.currencyExchangeInfo.fromCode];
            self.showCurrencyItems = [self.currencyItems filteredArrayUsingPredicate:gpredicate];
            [self.tableView reloadData];
        };
        
    }
    return _head;
}
@end
