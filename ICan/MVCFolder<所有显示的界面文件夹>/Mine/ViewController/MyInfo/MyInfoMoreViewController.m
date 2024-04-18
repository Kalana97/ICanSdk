//  个人信息--更多
//  MyInfoMoreViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/17.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "MyInfoMoreViewController.h"
#import "BindingMoblieOrEmailViewController.h"
#import "SetGenderViewController.h"
#import "ModifySignatureViewController.h"
#import <AlipaySDK/AFServiceCenter.h>
#import <AlipaySDK/AFServiceResponse.h>
#import "WXApi.h"
#import "HandleOpenUrlManager.h"
#import "CertificationViewController.h"

@interface MyInfoMoreViewController ()<HandleOpenUrlManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *mobileTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;

@property (weak, nonatomic) IBOutlet UILabel *emailTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;

@property (weak, nonatomic) IBOutlet UIControl *weixinBgCon;

@property (weak, nonatomic) IBOutlet UILabel *wxchatTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *wxchatLab;


@property (weak, nonatomic) IBOutlet UIImageView *realnameArrowImg;
@property (weak, nonatomic) IBOutlet UILabel *realnameTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *realnameLab;

@property (weak, nonatomic) IBOutlet UIImageView *idCardArrowImg;
@property (weak, nonatomic) IBOutlet UILabel *idcardTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *idcardLab;

@property (weak, nonatomic) IBOutlet UILabel *genderTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;

@property (weak, nonatomic) IBOutlet UILabel *signatureTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *signatureLab;


///国家
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *countryText;
@end

@implementation MyInfoMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.title = [@"mine.profile.title.more" icanlocalized:@"更多" ];
    [HandleOpenUrlManager shareManager].delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KUpdateUserMessageNotification object:nil];
    self.mobileTipsLab.text=[@"mine.profile.title.more.mobile" icanlocalized:@"手机号"];
    self.emailTipsLab.text=[@"mine.profile.title.more.email" icanlocalized:@"邮箱"];
    self.wxchatTipsLab.text=NSLocalizedString(@"mine.profile.title.more.weChat",微信);
    self.realnameTipsLab.text=NSLocalizedString(@"mine.profile.title.more.realName",真实姓名);
    self.idcardTipsLab.text=NSLocalizedString(@"mine.profile.title.more.IDNumber",证件号码);
    self.genderTipsLab.text=@"mine.profile.title.more.gender".icanlocalized;
    self.signatureTipsLab.text = NSLocalizedString(@"friend.detail.listCell.Signature", 个性签名);
    self.countryLab.text = @"Country".icanlocalized;
    [self updateUserMessage];
    [self getOneCountryRequest];
    
}

-(void)updateUserMessage{
    if ([UserInfoManager sharedManager].mobile) {
        if (UserInfoManager.sharedManager.areaNum.length>0) {
            self.mobileLab.text=[NSString stringWithFormat:@"+%@ %@",UserInfoManager.sharedManager.areaNum,UserInfoManager.sharedManager.mobile];
        }else{
            self.mobileLab.text=UserInfoManager.sharedManager.mobile;
        }
    }else{
        self.mobileLab.text= [@"tip.notSet" icanlocalized:@"未设置"];
        
    }
    self.emailLab.text=[UserInfoManager sharedManager].email?:[@"tip.notSet" icanlocalized:@"未设置"];
    if ([[UserInfoManager sharedManager].openIdType isEqualToString:@"WeChat"]) {
        self.wxchatLab.text= [@"tip.Bound" icanlocalized:@"已绑定"];
      
    }else{
        self.wxchatLab.text=[@"tip.Unbound" icanlocalized:@"未绑定"];
    }
    
    NSString * name;
    if (UserInfoManager.sharedManager.lastName&&UserInfoManager.sharedManager.firstName) {
        name = UserInfoManager.sharedManager.realname;
        for (int i =0; i<name.length-1; i++) {
            name=[name stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
        self.realnameArrowImg.hidden = YES;
    }else{
        name=[@"tip.notSet" icanlocalized:@"未设置"];
        self.realnameArrowImg.hidden = NO;
    }
    self.realnameLab.text=name;
    NSString *cardId = [UserInfoManager sharedManager].cardId;
    if (cardId) {
        self.idCardArrowImg.hidden = YES;
        self.idcardLab.text=cardId;
    }else{
        self.idCardArrowImg.hidden = NO;
        self.idcardLab.text=[@"tip.notSet" icanlocalized:@"未设置"];
    }
    NSString *gender = [UserInfoManager sharedManager].gender;
    if ([gender isEqualToString:@"1"]) {
        self.genderLab.text = NSLocalizedString(@"Male", 男);
        
    }else if ([gender isEqualToString:@"2"]){
        self.genderLab.text = NSLocalizedString(@"Female", 女);
    }else{
        self.genderLab.text = [@"tip.notSet" icanlocalized:@"未设置"];
    }
    
    if (![UserInfoManager sharedManager].signature || [[UserInfoManager sharedManager].signature isEqualToString:@""]) {
        self.signatureLab.text =[@"tip.notSet" icanlocalized:@"未设置"];
    }else{
        self.signatureLab.text = [UserInfoManager sharedManager].signature;
    }
}
- (IBAction)mobileAction {
    BindingMoblieOrEmailViewController * vc = [BindingMoblieOrEmailViewController new];
    vc.bindingType=BindingType_Moblie;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)eamilAction {
    BindingMoblieOrEmailViewController * vc = [BindingMoblieOrEmailViewController new];
    vc.bindingType=BindingType_Email;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)weixinAction {
    [self sendweixinAuthRequest];
}
- (IBAction)realnameAction {
    if (![UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        CertificationViewController *vc =[[CertificationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)idcardAction {
    if (![UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        CertificationViewController *vc =[[CertificationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)genderAction {
    SetGenderViewController * vc = [SetGenderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)signatureAction {
    ModifySignatureViewController * vc = [ModifySignatureViewController new];
    vc.modifySucessBlock = ^{
        [self updateUserMessage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 微信授权
 	*/
-(void)sendweixinAuthRequest{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    //     [WXApi sendReq:req ];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
    
    
}

-(void)managerDidRecvWeiXinAuthResponse:(SendAuthResp *)response{
    if (response.errCode==0) {
        BindThirdPartyRequest*request=[BindThirdPartyRequest request];
        request.type=@(0);
        request.code=response.code;
        request.parameters=[request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:@"WechatAuthorizedLogin".icanlocalized inView:self.view];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
            [UserInfoManager sharedManager].openIdType = @"WeChat";
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}

-(void)getOneCountryRequest{
    GetOneCountriesRequest * request = [GetOneCountriesRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/public/countries/%@",UserInfoManager.sharedManager.countriesCode];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[AllCountryInfo class] contentClass:[AllCountryInfo class] success:^(AllCountryInfo *response) {
        if (BaseSettingManager.isChinaLanguages) {
            self.countryText.text = response.nameCn;
        }else{
            self.countryText.text = response.nameEn;
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}


@end
