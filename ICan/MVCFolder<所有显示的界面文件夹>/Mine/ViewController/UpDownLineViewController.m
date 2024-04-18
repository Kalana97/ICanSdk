//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 8/7/2020
 - File name:  UpDownLineViewController.m
 - Description:
 - Function List:
 */


#import "UpDownLineViewController.h"
#import "UpDownLineFirstTableViewCell.h"
#import "UpDownLineTableViewCell.h"
@interface UpDownLineViewController ()

@end

@implementation UpDownLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
        self.title= [@"mine.listView.cell.invite" icanlocalized:@"我的邀请"];
    }else{
        self.title=self.name;
    }
    self.listRequest=[BeInvitedListRequest request];
    self.listClass=[BeInvitedListInfo class];
    self.listRequest.pathUrlString=[self.listRequest.baseUrlString stringByAppendingFormat:@"/beInvited/%@",self.userId];
    [self refreshList];
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kUpDownLineTableViewCell];
    [self.tableView registNibWithNibName:kUpDownLineFirstTableViewCell];
    [self getBeInvitedCountRequest];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 60;
    }
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count+1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UpDownLineFirstTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kUpDownLineFirstTableViewCell];
        return cell;
    }
    UpDownLineTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kUpDownLineTableViewCell];
    cell.beInvitedInfo=[self.listItems objectAtIndex:indexPath.row-1];
    cell.serialLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=0) {
        BeInvitedInfo*info=[self.listItems objectAtIndex:indexPath.row-1];
        UpDownLineViewController*vc=[[UpDownLineViewController alloc]init];
        vc.userId=info.ID;
        vc.name=info.nickname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)getBeInvitedCountRequest{
    GetBeInvitedCountRequest*request=[GetBeInvitedCountRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/beInvited/%@/count",self.userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetBeInvitedCountInfo class] contentClass:[GetBeInvitedCountInfo class] success:^(GetBeInvitedCountInfo* response) {
        if ([self.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
            if (response.count>0) {
                self.title=[ [@"mine.listView.cell.invite" icanlocalized:@"我的邀请"] stringByAppendingFormat:@"(%ld)",response.count];
            }else{
                self.title= [@"mine.listView.cell.invite" icanlocalized:@"我的邀请"];
            }
            
        }else{
            if (response.count>0) {
                self.title=[self.name stringByAppendingFormat:@"(%ld)",response.count];
            }else{
                self.title=self.name;
            }
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
@end
