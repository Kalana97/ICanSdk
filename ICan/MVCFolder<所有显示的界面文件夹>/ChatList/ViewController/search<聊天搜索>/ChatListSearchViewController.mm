//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 25/12/2019
 - File name:  ChatListSearchViewController.m
 - Description:
 - Function List:
 */
#import "ChatListSearchViewController.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "SearchHeadView.h"
#import "ChatSearchHistoryResultTableViewCell.h"
#import "ChatSearchResultViewController.h"

#import "CTMediator+CTMediatorModuleChatActions.h"
@interface ChatListSearchViewController ()
@property(nonatomic, strong) NSArray<ChatListModel*> *chatListItems;
@property(nonatomic, strong) NSArray<GroupListInfo*> *groupListItems;
@property(nonatomic, strong) NSArray<UserMessageInfo*> *friendItems;
@property(nonatomic, strong) NSArray<ChatModel*> *chatModelItems;
@property(nonatomic, strong) SearchHeadView *chatListSearchHeadView;
@property(nonatomic, strong) NSMutableArray *searchResultArray;
@property(nonatomic, copy) NSString *searchText;
@end

@implementation ChatListSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Search",搜索);
    self.chatListItems=[[WCDBManager sharedManager]getAllIcanChatListModel];
    self.groupListItems=[[WCDBManager sharedManager]getAllGroupListInfo];
    self.friendItems=[[WCDBManager sharedManager]fetchFriendList];
    [self.chatListSearchHeadView.searTextField becomeFirstResponder];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView=self.chatListSearchHeadView;
    [self.tableView registNibWithNibName:kChatSearchHistoryResultTableViewCell];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.searchResultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary*dict=[self.searchResultArray objectAtIndex:section];
    NSMutableArray*item=[dict objectForKey:@"array"];
    return item.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatSearchHistoryResultTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kChatSearchHistoryResultTableViewCell forIndexPath:indexPath];
    NSDictionary*dict=[self.searchResultArray objectAtIndex:indexPath.section];
    NSString*type=[dict objectForKey:@"type"];
    NSMutableArray*array=[dict objectForKey:@"array"];
    cell.searchText=self.searchText;
    if ([type isEqualToString:@"friend"]) {
        cell.userMessageInfo=[array objectAtIndex:indexPath.row];
    }else if ([type isEqualToString:@"chatList"]){
        cell.chatListModel=[array objectAtIndex:indexPath.row];
    }else if([type isEqualToString:@"group"]){
        id obj =[array objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[GroupListInfo class]]){
            GroupListInfo*info=obj;
            cell.groupListInfo=info;
        }else{
            NSArray*info=obj;
            cell.groupMemberItems=info;
        }
    }else{
        cell.historyItems=[array objectAtIndex:indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor=UIColor10PxClearanceBgColor;
    
    UILabel*label=[UILabel leftLabelWithTitle:NSLocalizedString(@"Recent chat", 最近聊天) font:16 color:UIColor102Color];
    label.frame=CGRectMake(15, 0, 300, 30);
    label.textColor = UIColorThemeMainSubTitleColor;
    [view addSubview:label];
    NSDictionary*dict=[self.searchResultArray objectAtIndex:section];
    NSString*type=[dict objectForKey:@"type"];
    if ([type isEqualToString:@"friend"]) {
        label.text=NSLocalizedString(@"Contact person", 联系人);
    }else if ([type isEqualToString:@"chatList"]){
        label.text=NSLocalizedString(@"Recent chat", 最近聊天);
    }else if([type isEqualToString:@"group"]){
        label.text=NSLocalizedString(@"Group Chats", 群聊);
    }else if([type isEqualToString:@"chatModel"]){
        label.text=@"mine.setting.cell.title.records".icanlocalized;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict=[self.searchResultArray objectAtIndex:indexPath.section];
    NSMutableArray*array=[dict objectForKey:@"array"];
    id obj =[array objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[UserMessageInfo class]]) {
        UserMessageInfo*info=obj;
        if (self.tapBlock) {
            self.tapBlock(info.userId, UserChat);
        }
    }else if ([obj isKindOfClass:[GroupListInfo class]]){
        GroupListInfo*info=obj;
        if (self.tapBlock) {
            self.tapBlock(info.groupId, GroupChat);
        }
        
    }else if([obj isKindOfClass:[ChatListModel class]]){
        ChatListModel*info=obj;
        if (self.tapBlock) {
            self.tapBlock(info.chatID, info.chatType);
        }
        
    }else{
        NSArray *array=obj;
        id containObj=array.firstObject;
        if ([containObj isKindOfClass:[ChatModel class]]) {
            if (array.count>1) {
                ChatSearchResultViewController*vc=[[ChatSearchResultViewController alloc]init];
                vc.historyItems=array;
                vc.searchText=self.searchText;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                ChatModel*model=array.firstObject;
                UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:model.authorityType,ksearchText:self.searchText,kshouldStartLoad:@(1),kmessageTime:model.messageTime}];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            NSArray *array=obj;
            GroupMemberInfo*info=array.firstObject;
            GroupListInfo*ginfo=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:info.groupId];
            UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:info.groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend,kshouldStartLoad:@(0),kshowName:ginfo.name}];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
    
}
-(SearchHeadView *)chatListSearchHeadView{
    if (!_chatListSearchHeadView) {
        _chatListSearchHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _chatListSearchHeadView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _chatListSearchHeadView.shouShowKeybord=YES;
        ViewRadius(_chatListSearchHeadView.bgView, 15.0);
        @weakify(self);
        _chatListSearchHeadView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            self.searchText=search;
            if (search.length>0) {
                [self searchWithText:search];
            }else{
                [self.searchResultArray removeAllObjects];
                [self.tableView reloadData];
            }
            
        };
        
    }
    return _chatListSearchHeadView;
}


