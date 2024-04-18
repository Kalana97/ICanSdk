//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/7/2020
- File name:  BlockUsersListViewController.m
- Description:
- Function List:
*/
        

#import "BlockUsersListViewController.h"
#import "FriendListTableViewCell.h"
#import "FriendDetailViewController.h"
@interface BlockUsersListViewController ()

@end

@implementation BlockUsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Block list".icanlocalized;
    self.listRequest=[BlockUsersListRequest request];
    self.listClass=[BlockUsersListInfo class];
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightFriendListTableViewCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.userMessageInfo=[self.listItems objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
    UserMessageInfo*info=[self.listItems objectAtIndex:indexPath.row];
    vc.userId=info.userId;
    vc.friendDetailType=FriendDetailType_push;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
