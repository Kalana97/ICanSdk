//
//  BusinessBaseTableListViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessBaseTableListViewController.h"
#import "BusinessNetworkReqManager.h"

@interface BusinessBaseTableListViewController ()
@property (nonatomic,strong)MJRefreshBackNormalFooter *footer;
@end

@implementation BusinessBaseTableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = self.footer;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableViewCell *lastCell = self.tableView.visibleCells.lastObject;
    NSIndexPath *last = [self.tableView indexPathForCell:lastCell];
    if (self.listItems.count - last.row < 5) {
        if (!self.isLoadMoreData) {
            self.isAutoLoad = YES;
            self.isLoadMoreData = YES;
            [self loadMore];
        }
    }
}

-(void)refreshList{
    self.current = 1;
    self.pageSize = 20;
    [self fetchListRequest];
}

-(void)loadMore{
    if (self.listInfo.records.count == 0) {
        [self endingRefresh];
        return;
    }
    self.current++;
    [self fetchListRequest];
}

-(void)checkHasFooter{
    if (self.listInfo.records.count == 0) {
        self.tableView.mj_footer = nil;
    }else{
        self.tableView.mj_footer = self.footer;
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    }
}

-(void)fetchListRequest{
    self.listRequest.size = @(self.pageSize);
    self.listRequest.current = @(self.current);
    self.listRequest.parameters = [self.listRequest mj_JSONObject];
    if (!self.isAutoLoad) {
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    }
    @weakify(self);
    [[BusinessNetworkReqManager shareManager]startRequest:self.listRequest responseClass:[self.listClass class] contentClass:[self.listClass class] success:^(BusinessListInfo *response) {
        @strongify(self);
        self.isLoadMoreData = NO;
        self.isAutoLoad = NO;
        self.listInfo = response;
        [self handleFetchlistSuccess:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self endingRefresh];
        self.isAutoLoad = NO;
        self.isLoadMoreData = NO;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)handleFetchlistSuccess:(BusinessListInfo *)response{
    if (self.current == 1) {
        self.listItems = [NSMutableArray arrayWithArray:response.records];
    }else{
        [self.listItems addObjectsFromArray:response.records];
    }
    [self checkHasFooter];
    [self endingRefresh];
    [self.tableView reloadData];
}

-(void)endingRefresh{
    [QMUITips hideAllTips];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(NSMutableArray *)listItems{
    if (!_listItems) {
        _listItems = [NSMutableArray array];
    }
    return _listItems;
}

@end
