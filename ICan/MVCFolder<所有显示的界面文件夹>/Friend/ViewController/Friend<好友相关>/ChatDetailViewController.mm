//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - Author: Created  by DZL on 8/10/2019
 - File name:  ChatDetailViewController.m
 - Description:
 - Function List:
 */


#import "ChatDetailViewController.h"
#import "JKPickerView.h"
#import "HJCActionSheet.h"
#import "ChatUtil.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "SelectMembersViewController.h"
#import "FriendDetailViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatViewHandleTool.h"
#import "AppearenceViewController.h"
@interface ChatDetailViewController ()<HJCActionSheetDelegate>
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property (nonatomic,strong) UserMessageInfo *userMessageInfo;
@property (nonatomic,strong) ChatSetting * chatSetting;
@property (weak, nonatomic) IBOutlet UILabel *selectedTranslateLanguage;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *muteLabel;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UISwitch *topSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *secretLabel;
@property (nonatomic,strong) NSMutableArray <LanguageInfo*> *languageItems;
@property (weak, nonatomic) IBOutlet UILabel *screenshotLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenshotDesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *screenshotSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *burningLabel;
@property (weak, nonatomic) IBOutlet UILabel *burningDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *burningTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *translateLbl;
@property (weak, nonatomic) IBOutlet UILabel *translateDescLbl;
@property (weak, nonatomic) IBOutlet UIControl *secretBgCon;
@property (weak, nonatomic) IBOutlet UIView *secretLineView;
@property (weak, nonatomic) IBOutlet UIView *UserAddViewContainer;
@property (weak, nonatomic) IBOutlet UIView *UserMuteViewContainer;
@property (weak, nonatomic) IBOutlet UIView *spaceView1;
@property (weak, nonatomic) IBOutlet UIView *spaceView2;
@property (weak, nonatomic) IBOutlet UIControl *screenShotOptionContainerView;
@property (weak, nonatomic) IBOutlet UIControl *burnAfterReadingContainerView;
@property (weak, nonatomic) IBOutlet UILabel *appearencelabel;
@property (weak, nonatomic) IBOutlet UIControl *clearChatHistoryContainerView;
@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"mine.listView.cell.setting" icanlocalized:@"设置"];
    self.translateLbl.text = @"translate".icanlocalized;
    self.translateDescLbl.text = @"Select Language".icanlocalized;
    self.appearencelabel.text = @"Appearance".icanlocalized;
    self.view.backgroundColor = UIColorBg243Color;
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = self.authorityType;
    config.chatID = self.userId;
    config.chatType = UserChat;
    self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSecretShow) name:kGetPriviSuccessNotification object:nil];

    self.muteLabel.text = NSLocalizedString(@"Mute Notifications", 消息免打扰);
    self.topLabel.text = NSLocalizedString(@"Sticky on Top", 置顶聊天);
    self.screenshotLabel.text = NSLocalizedString(@"ScreenshotNotice", 截屏通知);
    self.screenshotDesLabel.text = NSLocalizedString(@"ScreenshotNoticeTips", @"开启后,在对话中的截屏你会收到消息通知");
    self.burningLabel.text=NSLocalizedString(@"BurningAfterReading", 阅后即焚);
    self.burningDesLabel.text = NSLocalizedString(@"Burn off after reading", [阅后即焚 关闭]);
    self.privateLabel.text = @"Start a private chat".icanlocalized;
    self.secretLabel.text = @"friend.detail.privateChat".icanlocalized;
    self.clearLabel.text = NSLocalizedString(@"Clear Chat History", 清空聊天记录);
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconAction)];
    [self.iconImageView addGestureRecognizer:tap];
    [self.iconImageView layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    self.muteSwitchBtn.on = self.chatSetting.isNoDisturbing;
    self.topSwitchBtn.on = self.chatSetting.isStick;
    self.screenshotSwitchBtn.on = self.chatSetting.isOpenTaskScreenNotice;
    [self getBurningTime];
    [self updateSecretShow];
    //赋值
    [self checkVisibilityViews];
    if([self.typeAi isEqual:@"yes"]) {
        self.UserAddViewContainer.hidden = YES;
        self.UserMuteViewContainer.hidden = YES;
        self.burnAfterReadingContainerView.hidden = YES;
        self.secretBgCon.hidden = YES;
        self.screenShotOptionContainerView.hidden = YES;
        self.spaceView1.hidden = YES;
        self.spaceView2.hidden = YES;
    }else {
        [self getFriendDetailRequest];
    }
    [self addArrayData];
    [self updateLanguageTitle];
}

