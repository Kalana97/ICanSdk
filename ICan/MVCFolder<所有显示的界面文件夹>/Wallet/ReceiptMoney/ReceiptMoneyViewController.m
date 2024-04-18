//
//  ReceiptMoneyViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptMoneyViewController.h"
#import "SetMoneyViewController.h"
#import "ReceiptRecordViewController.h"
#import "ReceiptMoneyTableHeaderView.h"
#import "ReceiptMoneyListTableViewCell.h"
#import "ReceiptMoneyCountTableViewCell.h"
#import "PayMoneyViewController.h"
#import "ReceiptRecordViewController.h"
#import "SaveViewManager.h"
#import "ChatModel.h"
#import "UIViewController+Extension.h"
@interface ReceiptMoneyViewController ()<WebSocketManagerDelegate>
@property(nonatomic, weak) IBOutlet UILabel *titleNameLabel;
@property(nonatomic, strong) ReceiptMoneyTableHeaderView *headerView;
@property(nonatomic, strong) NSMutableArray *msgItems;
@property(nonatomic, copy) NSString *code;
/** 用来做一个背景的View */
@property(nonatomic, assign) BOOL hasSettingMoney;
@property(nonatomic, copy) NSString *money;
//--------------------------

@property(nonatomic, strong) UIView *bgContView;

@property(nonatomic, strong) UIImageView *topBgImageView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIImageView *topTipsImageView;
@property(nonatomic, strong) UILabel *topTipsLabel;
/** 扫一扫，向我付钱呦 */
@property(nonatomic, strong) UILabel *tipsLabel;
/** 自己设置的收款金额 */
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UIImageView *qrCodeImageView;
@property(nonatomic, strong) UILabel *nameLabel;


@end

@implementation ReceiptMoneyViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"PayMoneyViewController"]];
}
-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorThemeMainColor;
    self.titleNameLabel.text = @"Receive".icanlocalized;
    [self getReceiptCodeRequest:nil];
    [WebSocketManager sharedManager].delegate = self;
    
}
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if ([chatModel.messageType isEqualToString:Notice_PayQRType]) {
        Notice_PayQRInfo*info=[Notice_PayQRInfo mj_objectWithKeyValues:chatModel.messageContent];
        if ([info.code isEqualToString:self.code]) {
            BOOL contain=NO;
            for (Notice_PayQRInfo*exitInfo in self.msgItems) {
                if ([exitInfo.code isEqualToString:info.code]&&exitInfo.status!=2) {
                    contain=YES;
                    exitInfo.status=info.status;
                    exitInfo.money=info.money;
                    break;
                }
            }
            if (!contain) {
                [self.msgItems addObject:info];
            }
            [self.tableView reloadData];
            
            
        }
        
    }
    
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    self.tableView.backgroundColor=UIColor.clearColor;
    self.tableView.tableHeaderView=self.headerView;
    [self.tableView registNibWithNibName:kReceiptMoneyListTableViewCell];
    [self.tableView registNibWithNibName:kReceiptMoneyCountTableViewCell];
    [self setUpHasMoneyView];
}
-(ReceiptMoneyTableHeaderView *)headerView{
    if (!_headerView) {
        _headerView=[[ReceiptMoneyTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 425)];
        @weakify(self);
        _headerView.settingMoneyBlock = ^{
            SetMoneyViewController * vc = [SetMoneyViewController new];
            vc.settingMoneySuccessBlock = ^(NSString * _Nonnull money) {
                @strongify(self);
                self.moneyLabel.text=[NSString stringWithFormat:@"%.2f",[money doubleValue]];
                self.hasSettingMoney=YES;
                [self updateLayout:YES];
                [self getReceiptCodeRequest:money];
                self.headerView.frame=CGRectMake(0, 0, ScreenWidth, 450);
                self.tableView.tableHeaderView=self.headerView;
                [self.headerView updateHasMoney];
            };
            
            @strongify(self);
            [self.navigationController pushViewController:vc animated:YES];
        };
        _headerView.clearMoneyBlock = ^{
            @strongify(self);
            [self updateLayout:NO];
            self.hasSettingMoney=NO;
            self.headerView.frame=CGRectMake(0, 0, ScreenWidth, 425);
            [self getReceiptCodeRequest:nil];
        };
        _headerView.saveQrImageBlock = ^{
            @strongify(self);
            [self saveAction];
            
        };
    }
    return _headerView;
}
-(void)layoutTableView{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.msgItems.count>0) {
        return self.msgItems.count+1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightReceiptMoneyListTableViewCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        ReceiptMoneyCountTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kReceiptMoneyCountTableViewCell];
        double money=0.00;
        for (Notice_PayQRInfo*info in self.msgItems) {
            if (info.status==2) {
                money=info.money+money;
            }
        }
        if (money>0) {
            cell.countMoneyLabel.text=[NSString stringWithFormat:@"%@%.2f",@"Total".icanlocalized,money];
        }else{
            cell.countMoneyLabel.text=@"";
        }
        
        return cell;
    }
    ReceiptMoneyListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kReceiptMoneyListTableViewCell];
    cell.info=self.msgItems[indexPath.row-1];
    return cell;
}
-(NSMutableArray *)msgItems{
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}
/** 获取收款码的code */
-(void)getReceiptCodeRequest:(NSString*)money{
    if (money) {
        self.headerView.moneyLabel.hidden=NO;
        self.headerView.moneyLabel.text=[NSString stringWithFormat:@"￥%.2f",[money doubleValue]];
    }
    //    receivePayment
    GetCodeRequest*request=[GetCodeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/payQRCode/receivePayment"];
    request.isHttpResponse=YES;
    if (money) {
        request.money=money;
    }
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
        
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSNumber *statusValue = jsonDictionary[@"status"];
        NSInteger intValue = [statusValue integerValue];
        NSLog(@"Status value as an integer: %ld", (long)intValue);
        if(intValue == 3 || intValue == 2 ){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
               });
        }else{
            self.code=response;
            [self settingReceivePaymentCode:response money:money];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
///q/receive/{code}/{userId}/{m}
-(void)settingReceivePaymentCode:(NSString*)code money:(NSString*)money{
    NSString*qrcode;
    if (money) {
        qrcode=[[BaseRequest request].baseUrlString stringByAppendingFormat:@"/q/receive/%@/%@/%@",code,[UserInfoManager sharedManager].userId,money];
    }else{
        qrcode=[[BaseRequest request].baseUrlString stringByAppendingFormat:@"/q/receive/%@/%@/-1",code,[UserInfoManager sharedManager].userId];
    }
    UIImage*qrImage=[UIImage dm_QRImageWithString:qrcode size:ScreenWidth-80];
    self.headerView.qrCodeImageView.image=qrImage;
    self.qrCodeImageView.image=qrImage;
}

-(void)setUpHasMoneyView{
    [self.view insertSubview:self.bgContView belowSubview:self.tableView];
    [self.bgContView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1000);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@740);
        make.width.equalTo(@540);
    }];
    [self.bgContView addSubview:self.topBgImageView];
    [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@140);
    }];
    [self.topBgImageView addSubview:self.topTipsImageView];
    [self.topTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.centerY.equalTo(self.topBgImageView.mas_centerY);
        make.width.height.equalTo(@52);
    }];
    [self.topBgImageView addSubview:self.topTipsLabel];
    [self.topTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTipsImageView.mas_right).offset(30);
        make.centerY.equalTo(self.topTipsImageView.mas_centerY);
    }];
    [self.bgContView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgImageView.mas_bottom).offset(100);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    
    //30+10
    [self.bgContView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgContView.mas_centerX);
        make.top.equalTo(self.topBgImageView.mas_bottom).offset(100);
    }];
    
    [self.bgContView addSubview:self.qrCodeImageView];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@236);
        make.top.equalTo(self.topBgImageView.mas_bottom).offset(157);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    
    [self.bgContView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-100);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
}
-(void)updateLayout:(BOOL)hasMoney{
    
    if (hasMoney) {
        [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBgImageView.mas_bottom).offset(50);
            make.centerX.equalTo(self.bgContView.mas_centerX);
        }];
        self.moneyLabel.hidden=NO;
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgContView.mas_centerX);
            make.top.equalTo(self.topBgImageView.mas_bottom).offset(100);
        }];
    }else{
        [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBgImageView.mas_bottom).offset(100);
            make.centerX.equalTo(self.bgContView.mas_centerX);
        }];
        self.moneyLabel.hidden=YES;
    
    }
}
-(void)saveAction{
    [SaveViewManager captureImageFromView:self.bgContView success:^{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
    } failed:^{
        
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
    }];
}

