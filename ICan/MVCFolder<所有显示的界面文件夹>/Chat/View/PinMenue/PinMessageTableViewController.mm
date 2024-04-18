//
//  PinMessageTableViewController.m
//  ICan
//
//  Created by apple on 28/06/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "PinMessageTableViewController.h"
#import "ChatMineMessageTableViewCell.h"
#import "ChatRightMsgBaseTableViewCell.h"
#import "ChatRightTxtMsgTableViewCell.h"
#import "ChatLeftMsgBaseTableViewCell.h"
#import "ChatModel.h"
#import "ChatRightImgMsgTableViewCell.h"
#import "ChatRightUrlMsgTableViewCell.h"
#import "ChatRightVoiceTableViewCell.h"
#import "ChatRightVideoTableViewCell.h"
#import "ChatRightFileTableViewCell.h"
#import "ChatRightNimCallTableViewCell.h"
#import "ChatRightTimelineTableViewCell.h"
#import "ChatRightGoodsTableViewCell.h"

#import "ChatLeftMsgBaseTableViewCell.h"
#import "ChatLeftTxtMsgTableViewCell.h"
#import "ChatLeftUrlMsgTableViewCell.h"
#import "ChatLeftImgMsgTableViewCell.h"
#import "ChatLeftVoiceTableViewCell.h"
#import "ChatLeftVideoTableViewCell.h"
#import "ChatLeftFileTableViewCell.h"
#import "ChatLeftNimCallTableViewCell.h"
#import "ChatLeftTimelineTableViewCell.h"
#import "ChatLeftGoodsTableViewCell.h"
#import "ChatOtherMessageTableViewCell.h"
#import "ChatWithdrawTableViewCell.h"
#import "ChatNoticeTableViewCell.h"

#import "WCDBManager+GroupListInfo.h"
#import "MsgContentModel.h"
#import "WCDBManager+ChatModel.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif

@interface PinMessageTableViewController()
@property(nonatomic,strong) UILabel *pinScreenTitle;
@property(nonatomic,strong) UIButton *UnpinAllMsgBtn;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIView *navBar;
@property(nonatomic, strong) ChatModel *pinChatModel;
@property(nonatomic, strong) MsgContentModel *msgContentModel;
@property(nonatomic, strong) GroupListInfo *groupDetailInfo;
@property(nonatomic, strong) NSString *chatId;
@end

