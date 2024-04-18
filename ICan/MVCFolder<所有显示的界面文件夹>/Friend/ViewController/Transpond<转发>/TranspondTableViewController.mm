//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/27
 - ICan
 - File name:  TranspondTableViewController.m
 - Description:
 - Function List:
 */


#import "TranspondTableViewController.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupListInfo.h"
#import "UIView+Nib.h"
#import "TranspondSearchResultFriendTableViewCell.h"
#import "TranspondHeadView.h"
#import "ChatUtil.h"
#import "SelectTranspondMoreCollectionViewCell.h"
#import "SelectMembersViewController.h"
#import "TranspondShowDetailView.h"
#import "ChatListModel.h"
#import <WBGLinkPreview/WBGLinkPreview.h>
@interface TranspondTableViewController ()<QMUISearchControllerDelegate>
/**
 源数据 聊天列表
 */
@property(nonatomic, strong) NSMutableArray<ChatListModel*> *chatListItems;
/**
 群聊列表
 */
@property(nonatomic, strong) NSMutableArray<GroupListInfo*> *groupListItems;
/**
 好友列表
 */
@property(nonatomic, strong) NSArray<UserMessageInfo*> *friendItems;
@property(nonatomic, strong) UIButton *changeSelectStateBtn;
/** 能否多选 */
@property (nonatomic, assign)  BOOL isCanSelect;
/** 需要转发的人或者群 */
@property (nonatomic,strong) NSMutableArray * selectForwarArray;
/** 多选的时候搜索结果items  */

@property(nonatomic, strong) NSMutableArray *searchResultArray;

@property(nonatomic, strong) TranspondHeadView *headView;
@property(nonatomic, strong) NSMutableArray *needSendUserArray;
@property(nonatomic, strong) NSMutableArray *needSendMessageArray;
@property(nonatomic, strong) TranspondShowDetailView *transpondDetailView;
@end

@implementation TranspondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Select friends".icanlocalized;
    self.chatListItems=[NSMutableArray array];
    for (ChatListModel*model in [[WCDBManager sharedManager]getAllIcanChatListModel] ) {
        if ([model.chatType isEqualToString:UserChat]) {
            if (![model.chatID isEqualToString:PayHelperMessageType]&&![model.chatID isEqualToString:ShopHelperMessageType]&&![model.chatID isEqualToString:SystemHelperMessageType]) {
                [self.chatListItems addObject:model];
            }
            
            if ([model.chatID isEqualToString:SystemHelperMessageType]) {
                [self.chatListItems addObject:model];
            }
            
        }else{
            GroupListInfo*info=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:model.chatID];
            if (info.isInGroup) {
                if ([info.role isEqualToString:@"0"]) {
                    [self.chatListItems addObject:model];
                }else{
                    //如果没有被禁言 还可以转发
                    if (!info.allShutUp) {
                        [self.chatListItems addObject:model];
                    }
                }
            }
            
        }
    }
    self.groupListItems=[NSMutableArray array];
    for (GroupListInfo*listInfo in [[WCDBManager sharedManager]getAllGroupListInfo]) {
        if (listInfo.isInGroup) {
            [self.groupListItems addObject:listInfo];
        }
    }
    self.friendItems=[[WCDBManager sharedManager]fetchFriendList];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"Close", nil) target:self action:@selector(cancleAction)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.changeSelectStateBtn];
    if (self.chatListItems.count>0) {
        NSDictionary*dict=@{@"type":@"chatList",@"array":self.chatListItems};
        [self.searchResultArray addObject:dict];
    }
}
- (void)cancleAction {
    if (self.isCanSelect) {
        self.isCanSelect = NO;
        [self.tableView reloadData];
        for (ChatListModel*listModel in self.chatListItems) {
            listModel.isSelect=NO;
        }
        for (GroupListInfo*listInfo in self.groupListItems) {
            listInfo.isSelect=NO;
        }
        for (UserMessageInfo*messageInfo in self.friendItems) {
            messageInfo.isSelect=NO;
        }
        self.changeSelectStateBtn=nil;
        [self.changeSelectStateBtn setTitle:@"Multiple".icanlocalized forState:(UIControlStateNormal)];
        [self.changeSelectStateBtn setTitleColor:UIColor252730Color forState:(UIControlStateNormal)];
        self.changeSelectStateBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeSelectStateBtn];
        //当多选的情况下点击关闭按钮 需要重新刷新tableView
        if (self.chatListItems.count>0) {
            [self.searchResultArray removeAllObjects];
            NSDictionary*dict=@{@"type":@"chatList",@"array":self.chatListItems};
            [self.searchResultArray addObject:dict];
        }
        [self.selectForwarArray removeAllObjects];
        [self.tableView reloadData];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.tableView reloadData];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        
    }
}

