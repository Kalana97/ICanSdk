//
//  ContactListVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ContactListVC.h"
#import "InviteUserCardCell.h"

@interface ContactListVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray<MemebersResponseInfo *> *MemberItems;
@property (weak, nonatomic) IBOutlet UIView *searchBg;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *inviteeList;
@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"InviteUserCardCell"];
    self.searchTxt.delegate = self;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    UIColor *color = [UIColor grayColor];
    self.searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search".icanlocalized attributes:@{NSForegroundColorAttributeName: color}];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self getMemberList];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getMemberList];
    [self.view endEditing:YES];
    return YES;
}

-(void)setupUI{
    [self.searchBg layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.titleLbl.text = @"chatlist.menu.list.contacts".icanlocalized;
}

-(void)getMemberList{
    GetContactListRequest *request = [GetContactListRequest request];
    NSString *text = self.searchTxt.text;
    NSUInteger characterCount = [text length];
    if( characterCount > 0){
        request.search = self.searchTxt.text;
    }
    request.isNumberIdSearch = NO;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemebersResponseInfo class] success:^(NSArray<MemebersResponseInfo*>* response) {
        self.MemberItems = [NSMutableArray arrayWithArray:response];
        [self.myTableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.MemberItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteUserCardCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"InviteUserCardCell"];
    MemebersResponseInfo *modelData = self.MemberItems[indexPath.row];
    [cell setContact:modelData];
    cell.inviteBlock = ^{
        [self sendInviteRequest:modelData];
    };
    return cell;
}

-(void)sendInviteRequest:(MemebersResponseInfo *)userModel{
    [self.inviteeList removeAllObjects];
    SendInviteRequest *request = [SendInviteRequest request];
    [self.inviteeList addObject:@(userModel.userId)];
    request.inviteeList = self.inviteeList;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[InviteResponseInfo class] contentClass:[InviteResponseInfo class] success:^(InviteResponseInfo *response)  {
        if(response.allInvited == TRUE){
            [self.MemberItems removeObject:userModel];
            [self.myTableView reloadData];
            [QMUITipsTool showOnlyTextWithMessage:@"Success".icanlocalized inView:nil];
        }else{
            [QMUITipsTool showErrorWihtMessage:response.failedIds.firstObject[@"reason"] inView:nil];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(NSMutableArray<NSNumber *> *)inviteeList{
    if (!_inviteeList) {
        _inviteeList = [NSMutableArray array];
    }
    return _inviteeList;
}

@end
