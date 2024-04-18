//
//  MembersVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "MembersVC.h"
#import "InviteVC.h"
#import "MemberCell.h"
#import "UserProfileVC.h"

@interface MembersVC ()
@property (weak, nonatomic) IBOutlet QMUITextField *searchtxt;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property(nonatomic, strong) NSArray<MemebersResponseInfo *> *MemberItems;
@end

@implementation MembersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"MemberCell"];
    [self.searchBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    UIColor *color = [UIColor grayColor];
    self.searchtxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search".icanlocalized attributes:@{NSForegroundColorAttributeName: color}];
    self.searchtxt.delegate = self;
    self.searchtxt.returnKeyType = UIReturnKeySearch;
    [self addlocalization];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
       [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.searchtxt resignFirstResponder];
}

-(void)addlocalization{
    self.titleLbl.text = @"Members".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getMemberList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.searchtxt resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getMemberList];
    [self.view endEditing:YES];
    return YES;
}

-(void)getMemberList{
    GetMemeberListRequest *request = [GetMemeberListRequest request];
    NSString *text = self.searchtxt.text;
    NSUInteger characterCount = [text length];
    if( characterCount > 0){
        request.search = self.searchtxt.text;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemebersResponseInfo class] success:^(NSArray<MemebersResponseInfo*>* response) {
        self.MemberItems = response;
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
    MemberCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"MemberCell"];
    [cell setData:self.MemberItems[indexPath.row]];
    cell.tapBlock = ^{
        UserProfileVC *profileVC = [[UserProfileVC alloc]init];
        profileVC.memberInfo = self.MemberItems[indexPath.row];
        [self.navigationController pushViewController:profileVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

@end
