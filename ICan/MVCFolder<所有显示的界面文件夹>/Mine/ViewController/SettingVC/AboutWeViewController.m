//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/11/2019
 - File name:  AboutWeViewController.m
 - Description:
 - Function List:
 */


#import "AboutWeViewController.h"
#import "CommonWebViewController.h"
@interface AboutWeViewController ()
@property(nonatomic, assign) BOOL update;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UILabel *privacyAgreementLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceAgreementLab;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalAgreementLab;
@property (weak, nonatomic) IBOutlet UILabel *updateLab;

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=NSLocalizedString(@"mine.setting.cell.title.about", 关于我们);
    self.view.backgroundColor = UIColorBg243Color;
    self.privacyAgreementLab.text = [@"PrivacyAgreement".icanlocalized substringWithRange:NSMakeRange(1, @"PrivacyAgreement".icanlocalized.length-2)];
    self.serviceAgreementLab.text = [@"ServiceAgreement".icanlocalized substringWithRange:NSMakeRange(1, @"ServiceAgreement".icanlocalized.length-2)];
    self.withdrawalAgreementLab.text = [@"WithdrawalAgreement".icanlocalized substringWithRange:NSMakeRange(1, @"WithdrawalAgreement".icanlocalized.length-2)];
    self.updateLab.text = NSLocalizedString(@"VersionUpdate", 版本更新);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text= [NSString stringWithFormat:@"%@",appCurVersion];
    self.logoImgView.image =  [UIImage imageNamed:@"appicon"];
    [self.logoImgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self checkVersionRequest];
}

-(void)checkVersionRequest{
    VersionsRequest*request=[VersionsRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[VersionsInfo class] contentClass:[VersionsInfo class] success:^(VersionsInfo* response) {
        if (response.content) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            // 当前应用软件版本  比如：1.0.1
            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([appCurVersion compare:response.version]==NSOrderedAscending) {
                self.update=YES;
            }else{
                self.update=NO;
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(IBAction)privacyAgreemenAction{
    [self pushWebWithTitle:@"PrivacyAgreement".icanlocalized];
}
-(IBAction)serviceAgreementAction{
    [self pushWebWithTitle:@"ServiceAgreement".icanlocalized];
}
-(IBAction)withdrawalAgreementAction{
    [self pushWebWithTitle:@"WithdrawalAgreement".icanlocalized];
}
-(void)pushWebWithTitle:(NSString*)title{
    CommonWebViewController*web=[[CommonWebViewController alloc]init];
    NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:title];
    web.title = dict[@"title"];
    web.urlString = dict[@"url"];
    [self.navigationController pushViewController:web animated:YES];
}
-(IBAction)updateAction{
    if (self.update) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/ican-%E6%88%91%E8%A1%8C/id1466628262"] options:@{} completionHandler:nil];
    }
    
}
@end
