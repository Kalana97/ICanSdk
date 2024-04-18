//
//  RedPacketReceiveDetailViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/3.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "RedPacketReceiveDetailViewController.h"
#import "RedPacketReceiveDetailHeaderView.h"
#import "RedPacketDetailMemberTableViewCell.h"
#import <MJRefresh.h>
#import "RedPacketRecordingViewController.h"
@interface RedPacketReceiveDetailViewController ()
@property(nonatomic, strong) RedPacketReceiveDetailHeaderView * heardView;
@property(nonatomic, strong) NSMutableArray<RedPacketDetailMemberInfo*> *memberItems;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *moreButton;
/** 用来作为下拉的时候一个效果图 243 85 68 */
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIView *redView;
@property(nonatomic, assign) CGFloat defauBgtHeight;
@property(nonatomic, assign) CGFloat defRedHeight;
//CGFloat
@property(nonatomic, assign) CGFloat defautMargin;

@property(nonatomic, strong) UILabel *footerTipsLabel;
@end

@implementation RedPacketReceiveDetailViewController

- (void)viewDidLoad {
    self.defautMargin=isIPhoneX?25:0;
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(100+self.defautMargin));
    }];
    [self.view addSubview:self.redView];
    CGFloat redHeight=isIPhoneX?60:45;
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(redHeight));
    }];
    CGFloat top= isIPhoneX?50:25;
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(top));
        make.left.equalTo(@10);
    }];
    [self.view addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(top));
        make.right.equalTo(@-10);
    }];
    [self refreshList];
    
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(UIView *)redView{
    if (!_redView) {
        _redView=[[UIView alloc]init];
        _redView.backgroundColor=UIColorMake(243, 85, 68);
    }
    return _redView;
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.heardView;
    [self.tableView registNibWithNibName:kRedPacketDetailMemberTableViewCell];
    self.tableView.mj_header=nil;
    
    
}
-(void)layoutTableView{
    //如果红包没有完成并且发送的人是自己 那么显示
    if (!self.redPacketDetailInfo.done&&[self.redPacketDetailInfo.sendUserId isEqualToString:[UserInfoManager sharedManager].userId]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@(isIPhoneX?-44:-20));
            make.bottom.equalTo(@-40);
        }];
        [self.view addSubview:self.footerTipsLabel];
        [self.footerTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@40);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.top.equalTo(@(isIPhoneX?-44:-20));
        }];
    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat ty=scrollView.contentOffset.y;
    CGFloat margin=isIPhoneX?-44:-20;
    if (ty>=margin) {
        self.bgImageView.hidden=NO;
        self.redView.hidden=YES;
    }else{
        self.bgImageView.hidden=YES;
        self.redView.hidden=NO;
        CGFloat redHeight=isIPhoneX?60:45;
        [self.redView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@(redHeight+(margin-ty)));
        }];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightRedPacketDetailMemberTableViewCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketDetailMemberTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kRedPacketDetailMemberTableViewCell];
    cell.redPacketDetailMemberInfo=[self.listItems objectAtIndex:indexPath.row];
    return cell;
}
-(UILabel *)footerTipsLabel{
    if (!_footerTipsLabel) {
        _footerTipsLabel=[UILabel centerLabelWithTitle:@"Red packet that has not been opened will return to the wallet".icanlocalized font:13 color:UIColorThemeMainSubTitleColor];
        _footerTipsLabel.numberOfLines=0;
        _footerTipsLabel.backgroundColor=UIColor.clearColor;
    }
    return _footerTipsLabel;
}
-(RedPacketReceiveDetailHeaderView *)heardView{
    if (!_heardView) {
        
        if (self.redPacketDetailInfo.money) {
            if ([self.redPacketDetailInfo.type isEqualToString:@"s"]) {
                _heardView = [[RedPacketReceiveDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 310+self.defautMargin+20)];
            }else{
                _heardView = [[RedPacketReceiveDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 350+self.defautMargin+20)];
            }
            
        }else{
            _heardView = [[RedPacketReceiveDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 260+self.defautMargin)];
        }
        
        _heardView.redPacketDetailInfo=self.redPacketDetailInfo;
    }
    return _heardView;
}
-(NSMutableArray<RedPacketDetailMemberInfo *> *)memberItems{
    if (!_memberItems) {
        _memberItems=[NSMutableArray array];
    }
    return _memberItems;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton=[UIButton dzButtonWithTitle:nil image:@"icon_red_more" backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(moreButtonAction)];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}
-(void)moreButtonAction{
    RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
    vc.receive=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton=[UIButton dzButtonWithTitle:nil image:@"icon_nav_back_big_white" backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(backButtonAction)];
        [_backButton sizeToFit];
    }
    return _backButton;
}
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_red_details_bg")];
    }
    return _bgImageView;
}
-(void)fetchListRequest{
    RedPacketDetailMemberListRequest *request = [RedPacketDetailMemberListRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/redEnvelopes/d/%@/%@",self.redPacketDetailInfo.type,self.redPacketDetailInfo.ID];
    request.size=@(10);
    request.page=@(self.current);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RedPacketDetailMemberListInfo class] contentClass:[RedPacketDetailMemberListInfo class] success:^(RedPacketDetailMemberListInfo* response) {
        @strongify(self);
        self.listInfo=response;
        self.heardView.redPacketDetailMemberListInfo=response;
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:response.content];
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        //是多人红包并且是凭手气红包
        if ([self.redPacketDetailInfo.roomRedPacketType isEqualToString:@"RANDOM"]) {
            //如果红包已经领完 并且已经拿到全部红包数据
            if (self.redPacketDetailInfo.done&&response.last) {
               double value= [[self.listItems valueForKeyPath:@"@max.money"] doubleValue];
                for (RedPacketDetailMemberInfo* memberInfo in self.listItems) {
                    if ([[NSString stringWithFormat:@"%.2f",[memberInfo.money doubleValue]] isEqualToString:[NSString stringWithFormat:@"%.2f",value]]) {
                        memberInfo.goodLucky=YES;
                        break;
                    }
                
                }
            }
        }
        
        [self checkHasFooter];
        [UIView performWithoutAnimation:^{
            [self endingRefresh];
            [self.tableView reloadData];
        }];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}


@end
