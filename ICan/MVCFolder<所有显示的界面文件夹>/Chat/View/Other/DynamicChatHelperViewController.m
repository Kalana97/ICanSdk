//
//  DynamicChatHelperViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 04/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "DynamicChatHelperViewController.h"
#import "DynamicTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import <MJRefresh.h>
#import "ICanHelpSettingViewController.h"
#import "MesageContentModel.h"
#import "DynamicChatModel.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif


@interface DynamicChatHelperViewController ()
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
@property(nonatomic, strong) UIImageView *backimageView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;
@property (nonatomic ,assign) NSInteger offset;
@property (nonatomic, assign) BOOL isScrollViewScroll;
@end

@implementation DynamicChatHelperViewController

-(void)dealloc{
    [WebSocketManager sharedManager].currentChatID=@"";
    DDLogInfo(@"IDynamicChatHelperViewController%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateWebView:) name:@"Dynamic Message" object:nil];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(push)];
    self.backimageView = [[UIImageView alloc] init];
    self.backimageView.image = [UIImage imageNamed:@"icon_nav_back_black"];
    self.imageView = [[UIImageView alloc] init];
    CGFloat maxWidth = 35.0;
    CGFloat maxHeight = 35.0;

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:maxWidth];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:maxHeight];

    // Add constraints to the UIImageView
    [self.imageView addConstraints:@[widthConstraint, heightConstraint]];
    self.imageView.layer.cornerRadius = 18;
    self.imageView.layer.masksToBounds = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIBarButtonItem *imageBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.imageView];
    UIBarButtonItem *backimageBarButtonItem = [UIBarButtonItem qmui_itemWithImage:self.backimageView.image target:self action:@selector(back)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 0;
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:16.0];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.frame = CGRectMake(50, 50, 200, 30);
    UIBarButtonItem *textBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.label];
    self.navigationItem.leftBarButtonItems = @[backimageBarButtonItem, fixedSpace, imageBarButtonItem, textBarButtonItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self loadMoreMessage];
}

-(void)navigateWebView:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[WebPageVC class]]) {
        WebPageVC *webPage = (WebPageVC *)notification.object;
        [self.navigationController pushViewController:webPage animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.chatType = UserChat;
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];

}

-(void)push{
    ICanHelpSettingViewController*vc=[[ICanHelpSettingViewController alloc]init];
    vc.type = ICanHelpSettingTypeAnnouncement;
    vc.deleteMessageBlock = ^{
        [self.msgItems removeAllObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
//    if ([chatModel.chatID isEqualToString:AnnouncementHelperMessageType]) {
//        __block BOOL isExist = NO;
//        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.messageID isEqualToString:chatModel.messageID]) { //trigger when recieve message
//                *stop = YES;
//                isExist = YES;
//            }
//        }];
//
//        if (!isExist) {
//            [self.msgItems addObject:chatModel];
//            [self.tableView reloadData];
//            [self scrollTableViewToBottom:YES needScroll:NO];
//        }
//    }
//}
//this code snippet may have use in future


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

- (void)loadMessage {
    NSArray<ChatModel*> *array = [[WCDBManager sharedManager]fetchDynamicHelperMessageTypeWithoffset:self.msgItems.count chatID:self.chatID];
    if (array.count<5) {
        [self noMoreMessage];
    }
    for (ChatModel *model in array) {
        [self.msgItems insertObject:model atIndex:0];
    }
    DynamicMessageInfo *info = [DynamicMessageInfo mj_objectWithKeyValues:[self.msgItems objectAtIndex:0].messageContent];
    [self.imageView setImageWithString:info.senderImgUrl placeholder:nil];
    self.label.text = info.sender;
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
    [self.tableView registNibWithNibName:kDynamicChatHelperListTableViewCell];
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
    self.tableView.backgroundColor=UIColorBg243Color;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDynamicChatHelperListTableViewCell];
    DynamicMessageInfo *info = [DynamicMessageInfo mj_objectWithKeyValues:[self.msgItems objectAtIndex:indexPath.row].messageContent];
    
    if (info.messageType == 1) {
        cell.title.text = info.title;
        NSURL *imageUrl = [NSURL URLWithString:info.headerImgUrl];
        cell.headerImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        cell.htmlString = info.messageData;
        cell.infor = info;
    }else if(info.messageType == 2) {
        cell.htmlString = info.messageData;
        cell.infor = info;
    }
    cell.tableViewHeight.constant = info.dataList.count*100;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


-(NSMutableArray<ChatModel *> *)msgItems {
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}


@end
