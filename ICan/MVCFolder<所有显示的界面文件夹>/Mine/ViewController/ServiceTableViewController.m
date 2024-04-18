//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  ServiceTableViewController.m
- Description:
- Function List:
*/
        

#import "ServiceTableViewController.h"
#import "UserServiceTableViewCell.h"
#import "FriendDetailViewController.h"
#import "CommonWebViewController.h"
@interface ServiceTableViewController ()
@property(nonatomic, strong) NSArray<UserMessageInfo*> *serviceItems;
@end

@implementation ServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= NSLocalizedString(@"service",客服);
    
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kUserServiceTableViewCell];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.info.csUserList.count>0 ) {
        return self.info.csUserList.count;
    }else if (self.info.csWebList){
        return self.info.csWebList.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightUserServiceTableViewCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserServiceTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kUserServiceTableViewCell];
    if (self.info.csUserList.count>0) {
        cell.servicesInfo=self.info.csUserList[indexPath.row];
    }else if (self.info.csWebList){
        cell.servicesInfo=self.info.csWebList[indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.info.csUserList.count>0) {
        FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
        vc.friendDetailType=FriendDetailType_push;
        ServicesInfo*info=self.info.csUserList[indexPath.row];
        vc.userId=info.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.info.csWebList){
        CommonWebViewController*vc=[CommonWebViewController new];
        ServicesInfo*info=self.info.csWebList[0];
        vc.urlString=info.linkUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
   
}


@end