-(UIView *)bgContView{
    if (!_bgContView) {
        _bgContView=[[UIView alloc]init];
        _bgContView.backgroundColor=UIColor.whiteColor;
//        [_bgContView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    return _bgContView;
}
-(UIImageView *)topBgImageView{
    if (!_topBgImageView) {
        _topBgImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"img_receipmoney_top_bg")];
        _topBgImageView.backgroundColor=UIColor.whiteColor;
    }
    return _topBgImageView;
}
-(UIImageView *)topTipsImageView{
    if (!_topTipsImageView) {
        _topTipsImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_scan_Collection_1")];
    }
    return _topTipsImageView;
}

-(UILabel *)topTipsLabel{
    if (!_topTipsLabel) {
        _topTipsLabel=[UILabel leftLabelWithTitle:@"QRCodeCollection".icanlocalized font:34 color:UIColorViewBgColor];
    }
    return _topTipsLabel;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel=[UILabel centerLabelWithTitle:@"" font:36 color:UIColorThemeMainColor];
        _moneyLabel.font=[UIFont boldSystemFontOfSize:36];
        _moneyLabel.hidden=YES;
    }
    return _moneyLabel;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel centerLabelWithTitle:@"Scan to pay".icanlocalized font:24 color:UIColorThemeMainTitleColor];
    }
    return _tipsLabel;
}
-(UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView) {
        _qrCodeImageView=[[UIImageView alloc]initWithImage:self.headerView.qrCodeImageView.image];
    }
    return _qrCodeImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:nil font:30 color:UIColorThemeMainTitleColor];
        NSString*name=[UserInfoManager sharedManager].nickname;
        if ([UserInfoManager sharedManager].realname.length>0) {
            NSString * rname = [UserInfoManager sharedManager].realname;
            if (rname) {
                for (int i =0; i<rname.length-1; i++) {
                    rname=[rname stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
                }
            }
            
           name= [NSString stringWithFormat:@"%@（%@）",name,rname];
        }
        _nameLabel.text=name;
    }
    return _nameLabel;
}
@end