#pragma mark =  多选 ==
- (void)multiselectAction {
    //如果当前是多选状态
    if (self.isCanSelect) {
        [self alertSendView];
    } else {
        self.isCanSelect = YES;
        self.changeSelectStateBtn=nil;
        [self.changeSelectStateBtn setBackgroundColor:UIColorThemeMainColor];
        [self.changeSelectStateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.changeSelectStateBtn.frame=CGRectMake(0, 0, 50, 30);
        self.changeSelectStateBtn.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeSelectStateBtn];
        [self.changeSelectStateBtn setTitle:NSLocalizedString(@"Done", 完成) forState:(UIControlStateNormal)];
        [self.selectForwarArray removeAllObjects];
        [self.tableView reloadData];
    }
}
- (void)checkSelectBtnState {
    if (self.selectForwarArray.count == 0) {
        self.changeSelectStateBtn=nil;
        [self.changeSelectStateBtn setBackgroundColor:UIColorThemeMainColor];
        [self.changeSelectStateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.changeSelectStateBtn.frame=CGRectMake(0, 0, 50, 30);
        self.changeSelectStateBtn.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeSelectStateBtn];
        [self.changeSelectStateBtn setTitle:NSLocalizedString(@"Done", 完成) forState:(UIControlStateNormal)];
    } else {
        self.changeSelectStateBtn=nil;
        self.changeSelectStateBtn.frame=CGRectMake(0, 0, 80, 30);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeSelectStateBtn];
        self.changeSelectStateBtn.userInteractionEnabled = YES;
        [self.changeSelectStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changeSelectStateBtn setBackgroundColor:UIColorThemeMainColor];
        [self.changeSelectStateBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"Done", 完成), (unsigned long)self.selectForwarArray.count] forState:(UIControlStateNormal)];
        
        
    }
}
-(ChatModel*)creatChatModel:(id)obj{
    ChatModel*model;
    if ([obj isKindOfClass:[ChatListModel class]]) {
        ChatListModel*listModel=obj;
        model=[ChatUtil creatChatMessageModelWithChatId:listModel.chatID chatType:listModel.chatType authorityType:AuthorityType_friend circleUserId:nil];
    }else if ([obj isKindOfClass:[GroupListInfo class]]){
        GroupListInfo*listModel=obj;
        model=[ChatUtil creatChatMessageModelWithChatId:listModel.groupId chatType:GroupChat authorityType:AuthorityType_friend circleUserId:nil];
    }else if ([obj isKindOfClass:[UserMessageInfo class]]){
        UserMessageInfo*info=obj;
        model=[ChatUtil creatChatMessageModelWithChatId:info.userId chatType:UserChat authorityType:AuthorityType_friend circleUserId:nil];
    }
    return model;
}
///选择联系人之后 弹出确认转发的框
- (void)alertSendView {
    [self.view endEditing:YES];
    if (self.chatOtherUrlInfo) {
        //分享的是其他应用 例如商品详情
        for (id obj in self.selectForwarArray) {
            ChatModel*model= [self creatChatModel:obj];
            model.messageType=kChatOtherShareType;
            model.messageContent=[self.chatOtherUrlInfo mj_JSONString];
            self.selectMessagegArray =[NSMutableArray arrayWithObject:model];
        }

        self.transpondDetailView.selectMessageArray = self.selectMessagegArray;
        self.transpondDetailView.userArr = self.selectForwarArray;
        [self.transpondDetailView showTranspondDetailView];
       
    }else if (self.chatPostShareMessageInfo){
        //分享的是朋友圈
        for (id obj in self.selectForwarArray) {
            ChatModel*model= [self creatChatModel:obj];
            model.messageType=kChat_PostShare;
            model.messageContent=[self.chatPostShareMessageInfo mj_JSONString];
            [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
        }
        [self.navigationController popViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else if (self.transpondType ==TranspondType_Image){
        self.selectMessagegArray = [NSMutableArray array];
        ChatModel * model = [[ChatModel alloc]init];
        model.messageType = @"Image_Share";
        NSData*smallAlbumData=[UIImage compressImageSize:self.shareImg toByte:1024*50];
        model.orignalImageData = smallAlbumData;
        [self.selectMessagegArray addObject:model];
        self.transpondDetailView.selectMessageArray = self.selectMessagegArray;
        self.transpondDetailView.userArr = self.selectForwarArray;
        [self.transpondDetailView showTranspondDetailView];
    } else {
        //分享的是聊天消息
        self.transpondDetailView.selectMessageArray = self.selectMessagegArray;
        self.transpondDetailView.userArr = self.selectForwarArray;
        [self.transpondDetailView showTranspondDetailView];
    }
    
    
}

//这个是分享完成之后的界面隐藏
-(void)endTranspond{
    switch (self.transpondType) {
        case TranspondType_Time:
        case TranspondType_ChatVc:{
            [self.navigationController popViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:NO completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
            break;
        case TranspondType_OtherApp:{
            [self dismissViewControllerAnimated:YES completion:^{
                ///如果是从其他APP分享过来的，如果当前转发的聊天只有一个，那么跳转到对应的聊天界面
                if (self.needSendUserArray.count==1) {
                    self.pushChatViewBlock(self.needSendUserArray.firstObject, self.selectMessagegArray);
                }
            }]; 
            
        }
            break;
        case TranspondType_Image:{
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.endBlock) {
                    self.endBlock(self.needSendUserArray, self.selectMessagegArray);
                }
            }];
        }
            break;
    }
    
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:KTranspondSearchResultFriendTableViewCell];
    self.tableView.tableHeaderView = self.headView;
    
}
-(void)layoutTableView{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchResultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary*dict=[self.searchResultArray objectAtIndex:section];
    NSMutableArray*item=[dict objectForKey:@"array"];
    return item.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TranspondSearchResultFriendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:KTranspondSearchResultFriendTableViewCell];
    cell.isShowSelectButton=self.isCanSelect;
    if (self.searchResultArray.count>0) {
        NSDictionary*dict=[self.searchResultArray objectAtIndex:indexPath.section];
        NSString*type=[dict objectForKey:@"type"];
        NSMutableArray*array=[dict objectForKey:@"array"];
        if ([type isEqualToString:@"friend"]) {
            cell.userMessageInfo=[array objectAtIndex:indexPath.row];
        }else if ([type isEqualToString:@"chatList"]){
            cell.chatListModel=[array objectAtIndex:indexPath.row];
        }
        else {
            cell.groupListInfo=[array objectAtIndex:indexPath.row];
        }
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor=UIColorBg243Color;
    UILabel*label=[UILabel leftLabelWithTitle:NSLocalizedString(@"Recent chat", 最近聊天) font:16 color:UIColor102Color];
    label.frame=CGRectMake(15, 0, 300, 30);
    [view addSubview:label];
    NSDictionary*dict=[self.searchResultArray objectAtIndex:section];
    NSString*type=[dict objectForKey:@"type"];
    if ([type isEqualToString:@"friend"]) {
        label.text=NSLocalizedString(@"Contact person", 联系人);
    }else if ([type isEqualToString:@"chatList"]){
        label.text=NSLocalizedString(@"Recent chat", 最近聊天);
    }else{
        
        label.text=NSLocalizedString(@"Group Chats", 群聊);
    }
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.tableView) {
        NSDictionary*dict=[self.searchResultArray objectAtIndex:indexPath.section];
        NSString*type=[dict objectForKey:@"type"];
        NSMutableArray*array=[dict objectForKey:@"array"];
        if (self.isCanSelect) {
            if (self.selectForwarArray.count == 9) {
                [QMUITipsTool showOnlyTextWithMessage:@"Up to 9 people contacts".icanlocalized inView:self.view];
                return;
            }
            if ([type isEqualToString:@"friend"]) {
                UserMessageInfo*info=[array objectAtIndex:indexPath.row];
                if (info.isSelect) {
                    info.isSelect=NO;
                    [self.selectForwarArray removeObject:info];
                }else{
                    info.isSelect=YES;
                    [self.selectForwarArray addObject:info];
                }
            }else if ([type isEqualToString:@"chatList"]){
                ChatListModel*info=[array objectAtIndex:indexPath.row];
                if (info.isSelect) {
                    info.isSelect=NO;
                    [self.selectForwarArray removeObject:info];
                }else{
                    info.isSelect=YES;
                    [self.selectForwarArray addObject:info];
                }
            }
            else {
                GroupListInfo*info=[array objectAtIndex:indexPath.row];
                if (info.isSelect) {
                    info.isSelect=NO;
                    [self.selectForwarArray removeObject:info];
                }else{
                    info.isSelect=YES;
                    [self.selectForwarArray addObject:info];
                }
            }
            
            [self.tableView reloadData];
            [self checkSelectBtnState];
        } else {
            [self.selectForwarArray addObject:[array objectAtIndex:indexPath.row]];
            [self alertSendView];
        }
    }else{
        NSDictionary*dict=[self.searchResultArray objectAtIndex:indexPath.section];
        NSMutableArray*array=[dict objectForKey:@"array"];
        [self.selectForwarArray addObject:[array objectAtIndex:indexPath.row]];
        [self alertSendView];
    }
    
    
}
-(void)searchWithText:(NSString*)text{
    if (text.length) {
        [self.searchResultArray removeAllObjects];
        NSArray*searFriendItems;
        NSArray*searchGroupListItems;
        NSArray*searchFriend;
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"showName CONTAINS[c] %@ ",text];
        searFriendItems= [self.chatListItems filteredArrayUsingPredicate:predicate];
        NSPredicate * cpredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ ",text];
        searchGroupListItems= [self.groupListItems filteredArrayUsingPredicate:cpredicate];
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@",text,text];
        searchFriend= [self.friendItems filteredArrayUsingPredicate:gpredicate];
        if (searchFriend.count>0) {
            NSDictionary*dict=@{@"type":@"friend",@"array":searchFriend};
            [self.searchResultArray addObject:dict];
        }
        if (searFriendItems.count>0) {
            NSDictionary*dict=@{@"type":@"chatList",@"array":searFriendItems};
            [self.searchResultArray addObject:dict];
        }
        if (searchGroupListItems.count>0) {
            NSDictionary*dict=@{@"type":@"group",@"array":searchGroupListItems};
            [self.searchResultArray addObject:dict];
        }
    }
    
}
-(UIButton *)changeSelectStateBtn{
    if (!_changeSelectStateBtn) {
        _changeSelectStateBtn=[UIButton dzNavButtonWithTitle:@"Multiple".icanlocalized image:nil backgroundColor:nil titleFont:16 titleColor:UIColor252730Color target:self action:@selector(multiselectAction)];
        _changeSelectStateBtn.frame=CGRectMake(0, 0, 50, 30);
        _changeSelectStateBtn.titleLabel.textAlignment=NSTextAlignmentRight;
        [_changeSelectStateBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    return _changeSelectStateBtn;
}
- (NSMutableArray *)selectForwarArray {
    if (!_selectForwarArray) {
        _selectForwarArray = [NSMutableArray array];
    }
    return _selectForwarArray;
}
-(NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray=[NSMutableArray array];
    }
    return _searchResultArray;
}
- (TranspondHeadView *)headView{
    if (!_headView) {
        _headView=[[TranspondHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        _headView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        @weakify(self);
        _headView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searchWithText:search];
            if (search.length==0) {
                if (self.chatListItems.count>0) {
                    [self.searchResultArray removeAllObjects];
                    NSDictionary*dict=@{@"type":@"chatList",@"array":self.chatListItems};
                    [self.searchResultArray addObject:dict];
                }
            }
            [self.tableView reloadData];
        };
        /**
         跳转到选择群聊界面或者是创建新的聊天界面
         */
        _headView.gotoNewChatBlock = ^{
            @strongify(self);
            SelectMembersViewController*vc=[[SelectMembersViewController alloc]init];
            vc.selectMemberType = SelectMenbersType_Transpond;
            UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.transpondBlock = ^(NSArray *selectForwardUsersArr) {
                self.selectForwarArray = [NSMutableArray arrayWithArray:selectForwardUsersArr];
                [self alertSendView];
            };
            [self presentViewController:nav animated:YES completion:nil];
        };
    }
    return _headView;
}

-(NSMutableArray *)needSendUserArray{
    if (!_needSendUserArray) {
        _needSendUserArray=[NSMutableArray array];
    }
    return _needSendUserArray;
}
-(NSMutableArray *)needSendMessageArray{
    if (!_needSendMessageArray) {
        _needSendMessageArray = [NSMutableArray array];
    }
    return _needSendMessageArray;
}
-(TranspondShowDetailView *)transpondDetailView{
    if (!_transpondDetailView) {
        _transpondDetailView= [TranspondShowDetailView loadFromNibWithFrame:[UIScreen mainScreen].bounds];
        @weakify(self);
        _transpondDetailView.sendBlock = ^(ChatModel * textModel) {
            @strongify(self);
            [self sendTranspond];
            [self endTranspond];
        };
        _transpondDetailView.cancleBlock = ^(){
            @strongify(self);
            [self.selectForwarArray removeAllObjects];
            
        };
    }
    return _transpondDetailView;
}
-(void)sendTranspond{
    for (id obj in self.selectForwarArray) {
        [self transpondMessageById:obj messageItems:self.selectMessagegArray];
    }
}
- (void)transpondMessageById:(id)obj messageItems:(NSArray *)messageItems{
    self.needSendMessageArray = [NSMutableArray array];
    ChatModel*configModel=[[ChatModel alloc]init];
    configModel.authorityType = AuthorityType_friend;
    ChatModel*sendModel;
    //判断转发的是群 还是用户 还是聊天列表数据
    if ([obj isKindOfClass:[ChatListModel class]]) {
        ChatListModel*listModel=obj;
        configModel.chatID=listModel.chatID;
        configModel.chatType=listModel.chatType;
        
    }else if ([obj isKindOfClass:[GroupListInfo class]]){
        GroupListInfo*listModel=obj;
        configModel.chatID=listModel.groupId;
        configModel.chatType=GroupChat;
    }else if ([obj isKindOfClass:[UserMessageInfo class]]){
        UserMessageInfo*info=obj;
        configModel.chatID=info.userId;
        configModel.chatType=UserChat;
    }
    [self.needSendUserArray addObject:configModel];
    for (ChatModel*transpondModel in messageItems) {
        NSString*msgType=transpondModel.messageType;
        ///如果消息类型不等于图片类型
        if (![msgType isEqualToString:@"Image_Share"]) {
            if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]||[msgType isEqualToString:AIMessageType]||[msgType isEqualToString:AIMessageQuestionType]) {
                sendModel=[ChatUtil initTextMessage:transpondModel.showMessage config:configModel];
            }
            else if([msgType isEqualToString:URLMessageType]){
                sendModel=[ChatUtil initUrlMessage:transpondModel.showMessage config:configModel];
                sendModel.thumbnailTitleofTextUrl = transpondModel.thumbnailTitleofTextUrl;
                sendModel.thumbnailImageurlofTextUrl = transpondModel.thumbnailImageurlofTextUrl;
            }
            else if ([msgType isEqualToString:FileMessageType]){
                configModel.showFileName=transpondModel.showFileName;
                configModel.fileData=[NSData dataWithContentsOfFile:[MessageFileCache(configModel.chatID) stringByAppendingPathComponent:transpondModel.fileCacheName]];
                sendModel=[ChatUtil creatTranspondFileWithChatModel:configModel];
                if (configModel.fileData) {
                    sendModel.uploadState=1;
                }
                sendModel.messageContent=transpondModel.messageContent;
                FileMessageInfo * fileInfo=[FileMessageInfo mj_objectWithKeyValues:sendModel.messageContent];
                sendModel.fileServiceUrl=fileInfo.fileUrl;
            }else if ([msgType isEqualToString:ImageMessageType]){
                sendModel=[ChatUtil creatTranspondImageModelWithConfig:configModel transpondModel:transpondModel];
            }else if ([msgType isEqualToString:LocationMessageType]){
                sendModel=[ChatUtil initLocationWithChatModel:configModel];
                sendModel.messageContent = transpondModel.messageContent;
            }else if ([msgType isEqualToString:VideoMessageType]){
                sendModel=  [ChatUtil creatTranspondVideoModelWithConfig:configModel transpondModel:transpondModel];
            }else if ([msgType isEqualToString:kChat_PostShare]){
                sendModel=[ChatUtil creatChatMessageModelWithChatId:configModel.chatID chatType:configModel.chatType authorityType:AuthorityType_friend circleUserId:nil];
                sendModel.messageType=kChat_PostShare;
                sendModel.messageContent=transpondModel.messageContent;
            }else if ([msgType isEqualToString:kChatOtherShareType]){
                sendModel=[ChatUtil creatChatMessageModelWithChatId:configModel.chatID chatType:configModel.chatType authorityType:AuthorityType_friend circleUserId:nil];
                sendModel.messageType=kChatOtherShareType;
                sendModel.messageContent=transpondModel.messageContent;
            }else if ([msgType isEqualToString:UserCardMessageType]){
                sendModel = [ChatUtil initUserCardModelWithConfig:configModel];
                sendModel.messageContent=transpondModel.messageContent;
            }
            [self.needSendMessageArray addObject:sendModel];
            [[WCDBManager sharedManager]cacheMessageWithChatModel:sendModel isNeedSend:YES];
           
        }else{
            [self.needSendMessageArray addObject:transpondModel];
        }
       
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:KTranspondSuccessNotification object:@{@"config":configModel,@"messages":self.needSendMessageArray}];

}
@end
