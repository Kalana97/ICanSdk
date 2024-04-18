//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/4/2021
 - File name:  TelecomListViewController.m
 - Description:
 - Function List:
 */


#import "TelecomListViewController.h"
#import "TelecomListCell.h"
#import "UtilityPaymentsPayViewController.h"
#import "UtilityPaymentsRecordViewController.h"
@interface TelecomListViewController ()
@property(nonatomic, strong) NSArray<DialogListInfo*> *items;
@end

@implementation TelecomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleName;
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UtilityPaymentsViewController.rightBarItem".icanlocalized target:self action:@selector(toRecordAction)];
    [self getRequest];
}
-(void)toRecordAction{
    [self.navigationController pushViewController:[UtilityPaymentsRecordViewController new] animated:YES];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kTelecomListCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
-(void)layoutTableView{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TelecomListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTelecomListCell];
    cell.dialogInfo=self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilityPaymentsPayViewController*payVc=[[UtilityPaymentsPayViewController alloc]init];
    payVc.dialogInfo=self.items[indexPath.row];
    payVc.isFromFavorite=NO;
    [self.navigationController pushViewController:payVc animated:YES];
}
-(void)getRequest{
    GetDialogListRequest*request=[GetDialogListRequest request];
    request.dialogClass=self.dialogClass;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[DialogListInfo class] success:^(NSArray* response) {
        [QMUITips hideAllTips];
        self.items=response;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
