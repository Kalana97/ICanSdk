//
//  BusinessBaseTableListViewController.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "QDCommonTableViewController.h"
#import "BusinessBaseRequest.h"
#import "BusinessBaseResponse.h"
#import <MJRefresh.h>
NS_ASSUME_NONNULL_BEGIN

@interface BusinessBaseTableListViewController : QDCommonTableViewController
@property (nonatomic,assign) NSInteger  current;
@property (nonatomic,assign) NSInteger  pageSize;
@property (nonatomic,strong) BusinessListInfo *listInfo;
@property (nonatomic,strong) BusinessListRequest *listRequest;
@property (nonatomic) Class listClass;
@property (nonatomic,strong) NSMutableArray *listItems;
@property (nonatomic,assign) BOOL  isLoadMoreData;
@property(nonatomic,assign) BOOL isAutoLoad;
-(void)fetchListRequest;
-(void)endingRefresh;
-(void)checkHasFooter;
-(void)loadMore;
-(void)refreshList;
@end

NS_ASSUME_NONNULL_END
