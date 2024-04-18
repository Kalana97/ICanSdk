//
//  RedPacketRecordingViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "RedPacketRecordingViewController.h"
#import "ReceiveRedRecordingHeaderView.h"
#import "RedPacketRecordingTableViewCell.h"
#import "ReceiveRedNavBarView.h"
#import <BRPickerView.h>
#import "RedPacketReceiveDetailViewController.h"
@interface RedPacketRecordingViewController ()<ReceiveRedNavBarViewDelegate>
@property(nonatomic,strong)ReceiveRedNavBarView * navBarView;
@property(nonatomic,strong)ReceiveRedRecordingHeaderView * headerView;


@property(nonatomic,copy)NSString *year;

@end

@implementation RedPacketRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.tableView.mj_header=nil;
    //获取当前的时间
    NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
    self.year = [GetTime stringFromDate:date withDateFormat:@"yyyy"];
    [self startRequest];
    [self getRedPacketSummaryRequest];
}
-(void)startRequest{
    if (self.receive) {
        RedPacketRecordGrabListRequest *request = [RedPacketRecordGrabListRequest request];
        request.year=self.year;
        self.listRequest=request;
        self.listClass=[RedPacketRecordGrabListInfo class];
    }else{
        RedPacketRecordSendListRequest *request = [RedPacketRecordSendListRequest request];
        request.year=self.year;
        self.listRequest=request;
        self.listClass=[RedPacketRecordSendListInfo class];
    }
    [self getRedPacketSummaryRequest];
    [self refreshList];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}

-(void)layoutTableView{
    
}

-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registNibWithNibName:KReceiveRedRedcordingTableViewCell];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightReceiveRedRedcordingTableViewCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketRecordingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KReceiveRedRedcordingTableViewCell];
    if (self.receive) {
        cell.redPacketRecordGrabInfo=[self.listItems objectAtIndex:indexPath.row];
    }else{
        cell.redPacketRecordSendInfo=[self.listItems objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*type;
    NSString*redId;
    if (self.receive) {
        RedPacketRecordGrabInfo* redPacketRecordGrabInfo=[self.listItems objectAtIndex:indexPath.row];
        NSArray*ids=[redPacketRecordGrabInfo .ID componentsSeparatedByString:@":"];
        type=ids[0];
        redId=redPacketRecordGrabInfo.belongs;
        
    }else{
        RedPacketRecordSendInfo*redPacketRecordSendInfo=[self.listItems objectAtIndex:indexPath.row];
        NSArray*ids=[redPacketRecordSendInfo .ID componentsSeparatedByString:@":"];
        type=ids[0];
        redId=ids[1];
    }
    [self getRedPackeDetailRequestWithRedId:redId type:type];
    
}
-(void)getRedPackeDetailRequestWithRedId:(NSString*)redId type:(NSString*)type{
    RedPacketDetailRequest*request=[RedPacketDetailRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/redEnvelopes/%@/%@",type,redId];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RedPacketDetailInfo class] contentClass:[RedPacketDetailInfo class] success:^(RedPacketDetailInfo* response) {
        [QMUITips hideAllTips];
        RedPacketReceiveDetailViewController*vc=[[RedPacketReceiveDetailViewController alloc]init];
        vc.redPacketDetailInfo=response;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(ReceiveRedRecordingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ReceiveRedRecordingHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 320)];
        
        //如果是发送的红包记录 那么高度是300
        @weakify(self);
        _headerView.showMoreTimeBlock = ^{
            @strongify(self);
            [self showDatePickerView];
        };
    }
    return _headerView;
}

-(void)showDatePickerView{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeY];
    datePickerView.title = @"";
    datePickerView.selectValue = [NSString stringWithFormat:@"%@",self.year];
    datePickerView.minDate = [NSDate br_setYear:2017];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        if (![self.year isEqualToString:selectValue]) {
            self.year = selectValue;
            self.headerView.timeLabel.text = [NSString stringWithFormat:@"%@",self.year];
            [self startRequest];
        }
    };
    // 自定义主题样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColorBg243Color;
    customStyle.pickerTextColor = UIColor102Color;
    customStyle.separatorColor = UIColor102Color;
    datePickerView.pickerStyle = customStyle;
    
    // 3.显示
    [datePickerView show];
    
}

-(ReceiveRedNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[ReceiveRedNavBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
        _navBarView.delegate = self;
        _navBarView.titleLabel.text=self.receive?@"Received red packet".icanlocalized:@"Sent red packet".icanlocalized ;
    }
    return _navBarView;
}

-(void)navBarLeftReturnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navBarRightMoreAction{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"Sent red packet".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if (self.receive) {
            self.receive=NO;
            //重新获取列表 和概要
            self.navBarView.titleLabel.text=@"Sent red packet".icanlocalized;
            [self.headerView showSendRedPacketTips];
            [self startRequest];
        }
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Received red packet".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if (!self.receive) {
            self.receive=YES;
            self.navBarView.titleLabel.text=@"Received red packet";
            [self.headerView showGrabRedPacketTips];
            [self startRequest];
        }
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
}
-(void)getRedPacketSummaryRequest{
    RedPacketSummaryRequest*request=[RedPacketSummaryRequest request];
    request.type=self.receive?@"grab":@"send";
    request.year=self.year;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RedPacketSummaryInfo class] contentClass:[RedPacketSummaryInfo class] success:^(RedPacketSummaryInfo* response) {
        [QMUITips hideAllTips];
        self.headerView.redPacketSummaryInfo=response;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