@implementation PinMessageTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePinMessage) name:@"updatePinMessage" object:nil];
    self.pinScreenTitle.text = [NSString stringWithFormat:@"%lu Pinned Messages", (unsigned long)self.messagesArray.count];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@50);
    }];
    [self.navBar addSubview:self.pinScreenTitle];
    [self.pinScreenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar.mas_centerX);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
    [self.navBar addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
    [self.navBar addSubview:self.UnpinAllMsgBtn];
    [self.UnpinAllMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

- (void)updatePinMessage {
    if(self.messagesArray.count > 0) {
        self.chatId = self.messagesArray[0].chatID;
    }else {
        return;
    }
    [self.messagesArray removeAllObjects];
    self.messagesArray = [[[WCDBManager sharedManager]getPinMessageWithChatModel:self.chatId] mutableCopy]; // Convert to mutable copy
    [self.tableView reloadData];
}

- (UIView *)navBar {
    if(!_navBar) {
        _navBar = [[UIView alloc] init];
        [_navBar setBackgroundColor: UIColorMakeHEXCOLOR(0xECF0EF)];
    }
    return _navBar;
}

- (UILabel *)pinScreenTitle {
    if(!_pinScreenTitle) {
        _pinScreenTitle = [[UILabel alloc]init];
        [_pinScreenTitle setTextColor: UIColor.blackColor];
        [_pinScreenTitle setFont:[UIFont boldSystemFontOfSize:16]];
    }
    return _pinScreenTitle;
}

- (UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setTitle:@"Close".icanlocalized forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColorMakeHEXCOLOR(0x1473D1) forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_closeBtn setBackgroundColor:UIColor.clearColor];
        [_closeBtn addTarget:self action:@selector(dismissPopoverView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)UnpinAllMsgBtn {
    if(!_UnpinAllMsgBtn) {
        _UnpinAllMsgBtn = [[UIButton alloc]init];
        [_UnpinAllMsgBtn setTitle:@"UnpinAll".icanlocalized forState:UIControlStateNormal];
        [_UnpinAllMsgBtn setTitleColor:UIColorMakeHEXCOLOR(0x1473D1) forState:UIControlStateNormal];
        _UnpinAllMsgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_UnpinAllMsgBtn setBackgroundColor:UIColor.clearColor];
        [_UnpinAllMsgBtn addTarget:self action:@selector(removeAllPins) forControlEvents:UIControlEventTouchUpInside];
    }
    return _UnpinAllMsgBtn;
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registNibWithNibName:kChatOtherMessageTableViewCell];
    [self.tableView registNibWithNibName:kChatMineMessageTableViewCell];
    [self.tableView registClassWithClassName:kChatWithdrawTableViewCell];
    [self.tableView registNibWithNibName:KChatNoticeTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftMsgBaseTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftTxtMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftUrlMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftImgMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftVoiceTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftVideoTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftFileTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftNimCallTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftTimelineTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftGoodsTableViewCell];
    [self.tableView registClassWithClassName:kChatRightMsgBaseTableViewCell];
    [self.tableView registClassWithClassName:kChatRightTxtMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightUrlMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightImgMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightVoiceTableViewCell];
    [self.tableView registClassWithClassName:kChatRightVideoTableViewCell];
    [self.tableView registClassWithClassName:kChatRightFileTableViewCell];
    [self.tableView registClassWithClassName:kChatRightNimCallTableViewCell];
    [self.tableView registClassWithClassName:kChatRightTimelineTableViewCell];
    [self.tableView registClassWithClassName:kChatRightGoodsTableViewCell];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messagesArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 150)];
    [headerView setBackgroundColor:UIColorViewBgColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.messagesArray[indexPath.row].isPin) {
        ChatModel *chatModel = self.messagesArray[indexPath.row];
        NSString *messageType = chatModel.messageType;
        BOOL isGroup = [chatModel.chatType isEqualToString:GroupChat];
        BOOL isShowNickname = YES;
        BOOL isShowTime = NO;
        if(chatModel.isOutGoing) {
            ChatRightMsgBaseTableViewCell *rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightMsgBaseTableViewCell];
            rightBaseCell.multipleBtn.selected = chatModel.isSelect;
            if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AtAllMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightTxtMsgTableViewCell];
                ChatRightTxtMsgTableViewCell *txtCell = (ChatRightTxtMsgTableViewCell *)rightBaseCell;
                txtCell.longpressStatus = NO;
                if(chatModel.layoutHeight > 40.00) {
                    txtCell.timeLableFlag = YES;
                }else {
                    txtCell.timeLableFlag = NO;
                }
            }else if ([messageType isEqualToString:URLMessageType]) {
                NSDataDetector *rightDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                NSArray *rightMatches = [rightDetector matchesInString:chatModel.showMessage options:0 range:NSMakeRange(0, [chatModel.showMessage length])];
                NSURL *url = [rightMatches[0] valueForKeyPath:@"_url"];
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightUrlMsgTableViewCell];
                ChatRightUrlMsgTableViewCell *txtCell = (ChatRightUrlMsgTableViewCell*)rightBaseCell;
                txtCell.longpressStatus = NO;
                if(chatModel.layoutHeight > 56.00) {
                    txtCell.seeMoreBtnFlag = YES;
                }
                else {
                    txtCell.seeMoreBtnFlag = NO;
                }
                @weakify(self);
                txtCell.resetBlock = ^{
                    @strongify(self);
                    UIStoryboard *board;
                    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                    View.isChat = YES;
                    View.chatUrlString = url.absoluteString;
                    View.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:View animated:YES];
                    [[self navigationController] setNavigationBarHidden:NO animated:YES];
                };
            }else if([messageType isEqualToString:ImageMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightImgMsgTableViewCell];
                ChatRightImgMsgTableViewCell *txtCell = (ChatRightImgMsgTableViewCell *)rightBaseCell;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:VoiceMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightVoiceTableViewCell];
                ChatRightVoiceTableViewCell *txtCell = (ChatRightVoiceTableViewCell *)rightBaseCell;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:VideoMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightVideoTableViewCell];
            }else if([messageType isEqualToString:FileMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightFileTableViewCell];
                ChatRightFileTableViewCell *txtCell = (ChatRightFileTableViewCell *)rightBaseCell;
                txtCell.fileContainerView = self;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:ChatCallMessageType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightNimCallTableViewCell];
            }else if([messageType isEqualToString:kChat_PostShare]){
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightTimelineTableViewCell];
                ChatRightTimelineTableViewCell *txtCell = (ChatRightTimelineTableViewCell *)rightBaseCell;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:kChatOtherShareType]) {
                rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightGoodsTableViewCell];
                ChatRightGoodsTableViewCell *txtCell = (ChatRightGoodsTableViewCell *)rightBaseCell;
                txtCell.longpressStatus = NO;
            }
            [rightBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
            return rightBaseCell;
        }else {
            ChatLeftMsgBaseTableViewCell *leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftMsgBaseTableViewCell];
            leftBaseCell.multipleBtn.selected = chatModel.isSelect;
            if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AtAllMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftTxtMsgTableViewCell];
                ChatLeftTxtMsgTableViewCell *txtCell = (ChatLeftTxtMsgTableViewCell *)leftBaseCell;
                txtCell.longpressStatus = NO;
                if(chatModel.layoutHeight > 40.00) {
                    txtCell.timeLableFlag = YES;
                }else {
                    txtCell.timeLableFlag = NO;
                }
            }else if([messageType isEqualToString:URLMessageType]) {
                NSDataDetector *rightDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                NSArray *rightMatches = [rightDetector matchesInString:chatModel.showMessage options:0 range:NSMakeRange(0, [chatModel.showMessage length])];
                NSURL *url = [rightMatches[0] valueForKeyPath:@"_url"];
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftUrlMsgTableViewCell];
                ChatLeftUrlMsgTableViewCell *txtCell = (ChatLeftUrlMsgTableViewCell*)leftBaseCell;
                txtCell.longpressStatus = NO;
                if(chatModel.layoutHeight > 56.00) {
                    txtCell.seeMoreBtnFlag = YES;
                }
                else{
                    txtCell.seeMoreBtnFlag = NO;
                }
                @weakify(self);
                txtCell.resetBlock = ^{
                    @strongify(self);
                    UIStoryboard *board;
                    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                    View.isChat = YES;
                    View.chatUrlString = url.absoluteString;
                    View.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:View animated:YES];
                    [[self navigationController] setNavigationBarHidden:NO animated:YES];
                };
            }else if([messageType isEqualToString:ImageMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftImgMsgTableViewCell];
                ChatLeftImgMsgTableViewCell *txtCell = (ChatLeftImgMsgTableViewCell *)leftBaseCell;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:VoiceMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftVoiceTableViewCell];
                ChatLeftVoiceTableViewCell *txtCell = (ChatLeftVoiceTableViewCell *)leftBaseCell;
                txtCell.longpressStatus = NO;
            }else if ([messageType isEqualToString:VideoMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftVideoTableViewCell];
            }else if([messageType isEqualToString:FileMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftFileTableViewCell];
                ChatLeftFileTableViewCell *txtCell = (ChatLeftFileTableViewCell*)leftBaseCell;
                txtCell.fileContainerView = self;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:ChatCallMessageType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftNimCallTableViewCell];
            }else if([messageType isEqualToString:kChat_PostShare]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftTimelineTableViewCell];
                ChatLeftTimelineTableViewCell *txtCell = (ChatLeftTimelineTableViewCell*)leftBaseCell;
                txtCell.longpressStatus = NO;
            }else if([messageType isEqualToString:kChatOtherShareType]) {
                leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftGoodsTableViewCell];
                ChatLeftGoodsTableViewCell *txtCell = (ChatLeftGoodsTableViewCell*)leftBaseCell;
                txtCell.longpressStatus = NO;
            }
            [leftBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
            return leftBaseCell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *chatModel = self.messagesArray[indexPath.row];
    NSString *messageType = chatModel.messageType;
    if ([messageType containsString:WithdrawMessageType]) {
        return 40;
    }
    return UITableViewAutomaticDimension;
}

