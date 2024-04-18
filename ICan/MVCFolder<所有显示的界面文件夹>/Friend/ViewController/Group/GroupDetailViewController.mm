//
//  GroupDetialViewController.m
//  EasyPay
//
//  Created by young on 24/9/2019.
//  Copyright © 2019 EasyPay. All rights reserved.
//
#import "GroupDetailViewController.h"
#import "SelectMembersViewController.h"
#import "EditGroupNameViewController.h"
#import "EditGroupAnnounceViewController.h"
#import "GroupMemberCollectionViewCell.h"

#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupListInfo.h"

#import "ChatUtil.h"
#import "QRCodeView.h"
#import "JKPickerView.h"
#import "FriendDetailViewController.h"
#import "GroupAllMemberViewController.h"
#import "GroupManagerTableViewController.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "OSSWrapper.h"
#import "SaveViewManager.h"
#import "ChatViewHandleTool.h"
#import "AppearenceViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface GroupDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *translateLbl;
@property (weak, nonatomic) IBOutlet UILabel *translateDescLbl;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *showAllMemberLab;

//群ID
@property (weak, nonatomic) IBOutlet UILabel *groupIdLab;
@property (weak, nonatomic) IBOutlet UILabel *groupIdDetailLab;
//群头像
@property (weak, nonatomic) IBOutlet UILabel *groupIconLab;
@property (weak, nonatomic) IBOutlet UIImageView *groupIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupIconArrowImgView;
//群名称
@property (weak, nonatomic) IBOutlet UILabel *groupNameLab;
@property (weak, nonatomic) IBOutlet UILabel *groupNameDetailLab;
//群二维码
@property (weak, nonatomic) IBOutlet UILabel *groupQrCodeLab;
//群公告
@property (weak, nonatomic) IBOutlet UILabel *groupNoticeLab;
@property (weak, nonatomic) IBOutlet UILabel *groupNoticeDetailLab;
//群管理
@property (weak, nonatomic) IBOutlet UILabel *groupManageLab;
@property (weak, nonatomic) IBOutlet UIControl *groupManagerBgCon;

//消息免打扰
@property (weak, nonatomic) IBOutlet UILabel *muteLabel;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitchBtn;
//置顶
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UISwitch *topSwitchBtn;
//截屏通知
@property (weak, nonatomic) IBOutlet UILabel *screenshotLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenshotDesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *screenshotSwitchBtn;
//阅后即焚
@property (weak, nonatomic) IBOutlet UILabel *burningLabel;
@property (weak, nonatomic) IBOutlet UILabel *burningDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *burningTimeLabel;

//我的群昵称
@property (weak, nonatomic) IBOutlet UILabel *myGroupNicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *myGroupNicknameDetailLab;
//显示群昵称
@property (weak, nonatomic) IBOutlet UILabel *showGroupNicknameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *showGroupNicknameSwitchBtn;
//清除所有缓存
@property (weak, nonatomic) IBOutlet UILabel *clearLab;

//删除并退出
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *selectedTranslateLanguage;
@property (nonatomic,strong) NSMutableArray <LanguageInfo*> *languageItems;
@property (nonatomic,strong) GroupListInfo * groupDetailInfo;
@property (nonatomic,strong) ChatSetting * chatSetting;
@property (nonatomic,strong) NSArray <GroupMemberInfo*>* groupMemberInfoItems;
// 每列的个数
@property (nonatomic, assign) NSInteger columns;
//排序之后的数组
@property (nonatomic,strong) NSMutableArray *sortGroupMemberInfoItems;
@property(nonatomic, strong) RACSignal *signalA;
@property (weak, nonatomic) IBOutlet UILabel *appearenceLabell;
@property(nonatomic, strong) RACSignal *signalB;
@end

