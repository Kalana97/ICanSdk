//
//  NoticeOTPViewController.m
//  ICan
//
//  Created by MAC on 2023-05-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "NoticeOTPViewController.h"
#import "NoticeOTPTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import <MJRefresh.h>
#import "ICanHelpSettingViewController.h"

@interface NoticeOTPViewController ()<WebSocketManagerDelegate>
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
@property (nonatomic ,assign) NSInteger offset;
@property (nonatomic, assign) BOOL isScrollViewScroll;
@end

@implementation NoticeOTPViewController
- (void)dealloc {
    [WebSocketManager sharedManager].currentChatID = @"";
    DDLogInfo(@"Notice_OTP%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0; // set an estimated row height
    self.title = @"NoticeOTP".icanlocalized;
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(push)];
    [WebSocketManager sharedManager].currentChatID = NoticeOTPMessageType;
    [self loadMoreMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = NoticeOTPMessageType;
    config.chatType = NoticeOTPMessageType;
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];
    [WebSocketManager sharedManager].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ChatModel *config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = NoticeOTPMessageType;
    config.chatType = NoticeOTPMessageType;
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];
}

- (void)push {
    ICanHelpSettingViewController *vc = [[ICanHelpSettingViewController alloc]init];
    vc.type = ICanHelpSettingTypeNoticeOTP;
    vc.deleteMessageBlock = ^{
        [self.msgItems removeAllObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel {
    if ([chatModel.chatID isEqualToString:NoticeOTPMessageType]) {
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        self.isScrollViewScroll = YES;
    }else{
        self.isScrollViewScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrollViewScroll=NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark The table starts dragging and scrolling, hiding the keyboard
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.isScrollViewScroll = YES;
        [self.view endEditing:YES];
    }
}

- (void)scrollTableViewToBottom:(BOOL)animated needScroll:(BOOL)needScroll {
    if (self.isScrollViewScroll) {
        return;
    }
    if (self.msgItems.count > 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.msgItems.count-1 inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
        });
    }
}

- (void)loadMoreMessage {
    self.offset++;
    [self loadMessage];
}

- (void)loadMessage {
    NSArray<ChatModel*> *array = [[WCDBManager sharedManager]fetchNoticeOTPMessageTypeWithoffset:self.msgItems.count];
    if (array.count < 5) {
        [self noMoreMessage];
    }
    for (ChatModel*model in array) {
        [self.msgItems insertObject:model atIndex:0];
    }
    [self.tableView reloadData];
    [self.tableView endHeaderRefreshing];
    if (self.msgItems.count>0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.msgItems.count-1 inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
        });
    }
}

- (void)noMoreMessage {
    [self.tableView.mj_header endRefreshing];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView.mj_header removeFromSuperview];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registNibWithNibName:kNoticeOTPTableViewCell];
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    NSMutableArray *imageItems = [NSMutableArray array];
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
    self.tableView.backgroundColor = UIColorBg243Color;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeOTPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticeOTPTableViewCell];
    cell.chatModel = [self.msgItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSMutableArray<ChatModel *> *)msgItems {
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}
@end