- (void)dismissPopoverView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeAllPins {
    if(self.messagesArray.count == 0) {
        return;
    }
    if([self.messagesArray[0].chatType isEqualToString:@"groupChat"]) {
        self.groupDetailInfo = [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.messagesArray[0].chatID];
        for(ChatModel *chatModel in self.messagesArray) {
            if([self.groupDetailInfo.role isEqualToString: @"0"] || [self.groupDetailInfo.role isEqualToString: @"1"]) {
                self.msgContentModel = [[MsgContentModel alloc] init];
                self.pinChatModel = [[ChatModel alloc] init];
                self.pinChatModel = [chatModel mutableCopy];
                self.msgContentModel.pinnedMsgId = chatModel.messageID;
                if([chatModel.pinAudiance isEqualToString:@"Self"]) {
                    self.msgContentModel.audience = @"Self";
                    self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                    self.pinChatModel.chatID = nil;
                    chatModel.pinAudiance = @"Self";
                }else {
                    self.msgContentModel.audience = @"All";
                    chatModel.pinAudiance = @"All";
                }
                self.msgContentModel.isUnpinAll = NO;
                self.msgContentModel.action = @"Unpin";
                self.pinChatModel.messageID = [NSString getCFUUID];
                self.pinChatModel.messageType = @"Pin_Message";
                NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                if (!jsonData) {
                    NSLog(@"Error converting to JSON: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"JSON string: %@", jsonString);
                    self.pinChatModel.messageContent = jsonString;
                }
                [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
            }else {
                self.msgContentModel = [[MsgContentModel alloc] init];
                self.pinChatModel = [[ChatModel alloc] init];
                self.pinChatModel = [chatModel mutableCopy];
                self.msgContentModel.pinnedMsgId = chatModel.messageID;
                self.msgContentModel.audience = @"Self";
                self.msgContentModel.isUnpinAll = NO;
                self.msgContentModel.action = @"Unpin";
                self.pinChatModel.messageID = [NSString getCFUUID];
                self.pinChatModel.messageType = @"Pin_Message";
                self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                self.pinChatModel.chatID = nil;
                NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                if (!jsonData) {
                    NSLog(@"Error converting to JSON: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"JSON string: %@", jsonString);
                    self.pinChatModel.messageContent = jsonString;
                }
                [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
            }
            [[WCDBManager sharedManager]updatePinStatusWithChatId:chatModel.messageID isPin:NO isOther:NO pinAudiance:nil];
        }
    }
    if([self.messagesArray[0].chatType isEqualToString: @"userChat"]) {
        for(ChatModel *chatModel in self.messagesArray) {
            self.msgContentModel = [[MsgContentModel alloc] init];
            self.pinChatModel = [[ChatModel alloc] init];
            self.pinChatModel = [chatModel mutableCopy];
            self.msgContentModel.pinnedMsgId = chatModel.messageID;
            if([chatModel.pinAudiance isEqualToString: @"All"]) {
                self.msgContentModel.audience = @"All";
                self.pinChatModel.messageTo = chatModel.chatID;
            }else {
                self.msgContentModel.audience = @"Self";
                self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                self.pinChatModel.chatID = nil;
            }
            self.msgContentModel.isUnpinAll = NO;
            self.msgContentModel.action = @"Unpin";
            self.pinChatModel.messageID = [NSString getCFUUID];
            self.pinChatModel.messageType = @"Pin_Message";
            NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
            if (!jsonData) {
                NSLog(@"Error converting to JSON: %@", error);
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"JSON string: %@", jsonString);
                self.pinChatModel.messageContent = jsonString;
            }
            [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
            [[WCDBManager sharedManager]updatePinStatusWithChatId:chatModel.messageID isPin:NO isOther:NO pinAudiance:nil];
        }
    }
    [self.messagesArray removeAllObjects];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setPinMenuBarHidden" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)messagesArray {
    if(!_messagesArray) {
        _messagesArray = [[NSMutableArray alloc]init];
    }
    return _messagesArray;
}
@end