@implementation GroupDetailViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)reloadComplationDataA{
    NSInteger maxGroupMemberInfoItemsCount = self.groupMemberInfoItems.count;
    if ([self.groupDetailInfo.role isEqualToString:@"2"]) {
        //普通成员 ordinary member
        if (maxGroupMemberInfoItemsCount>19) {
            maxGroupMemberInfoItemsCount = 19;
        }
    }else{
        //群主管理员 Group owner administrator
        if (maxGroupMemberInfoItemsCount>18) {
            maxGroupMemberInfoItemsCount = 18;
        }
        
    }
    [self.sortGroupMemberInfoItems removeAllObjects];
    for (int i = 0; i < 3; i++) {
        for (int j =0; j < maxGroupMemberInfoItemsCount; j++) {
            GroupMemberInfo * info = self.groupMemberInfoItems[j];
            if ([info.role isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
                [self.sortGroupMemberInfoItems addObject:info];
            }
        }
    }
    [self.collectionView reloadData];
//    commented for future needs
//    [self.collectionView layoutSubviews];
//    [self.collectionView layoutIfNeeded];
    self.collectionViewHeight.constant=self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.translateLbl.text = @"translate".icanlocalized;
    self.translateDescLbl.text = @"Select Language".icanlocalized;
    self.appearenceLabell.text = @"Appearance".icanlocalized;
    [self addArrayData];
    [self fetchGroupDetailRequest];
    [self fetchGroupMemberInfo];
    self.groupMemberInfoItems = [[WCDBManager sharedManager]getAllGroupMemberByGroupId:self.config.chatID];
    [self reloadComplationDataA];
// ---------------------------------------------------commented for future uses--------------------------------------------------------------   [self rac_liftSelector:@selector(reloadComplationDataA:dataB:) withSignalsFromArray:@[self.signalA,self.signalB]];
    [self.collectionView registNibWithNibName:KGroupMemberCollectionViewCell];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroupDetail:) name:kUpdateGroupMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroupDetail:) name:KGetGroupDetailNotification object:nil];
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = self.config.chatID;
    config.chatType = GroupChat;
    self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
    //    self.view.backgroundColor = UIColorViewBgColor;
    [self setUI];
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

-(void)setUI{
    self.groupIdLab.text = @"Group ID".icanlocalized;
    self.groupIconLab.text = NSLocalizedString(@"Group avatar", 群头像);
    self.groupNameLab.text = @"group.detail.listCell.groupNmae".icanlocalized;//群聊名稱;
    self.groupQrCodeLab.text = @"group.detail.listCell.groupQRCode".icanlocalized;//群二维码
    self.groupNoticeLab.text = @"group.detail.listCell.groupNotice".icanlocalized;
    self.groupManageLab.text = NSLocalizedString(@"group.detail.listCell.groupManagement", 群管理);
    self.showAllMemberLab.text = @"View all members".icanlocalized;
    self.muteLabel.text = NSLocalizedString(@"Mute Notifications", 消息免打扰);
    self.topLabel.text = NSLocalizedString(@"Sticky on Top", 置顶聊天);
    self.screenshotLabel.text = NSLocalizedString(@"ScreenshotNotice", 截屏通知);
    self.screenshotDesLabel.text = NSLocalizedString(@"ScreenshotNoticeTips", @"开启后,在对话中的截屏你会收到消息通知");
    self.burningLabel.text=NSLocalizedString(@"BurningAfterReading", 阅后即焚);
    self.burningDesLabel.text = NSLocalizedString(@"Burn off after reading", [阅后即焚 关闭]);
    self.myGroupNicknameLab.text = NSLocalizedString(@"group.detail.listCell.myNickname", 我的群昵称);
    self.showGroupNicknameLabel.text = NSLocalizedString(@"group.detail.listCell.showNickname", 显示群昵称);
    self.clearLab.text = NSLocalizedString(@"Clear Chat History", 清空聊天记录);
    [self.quitBtn setTitle:NSLocalizedString(@"group.detail.listCell.deleteAndExitGroup", 删除并退出群) forState:UIControlStateNormal];
    [self.quitBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self updateGroupMessage];
}
-(void)updateGroupMessage{
    self.groupIdDetailLab.text = self.groupDetailInfo.groupNumberId;
    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:self.groupDetailInfo.headImgUrl] placeholderImage:[UIImage imageNamed:GroupDefault]];
    self.groupIconArrowImgView.hidden = [self.groupDetailInfo.role isEqualToString:@"2"];
    self.groupNameDetailLab.text = self.groupDetailInfo.name;
    self.groupNoticeDetailLab.text = self.groupDetailInfo.announce?:[@"tip.notSet" icanlocalized:@"未设置"];
    
    self.muteSwitchBtn.on = self.groupDetailInfo.messageNotDisturb;
    self.topSwitchBtn.on = self.groupDetailInfo.topChat;
    self.screenshotSwitchBtn.enabled = ![self.groupDetailInfo.role isEqualToString:@"2"];
    self.screenshotSwitchBtn.on = self.groupDetailInfo.screenCaptureNotice;
    
    self.myGroupNicknameDetailLab.text = self.groupDetailInfo.groupRemark?:[@"tip.notSet" icanlocalized:@"未设置"];
    self.showGroupNicknameSwitchBtn.on=self.groupDetailInfo.displaysGroupUserNicknames;
    self.groupManagerBgCon.hidden = [self.groupDetailInfo.role isEqualToString:@"2"];
    [self updateDestroyTimeTitle];
    [self updateLanguageTitle];
}

