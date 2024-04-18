
#import "FriendListTableViewController.h"
#import "AddFriendsViewController.h"
#import "UITableView+SCIndexView.h"
#import "NewFriendsViewController.h"
#import "GroupListViewController.h"

#import "FriendListTableViewCell.h"
#import "FriendDetailViewController.h"
#import "FriendListFirstHeaderView.h"
#import "GroupApplyTableViewController.h"
#import "FriendListTableViewHeaderView.h"
#import "FriendListNavBarView.h"

#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+GroupApplyInfo.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+UserMessageInfo.h"
@interface FriendListTableViewController ()<WebSocketManagerDelegate,SCIndexViewDelegate>
@property(nonatomic, strong) FriendListNavBarView *navBarView;
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo*> *friendItem;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic, strong) UILabel *footerLabel;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;
@property(nonatomic, strong) UIButton *rightButton;

@property(nonatomic, strong) FriendListTableViewHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarHeight;
@end

@implementation FriendListTableViewController


-(instancetype)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kReceiveFriendApplyNotication object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kAgreeFriendNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kUpdateFriendSubscriptionReadNotication object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"chatlist.menu.list.contacts".icanlocalized;
    self. queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
    [self loadCacheData];
    [self getFriendsListRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadCacheData) name:KUpdateFriendRemarkNotification object:nil];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFriendsListRequest) name:kAgreeFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFriendsListRequest) name:kDeleteFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUnreadCount) name:KreceivedApplyJoinGroupNotification object:nil];
    self.tableView.tableFooterView=self.footerLabel;
    [self updateUnreadCount];
    [self updateFriendUnreadCount];
}

