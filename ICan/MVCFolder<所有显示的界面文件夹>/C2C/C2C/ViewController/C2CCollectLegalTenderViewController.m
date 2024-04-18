//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 24/11/2021
 - File name:  C2CSelectLegalTenderViewController.m
 - Description:
 - Function List:
 */


#import "C2CCollectLegalTenderViewController.h"
#import "C2CSelectLegalTenderTableViewCell.h"
#import "C2CSelectLegalTenderHeadView.h"
#import "C2CCollectLegalTenderHeadView.h"
#import "UIViewController+Extension.h"

@interface C2CCollectLegalTenderViewController ()
/** 支持的全部法币 */
@property (nonatomic, strong) NSArray<C2CCollectCurrencyInfo*> *showLegalTenderItems;
@property (nonatomic, strong) C2CCollectLegalTenderHeadView *headView;

@end

@implementation C2CCollectLegalTenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"mine.listView.cell.collect".icanlocalized;
    [self getCollectCurrencyRequest];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerNib:[UINib nibWithNibName:@"C2CCollectLegalTenderHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"C2CCollectLegalTenderHeadView"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kC2CSelectLegalTenderTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showLegalTenderItems.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CSelectLegalTenderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CSelectLegalTenderTableViewCell];
    
    cell.collectInfo = self.showLegalTenderItems[indexPath.row];;
    cell.selectBlock = ^(BOOL select) {
        [self collectOrCancelCollect:select code:self.showLegalTenderItems[indexPath.row].code];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CCollectCurrencyInfo* info = self.showLegalTenderItems[indexPath.row];
    CurrencyInfo*currencyInfo = [[CurrencyInfo alloc]init];
    currencyInfo.code = info.code;
    C2CUserManager.shared.currentCurrencyInfo = currencyInfo;
    !self.selectBlock?:self.selectBlock(currencyInfo);
    [self removeVcWithArray:@[@"C2CSelectLegalTenderViewController"]];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(C2CCollectLegalTenderHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"C2CCollectLegalTenderHeadView" owner:self options:nil].firstObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 45);
    }
    return _headView;
}

-(void)getCollectCurrencyRequest{
    GetC2CCollectCurrencyRequest * request = [GetC2CCollectCurrencyRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CCollectCurrencyInfo class] success:^(NSArray* response) {
        self.showLegalTenderItems = response;
        C2CUserManager.shared.collectCurrencyItems = response;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)collectOrCancelCollect:(BOOL)select code:(NSString*)code{
    if (select) {
        PostC2CCollectCurrencyRequest * request = [PostC2CCollectCurrencyRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/currency/collect/%@",code];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            [self getCollectCurrencyRequest];
            !self.changeBlock?:self.changeBlock();
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
    }else{
        DeleteC2CCollectCurrencyRequest * request = [DeleteC2CCollectCurrencyRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/currency/collect/%@",code];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            [self getCollectCurrencyRequest];
            !self.changeBlock?:self.changeBlock();
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
    }
    
}
@end
