//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 6/5/2020
 - File name:  ICanHelpViewController.m
 - Description:
 - Function List:
 */


#import "SystemHelperViewController.h"
#import "SystemHelperListTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import <MJRefresh.h>
#import "ICanHelpSettingViewController.h"

@interface SystemHelperViewController ()<WebSocketManagerDelegate>
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
/** 当前插叙的页数 */
@property (nonatomic ,assign) NSInteger offset;
/**当前表格是否正在滑动*/
@property (nonatomic, assign) BOOL isScrollViewScroll;

@end

@implementation SystemHelperViewController
-(void)dealloc{
    [WebSocketManager sharedManager].currentChatID=@"";
    DDLogInfo(@"ICanHelpViewController%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"systemnotification".icanlocalized;
    [WebSocketManager sharedManager].currentChatID = SystemHelperMessageType;
    [self loadMoreMessage];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(push)];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = SystemHelperMessageType;
    config.chatType = UserChat;
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = SystemHelperMessageType;
    config.chatType = UserChat;
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];
    [WebSocketManager sharedManager].delegate = self;
}
-(void)push{
    ICanHelpSettingViewController*vc=[[ICanHelpSettingViewController alloc]init];
    vc.type = ICanHelpSettingTypeSystem;
    vc.deleteMessageBlock = ^{
        [self.msgItems removeAllObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 收到普通的消息
//@param chatModel chatModel description
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if ([chatModel.chatID isEqualToString:SystemHelperMessageType]) {
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) { //trigger when recieve message
                *stop = YES;
                isExist = YES;
            }
        }];
        
        if (!isExist) {
            [self.msgItems addObject:chatModel];
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:NO];
        }
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        self.isScrollViewScroll=YES;
    }else{
        self.isScrollViewScroll=NO;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isScrollViewScroll=NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark 表格开始拖拽滚动，隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView ==self.tableView) {
        self.isScrollViewScroll=YES;
        [self.view endEditing:YES];
    }
    
}
- (void)scrollTableViewToBottom:(BOOL)animated needScroll:(BOOL)needScroll{
    if (self.isScrollViewScroll) {
        return;
    }
    if (self.msgItems.count>0) {
        NSIndexPath*index=[NSIndexPath indexPathForRow:self.msgItems.count-1 inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
        });
    }
    
}
-(void)loadMoreMessage{
    self.offset++;
    [self loadMessage];
}
#pragma mark - 拉取数据库消息
- (void)loadMessage {
    
    NSArray<ChatModel*>*array=[[WCDBManager sharedManager]fetchSystemHelperMessageTypeWithoffset:self.msgItems.count];
    
    if (array.count<5) {
        [self noMoreMessage];
    }
    for (ChatModel*model in array) {
        [self.msgItems insertObject:model atIndex:0];
    }
    [self.tableView reloadData];
    [self.tableView endHeaderRefreshing];
    if (self.msgItems.count>0) {
        NSIndexPath*index=[NSIndexPath indexPathForRow:self.msgItems.count-1 inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
        });
    }
    
}
-(void)noMoreMessage{
    [self.tableView.mj_header endRefreshing];
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView.mj_header removeFromSuperview];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kSystemHelperListTableViewCell];
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    NSMutableArray*imageItems=[NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
        [imageItems addObject:image];
    }
    
    [headerView setImages:imageItems duration:0.6 forState:MJRefreshStateIdle];
    [headerView setImages:imageItems duration:0.6 forState:MJRefreshStatePulling];
    [headerView setImages:imageItems duration:0.6 forState:MJRefreshStateRefreshing];
    headerView.lastUpdatedTimeLabel.hidden = YES;
    headerView.stateLabel.hidden = YES;
    self.tableView.mj_header = headerView;
    self.tableView.backgroundColor=UIColorBg243Color;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemHelperListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemHelperListTableViewCell];
    cell.chatModel=[self.msgItems objectAtIndex:indexPath.row];
    @weakify(self);
    cell.deleteBlock = ^(ChatModel * _Nonnull model) {
        @strongify(self);
        [self.msgItems removeObject:model];
        [[WCDBManager sharedManager]deleteOneChatModelWithMessageId:model.messageID];
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(NSMutableArray<ChatModel *> *)msgItems{
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}
@end
