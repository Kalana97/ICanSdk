//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/11/2019
 - File name:  GroupAllMemberViewController.m
 - Description:
 - Function List:
 */


#import "GroupAllMemberViewController.h"
#import "FriendListTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "FriendDetailViewController.h"
#import "FriendListFirstHeaderView.h"
#import "SearchHeadView.h"
@interface GroupAllMemberViewController ()
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property(nonatomic, strong) SearchHeadView *allMemberSearchHeadView;
@end

@implementation GroupAllMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"AllMembers", 所有群成员);
}
-(SearchHeadView *)allMemberSearchHeadView{
    if (!_allMemberSearchHeadView) {
        _allMemberSearchHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _allMemberSearchHeadView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _allMemberSearchHeadView.shouShowKeybord=YES;
        ViewRadius(_allMemberSearchHeadView.bgView, 15.0);
        @weakify(self);
        _allMemberSearchHeadView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        
    }
    return _allMemberSearchHeadView;
}
-(void)initTableView{
    [super initTableView];
    [self sortFriens:self.allMemberItems];
    self.tableView.tableHeaderView = self.allMemberSearchHeadView;
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightFriendListTableViewCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.groupMemberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
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

-(void)searFriendWithText:(NSString*)searchText{
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || groupRemark CONTAINS[c] %@",searchText,searchText];
    NSArray*searArray= [self.allMemberItems filteredArrayUsingPredicate:gpredicate];
    [self sortFriens:searArray];
    if ([NSString isEmptyString:searchText]) {
        [self sortFriens:self.allMemberItems];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMemberInfo*info=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    if (self.groupDetailInfo.showUserInfo) {
        FriendDetailViewController*vc=[FriendDetailViewController new];
        vc.userId=info.userId;
        vc.friendDetailType = FriendDetailType_push;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if ([self.groupDetailInfo.role isEqualToString:@"0"]||[self.groupDetailInfo.role isEqualToString:@"1"]) {
            FriendDetailViewController*vc=[FriendDetailViewController new];
            vc.userId=info.userId;
            vc.friendDetailType = FriendDetailType_push;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([info.role isEqualToString:@"0"]||[info.role isEqualToString:@"1"]) {
                FriendDetailViewController*vc=[FriendDetailViewController new];
                vc.userId=info.userId;
                vc.friendDetailType = FriendDetailType_push;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
}
-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[NSMutableDictionary dictionary];
    for (GroupMemberInfo * userMessageInfo in friendListCoreDataArray) {
        NSMutableArray*array=[friendDict objectForKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?userMessageInfo.groupRemark:userMessageInfo.nickname]];
        if (!array) {
            array=[NSMutableArray array];
            [friendDict setObject:array forKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?userMessageInfo.groupRemark:userMessageInfo.nickname]];
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
@end
