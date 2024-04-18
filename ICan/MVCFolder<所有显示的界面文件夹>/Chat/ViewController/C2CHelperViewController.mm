//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 8/3/2022
- File name:  C2CHelperViewController.m
- Description:
- Function List:
*/
        

#import "C2CHelperViewController.h"
#import "C2CHelpListTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import <MJRefresh.h>
#import "ICanHelpSettingViewController.h"
#import "C2COrderDetailViewController.h"
#import "C2CPConfirmOrderViewController.h"
#import "C2CConfirmReceiptMoneyViewController.h"
#import "C2CBillDetailViewController.h"
@interface C2CHelperViewController ()<WebSocketManagerDelegate>
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
/** 当前插叙的页数 */
@property (nonatomic ,assign) NSInteger offset;
/**当前表格是否正在滑动*/
@property (nonatomic, assign) BOOL isScrollViewScroll;


@end

@implementation C2CHelperViewController
-(void)dealloc{
    WebSocketManager.sharedManager.currentChatID=@"";
    DDLogInfo(@"ICanHelpViewController%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"WalletAssistant".icanlocalized;
    WebSocketManager.sharedManager.currentChatID = C2COrderMessageType;
    [self loadMoreMessage];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(push)];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = C2CHelperMessageType;
    config.chatType = C2CHelperMessageType;
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = C2CHelperMessageType;
    config.chatType = C2CHelperMessageType;
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:config];
    [WebSocketManager sharedManager].delegate = self;
}
-(void)push{
    ICanHelpSettingViewController*vc=[[ICanHelpSettingViewController alloc]init];
    vc.type = ICanHelpSettingTypeC2C;
    vc.deleteMessageBlock = ^{
        [self.msgItems removeAllObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 收到普通的消息
//@param chatModel chatModel description
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if ([chatModel.chatID isEqualToString:C2CHelperMessageType]) {
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
    
    NSArray<ChatModel*>*array=[[WCDBManager sharedManager]fetchC2CHelperMessageTypewithoffset:self.msgItems.count];
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
    [self.tableView registNibWithNibName:KC2CHelpListTableViewCell];
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
    C2CHelpListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KC2CHelpListTableViewCell];
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
-(void)getOrderDetailWith:(NSInteger)adOrderId successBlock:(void(^)(C2COrderInfo*adverInfo))successBlcok{
    C2CGetOrderDetailRequest * request = [C2CGetOrderDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/%ld",adOrderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
        if (successBlcok) {
            successBlcok(response);
        }
        [QMUITips hideAllTips];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel*chatModel = [self.msgItems objectAtIndex:indexPath.row];
    if ([chatModel.messageType isEqualToString:C2COrderMessageType]) {
        C2COrderMessageInfo*msgInfo=[C2COrderMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        [self getOrderDetailWith:msgInfo.adOrderId successBlock:^(C2COrderInfo *orderInfo) {
            if ([orderInfo.status isEqualToString:@"Unpaid"]) {
                //如果购买的用户是自己 跳转到付款界面
                if ([msgInfo.buyC2CUserId isEqualToString: C2CUserManager.shared.userId]) {
                    C2CPConfirmOrderViewController * vc = [[C2CPConfirmOrderViewController alloc]init];
                    vc.orderInfo = orderInfo;
                    [self getC2CAdverDetailInfo:orderInfo successBlock:^(C2CAdverInfo *adverInfo) {
                        vc.adverInfo = adverInfo;
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    
                }else{
                    //订单详情
                    C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                    vc.orderInfo = orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
            }else if ([orderInfo.status isEqualToString:@"Paid"]) {
                
                //如果购买的用户是自己 是购买
                if ([msgInfo.buyC2CUserId isEqualToString: C2CUserManager.shared.userId]) {
                    //订单详情
                    C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                    vc.orderInfo = orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{//跳转到收款界面
                    C2CConfirmReceiptMoneyViewController * vc = [[C2CConfirmReceiptMoneyViewController alloc]init];
                    vc.orderInfo = orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                vc.orderInfo = orderInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else if ([chatModel.messageType isEqualToString:C2CTransferType]){
        
    }else if ([chatModel.messageType isEqualToString:C2CExtRechargeWithdrawType]){
        C2CExtRechargeWithdrawMessageInfo*msgInfo=[C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
        C2CFlowsInfo * info = [[C2CFlowsInfo alloc]init];
        info.orderId = msgInfo.orderId;
        
        if ([msgInfo.type isEqualToString:@"Recharge"]) {///充值ExternalRecharge
            info.flowType =@"ExternalRecharge";
        }else{///提现ExternalWithdraw
            info.flowType =@"ExternalWithdraw";
        }
        C2CBillDetailViewController * detailVc = [[C2CBillDetailViewController alloc]init];
        detailVc.c2cFlowsInfo = info;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
    
}
-(void)getC2CAdverDetailInfo:(C2COrderInfo*)orderInfo successBlock:(void(^)(C2CAdverInfo*adverInfo))successBlcok{
    C2CGetAdverDetailRequest * request = [C2CGetAdverDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld",orderInfo.adId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAdverInfo class] contentClass:[C2CAdverInfo class] success:^(C2CAdverInfo*  _Nonnull response) {
        if (successBlcok) {
            successBlcok(response);
        }
        [QMUITips hideAllTips];
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(NSMutableArray<ChatModel *> *)msgItems{
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}


@end