-(void)updateDestroyTimeTitle{
    NSString*destroyTime = self.groupDetailInfo.destructionTime?:@"0";
    NSString*rightText = [ChatViewHandleTool getTitleByDestroyTime:destroyTime];
    self.burningTimeLabel.text = rightText;
}

-(void)updateLanguageTitle{
    NSString *translateLanguageCode = self.chatSetting.translateLanguageCode?:@"0";
    NSString *rightText = [ChatViewHandleTool getLanguageByLanguageCode:translateLanguageCode];
    self.selectedTranslateLanguage.text = rightText;
}

-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//显示全部群成员
-(IBAction)showAllMemberAction{
    GroupAllMemberViewController*vc=[[GroupAllMemberViewController alloc]init];
    vc.groupDetailInfo  =self.groupDetailInfo;
    vc.allMemberItems=self.groupMemberInfoItems;
    [self.navigationController pushViewController:vc animated:YES];
}
//群头像
-(IBAction)groupIconAction{
    if ([self.groupDetailInfo.role isEqualToString:@"2"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"Only the owner and manager can modify the group avatar".icanlocalized inView:nil];
    }else{
        [self showAlert];
    }
}
//群名称
-(IBAction)groupNameAction{
    if (![self.groupDetailInfo.role isEqualToString:@"2"]) {
        EditGroupNameViewController*vc=[[EditGroupNameViewController alloc]init];
        vc.groupDetailInfo=self.groupDetailInfo;
        vc.editNameType=EditNameType_GroupName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//群二维码
-(IBAction)groupQrCodeAction{
    
    QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    view.groupDetailInfo=self.groupDetailInfo;
    view.qrCodeViewTyep=QRCodeViewTyep_group;
    [view showQRCodeView];
}
//群公告
-(IBAction)groupNoticeAction{
    EditGroupAnnounceViewController*vc=[[EditGroupAnnounceViewController alloc]init];
    vc.groupDetailInfo=self.groupDetailInfo;
    @weakify(self);
    vc.settingGroupAnnounceBlock = ^(NSString * _Nonnull announce) {
        @strongify(self);
        self.groupDetailInfo.announce=announce;
        ChatModel * config = [[ChatModel alloc]init];
        config.chatID = self.groupDetailInfo.groupId;
        config.chatType = GroupChat;
        config.authorityType = AuthorityType_friend;
        ChatModel*model=[ChatUtil creatAtAllMessageInfoWithConfig:config announce:announce];
        [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
        if (self.atAllMemberBlock) {
            self.atAllMemberBlock(model);
        }
        self.groupNoticeDetailLab.text = announce;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//群管理
-(IBAction)groupManageAction{
    GroupManagerTableViewController*vc=[GroupManagerTableViewController new];
    vc.allMemberItems = self.groupMemberInfoItems;
    vc.groupDetailInfo=self.groupDetailInfo;
    vc.sucessSettingOwnerBlock = ^{
        [self fetchGroupDetailRequest];
    };
    vc.deleteSuccessBlock = ^{
        if (self.deleteSuccessBlock) {
            self.deleteSuccessBlock();
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//消息免打扰
-(IBAction)muteAction{
    [self settingGroupMessageNotDisturbRequest];
    [[WCDBManager sharedManager]updateIsNoDisturbing:self.muteSwitchBtn.isOn chatId:self.groupDetailInfo.groupId chatType:GroupChat];
    [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:self.muteSwitchBtn.isOn chatId:self.groupDetailInfo.groupId chatType:GroupChat authorityType:AuthorityType_friend];
    
}
//置顶
-(IBAction)topAction{
    [self settingGroupTopChatRequest];
    [[WCDBManager sharedManager]updateChatSettingIsStick:self.topSwitchBtn.isOn chatId:self.groupDetailInfo.groupId chatType:GroupChat authorityType:AuthorityType_friend];
    [[WCDBManager sharedManager]updateIsStick:self.topSwitchBtn.isOn chatId:self.groupDetailInfo.groupId chatType:GroupChat];
}
//截屏通知
-(IBAction)screenshotAction{
    [self settingGroupScreenCaptureNoticeRequest];
    [[WCDBManager sharedManager]updateChatSettingScreencast:self.screenshotSwitchBtn.isOn chatId:self.groupDetailInfo.groupId isGroup:YES chatType:GroupChat authorityType:AuthorityType_friend];
    ChatModel * configModel = [[ChatModel alloc]init];
    configModel.chatID = self.groupDetailInfo.groupId;
    configModel.chatType = GroupChat;
    configModel.authorityType = AuthorityType_friend;
    ChatModel*chatModel=[ChatUtil initClickOpenScreenNoticeWithModel:configModel isOpen:self.screenshotSwitchBtn.isOn];;
    [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:NO];
    if (self.clickScreenNoticeBlock) {
        self.clickScreenNoticeBlock(chatModel);
    }
}
//阅后即焚
-(IBAction)burningAction{
    if ([self.groupDetailInfo.role isEqualToString:@"2"]) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"FunctionOfBurningRemind", 只有管理员才可以切换阅后即焚开关) inView:self.view];
    }else{
        @weakify(self);
        NSString*destroyTime=self.groupDetailInfo.destructionTime?:@"0";
        NSString*rightText=[ChatViewHandleTool getTitleByDestroyTime:destroyTime];
        //设置显示的名字
        NSArray*dataArray=@[@"Close".icanlocalized, @"Burn immediately".icanlocalized,@"30minutes".icanlocalized,@"120minutes".icanlocalized, @"8hours".icanlocalized, @"24hours".icanlocalized,@"7days".icanlocalized,@"15days".icanlocalized,@"30days".icanlocalized,@"90days".icanlocalized];
        NSInteger row=[dataArray indexOfObject:rightText];
        [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:NSLocalizedString(@"SelectBurningTime", SelectBurningTime) leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
            @strongify(self);
            NSInteger time= [ChatViewHandleTool transformDestroyTitleWithTime:title];
            if ([[NSString stringWithFormat:@"%ld",(long)time]isEqualToString:self.chatSetting.destoryTime]) {
                return;
            }
            [self settingDestructionTimeRequestWithTime:[NSString stringWithFormat:@"%ld",(long)time]];
            [[WCDBManager sharedManager]updateChatSettingDestoryTime:[NSString stringWithFormat:@"%ld",(long)time] chatId:self.groupDetailInfo.groupId chatType:GroupChat authorityType:AuthorityType_friend];
            self.groupDetailInfo.destructionTime=[NSString stringWithFormat:@"%ld",(long)time];
            if (self.chatSetting) {
                self.chatSetting.destoryTime=[NSString stringWithFormat:@"%ld",(long)time];
                
            }else{
                ChatModel * config = [[ChatModel alloc]init];
                config.authorityType = AuthorityType_friend;
                config.chatID = self.config.chatID;
                config.chatType = GroupChat;
                self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
            }
            ChatModel * configModel = [[ChatModel alloc]init];
            configModel.chatID = self.groupDetailInfo.groupId;
            configModel.chatType = GroupChat;
            configModel.authorityType = AuthorityType_friend;
            ChatModel*chatModel = [ChatUtil creatDestroyTimeMessageModelWithConfig:configModel destoryTime:time];
            if (self.selectDestorytimeBlock) {
                self.selectDestorytimeBlock(chatModel);
            }
            [self updateDestroyTimeTitle];
            [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:NO];
        }];
        [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
        
    }
    
}

- (IBAction)translateAction:(id)sender {
    [self showPickView];
}
- (IBAction)appearenceAction {
    [self.navigationController pushViewController:[AppearenceViewController new] animated:YES];
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
        [[WCDBManager sharedManager] updateTranslationSettingStates:title translateLanguageCode:getLanguageCode chatId:self.groupDetailInfo.groupId chatType:GroupChat authorityType:AuthorityType_friend];
        ChatModel * config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.config.chatID;
        config.chatType = GroupChat;
        self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
        [self updateLanguageTitle];
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
    
}

//我的群昵称
-(IBAction)myGroupNicknameAction{
    EditGroupNameViewController*vc = [[EditGroupNameViewController alloc]init];
    vc.groupDetailInfo = self.groupDetailInfo;
    vc.editNameType = EditNameType_GroupNickname;
    [self.navigationController pushViewController:vc animated:YES];
}
//显示群昵称
-(IBAction)showGroupNicknameAction{
    [self settingGroupShowNickNameRequest];
    [[WCDBManager sharedManager]updateChatSettingIsShowNickname:self.showGroupNicknameSwitchBtn.isOn chatId:self.groupDetailInfo.groupId chatType:GroupChat];
    if (self.clickIsShowNicknameBlock) {
        self.clickIsShowNicknameBlock(self.showGroupNicknameSwitchBtn.isOn);
    }
}
//清除消息
-(IBAction)clearAction{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"Delete on all device".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self deleteGroupAllMessage];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self deleteFromMySide];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    if([self.groupDetailInfo.role isEqualToString:@"0"] || [self.groupDetailInfo.role isEqualToString:@"1"]) {
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
    }else {
        [alertController addAction:action1];
        [alertController addAction:action3];
    }
    [alertController showWithAnimated:YES];
}

//删除退出群
- (IBAction)deleteAction {
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Exit group or not", 是否退出群) message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            [self quitGroup];
        }
    }];
}
#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.groupDetailInfo.role isEqualToString:@"2"]) {
        return self.sortGroupMemberInfoItems.count+1;
    }
    return self.sortGroupMemberInfoItems.count+2;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KGroupMemberCollectionViewCell forIndexPath:indexPath];
    if (indexPath.item < self.sortGroupMemberInfoItems.count) {
        cell.memberInfo = self.sortGroupMemberInfoItems[indexPath.item];
    }
    else if(indexPath.item == self.sortGroupMemberInfoItems.count){
        cell.image = [UIImage imageNamed:@"icon_groupdetail_addmember"];
    }else{
        cell.image = [UIImage imageNamed:@"icon_groupdetail_reducemember"];
    }
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.groupDetailInfo.role isEqualToString:@"2"]) {
        if (indexPath.item == self.sortGroupMemberInfoItems.count) {
            [self selectNewUserJoinInRoom];
        }else{
            [self didSelectMucMember:[self.sortGroupMemberInfoItems objectAtIndex:indexPath.item]];
        }
    }else{
        if (indexPath.item == self.sortGroupMemberInfoItems.count) {
            [self selectNewUserJoinInRoom];
        }else if (indexPath.item==self.sortGroupMemberInfoItems.count+1){
            [self  deleteMembersAction];
        }else{
            [self didSelectMucMember:[self.sortGroupMemberInfoItems objectAtIndex:indexPath.item]];
        }
    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 120) / 5, (ScreenWidth - 120) / 5+20);
    
    
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//设置section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
-(void)getGroupDetail:(NSNotification*)notifi{
    NSString*groupId=(NSString*)notifi.object;
    if ([groupId isEqualToString:self.config.chatID]) {
        [self fetchGroupDetailRequest];
    }
}
//更换群头像
- (void)showAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"Cancel".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"chatView.function.camera", 拍照) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self photographToSetHeaderPic];
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
}