-(void)loadCacheData{
    if(self.friendItem.count == 0){
        self.friendItem = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    }
    [self sortObjectsAccordingToInitialWith:self.friendItem];
}
-(void)updateFriendUnreadCount{
    NSInteger unReadAmount=[[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    if (unReadAmount==0) {
        self.headerView.friendUnReadLab.hidden=YES;
    }else{
        self.headerView.friendUnReadLab.hidden=NO;
        self.headerView.friendUnReadLab.text=[NSString stringWithFormat:@"%ld",(long)unReadAmount];
    }
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    self.tableView.tableHeaderView = self.headerView;
    
}
-(void)layoutTableView{
    
}
// 按首字母分组排序数组
-( void)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    __block int nameCount;
    /*任务a */
    dispatch_group_enter(self.group);
    dispatch_group_async(self.group, self.queue, ^{
        // 初始化UILocalizedIndexedCollation
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        
        //得出collation索引的数量，这里是27个（26个字母和1个#）
        NSInteger sectionTitlesCount = [[collation sectionTitles] count];
        //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
        //
        NSMutableArray *newSectionsArray= [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        
        //初始化27个空数组加入newSectionsArray
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
        }
        nameCount = 0;
        //Divide each name into a section
        for (UserMessageInfo *personModel in arr) {
            if (![personModel.chatType  isEqual: @"MALL"]){
                //Get the location of the value of the name attribute, such as "Lin Dan", the first letter is L, and it ranks 11th in A~Z (the first place is 0) Get the location of the value of the name attribute, such as " Lin Dan", the first letter is L, and it ranks 11th in A~Z (the first one is 0, sectionNumber is 11
                nameCount = nameCount + 1;
                NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:personModel.remarkName? @selector(remarkName):@selector(nickname)];
                //Add p whose name is "Lin Dan" to the 11th array in newSectionsArray Add p whose name is "Lin Dan" to the 11th array in newSectionsArray
                NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
                [sectionNames addObject:personModel];
            }
        }
        NSMutableArray *finalArr = [NSMutableArray new];
        NSMutableArray*index=[NSMutableArray array];
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
                [finalArr addObject:newSectionsArray[index]];
            }
        }
        for (NSArray*array in finalArr) {
            UserMessageInfo*info=array.firstObject;
            
            [index addObject:[NSString firstCharactorWithString:info.remarkName?info.remarkName:info.nickname]];
        }
        self.letterResultArr =[NSMutableArray arrayWithArray:finalArr];
        self.indexArray=[NSMutableArray arrayWithArray:index];
        dispatch_group_leave(self.group);
    });
    dispatch_group_notify(self.group,self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.sc_indexViewDataSource = self.indexArray.copy;
            SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
            self.tableView.sc_indexViewConfiguration = configuration;
//            self.tableView.sc_indexView.delegate=self; ---> unnecessary re-initialize , but better to keep it like this in future senarios ,for now its unnecessary.
            self.footerLabel.text=[NSString stringWithFormat:@"%d%@",nameCount,[@"friend.listView.footer.muchFriends" icanlocalized:@"位朋友及联系人"]];
            [self.tableView reloadData];
        });
        
    });
    
}
-(void)indexView:(SCIndexView *)indexView didSelectAtSection:(NSUInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section+1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
/**
 当滑动tableView时，索引位置改变，你需要自己返回索引位置时，实现此方法。
 不实现此方法，或者方法的返回值为 SCIndexViewInvalidSection 时，索引位置将由控件内部自己计算。
 
 @param indexView 索引视图
 @param tableView 列表视图
 @return          索引位置
 */
- (NSUInteger)sectionOfIndexView:(SCIndexView *)indexView tableViewDidScroll:(UITableView *)tableView{
    NSInteger firstVisibleSection = self.tableView.indexPathsForVisibleRows.firstObject.section;
    return firstVisibleSection;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[@"timeline.post.operation.delete" icanlocalized:@"删除"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"DeleteFriendRemind", 是否删除好友) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteFriendAtIndexPath:indexPath];
            
        }];
        [alert addAction:cancel];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    return @[deleted];
    
    
    
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
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    if([self.letterResultArr objectAtIndex:indexPath.section][indexPath.row] != nil) {
        cell.userMessageInfo = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.letterResultArr.count > 0){
        if([self.letterResultArr objectAtIndex:indexPath.section][indexPath.row] != nil){
            UserMessageInfo *info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
            FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
            vc.friendDetailType = FriendDetailType_push;
            vc.userMessageInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)addFriends {
    AddFriendsViewController *AddFriendsVC = [[AddFriendsViewController alloc]init];
    [self.navigationController pushViewController:AddFriendsVC animated:YES];
}
-(void)updateUnreadCount{
    
    NSNumber* groupNoticeUnReadAmount=[[WCDBManager sharedManager]getAllGroupApplyUnReadCount];
    if (groupNoticeUnReadAmount.intValue==0) {
        self.headerView.groupNoticeUnReadLab.hidden=YES;
    }else{
        self.headerView.groupNoticeUnReadLab.hidden=NO;
        self.headerView.groupNoticeUnReadLab.text=[NSString stringWithFormat:@"%d",groupNoticeUnReadAmount.intValue];
    }
}
-(FriendListNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NSBundle mainBundle]loadNibNamed:@"FriendListNavBarView" owner:self options:nil].firstObject;
        _navBarView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarAndNavigationBarHeight);
        _navBarView.navbarHeight.constant = StatusBarAndNavigationBarHeight;
        _navBarView.titleLabel.text = @"tabbar.friends".icanlocalized;;
        @weakify(self);
        _navBarView.publishBlock = ^{
            @strongify(self);
            [self addFriends];
        };
        
    }
    return _navBarView;
}
-(FriendListTableViewHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"FriendListTableViewHeaderView" owner:self options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 370);
        @weakify(self);
        _headerView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        
        _headerView.friendBlock = ^{
            @strongify(self);
            NewFriendsViewController *newFriendsVC = [[NewFriendsViewController alloc]initWithStyle:UITableViewStyleGrouped];
            [[WCDBManager sharedManager]updateFriendSubscriptionInfoHasRead];
            [self updateUnreadCount];
            [self.navigationController pushViewController:newFriendsVC animated:YES];
        };
        _headerView.groupNoticeBlock = ^{
            @strongify(self);
            GroupApplyTableViewController *groupListVC = [[GroupApplyTableViewController alloc]init];
            //把所有的未读消息更新为已读
            [[WCDBManager sharedManager]updateGroupApplyInfoHasRead];
            [self updateUnreadCount];
            [self.navigationController pushViewController:groupListVC animated:YES];
        };
    }
    return _headerView;
}
-(void)searFriendWithText:(NSString*)searchText{
    //如果是退出群聊 那么里面的选择都是群成员
    
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@",searchText,searchText];
    NSArray*searArray= [self.friendItem filteredArrayUsingPredicate:gpredicate];
    [self sortObjectsAccordingToInitialWith:searArray];
    
    if ([NSString isEmptyString:searchText]) {
        [self sortObjectsAccordingToInitialWith:self.friendItem];
    }
}
-(UILabel *)footerLabel{
    if (!_footerLabel) {
        _footerLabel=[UILabel centerLabelWithTitle:nil font:16 color:UIColor153Color];
        _footerLabel.frame=CGRectMake(0, 0, ScreenWidth,50);
    }
    return _footerLabel;
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton dzButtonWithTitle:nil image:@"icon_chat__nav_add" backgroundColor:UIColor.clearColor titleFont:9 titleColor:nil target:self action:@selector(addFriends)];
    }
    return _rightButton;
}
#pragma mark -- 获取好友列表 Get friend list
-(void)getFriendsListRequest {
    GetFriendsListRequest * request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        [self sortObjectsAccordingToInitialWith:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)deleteFriendAtIndexPath:(NSIndexPath *)indexPath{
    UserMessageInfo * model = self.letterResultArr[indexPath.section][indexPath.row];
    DeleteFriendRequest*request=[DeleteFriendRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/userFriend/%@",model.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfully deleted",成功删除) inView:self.view];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = model.userId;
        config.chatType = UserChat;
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:model.userId];
        [[WCDBManager sharedManager]deleteFriendSubscriptionInfoWithSender:model.userId];
        [[WCDBManager sharedManager]updateFriendRelationWithUserId:model.userId isFriend:NO];
        [[WCDBManager sharedManager]deleteOneChatSettingWithChatId:model.userId chatType:UserChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]deleteUserMessageInfoWithUserId:model.userId];
        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil];
        [self.friendItem removeObject:model];
        [self sortObjectsAccordingToInitialWith:self.friendItem];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
@end

