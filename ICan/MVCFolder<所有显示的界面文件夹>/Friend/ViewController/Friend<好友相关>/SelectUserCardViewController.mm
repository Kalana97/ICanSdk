//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 17/10/2019
 - File name:  SelectUserCardViewController.m
 - Description:
 - Function List:
 */


#import "SelectUserCardViewController.h"
#import "SearchHeadView.h"
#import "FriendListTableViewCell.h"
#import "FriendListFirstHeaderView.h"
#import "UITableView+SCIndexView.h"
#import "ShowSendUserCarSureView.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "ChatModel.h"
@interface SelectUserCardViewController ()<SCIndexViewDelegate>
@property (nonatomic,strong) NSMutableArray<UserMessageInfo*> *friendItem;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;
@property(nonatomic, strong) SearchHeadView *chatListSearchHeadView;
@property(nonatomic, strong) ShowSendUserCarSureView *sureView;
@end

@implementation SelectUserCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"SelectUserCardViewController.title", 选择朋友);
    self. queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    self.tableView.tableHeaderView=self.chatListSearchHeadView;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UIAlertController.cancel.title".icanlocalized target:self action:@selector(rightButtonAciton)];
    [self loadCacheData];
}
-(SearchHeadView *)chatListSearchHeadView{
    if (!_chatListSearchHeadView) {
        _chatListSearchHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _chatListSearchHeadView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _chatListSearchHeadView.shouShowKeybord=YES;
        ViewRadius(_chatListSearchHeadView.bgView, 15.0);
        @weakify(self);
        _chatListSearchHeadView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        
    }
    return _chatListSearchHeadView;
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
-(void)rightButtonAciton{
    self.backAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadCacheData{
    self.friendItem = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    [self sortObjectsAccordingToInitialWith:self.friendItem];
    
}
// 按首字母分组排序数组
-( void)sortObjectsAccordingToInitialWith:(NSMutableArray *)arr {
    if ([self.config.chatType isEqual: UserChat]) {
        for (UserMessageInfo * info in arr) {
            if ([info.userId isEqualToString:self.config.chatID]) {
                [self.friendItem removeObject:info];
                break;
            }
        }
    }
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
        
        //将每个名字分到某个section下
        for (UserMessageInfo *personModel in arr) {
            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
            NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:personModel.remarkName? @selector(remarkName):@selector(nickname)];
            //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
            NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
            [sectionNames addObject:personModel];
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
    dispatch_group_notify(self.group,dispatch_get_main_queue(), ^{
        self.tableView.sc_indexViewDataSource = self.indexArray.copy;
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
        self.tableView.sc_indexViewConfiguration = configuration;
        self.tableView.sc_indexView.delegate=self;
        [self.tableView reloadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.letterResultArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.letterResultArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightFriendListTableViewCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];;
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    NSArray*array=[self.letterResultArr objectAtIndex:indexPath.section];
    cell.userMessageInfo=[array objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (self.letterResultArr.count == 0) {
        return;
    }
    self.sureView.info=self.letterResultArr[indexPath.section][indexPath.row];
    [self.view endEditing:YES];
    [self.sureView showView];
    @weakify(self);
    self.sureView.sureBlock = ^{
        @strongify(self);
        if (self.selectUserChatBlock) {
            self.selectUserChatBlock(self.letterResultArr[indexPath.section][indexPath.row],@"dd");
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    
}
-(ShowSendUserCarSureView *)sureView{
    if (!_sureView) {
        _sureView=[[NSBundle mainBundle]loadNibNamed:@"ShowSendUserCarSureView" owner:self options:nil].firstObject;
        _sureView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _sureView;
}
@end
