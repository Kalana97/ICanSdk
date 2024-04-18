//
//  TranferAllFriendsViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/7.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "TranferAllFriendsViewController.h"
#import "UITableView+SCIndexView.h"
#import "WCDBManager+UserMessageInfo.h"
#import "FriendListTableViewCell.h"
#import "TransferViewController.h"
#import "FriendListFirstHeaderView.h"
#import "SearchHeadView.h"
@interface TranferAllFriendsViewController ()<WebSocketManagerDelegate,QMUISearchControllerDelegate>
@property(nonatomic,strong) NSMutableArray   <UserMessageInfo*> *friendItem;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray  *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray  *letterResultArr;

@property(nonatomic,strong) UserMessageInfo *userMessageInfo;

@property(nonatomic,strong) SearchHeadView  *tranferAllFriendHeadView;
@end

@implementation TranferAllFriendsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [WebSocketManager sharedManager].delegate = self;
    self.title =NSLocalizedString(@"All my friends", 全部好友);
    [self getFriendsListRequest];
    [self loadCacheData];
}
-(void)loadCacheData{
    self.friendItem = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    [self sortFriens:self.friendItem];
}
-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[NSMutableDictionary dictionary];
    for (UserMessageInfo * userMessageInfo in friendListCoreDataArray) {
        NSMutableArray*array=[friendDict objectForKey:[NSString firstCharactorWithString:userMessageInfo.remarkName?userMessageInfo.remarkName:userMessageInfo.nickname]];
        if (!array) {
            array=[NSMutableArray array];
            [friendDict setObject:array forKey:[NSString firstCharactorWithString:userMessageInfo.remarkName?userMessageInfo.remarkName:userMessageInfo.nickname]];
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
    [self.tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    self.tableView.tableHeaderView = self.tranferAllFriendHeadView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.letterResultArr[section] count];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.userMessageInfo=self.letterResultArr[indexPath.section][indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserMessageInfo*messageInfo = self.letterResultArr[indexPath.section][indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectBlock) {
        self.selectBlock(messageInfo);
    }
    
}

-(void)goToTranferViewControllerWithUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    TransferViewController * vc =[TransferViewController new];
    vc.tranferType = TranfetFrom_wallet;
    vc.userMessageInfo = userMessageInfo;
    vc.authorityType = AuthorityType_friend;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(SearchHeadView *)tranferAllFriendHeadView{
    if (!_tranferAllFriendHeadView) {
        _tranferAllFriendHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _tranferAllFriendHeadView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _tranferAllFriendHeadView.shouShowKeybord=YES;
        ViewRadius(_tranferAllFriendHeadView.bgView, 15.0);
        @weakify(self);
        _tranferAllFriendHeadView.searchDidChangeBlock = ^(NSString * _Nonnull searchString) {
            @strongify(self);
            if (searchString.length) {
                NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@",searchString,searchString];
                NSArray *array = [self.friendItem filteredArrayUsingPredicate:gpredicate];
                [self sortFriens:array];
            }
            if (searchString.length == 0) {
                [self sortFriens:self.friendItem];
            }
        };
        
    }
    return _tranferAllFriendHeadView;
}

#pragma mark -- 获取好友列表
-(void)getFriendsListRequest {
    GetFriendsListRequest * request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        [self sortFriens:self.friendItem];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
    
}



@end