-(void)addArrayData{
    [self.languageItems removeAllObjects];
    LanguageInfo *product001 = [LanguageInfo new];
    product001.name = @"None".icanlocalized;
    product001.code = @"None";
    LanguageInfo *product = [LanguageInfo new];
    product.name = @"English".icanlocalized;
    product.code = @"en-us";
    LanguageInfo *product1 = [LanguageInfo new];
    product1.name = @"Turkish".icanlocalized;
    product1.code = @"tr";
    LanguageInfo *product2 = [LanguageInfo new];
    product2.name = @"Chinese".icanlocalized;
    product2.code = @"zh-cn";
    LanguageInfo *product3 = [LanguageInfo new];
    product3.name = @"Vietnam".icanlocalized;
    product3.code = @"vi";
    LanguageInfo *product4 = [LanguageInfo new];
    product4.name = @"Khmer".icanlocalized;
    product4.code = @"km";
    LanguageInfo *product5 = [LanguageInfo new];
    product5.name = @"Thai".icanlocalized;
    product5.code = @"th";
    LanguageInfo *product6 = [LanguageInfo new];
    product6.name = @"Sinhala".icanlocalized;
    product6.code = @"si";
    LanguageInfo *product7 = [LanguageInfo new];
    product7.name = @"Tamil".icanlocalized;
    product7.code = @"ta";
    [self.languageItems addObject:product001];
    [self.languageItems addObject:product];
    [self.languageItems addObject:product1];
    [self.languageItems addObject:product2];
    [self.languageItems addObject:product3];
    [self.languageItems addObject:product4];
    [self.languageItems addObject:product5];
    [self.languageItems addObject:product6];
    [self.languageItems addObject:product7];
    NSLog(@"%lu",(unsigned long)self.languageItems.count);
}

-(void)updateSecretShow{
    self.secretBgCon.hidden = self.secretLineView.hidden = !UserInfoManager.sharedManager.isSecret;
}

-(void) checkVisibilityViews{
    if([self.chatMode isEqualToString:@"Seller"]){
        self.UserAddViewContainer.hidden = YES;
        self.screenShotOptionContainerView.hidden = YES;
        self.burnAfterReadingContainerView.hidden = YES;
        self.secretBgCon.hidden = YES;
        self.clearChatHistoryContainerView.hidden = YES;
    }
}

-(void)updateLanguageTitle{
    NSString *translateLanguageCode = self.chatSetting.translateLanguageCode?:@"0";
    NSString *rightText = [ChatViewHandleTool getLanguageByLanguageCode:translateLanguageCode];
    self.selectedTranslateLanguage.text = rightText;
}

