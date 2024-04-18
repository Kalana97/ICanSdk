//
//  FindNearbyPersonsViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/31.
//  Copyright © 2019 dzl. All rights reserved.
//  发现--附近的人

#import "FindNearbyPersonsViewController.h"
#import "FindNearbyPersonsTableViewCell.h"
#import "FriendDetailViewController.h"
#import "HJCActionSheet.h"
#import <MJRefresh.h>
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatModel.h"

@interface FindNearbyPersonsViewController ()<HJCActionSheetDelegate>
@property(nonatomic,strong)NSMutableArray <UserLocationNearbyInfo *>* items;
@property(nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) NSInteger page;
@property (nonatomic,strong) MJRefreshBackNormalFooter*footer;
@property (nonatomic, strong) UserMessageInfo *userMessageInfo;


@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, copy) void (^buttonBlock)(void);
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIButton *leftArrowButton;
@end

@implementation FindNearbyPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.currentIndex=3;
    self.page=0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    self.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer=self.footer;
    [self fetchNearbyPeopleRequest:self.currentIndex];
    [self setUpView];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)refreshList{
    self.page=0;
    [self fetchNearbyPeopleRequest:self.currentIndex];
}
-(void)loadMore{
    self.page++;
    [self fetchNearbyPeopleRequest:self.currentIndex];
}
-(void)rightButtonAction{
    self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:@"FemalesOnly".icanlocalized,@"MalesOnly".icanlocalized,@"ShowAll".icanlocalized,@"ClearLocationAndExit".icanlocalized,nil];
    [self.hjcActionSheet show];
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==4) {
        [self settingUserNearbyVisibleRequest];
        [UserInfoManager sharedManager].nearbyVisible = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self fetchNearbyPeopleRequest:buttonIndex];
    }
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    [self.tableView registNibWithNibName:KFindNearbyPersonsTableViewCell];
    
}
-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightFindNearbyPersonsTableViewCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNearbyPersonsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KFindNearbyPersonsTableViewCell];
    cell.userLocationNearbyInfo = [self.items objectAtIndex:indexPath.row];
    cell.addBlock = ^{
        [self pushToFriendDetail:indexPath];
    };
    cell.chatBlock = ^{
        [self sendToChat:indexPath];
    };
    return cell;
    
}

-(void)sendToChat:(NSIndexPath*)indexPath{
    ChatModel *chatModel = [[ChatModel alloc]init];
    UserLocationNearbyInfo *info = [self.items objectAtIndex:indexPath.row];
    chatModel.showName = info.nickname;
    chatModel.chatID = info.ID;
    chatModel.chatType = UserChat;
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToFriendDetail:indexPath];
}
-(void)pushToFriendDetail:(NSIndexPath*)indexPath{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    UserLocationNearbyInfo * info = [self.items objectAtIndex:indexPath.row];
    vc.userId = info.ID;
    vc.friendDetailType =FriendDetailType_push;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setUpView{
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    bgView.backgroundColor=UIColorViewBgColor;
    [self.view addSubview:bgView];
    [bgView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    [bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftArrowButton.mas_right).offset(10);
        make.top.equalTo(self.leftArrowButton.mas_top);
        make.right.equalTo(@-37);
    }];
    [bgView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [bgView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.right.equalTo(@-10);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
    }
    return _lineView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"] font:17 color:UIColorThemeMainTitleColor];
        _nameLabel.font=[UIFont boldSystemFontOfSize:17];
        _nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
       

       
    }
    return _nameLabel;
}

-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        //icon_nav_back_black
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
        _leftArrowButton.tag=0;
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:nil image:@"icon_nav_more_black" backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightButtonAction)];
        
    }
    return _rightBtn;
}
-(NSMutableArray<UserLocationNearbyInfo *> *)items{
    if (!_items) {
        _items=[NSMutableArray array];
    }
    return _items;
}
//设置用户附近的人是否可见
- (void)settingUserNearbyVisibleRequest{
    UserNearbyVisibleRequest * request = [UserNearbyVisibleRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
       
       
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)fetchNearbyPeopleRequest:(NSInteger)buttonIndex{
    GetUserNearbyRequest * request = [GetUserNearbyRequest request];
    if (buttonIndex==self.currentIndex) {
        request.page=@(self.page);
    }else{
        self.currentIndex=buttonIndex;
        self.page=0;
        request.page=@(0);
    }
    if (buttonIndex==2) {
        request.gender=@"Male";
        NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"]];
        NSTextAttachment*attchment = [[NSTextAttachment alloc]init];
        attchment.bounds=CGRectMake(0,0,15,15);//设置frame
        attchment.image=[UIImage imageNamed:@"icon_gender_boy"];//设置图片
        NSAttributedString*string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment*)(attchment)];
        [attributedString appendAttributedString:string];//添加到尾部
        self.nameLabel.attributedText=attributedString;
    }else if (buttonIndex==1){
        request.gender=@"Female";
        NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"]];
        NSTextAttachment*attchment = [[NSTextAttachment alloc]init];
        attchment.bounds=CGRectMake(0,0,15,15);//设置frame
        attchment.image=[UIImage imageNamed:@"icon_gender_girl"];//设置图片
        NSAttributedString*string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment*)(attchment)];
        [attributedString appendAttributedString:string];//添加到尾部
        self.nameLabel.attributedText=attributedString;
    }else{
        self.nameLabel.text=[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"];
    }
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserLocationNearbyInfo class] success:^(NSArray * response) {
        if (response.count==10) {
            self.tableView.mj_footer=self.footer;
        }else{
            self.tableView.mj_footer=nil;
        }
        if (self.page==0) {
            self.items=[NSMutableArray arrayWithArray:response];
        }else{
            [self.items addObjectsFromArray:response];
        }
        [self.tableView reloadData];
        [self endingRefresh];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)endingRefresh{
    [QMUITips hideAllTips];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


@end