//从相册选择
-(void)selectPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            [self setHeadPicWithImage:photos.firstObject];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
    
    
}
//拍照
-(void)photographToSetHeaderPic{
    
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [self setHeadPicWithImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                    [SaveViewManager saveImageToPhotos:image success:^{
                        
                    } failed:^{
                        
                    }];
                    
                } failure:^{
                    
                }];
                
            });
        }];
        
    } failure:^{
        
    }];
    
    
}

-(void)setHeadPicWithImage:(UIImage*)image{
    NSData*smallAlbumData=[UIImage compressImageSize:image toByte:1024*50];
    [QMUITipsTool showLoadingWihtMessage: NSLocalizedString(@"Setup...", 设置中...) inView:self.view isAutoHidden:NO];
    [[[OSSWrapper alloc]init] setUserHeadImageWithImage:smallAlbumData type:@"0" success:^(NSString * _Nonnull url) {
        [self setGroupHeadPortraitWihtUrl:url];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)removePick{
    [[JKPickerView sharedJKPickerView] removePickView];
}
-(void)sureAction{
    [[JKPickerView sharedJKPickerView] sureAction];
}
-(void)didSelectMucMember:(id)groupMemberInfo{
    GroupMemberInfo *info = groupMemberInfo;
    if (self.groupDetailInfo.showUserInfo) {
        if ([self.groupDetailInfo.role isEqualToString:@"0"]||[self.groupDetailInfo.role isEqualToString:@"1"]) {
            FriendDetailViewController*vc = [FriendDetailViewController new];
            vc.userId = info.userId;
            vc.friendDetailType = FriendDetailType_pushChatViewNotification;
            vc.isGroupOwnerOrAdmin = YES;
            vc.viwerRole = self.groupDetailInfo.role;
            vc.sortGroupMemberInfoItems = self.sortGroupMemberInfoItems;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            FriendDetailViewController*vc = [FriendDetailViewController new];
            vc.userId = info.userId;
            vc.friendDetailType = FriendDetailType_pushChatViewNotification;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if ([info.role isEqualToString:@"0"]||[info.role isEqualToString:@"1"]) {
            FriendDetailViewController *vc = [FriendDetailViewController new];
            vc.userId = info.userId;
            vc.friendDetailType = FriendDetailType_pushChatViewNotification;
            vc.isGroupOwnerOrAdmin = YES;
            vc.viwerRole = self.groupDetailInfo.role;
            vc.sortGroupMemberInfoItems = self.sortGroupMemberInfoItems;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//邀请别人进群
- (void)selectNewUserJoinInRoom {
    SelectMembersViewController *vc = [[SelectMembersViewController alloc]init];
    vc.selectMemberType = SelectMembersType_addMember;
    vc.inGroupMember = self.groupMemberInfoItems;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.groupId = self.groupDetailInfo.groupId;
    vc.addMemberSuccessBlock = ^(ChatModel *model) {
//        [self rac_liftSelector:@selector(reloadComplationDataA:dataB:) withSignalsFromArray:@[self.signalA,self.signalB]];------>commented for future uses
        [self fetchGroupDetailRequest];
        [self fetchGroupMemberInfo];
        self.groupMemberInfoItems = [[WCDBManager sharedManager]getAllGroupMemberByGroupId:self.config.chatID];
        [self reloadComplationDataA];
    };
    
    [self presentViewController:nav animated:YES completion:nil];
}

/// 踢人
-(void)deleteMembersAction{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.groupMemberInfoItems];
    for (GroupMemberInfo * model in self.groupMemberInfoItems) {
        if ([model.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
            [array removeObject:model];
            break;
        }
    }
    SelectMembersViewController * vc = [SelectMembersViewController new];
    vc.selectMemberType = SelectMenbersType_kickOut ;
    vc.groupId = self.groupDetailInfo.groupId;
    vc.groupDetailInfo=self.groupDetailInfo;
    vc.removeInGroupMembers = array;
    vc.quitMemberSuccessBlock = ^(ChatModel *model) {
//        [self rac_liftSelector:@selector(reloadComplationDataA:dataB:) withSignalsFromArray:@[self.signalA,self.signalB]];------> commented for future uses
        [self fetchGroupDetailRequest];
        [self fetchGroupMemberInfo];
        self.groupMemberInfoItems = [[WCDBManager sharedManager]getAllGroupMemberByGroupId:self.config.chatID];
        [self reloadComplationDataA];
        
    };
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)quitGroup{
    QuitGroupRequest*request=[QuitGroupRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/exit/%@",self.groupDetailInfo.groupId];
    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"Exit Group...", 退群中...) inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Quit successfully", 成功退出) inView:self.view];
        ChatModel *config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.groupDetailInfo.groupId;
        config.chatType = GroupChat;
        [[WCDBManager sharedManager]deleteResourceWihtChatId:self.groupDetailInfo.groupId];
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WebSocketManager sharedManager]unsubscribeGroupWithGroupId:self.groupDetailInfo.groupId];
        [[WCDBManager sharedManager]deleteGroupListInfoWithGroupId:self.groupDetailInfo.groupId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:KChatListRefreshNotification object:nil userInfo:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
/** 获取群成员 */
-(void)fetchGroupMemberInfo{
    GetGroupUserListRequest*request=[GetGroupUserListRequest request];
    request.groupId=self.config.chatID;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
        [[WCDBManager sharedManager]deleteAllGroupMemberByGroupId:self.config.chatID];
        [[WCDBManager sharedManager]insertOrReplaceGroupMemberInfoWithArray:response];
        self.groupMemberInfoItems = [[WCDBManager sharedManager]getAllGroupMemberByGroupId:self.config.chatID];
        [self reloadComplationDataA];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

-(void)fetchGroupDetailRequest{
    GetGroupDetailRequest * request =[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,self.config.chatID];
    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"Loading", 加载中) inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo * response) {
        [[WCDBManager sharedManager]updateShowName:response.name chatId:response.groupId chatType:GroupChat];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QMUITips hideAllTips];
        });
        self.groupDetailInfo = response;
        self.nameLabel.text=[NSString stringWithFormat:@"%@（%@）",response.name,response.userCount];
        self.title = response.name;
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:@[response]];
        [[WCDBManager sharedManager]updateChatSettingDestoryTime:response.destructionTime chatId:response.groupId chatType:GroupChat authorityType:AuthorityType_friend];
        self.groupMemberInfoItems = [[WCDBManager sharedManager]getAllGroupMemberByGroupId:self.config.chatID];
        [self reloadComplationDataA];
        [self updateGroupMessage];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)settingGroupScreenCaptureNoticeRequest{
    SettingScreenCaptureNoticeRequest*request=[SettingScreenCaptureNoticeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/screenCaptureNotice/%@",self.config.chatID];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)settingDestructionTimeRequestWithTime:(NSString*)time{
    SettingDestructionTimeRequest*request=[SettingDestructionTimeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/destructionTime/%@/%@",self.config.chatID,time];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITips hideAllTips];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
//设置是否显示群昵称
-(void)settingGroupShowNickNameRequest{
    SettingGroupShowNickNameRequest*request=[SettingGroupShowNickNameRequest request];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/%@/showNickName",self.config.chatID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
//免打扰
-(void)settingGroupMessageNotDisturbRequest{
    SettingGroupMessageNotDisturbRequest*request=[SettingGroupMessageNotDisturbRequest request];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/%@/messageNotDisturb",self.config.chatID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
//置顶
-(void)settingGroupTopChatRequest{
    SettingGroupTopChatRequest*request=[SettingGroupTopChatRequest request];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/%@/topChat",self.config.chatID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
//设置群头像
-(void)setGroupHeadPortraitWihtUrl:(NSString*)path{
    ChangeGroupHeadImgUrlRequest * request = [ChangeGroupHeadImgUrlRequest request];
    request.groupId =self.config.chatID;
    request.headImgUrl =path;
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
        self.groupDetailInfo.headImgUrl =path;
        [self updateGroupMessage];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(void)deleteGroupAllMessage{
        UserRemoveMessageRequest *request = [UserRemoveMessageRequest request];
        request.groupId = self.groupDetailInfo.groupId;
        request.type = @"GroupAll";
        request.deleteAll = true;
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            NSLog(@"%@",info);
        }];
        [self deleteFromMySide];
}

-(void)deleteFromMySide{
    ChatModel *config = [[ChatModel alloc]init];;
    config.chatID = self.groupDetailInfo.groupId;
    config.chatType = GroupChat;
    config.authorityType = AuthorityType_friend;;
    [[WCDBManager sharedManager]deleteAllChatModelWith:config];
    [[WCDBManager sharedManager]deleteResourceWihtChatId:self.groupDetailInfo.groupId];
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
    if (self.deleteSuccessBlock) {
        self.deleteSuccessBlock();
    }
    WebSocketManager.sharedManager.currentChatID = @"";
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
}

-(NSMutableArray *)sortGroupMemberInfoItems{
    if (!_sortGroupMemberInfoItems) {
        _sortGroupMemberInfoItems = [NSMutableArray array];
    }
    return _sortGroupMemberInfoItems;
}

-(NSMutableArray *)languageItems{
    if (!_languageItems) {
        _languageItems = [NSMutableArray array];
    }
    return _languageItems;
}
@end

