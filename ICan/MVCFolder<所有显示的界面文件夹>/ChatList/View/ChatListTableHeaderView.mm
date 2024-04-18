//
//  WGChatListTableHeaderView.m
//  ICan
//
//  Created by limaohuyu on 2022/4/21.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatListTableHeaderView.h"
#import "TimelinesViewController.h"
#import "FriendListTableViewController.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
@interface ChatListTableHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *searchLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
///新好友通知提示
@property (weak, nonatomic) IBOutlet UIView *contactUnReadTipsView;
@property (weak, nonatomic) IBOutlet UILabel *shareLab;
@property (weak, nonatomic) IBOutlet UILabel *nearLab;
@property (weak, nonatomic) IBOutlet UIControl *shareLabelContainer;
@end
@implementation ChatListTableHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.searchLab.text= @"Search".icanlocalized;
    self.contactLab.text = @"chatlist.menu.list.contacts".icanlocalized;
    self.shareLab.text = @"tabbar.share".icanlocalized;
    self.nearLab.text = @"find.listView.cell.peopleNearby".icanlocalized;
    ///监听好友相关的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kReceiveFriendApplyNotication object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kAgreeFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendUnreadCount) name:kUpdateFriendSubscriptionReadNotication object:nil];
    [self updateFriendUnreadCount];
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        _shareLabelContainer.layer.hidden = YES;
    }
}

- (IBAction)searchCallBackAction {
    if (self.searchCallBack) {
        self.searchCallBack();
    }
}
- (IBAction)contactCallBack {
    [[AppDelegate shared] pushViewController:[FriendListTableViewController new] animated:YES];
}
- (IBAction)shareCallBack {
    TimelinesViewController*vc=[[TimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [[AppDelegate shared] pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
}
- (IBAction)nearCallBackAction {
    if (self.nearCallBack) {
        self.nearCallBack();
    }
   
}
-(void)updateFriendUnreadCount{
    NSInteger unReadAmount=[[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    if (unReadAmount==0) {
        self.contactUnReadTipsView.hidden=YES;
        self.countLab.text = [NSString stringWithFormat:@"%ld", (long)unReadAmount];
    }else{
        self.contactUnReadTipsView.hidden=NO;
        self.countLab.text =  [NSString stringWithFormat:@"%ld", (long)unReadAmount];
    }
}
@end

