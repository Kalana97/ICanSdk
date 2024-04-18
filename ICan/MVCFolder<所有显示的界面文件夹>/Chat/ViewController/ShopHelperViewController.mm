//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 29/7/2020
- File name:  ShopHelperViewController.m
- Description:
- Function List:
*/
        

#import "ShopHelperViewController.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "ShopHelperTableViewCell.h"
#import <MJRefresh.h>
@interface ShopHelperViewController ()<WebSocketManagerDelegate>
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
/** 当前插叙的页数 */
@property (nonatomic ,assign) NSInteger offset;
/**当前表格是否正在滑动*/
@property (nonatomic, assign) BOOL isScrollViewScroll;

@end

@implementation ShopHelperViewController

-(void)dealloc{
    [WebSocketManager sharedManager].currentChatID=@"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Mall Assistant".icanlocalized;
    [WebSocketManager sharedManager].currentChatID=ShopHelperMessageType;
    [self loadMoreMessage];
    [self.tableView registNibWithNibName:kShopHelperTableViewCell];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = ShopHelperMessageType;
    config.chatType = UserChat;
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = ShopHelperMessageType;
    config.chatType = UserChat;
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];
    [WebSocketManager sharedManager].delegate = self;
}
// 收到普通的消息
//@param chatModel chatModel description
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if ([chatModel.chatID isEqualToString:ShopHelperMessageType]) {
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {//数组中已经存在该对象
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
    if (!needScroll) {
        NSIndexPath*index = self.tableView.indexPathsForVisibleRows.firstObject;
        BOOL shouldScroll = index.row>=20;
        if (self.isScrollViewScroll||!shouldScroll) {
            return;
        }
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
   
    NSArray<ChatModel*>*array=[[WCDBManager sharedManager]fetchShopHelperMessageTypewithoffset:self.offset];
    
    if (array.count<10) {
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
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.msgItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel* chatModel=[self.msgItems objectAtIndex:indexPath.row];
    
    ShopHelperMsgInfo*info=[ShopHelperMsgInfo mj_objectWithKeyValues:chatModel.messageContent];
    ShopHelperTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShopHelperTableViewCell];
    cell.info = info;
    cell.timeLabel.text = [NSString timestampSwitchTime:[chatModel.messageTime longLongValue] andFormatter:@"yyyy-MM-dd HH:mm"];
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
