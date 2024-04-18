//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 30/10/2019
 - File name:  SelectAtUserTableViewController.m
 - Description:
 - Function List:
 */


#import "SelectAtUserTableViewController.h"
#import "FriendListTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "FriendListFirstHeaderView.h"
#import "SearchHeadView.h"
@interface SelectAtUserTableViewController ()<QMUISearchControllerDelegate>
@property(nonatomic,strong)  NSArray<GroupMemberInfo*> * groupMembers;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic,strong)  SearchHeadView *searchView;
@property(nonatomic, assign) BOOL didMultipleSelectionEnable;
@property(nonatomic, assign) NSString *btnLabelData;
@property(nonatomic, strong) NSMutableArray *selectedGroupMembers;
@property(nonatomic, strong) NSMutableArray *atAllGroupMembers;

@end

@implementation SelectAtUserTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchGroupMemberInfo];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"Cancel", nil) target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"Multiple", nil) target:self action:@selector(selectAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectUser:) name:@"userSelection" object:nil];
    self.didMultipleSelectionEnable = NO;
}

- (void) selectUser:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"userSelection"]){
        GroupMemberInfo *objectMember = notification.object;
        if ([self.selectedGroupMembers containsObject:objectMember]) {
            [self.selectedGroupMembers removeObject:objectMember];
            objectMember.isMultipleSelected = NO;
            [self.tableView reloadData];
            if ((self.selectedGroupMembers.count) > 0){
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }else{
            [self.selectedGroupMembers addObject:objectMember];
            objectMember.isMultipleSelected = YES;
            [self.tableView reloadData];
            if ((self.selectedGroupMembers.count) > 0){
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }
    }
}
-(NSMutableArray *)selectedGroupMembers{
    if (!_selectedGroupMembers) {
        _selectedGroupMembers=[NSMutableArray array];
    }
    return _selectedGroupMembers;
}

-(NSMutableArray *)atAllGroupMembers{
    if (!_atAllGroupMembers) {
        _atAllGroupMembers=[NSMutableArray array];
    }
    return _atAllGroupMembers;
}

-(void)cancleAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)selectAction{
    self.didMultipleSelectionEnable = !self.didMultipleSelectionEnable;
    if ((self.selectedGroupMembers.count) > 0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    self.didMultipleSelectionEnable ? self.btnLabelData = @"Send".icanlocalized : self.btnLabelData = @"Multiple".icanlocalized;
    if([self.navigationItem.rightBarButtonItem.title  isEqual: @"Send"]){
        for (GroupMemberInfo *memberItem in self.selectedGroupMembers) {
            if (self.atSingleBlcok) {
                self.atSingleBlcok(memberItem);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.navigationItem.rightBarButtonItem.title = self.btnLabelData;
    [self.tableView reloadData];
}

-(void)initTableView{
    if (self.isNeedAtAll){
        [super initTableView];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 35, 35)];
        imageView.image = [UIImage imageNamed: @"img_default_groud"];
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        [headerView addSubview:imageView];
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(64, 83, ScreenWidth, 10)];
        labelView.text = @"All";
        [headerView addSubview:labelView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, ScreenWidth, 0.5)];
        lineView.layer.backgroundColor = [UIColorMakeWithAlpha(229, 229, 234, 0.6) CGColor];
        [headerView addSubview:lineView];
        UIButton *setAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
        [setAllBtn addTarget:self action:@selector(setAllUsers)forControlEvents:UIControlEventTouchUpInside];
        setAllBtn.tintColor = [UIColor clearColor];
        [headerView addSubview:setAllBtn];
        [headerView addSubview:self.searchView];
        self.tableView.tableHeaderView = headerView;
        [self.tableView registNibWithNibName:kFriendListTableViewCell];
        [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    }else{
        [super initTableView];
        self.tableView.tableHeaderView = self.searchView;
        [self.tableView registNibWithNibName:kFriendListTableViewCell];
        [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    }
}

-(void)setAllUsers{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.atSingleBlcokAll) {
        self.atSingleBlcokAll(self.atAllGroupMembers);
    }
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
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.selectionBtnStatus = self.didMultipleSelectionEnable;
    cell.groupMemberInfo = self.letterResultArr[indexPath.section][indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FriendListFirstHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didMultipleSelectionEnable){
        GroupMemberInfo *objectMember = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        if ([self.selectedGroupMembers containsObject:objectMember]) {
            [self.selectedGroupMembers removeObject:objectMember];
            objectMember.isMultipleSelected = NO;
            [self.tableView reloadData];
            if ((self.selectedGroupMembers.count) > 0){
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }else{
            [self.selectedGroupMembers addObject:objectMember];
            objectMember.isMultipleSelected = YES;
            [self.tableView reloadData];
            if ((self.selectedGroupMembers.count) > 0){
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
        if (self.atSingleBlcok) {
            if(self.letterResultArr.count > 0){
                self.atSingleBlcok([self.letterResultArr objectAtIndex:indexPath.section][indexPath.row]);
            }
        }
    }
}

-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[NSMutableDictionary dictionary];
    for (GroupMemberInfo * userMessageInfo in friendListCoreDataArray) {
        NSMutableArray*array = [friendDict objectForKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?:userMessageInfo.nickname]];
        if (!array) {
            array=[NSMutableArray array];
            [friendDict setObject:array forKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?:userMessageInfo.nickname]];
        }
        [array addObject:userMessageInfo];
    }
    //获取排序之后的字母
    NSArray *sortArray=  [friendDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexArray = [NSMutableArray arrayWithArray:sortArray];
    self.letterResultArr = [NSMutableArray array];
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

-(void)fetchGroupMemberInfo{
    GetGroupUserListRequest*request = [GetGroupUserListRequest request];
    request.groupId = self.groupId;
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
        NSMutableArray*array = [NSMutableArray array];
        //去除用户自己
        for (GroupMemberInfo*info in response) {
            if (![info.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
                [array addObject:info];
                [self.atAllGroupMembers addObject:info];
            }
        }
        
        for ( GroupMemberInfo *memberData in self.groupMembers) {
            memberData.isMultipleSelected = NO;
        }
        
        self.groupMembers = array;
        [self sortFriens:array];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}

-(SearchHeadView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _searchView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _searchView.shouShowKeybord = YES;
        ViewRadius(_searchView.bgView, 15.0);
        @weakify(self);
        _searchView.searchDidChangeBlock = ^(NSString * _Nonnull searchString) {
            @strongify(self);
            if (searchString.length) {
                NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || groupRemark CONTAINS[c] %@",searchString,searchString];
                NSArray *array = [self.groupMembers filteredArrayUsingPredicate:gpredicate];
                [self sortFriens:array];
            }
            if (searchString.length == 0) {
                [self sortFriens:self.groupMembers];
            }
        };
        
    }
    return _searchView;
}

@end
