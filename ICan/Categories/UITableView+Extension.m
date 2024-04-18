//
//  UITableView+Extension.m
//  GongShuQu
//
//  Created by SevenCat on 16/5/13.
//  Copyright © 2016年 拱墅区. All rights reserved.
//

#import "UITableView+Extension.h"
#import "MJRefresh.h"
#define     HEIGHT_STATUSBAR            20.0f
#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f

@implementation UITableView (Extension)

#pragma mark -- 设置搜索框 --
- (UISearchController *)setSearchControllerWithPlaceHolder:(NSString *)placeHolder target:(id)target {
    // 初始化 搜索器
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // 设置代理
    searchController.delegate  = target;
    searchController.searchBar.delegate = target;

    // 搜索框启动 界面阴影设置，不能对cell操作， 设NO 没有阴影
    searchController.dimsBackgroundDuringPresentation = YES;
    // 设置搜索框
    [searchController.searchBar sizeToFit];
    
    searchController.searchBar.placeholder = placeHolder;
    
    // 设置返回return键的样式
    searchController.searchBar.returnKeyType = UIReturnKeySearch;
    //搜索框的颜色
    searchController.searchBar.barStyle = UIBarStyleDefault;
    searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

    searchController.searchBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    // 设置search 是都为半透明
    searchController.searchBar.translucent = NO;
    self.tableHeaderView = searchController.searchBar;
    
    return searchController;
}







#pragma mark -- 注册 Nibcell --
- (void)registNibWithNibName:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
}

#pragma mark -- 注册 classcell --
- (void)registClassWithClassName:(NSString *)className {
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
}

#pragma mark -- 设置tableView的属性 --
- (void)setTableViewSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    
    // 不显示多余的cell
//    self.tableFooterView = [[UIView alloc] initWithFrame:(CGRectZero)];
//    // cell间线条样式
    self.separatorStyle = separatorStyle;
}


#pragma mark -- 设置下拉刷新和上拉加载 --
- (void)setMJRefreshWithTarget:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction {
    
    [self setMJRefreshWithTarget:target refreshAction:refreshAction];
    [self setMJRefreshWithTarget:target loadMoreAction:loadMoreAction];
   
}
#pragma mark -- 设置下拉刷新--
- (void)setMJRefreshWithTarget:(id)target refreshAction:(SEL)refreshAction {
    
    MJRefreshNormalHeader *headerView = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:refreshAction];
    [headerView setTitle:@"下拉刷新~" forState:MJRefreshStateIdle];
    [headerView setTitle:@"松开刷新~" forState:MJRefreshStatePulling];
    [headerView setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.mj_header = headerView;
}

#pragma mark -- 设置上拉加载 --
- (void)setMJRefreshWithTarget:(id)target loadMoreAction:(SEL)loadMoreAction {
    MJRefreshBackNormalFooter *footerView = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:loadMoreAction];
    [footerView setTitle:@"上拉获取更多~" forState:MJRefreshStateIdle];
    [footerView setTitle:@"松开刷新~" forState:MJRefreshStatePulling];
    [footerView setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.mj_footer = footerView;
    self.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
}

#pragma mark == 结束刷新 ==
- (void)endRefreshWithPage:(NSInteger)page {
    if (page == 1) {
        [self.mj_header endRefreshing];
    } else {
        [self.mj_footer endRefreshing];
    }
}

#pragma mark == 结束刷新并对结果做判断
- (void)endRefreshWithPage:(NSInteger)page headerBlock:(void(^)(void))headerBlock footerBlock:(void(^)(void))footerBlock {
   
    if (page == 1) {
        
//        dispatch_main_async_safe(^{
            [self.mj_header endRefreshing];
//        });
        
        if (headerBlock) {
            headerBlock();
            headerBlock = nil;
        }
    } else {
//        dispatch_main_async_safe(^{
            [self.mj_footer endRefreshing];
//        });
        
        if (footerBlock) {
            footerBlock();
            footerBlock = nil;
        }
    }
}

#pragma mark -- 获取所有的cell --
- (NSArray *)getTableViewAllCellWithNumOfRows:(NSInteger)num section:(NSInteger)section {
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:num];
    for (int i = 0; i < num; i++) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
        [cells addObject:cell];
    }
    return cells;
}

-(void)scrollToTopWithAnimated: (BOOL)animated {
    if([self numberOfSections]>0&&[self numberOfRowsInSection: 0]>0){
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection: 0]atScrollPosition: UITableViewScrollPositionTop animated: animated];
    }
}

-(void)scrollToBottomWithContentOffsetAnimation:(BOOL)animation{
    NSInteger s = [self numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animation];\
    
}

-(void)endHeaderRefreshing{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
