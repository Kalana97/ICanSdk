//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 30/10/2019
 - File name:  SelectAtUserTableViewController.m
 - Description:
 - Function List:
 */


#import "SelectAtTimelineTableViewController.h"
#import "FriendListTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "FriendListFirstHeaderView.h"
#import "WCDBManager+UserMessageInfo.h"
@interface SelectAtTimelineTableViewController ()<QMUISearchControllerDelegate>
@property (nonatomic,strong) NSArray<UserMessageInfo*> * groupMembers;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo*> *searchResultArray;
@end

@implementation SelectAtTimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldShowSearchBar=YES;
    self.title=NSLocalizedString(@"SelectAtUser",选择提醒的人);
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"Cancel", nil) target:self action:@selector(cancleAction)];
    [self.searchController.tableView registNibWithNibName:kFriendListTableViewCell];
    self.groupMembers = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    [self sortFriens:self.groupMembers];
}
-(void)cancleAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightFriendListTableViewCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.letterResultArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)self.letterResultArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView) {
        FriendListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
        cell.userMessageInfo=self.letterResultArr[indexPath.section][indexPath.row];
        return cell;
    }
    FriendListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.userMessageInfo=self.letterResultArr[indexPath.section][indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.atSingleBlcok) {
        self.atSingleBlcok([self.letterResultArr objectAtIndex:indexPath.section][indexPath.row]);
    }
    self.searchController.active=NO;
    
}
-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[NSMutableDictionary dictionary];
    for (UserMessageInfo * userMessageInfo in friendListCoreDataArray) {
        NSMutableArray*array=[friendDict objectForKey:[NSString firstCharactorWithString:userMessageInfo.remarkName?:userMessageInfo.nickname]];
        if (!array) {
            array=[NSMutableArray array];
            [friendDict setObject:array forKey:[NSString firstCharactorWithString:userMessageInfo.remarkName?:userMessageInfo.nickname]];
        }
        [array addObject:userMessageInfo];
    }
    //获取排序之后的字母
    NSArray *sortArray=  [friendDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexArray=[NSMutableArray arrayWithArray:sortArray];
    self.letterResultArr=[NSMutableArray array];
    if ([sortArray containsObject:@"#"]) {
        [self.indexArray removeObject:@"#"];
        [self.indexArray addObject:@"#"];
    }
    
    for (NSString * key in self.indexArray) {
        
        [self.letterResultArr addObject:[friendDict objectForKey:key]];
    }
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    self.tableView.sc_indexViewConfiguration = configuration;
    [self.searchController.tableView reloadData];
    [self.tableView reloadData];
    
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    
    [self.searchResultArray removeAllObjects];
    for (UserMessageInfo*info in self.groupMembers) {
        if ([info.nickname containsString:searchString]||[info.remarkName containsString:searchString]) {
            [self.searchResultArray addObject:info];
        }
    }
    [self sortFriens:self.searchResultArray];
    
}
-(void)willPresentSearchController:(QMUISearchController *)searchController{
    [self.letterResultArr removeAllObjects];
    [self.indexArray removeAllObjects];
}
-(void)didDismissSearchController:(QMUISearchController *)searchController{
    [self sortFriens:self.groupMembers];
}



-(NSMutableArray<UserMessageInfo *> *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray=[NSMutableArray array];
    }
    return _searchResultArray;
}

@end
