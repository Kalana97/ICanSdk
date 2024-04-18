#import "MyInfoViewController.h"
#import "ShowHeadPicVC.h"
#import "ChangeNicknameViewController.h"

#import "QRCodeView.h"
#import "PrivacyPermissionsTool.h"
#import "SaveViewManager.h"

#import "BuyVipOrIdViewController.h"
#import "MyInfoMoreViewController.h"
@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headImageTitle;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *nicknameDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *IdTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *IDDetailLab;
//等级
@property (weak, nonatomic) IBOutlet UILabel *grabTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *grabDetailLab;
//VIP
@property (weak, nonatomic) IBOutlet UILabel *memberTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberDetailLabel;


@property (weak, nonatomic) IBOutlet UILabel *qrCodeTipsLab;

@property (weak, nonatomic) IBOutlet UILabel *moreTipsLab;


@end

@implementation MyInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.titleView.title = NSLocalizedString(@"MyProfile",个人信息 );
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KUpdateUserMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KBuyVIPNotification object:nil];
    self.headImageTitle.text = [@"mine.profile.title.profilePhoto" icanlocalized:@"头像"];
    self.headImageTitle.textColor = UIColorThemeMainTitleColor;
    self.nicknameTipsLab.text = [@"mine.profile.title.nickname" icanlocalized:@"昵称"];
    self.nicknameTipsLab.textColor = UIColorThemeMainTitleColor;
    self.nicknameDetailLab.textColor =UIColorThemeMainSubTitleColor;

    self.grabTipsLab.text = [@"mine.profile.title.accountLevel" icanlocalized:@"等级"];
    self.grabTipsLab.textColor = UIColorThemeMainTitleColor;
    self.grabDetailLab.textColor =UIColorThemeMainSubTitleColor;

    self.IdTipsLab.textColor =UIColorThemeMainTitleColor;
    self.IDDetailLab.textColor =UIColorThemeMainSubTitleColor;

    self.grabDetailLab.text = NSLocalizedString(@"NoLevel",暂无等级);
    self.grabDetailLab.textColor =UIColorThemeMainSubTitleColor;

    self.qrCodeTipsLab.text = [@"mine.profile.title.qrcode" icanlocalized:@"我的二维码"];
    self.qrCodeTipsLab.textColor = UIColorThemeMainTitleColor;

    self.moreTipsLab.text = [@"mine.profile.title.more" icanlocalized:@"更多" ];
    self.moreTipsLab.textColor = UIColorThemeMainTitleColor;

    self.memberTipsLabel.text = @"MyInfoViewController_memberTipsLabel".icanlocalized;
    self.memberTipsLabel.textColor = UIColorThemeMainTitleColor;
    self.memberDetailLabel.textColor = UIColorThemeMainSubTitleColor;

    [self updateUserMessage];
    
}
-(void)updateUserMessage{
    [self.iconImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
    self.nicknameDetailLab.text = [UserInfoManager sharedManager].nickname;
    self.IDDetailLab.text = [UserInfoManager sharedManager].numberId;
    if (UserInfoManager.sharedManager.diamondValid) {
        self.memberDetailLabel.text =@"DiamondVIP".icanlocalized;
    }else if (UserInfoManager.sharedManager.seniorValid){
        self.memberDetailLabel.text =@"SeniorVIP".icanlocalized;
    }else{
        self.memberDetailLabel.text =@"Standard".icanlocalized;
        
    }
    
}
- (IBAction)memberAction {
    BuyVipOrIdViewController*vc = [[BuyVipOrIdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)headImgAction {
    ShowHeadPicVC *headPortrait = [[ShowHeadPicVC alloc]init];
    [self.navigationController pushViewController:headPortrait animated:YES];
    
}
- (IBAction)nicknameAction {
    ChangeNicknameViewController * vc = [ChangeNicknameViewController new];
    vc.nickName =   [UserInfoManager sharedManager].nickname;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)qrcodeAction {
    QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    view.qrCodeViewTyep=QRCodeViewTyep_user;
    [view showQRCodeView];
}
- (IBAction)moreAction {
    [self.navigationController pushViewController:[MyInfoMoreViewController new] animated:YES];
}


@end
