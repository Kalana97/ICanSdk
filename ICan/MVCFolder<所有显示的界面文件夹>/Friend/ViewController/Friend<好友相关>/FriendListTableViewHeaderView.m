//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/11/2021
- File name:  FriendListTableViewHeaderView.m
- Description:
- Function List:
*/

#import "FriendListTableViewHeaderView.h"
#import "GroupListViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "WCDBManager+ChatModel.h"
@interface FriendListTableViewHeaderView ()
@property (weak, nonatomic) IBOutlet QMUITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UILabel *friendNewLab;
@property (weak, nonatomic) IBOutlet UILabel *groupNoticeLab;
@property (weak, nonatomic) IBOutlet UILabel *groupChatLab;
@property (weak, nonatomic) IBOutlet UIView *bottomDivisionBgVIew;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView1;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView2;

@end

@implementation FriendListTableViewHeaderView

- (IBAction)friendAction {
    if (self.friendBlock) {
        self.friendBlock();
    }
    
}
- (IBAction)groupNoticeAction {
    if (self.groupNoticeBlock) {
        self.groupNoticeBlock();
    }
    
}
- (IBAction)groupChatAction {
    GroupListViewController *groupListVC = [[GroupListViewController alloc]init];
    [[AppDelegate shared] pushViewController:groupListVC animated:YES];
    
}
- (IBAction)chatGptAction {
    ChatModel *chatModel   = [[ChatModel alloc]init];
    chatModel.chatID = @"100";
    chatModel.chatType = UserChat;
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
    [[AppDelegate shared] pushViewController:vc animated:YES];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorThemeMainBgColor;
    self.searchBgView.backgroundColor = UIColorSearchBgColor;
    self.bottomDivisionBgVIew.backgroundColor = UIColorTabBarBgColor;
    
    self.separatorLineView1.backgroundColor = UIColorSeparatorColor;
    self.separatorLineView2.backgroundColor = UIColorSeparatorColor;

    self.friendNewLab.text = NSLocalizedString(@"New Friends", 新的好友);
    self.friendNewLab.textColor = UIColorThemeMainTitleColor;
    
    self.groupNoticeLab.text = @"GroupNotification".icanlocalized;
    self.groupNoticeLab.textColor = UIColorThemeMainTitleColor;

    self.groupChatLab.text = NSLocalizedString(@"Group Chats", 群聊);
    self.groupChatLab.textColor = UIColorThemeMainTitleColor;
    
    
    self.searchTextField.placeholder = @"Search".icanlocalized;
    [self.searchBgView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
    [self.friendUnReadLab layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self.groupNoticeUnReadLab layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    
}
-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.searchTextField.markedTextRange) {
        self.searchDidChangeBlock(self.searchTextField.text);
    }
}
@end