-(void)searchWithText:(NSString*)text{
    self.searchResultArray=[NSMutableArray array];
    NSArray*searFriendItems;
    NSArray*searchGroupListItems;
    NSArray*searchFriend;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"showName CONTAINS[c] %@ ",text];
    searFriendItems= [self.chatListItems filteredArrayUsingPredicate:predicate];
    NSPredicate * cpredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ ",text];
    searchGroupListItems= [self.groupListItems filteredArrayUsingPredicate:cpredicate];
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@ || numberId CONTAINS[c] %@ ",text,text,text];
    searchFriend= [self.friendItems filteredArrayUsingPredicate:gpredicate];
    
    if (searchFriend.count>0) {
        NSDictionary*dict=@{@"type":@"friend",@"array":searchFriend};
        [self.searchResultArray addObject:dict];
    }
    if (searFriendItems.count>0) {
        NSDictionary*dict=@{@"type":@"chatList",@"array":searFriendItems};
        [self.searchResultArray addObject:dict];
    }
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    NSArray*array=[[WCDBManager sharedManager]fetctGroupMemnberBySearchText:self.searchText];
    for (NSArray*garray in array) {
        GroupMemberInfo*info=garray.firstObject;
        [dict setObject:garray forKey:info.groupId];
    }
    for (GroupListInfo*listInfo in searchGroupListItems) {
        [dict setObject:listInfo forKey:listInfo.groupId];
    }
    if (dict.allValues.count>0) {
        NSDictionary*dict2=@{@"type":@"group",@"array":dict.allValues};
        [self.searchResultArray addObject:dict2];
    }
    self.chatModelItems=[[WCDBManager sharedManager]fetchChatModelBySearchText:self.searchText authorityType:AuthorityType_friend];
    if (self.chatModelItems.count>0) {
        NSDictionary*dict=@{@"type":@"chatModel",@"array":self.chatModelItems};
        [self.searchResultArray addObject:dict];
    }
    [self.tableView reloadData];
    
}
@end
