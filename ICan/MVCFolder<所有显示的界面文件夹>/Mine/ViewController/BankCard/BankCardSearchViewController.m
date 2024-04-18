//
//  BankCardSearchViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardSearchViewController.h"
#import "BankCardSearchCollectionViewCell.h"
#import "SearchHeadView.h"
#import "BankCardSearchTableViewCell.h"


@interface BankCardSearchViewController ()
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property(nonatomic, strong) SearchHeadView *searchHeaderView;
@property(nonatomic, strong)NSArray<CommonBankCardsInfo*> *searchBankCardsInfoItems;



@end

@implementation BankCardSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString(@"Search", 搜索);
    [self initUI];
    [self.tableView registNibWithNibName:KBankCardSearchTableViewCell];
    
}

-(void)initUI{
    [self.view addSubview:self.searchHeaderView];
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@55);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight));
    }];
}

-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(@0);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight+55));
        
    }];
}

-(void)layoutTableView{
    
}

-(SearchHeadView *)searchHeaderView{
    if (!_searchHeaderView) {
        _searchHeaderView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _searchHeaderView.searchTextFiledPlaceholderString=NSLocalizedString(@"Searchbank", 搜索银行);
        _searchHeaderView.shouShowKeybord=YES;
        @weakify(self);
        _searchHeaderView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searchBankNameRequestWith:search];
        };
    }
    return _searchHeaderView;
}

-(void)reloadsearchTableView{
    [self.tableView reloadData];
    self.collectionView.hidden =YES;
    self.tableView.hidden = NO;
    
}

-(void)hideTableview{
    self.tableView.hidden = YES;
    self.collectionView.hidden =NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchBankCardsInfoItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightBankCardSearchTableViewCell;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KBankCardSearchTableViewCell];
    cell.commonBankCardsInfo = [self.searchBankCardsInfoItems objectAtIndex:indexPath.row];
    return cell;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.searchBankcarBlock?:self.searchBankcarBlock(self.searchBankCardsInfoItems[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    view.backgroundColor= UIColorViewBgColor;
    UILabel*label=[UILabel leftLabelWithTitle:@"Searchcontent".icanlocalized font:14 color:UIColorThemeMainTitleColor];
    label.frame=CGRectMake(15, 0, 300, 30);
    [view addSubview:label];
    return view;
}

-(void)searchBankNameRequestWith:(NSString *)search{
    CommonBankCardsRequest * request = [CommonBankCardsRequest request];
    request.name =search;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CommonBankCardsInfo class] success:^(NSArray* response) {
        self.searchBankCardsInfoItems =response;
        [self reloadsearchTableView];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
}



@end
