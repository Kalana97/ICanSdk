//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 25/1/2021
 - File name:  AuthorizationLoginViewController.m
 - Description:
 - Function List:
 */


#import "AuthorizationLoginViewController.h"

@interface AuthorizationLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fromAppLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *tip1Label;
@property (weak, nonatomic) IBOutlet UILabel *tip2Label;
@property (weak, nonatomic) IBOutlet UILabel *tips3Label;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tips4Label;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *appId;

@end

@implementation AuthorizationLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tip1Label.text=@"iCan Store Apply for use".icanlocalized;
    self.tip2Label.text=@"Your iCan Chat avatar, nickname, and gender information".icanlocalized;
    self.tips3Label.text=@"You can log in with the following personal information".icanlocalized;
    self.tips4Label.text=@"iCan Chat Personal Information".icanlocalized;
    [self.agreeButton setTitle:@"Agree".icanlocalized forState:UIControlStateNormal];
    [self.refuseButton setTitle:@"Refuse".icanlocalized forState:UIControlStateNormal];
    [self.agreeButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.refuseButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.nicknameLabel.text=[UserInfoManager sharedManager].nickname;
    [self.iconImageView setImageWithString:[UserInfoManager sharedManager].headImgUrl placeholder:BoyDefault];
    [self.iconImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    [self.fromAppLogoImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"Close".icanlocalized target:self action:@selector(dimssViewController)];
    
    self.access_token = [self.parameters objectForKey:@"access_token"];
    self.appId = [self.parameters objectForKey:@"appid"];
    if (self.access_token.length>0) {
        [self getaccess_tokenRequest];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"access_token不能为空" inView:self.view];
    }
    
}
-(void)dimssViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)agreeBtnAction {
    PUTPrepareAccessTokenRequest*request=[PUTPrepareAccessTokenRequest request];
    request.pathUrlString=[NSString stringWithFormat:@"%@/prepareAccessToken/%@",request.baseUrlString,self.access_token];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(AccessTokenInfo* response) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.appId) {
            NSString*urlp= [NSString stringWithFormat:@"%@://authorization?errCode=0",self.appId];
            NSURL*url=[NSURL URLWithString:urlp];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                }];
            }
            
        }else{
            NSString*urlp= [NSString stringWithFormat:@"icanmall://authorization?type=authorization&status=1&access_token=%@",self.access_token];
            NSURL*url=[NSURL URLWithString:urlp];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                }];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        if (self.appId) {
            NSString*urlp= [NSString stringWithFormat:@"%@://authorization?errCode=-1&errStr=%@",self.appId,[info.desc netUrlEncoded]];
            NSURL*url=[NSURL URLWithString:urlp];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                }];
            }
        }else{
            NSString*urlp= [NSString stringWithFormat:@"icanmall://authorization?type=authorization&status=2&access_token=%@",self.access_token];
            NSURL*url=[NSURL URLWithString:urlp];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                }];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)refuseBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getaccess_tokenRequest{
    GetPrepareAccessTokenInfoRequest*request=[GetPrepareAccessTokenInfoRequest request];
    request.pathUrlString=[NSString stringWithFormat:@"%@/prepareAccessToken/%@",request.baseUrlString,self.access_token];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[AccessTokenInfo class] contentClass:[AccessTokenInfo class] success:^(AccessTokenInfo* response) {
        [self.fromAppLogoImageView setImageWithString:response.avatar placeholder:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        
    }];
}

@end
