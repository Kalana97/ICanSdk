//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 3/12/2019
 - File name:  BaseTableListViewController.m
 - Description:
 - Function List:
 */
#import "BaseTableListViewController.h"

@interface BaseTableListViewController ()
@property (nonatomic,strong)MJRefreshBackNormalFooter*footer;
@end

@implementation BaseTableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)initTableView{
    [super initTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    self.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer=self.footer;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
}
-(void)refreshList{
    self.current=0;
    self.pageSize=20;
    [self fetchListRequest];
}
-(void)loadMore{
    if (self.listInfo.last) {
        [self endingRefresh];
        return;
    }
    self.current++;
    [self fetchListRequest];
}
-(void)checkHasFooter{
    if (self.listInfo.last) {
        self.tableView.mj_footer=nil;
    }else{
        self.tableView.mj_footer=self.footer;
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    }
}
-(void)fetchListRequest{
    if (!self.listRequest) {
        return;
    }
    self.listRequest.size=@(self.pageSize);
    self.listRequest.page=@(self.current);
    self.listRequest.parameters=[self.listRequest mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:self.listRequest responseClass:[self.listClass class] contentClass:[self.listClass class] success:^(ListInfo* response) {
        [self handleFetctListRequestSuccess:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(void)handleFetctListRequestSuccess:(ListInfo*)response{
    self.listInfo=response;
    if (self.current==0) {
        self.listItems=[NSMutableArray arrayWithArray:response.content];
    }else{
        [self.listItems addObjectsFromArray:response.content];
    }
    [self checkHasFooter];
    [self endingRefresh];
    [self doSometingBeforeReloadData:response];
    [self.tableView reloadData];
}
-(void)doSometingBeforeReloadData:(ListInfo*)response{
    
}
-(void)endingRefresh{
    [QMUITips hideAllTips];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

@end