-(void)getBurningTime{
    NSString*destroyTime = self.chatSetting.destoryTime?:@"0";
    NSString*rightText = [ChatViewHandleTool getTitleByDestroyTime:destroyTime];
    self.burningTimeLabel.text = rightText;
    self.nameLabel.text=self.userMessageInfo.remarkName?:self.userMessageInfo.nickname;
    [self.iconImageView setDZIconImageViewWithUrl:self.userMessageInfo.headImgUrl gender:self.userMessageInfo.gender];
}
-(void)tapIconAction{
    FriendDetailViewController*vc = [[FriendDetailViewController alloc]init];
    vc.userMessageInfo = self.userMessageInfo;
    vc.friendDetailType = FriendDetailType_popChatView;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击加号
-(IBAction)addBtnAction{
    SelectMembersViewController*vc=[[SelectMembersViewController alloc]init];
    vc.selectMemberType=SelectMembersType_ChatDetail;
    vc.userMessageInfo = self.userMessageInfo;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.createGroupSuccessBlock = ^(NSString *groupId, NSString *groupName) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
//消息免打扰
-(IBAction)muteAction{
    [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:self.userId chatType:UserChat];
    [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:self.userId chatType:UserChat authorityType:self.authorityType];
    [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:self.userId chatType:UserChat authorityType:AuthorityType_secret];
    PutUserMute *request = [PutUserMute request];
    request.userId = self.userId;
    request.status = self.muteSwitchBtn.isOn;
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/user/muteUser/%@/%d",request.userId,request.status];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}
//置顶
-(IBAction)topAction{
    [[WCDBManager sharedManager]updateChatSettingIsStick:self.topSwitchBtn.isOn chatId:self.userId chatType:UserChat authorityType:self.authorityType];
    [[WCDBManager sharedManager]updateIsStick:self.topSwitchBtn.isOn chatId:self.userId chatType:UserChat];
}
- (IBAction)appearenceAction {
    [self.navigationController pushViewController:[AppearenceViewController new] animated:YES];
}
//截屏通知
-(IBAction)screenshotAction{
    [[WCDBManager sharedManager]updateChatSettingScreencast:self.screenshotSwitchBtn.isOn chatId:self.userId isGroup:NO chatType:UserChat authorityType:self.authorityType];
    ChatModel * configModel = [[ChatModel alloc]init];
    configModel.chatID = self.userId;
    configModel.chatType = UserChat;
    configModel.authorityType = self.authorityType;
    
    ChatModel*chatModel = [ChatUtil initClickOpenScreenNoticeWithModel:configModel isOpen:self.screenshotSwitchBtn.isOn];;
      [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:YES];
   if (self.clickScreenNoticeBlock) {
       self.clickScreenNoticeBlock(chatModel);
   }
}
//阅后即焚
-(IBAction)burningAction{
    [self showDestroyTimeView];
}

- (IBAction)translateAction:(id)sender {
    [self showPickView];
}

-(void)showPickView{
    @weakify(self);
    NSString *translateLanguageCode = self.chatSetting.translateLanguageCode;
    if(translateLanguageCode == nil || [translateLanguageCode  isEqual: @""]){
        translateLanguageCode = @"None";
    }
    NSString *rightText=[ChatViewHandleTool getLanguageByLanguageCode:translateLanguageCode];
    NSArray *dataArray = [self.languageItems valueForKey:@"name"];
    NSInteger row = [dataArray indexOfObject:rightText];
    [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:@"Select Language".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
        @strongify(self);
        NSString *getLanguageCode = [ChatViewHandleTool getLanguageCodeByLanguage:title];
        [[WCDBManager sharedManager] updateTranslationSettingStates:title translateLanguageCode:getLanguageCode chatId:self.userId chatType:UserChat authorityType:AuthorityType_friend];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.userId;
        config.chatType = UserChat;
        self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
        [self updateLanguageTitle];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

//发起私聊
-(IBAction)sendPrivateAction{
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:self.userMessageInfo.userId,kchatType:UserChat,kauthorityType:AuthorityType_secret,kshowName:self.userMessageInfo.nickname}];
    [self.navigationController pushViewController:vc animated:YES];
}
//清除消息
-(IBAction)clearAction{
    if([self.typeAi isEqual:@"yes"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [self deleteFriendAllMessage:NO];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
    }else {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"Delete on all device".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [self deleteFriendAllMessage:YES];
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [self deleteFriendAllMessage:NO];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        if([[UserInfoManager sharedManager].vip intValue] < 5) {
            [alertController addAction:action1];
            [alertController addAction:action3];
            [alertController showWithAnimated:YES];
        }else {
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController showWithAnimated:YES];
        }
    }
}
//阅后即焚：关闭，即刻焚毁，30分钟，120分钟，8小时，24小时，7天，15天，30天，90天
-(void)showDestroyTimeView{
    NSString*destroyTime=self.chatSetting.destoryTime?:@"0";
    NSString*rightText = [ChatViewHandleTool getTitleByDestroyTime:destroyTime];
    NSArray*dataArray=@[@"Close".icanlocalized, @"Burn immediately".icanlocalized,@"30minutes".icanlocalized,@"120minutes".icanlocalized, @"8hours".icanlocalized, @"24hours".icanlocalized,@"7days".icanlocalized,@"15days".icanlocalized,@"30days".icanlocalized,@"90days".icanlocalized];
    NSInteger row=[dataArray indexOfObject:rightText];
    @weakify(self);
    [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:NSLocalizedString(@"SelectBurningTime", 选择阅后即焚时间) leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
        @strongify(self);
        NSInteger time= [ChatViewHandleTool transformDestroyTitleWithTime:title];
        if ([[NSString stringWithFormat:@"%ld",(long)time]isEqualToString:self.chatSetting.destoryTime]) {
            return;
        }
        [self updateFriendDesTimeWithTime:time];
        [[WCDBManager sharedManager]updateChatSettingDestoryTime:[NSString stringWithFormat:@"%zd",time] chatId:self.userId chatType:UserChat authorityType:self.authorityType];
       if (self.chatSetting) {
           self.chatSetting.destoryTime = [NSString stringWithFormat:@"%zd",time];
       }else{
           ChatModel *config = [[ChatModel alloc]init];
           config.authorityType = self.authorityType;
           config.chatID = self.userId;
           config.chatType = UserChat;
           self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
       }
        [self getBurningTime];
        ChatModel *configModel = [[ChatModel alloc]init];
        configModel.chatID = self.userId;
        configModel.chatType = UserChat;
        configModel.authorityType = self.authorityType;
        ChatModel*chatModel = [ChatUtil creatDestroyTimeMessageModelWithConfig:configModel destoryTime:time];
        if (self.selectDestorytimeBlock) {
            self.selectDestorytimeBlock(chatModel);
        }
        [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:NO];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

-(void)removePick{
    [[JKPickerView sharedJKPickerView] removePickView];
}
-(void)sureAction{
    [[JKPickerView sharedJKPickerView] sureAction];
}

#pragma mark - network
-(void)getFriendDetailRequest{
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=self.userId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        self.userMessageInfo=response;
        if (response.headImgUrl) {
            [[WCDBManager sharedManager]updateGroupMemberHeadImageUrlWithUserId:response.userId headImg:response.headImgUrl];
        }
        UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.userId];
        if (messageInfo) {
            if (![messageInfo.headImgUrl isEqualToString:response.headImgUrl]) {
                [[WCDBManager sharedManager]insertUserMessageInfo:response];
                //发送通知更新tableView
                [[NSNotificationCenter defaultCenter]postNotificationName:kUserMessageChangeNotificatiaon object:nil];
            }
        }else{
            [[WCDBManager sharedManager]insertUserMessageInfo:response];
            //发送通知更新tableView
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserMessageChangeNotificatiaon object:nil];
        }
        [self getBurningTime];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
    
}
-(void)deleteFriendAllMessage:(BOOL)deleteAll{
    UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
    request.userId=self.userMessageInfo.userId;
    request.type=@"UserAll";
    if (deleteAll) {
        request.deleteAll=deleteAll;
    }
    request.authorityType=AuthorityType_friend;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        ChatModel*config = [[ChatModel alloc]init];;
        config.chatID = self.userId;
        config.chatType = UserChat;
        config.authorityType = self.authorityType;
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:self.userId];
        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
        if (self.deleteMessageBlock) {
            self.deleteMessageBlock();
        }
        WebSocketManager.sharedManager.currentChatID=@"";
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
   
}
-(void)updateFriendDesTimeWithTime:(NSInteger)time{
    UpdateFriendDestructionTimeRequest*request=[UpdateFriendDestructionTimeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/userFriend/destructionTime/%@/%zd",self.userMessageInfo.userId,time];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

-(NSMutableArray *)languageItems{
    if (!_languageItems) {
        _languageItems = [NSMutableArray array];
    }
    return _languageItems;
}
@end
