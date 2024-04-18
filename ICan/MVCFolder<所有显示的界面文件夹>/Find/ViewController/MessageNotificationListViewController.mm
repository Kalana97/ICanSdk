//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 12/3/2020
 - File name:  MessageNotificationListViewController.m
 - Description:
 - Function List:
 */


#import "MessageNotificationListViewController.h"
#import "MessageNotificationListCell.h"
#import "WCDBManager+TimeLineNotice.h"
#import "TimeLineNoticeInfo.h"
#import "TimelinesDetailViewController.h"
#import "HJCActionSheet.h"
@interface MessageNotificationListViewController ()<HJCActionSheetDelegate>
@property(nonatomic, strong) NSArray *unReadtimeLineNoticeItems;
@property(nonatomic, strong) NSArray *readtimeLineNoticeItems;
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@end

@implementation MessageNotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Notification".icanlocalized;
    [self loadData];
    UIButton*rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightBarButtonItemAction)];
    rightButton.frame=CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_nav_more_black"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kUpdateNoticeInfoNumberNotification object:nil];
}
-(void)rightBarButtonItemAction{
    
    
    self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:@"AllRead".icanlocalized,@"DeleteAll".icanlocalized, nil];
    self.hjcActionSheet.tag = 101;
    
    [self.hjcActionSheet show];
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[WCDBManager sharedManager]updateAllTimeLineNoticeHasRead];
        
    }else if (buttonIndex==2){
        [[WCDBManager sharedManager]deleteAllTimeLineNoticeInfo];
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateNoticeInfoNumberNotification object:nil];
    
    
}
-(void)loadData{
    self.unReadtimeLineNoticeItems=[[WCDBManager sharedManager]fetchAllUnReadTimeLineNoticeInfo];
    self.readtimeLineNoticeItems=[[WCDBManager sharedManager]fetchAllReadTimeLineNoticeInfo];
    [self.tableView reloadData];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kMessageNotificationListCell];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightMessageNotificationListCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?self.unReadtimeLineNoticeItems.count:self.readtimeLineNoticeItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageNotificationListCell*cell=[tableView dequeueReusableCellWithIdentifier:kMessageNotificationListCell];
    TimeLineNoticeInfo*info=indexPath.section==0?[self.unReadtimeLineNoticeItems objectAtIndex:indexPath.row]:[self.readtimeLineNoticeItems objectAtIndex:indexPath.row];
    cell.timeline=info;
    cell.moreButtonBlock = ^{
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:[@"timeline.post.operation.delete" icanlocalized:@"删除"]  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [[WCDBManager sharedManager]deleteOneTimeLineNoticeInfoByMsgId:info.msgId];
            [self loadData];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateNoticeInfoNumberNotification object:nil];
            
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        UILabel*label=[UILabel leftLabelWithTitle:[NSString stringWithFormat:@"    %@",@"NewNotification".icanlocalized] font:16.5 color:UIColor252730Color];
        label.frame=CGRectMake(0, 0, ScreenWidth, 40);
        label.backgroundColor=UIColor.whiteColor;
        return label;
    }
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    bgView.backgroundColor=UIColor.whiteColor;
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineView.backgroundColor=UIColorBg243Color;
    [bgView addSubview:lineView];
    
    UILabel*label=[UILabel leftLabelWithTitle:[NSString stringWithFormat:@"    %@",@"PreviousNotification".icanlocalized] font:16.5 color:UIColor252730Color];
    label.frame=CGRectMake(0, 10, ScreenWidth, 40);
    [bgView addSubview:label];
    return bgView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeLineNoticeInfo*info=indexPath.section==0?[self.unReadtimeLineNoticeItems objectAtIndex:indexPath.row]:[self.readtimeLineNoticeItems objectAtIndex:indexPath.row];
    info.hasRead=YES;
    [[WCDBManager sharedManager]updateTimeLineNoticeReadByTimeLineNoticeInfo:info];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateNoticeInfoNumberNotification object:nil];
    TimelinesDetailViewController*vc=[[TimelinesDetailViewController alloc]init];
    vc.messageId=info.noteId;
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateNoticeInfoNumberNotification object:nil];
}
@end

