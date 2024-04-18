//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleLikeOrDislikeListViewController.m
- Description:
- Function List:
*/
        

#import "CircleFllowOrBeFllowListViewController.h"
#import "CircleCommonListTableViewCell.h"
#import "CircleUserDetailViewController.h"
@interface CircleFllowOrBeFllowListViewController ()

@end

@implementation CircleFllowOrBeFllowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.circleListType) {
        case CircleListType_LikeMe:{
            GetLikeUsersListRequest*request=[GetLikeUsersListRequest request];
            request.likeMe=true;
            self.listRequest=request;
            self.listClass=[CircleILikeListInfo class];
            self.title=@"CircleLikeOrDislikeListViewController.title.likeMe".icanlocalized;
        }
            
            break;
        case CircleListType_ILike:{
            GetLikeUsersListRequest*request=[GetLikeUsersListRequest request];
            request.likeMe=false;
            self.listRequest=request;
            self.listClass=[CircleILikeListInfo class];
            self.title=@"CircleLikeOrDislikeListViewController.title.ILike".icanlocalized;
        }
            
            break;
        case CircleListType_Dislike:{
            self.listRequest=[GetDislikeUsersListRequest request];
            self.listClass=[CircleILikeListInfo class];
            self.title=@"CircleLikeOrDislikeListViewController.title.DisLike".icanlocalized;
        }
            
            break;
        case CircleListType_Favorite:{
            GetLikeUsersListRequest*request=[GetLikeUsersListRequest request];
            request.likeMe=false;
            self.listRequest=request;
            self.listClass=[CircleILikeListInfo class];
            self.title=@"CircleLikeOrDislikeListViewController.title.fllow".icanlocalized;
        }
        default:
            break;
    }
    [self refreshList];

}

-(void)initTableView{
    [super initTableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView registNibWithNibName:kCircleCommonListTableViewCell];
}
-(void)layoutTableView{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleCommonListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kCircleCommonListTableViewCell];
    cell.userInfo=self.listItems[indexPath.item];
    cell.isHome=NO;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserInfo*info=self.listItems[indexPath.row];
    if (info.deleted) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleHomeListViewController.deletedtips".icanlocalized inView:self.view];
    }else{
        CircleUserDetailViewController*vc=[CircleUserDetailViewController new];
        vc.userInfo=self.listItems[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView) {
        if (self.circleListType==CircleListType_Dislike) {
//            "CircleLikeOrDislikeListViewController.remove"="移除";
//            "CircleLikeOrDislikeListViewController.removeTips"="是否移除该用户？";
            UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"CircleLikeOrDislikeListViewController.remove".icanlocalized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"CircleLikeOrDislikeListViewController.removeTips".icanlocalized preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    CircleUserInfo*userinof=[self.listItems objectAtIndex:indexPath.row];
                    PUTDislikeUsersRequest*request=[PUTDislikeUsersRequest request];
                    request.dislikeUserId=userinof.userId;
                    request.parameters=[request mj_JSONObject];
                    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
                        [self.listItems removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                    }];
                    
                }];
                [alert addAction:cancel];
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
            }];
            return @[deleted];
        }
        return nil;
        
    }
    return nil;
    
    
}
@end
