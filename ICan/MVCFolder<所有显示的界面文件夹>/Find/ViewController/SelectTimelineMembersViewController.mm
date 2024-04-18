//
//  SelectMembersViewController.m
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "SelectTimelineMembersViewController.h"
#import "SelectPersonTableViewCell.h"
//搜索库 可以实现字体颜色匹配
#import "SearchCoreManager.h"
#import "WebSocketManager.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatList.h"
#import "ChatUtil.h"
#import "UITableView+SCIndexView.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "SearchHeadView.h"
#import "FriendListFirstHeaderView.h"
@interface SelectTimelineMembersViewController ()
@property (strong, nonatomic)  UICollectionView *collectionView;


@property(nonatomic,strong)   NSMutableArray<UserMessageInfo*> *choseArray;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong ,nonatomic) UIButton *cancelBtn;
/** 邀请或者创建群聊的时候的好友数组 */
@property (nonatomic,strong)  NSMutableArray<UserMessageInfo*> * friendItems;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property(nonatomic, strong) SearchHeadView *selectMemberSearchHeadView;
@end

@implementation SelectTimelineMembersViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = [@"friend.selectMember.title" icanlocalized:@"选择联系人"];;
    //这句代码可以解决6s plus 10.3.3系统的 一些UI界面问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sureBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self loadCacheData];
    
    
    
}
-(void)loadCacheData{
    self.friendItems = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    for (UserMessageInfo*info in self.friendItems) {
        info.isSelect=[self.userIds containsObject:info.userId];
        if (info.isSelect) {
            [self.choseArray addObject:info];
        }
    }
    for (UserMessageInfo*info in self.friendItems) {
        for (UserMessageInfo*hasInfo in self.selectUsers) {
            if ([hasInfo.userId isEqualToString:info.userId]) {
                info.isSelect=YES;
                [self.choseArray addObject:info];
                break;;
            }
        }
    }
    [self sortFriens:self.friendItems];
}
-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[[NSMutableDictionary alloc]init];
    for (UserMessageInfo * userMessageInfo in friendListCoreDataArray) {
        userMessageInfo.canEnabled=YES;
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
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.tableHeaderView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.sectionFooterHeight=0.1;
    self.tableView.sectionHeaderHeight=20;
    [self.tableView registerNib:[UINib nibWithNibName:kSelectPersonTableViewCell bundle:nil] forCellReuseIdentifier:kSelectPersonTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.tableView.tableHeaderView=self.selectMemberSearchHeadView;
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
}
-(SearchHeadView *)selectMemberSearchHeadView{
    if (!_selectMemberSearchHeadView) {
        _selectMemberSearchHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        _selectMemberSearchHeadView.searchTextFiledPlaceholderString = @"Search".icanlocalized;
        _selectMemberSearchHeadView.shouShowKeybord=YES;
        _selectMemberSearchHeadView.searchTipsImageView.image = [UIImage imageNamed:@"icon_search"];
        [_selectMemberSearchHeadView updateConstraint];
        @weakify(self);
        _selectMemberSearchHeadView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
    }
    return _selectMemberSearchHeadView;
}

-(void)searFriendWithText:(NSString*)searchText{
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@",searchText,searchText];
    NSArray*searArray= [self.friendItems filteredArrayUsingPredicate:gpredicate];
    [self sortFriens:searArray ];
    if ([NSString isEmptyString:searchText]) {
        [self sortFriens:self.friendItems ];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectMemberRowAtIndexPath:indexPath];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.letterResultArr.count;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectPersonTableViewCell];
    cell.userMessageInfo = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    @weakify(self);
    cell.buttonBlock = ^{
        @strongify(self);
        [self didSelectMemberRowAtIndexPath:indexPath];
    };
    return cell;
    
}

-(void)didSelectMemberRowAtIndexPath:(NSIndexPath *)indexPath{
    UserMessageInfo*memberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    if (memberInfo.canEnabled) {
        memberInfo.isSelect = !memberInfo.isSelect;
        if (memberInfo.isSelect) {
            [self.choseArray addObject:self.letterResultArr[indexPath.section][indexPath.row]];
        }else{
            [self.choseArray removeObject:self.letterResultArr[indexPath.section][indexPath.row]];
        }
    }
    
    [self sortFriens:self.friendItems ];
    self.selectMemberSearchHeadView.searTextField.text=@"";
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==self.tableView) {
        return 30;
    }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView==self.tableView) {
        FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
        view.titleLabel.text=self.indexArray[section];
        return view;
        
    }
    return nil;
    
}
#pragma mark 懒加载
//不可点击时候绿色 ace4c1 白色 c5ebd2
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sureBtn setFrame:(CGRectMake(0, 0, 50, 30))];
        [_sureBtn setTitle:NSLocalizedString(@"Done", 完成) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorNavBarBackColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(creatAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setFrame:(CGRectMake(0, 0, 50, 30))];
        [_cancelBtn setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorNavBarBackColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _cancelBtn;
}

-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(NSMutableArray *)friendItems{
    if (!_friendItems) {
        _friendItems=[[NSMutableArray alloc]init];
        
    }
    return _friendItems;
}

-(NSMutableArray *)choseArray{
    if (!_choseArray) {
        _choseArray = [NSMutableArray array];
        
    }
    return _choseArray;
}

-(void)loadFriendsRequest{
    
    GetFriendsListRequest * request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
        self.friendItems =[NSMutableArray arrayWithArray:response];
        [self sortFriens:self.friendItems ];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
    
}

-(void)creatAction{
    if (self.choseArray.count == 0) {
        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.addTimelinesAtMemberSuccessBlock) {
            self.addTimelinesAtMemberSuccessBlock(self.choseArray);
        }
    }];
    
}

@end
