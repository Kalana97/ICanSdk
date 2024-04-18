//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 25/10/2019
 - File name:  QRCodeView.m
 - Description:
 - Function List:
 */


#import "QRCodeView.h"
#import "UIButton+HYQUIButton.h"
#import "UIImage+colorImage.h"
#import "PrivacyPermissionsTool.h"
#import "SaveViewManager.h"
#import "DomainExamineManager.h"
#import "IcanShareManager.h"
@interface QRCodeView ()
@property(nonatomic, weak) IBOutlet DZIconImageView *bigIconImageView;
@property(nonatomic, weak) IBOutlet UIView *bgView;
@property(nonatomic, weak) IBOutlet UIImageView *qrImageView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UIButton *shareButton;
@property(nonatomic, weak) IBOutlet UIButton *saveButton;
@end
@implementation QRCodeView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=UIColorMakeWithRGBA(27, 25, 39, 0.8);
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}
-(void)tap{
    [self hiddenQRCodeView];
}
-(void)showQRCodeView{
    
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
   
}
-(void)hiddenQRCodeView{
    [self removeFromSuperview];
}
-(void)setQrCodeViewTyep:(QRCodeViewTyep)qrCodeViewTyep{
    _qrCodeViewTyep=qrCodeViewTyep;
    NSString * QRCodeString;
    if (self.qrCodeViewTyep == QRCodeViewTyep_user) {
        NSString*content;
        content=[DomainExamineManager sharedManager].baseUrl?:BASE_URL;
        self.tipsLabel.text=NSLocalizedString(@"Scan the QR code to add me on ICan", 扫一扫二维码加我好友); //
        QRCodeString = [NSString stringWithFormat:@"%@/q/userCard/%@",content,[UserInfoManager sharedManager].userId];
        self.nameLabel.text=[UserInfoManager sharedManager].nickname;
        [self.bigIconImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
    }
    if (self.qrCodeViewTyep == QRCodeViewTyep_group) {
        NSString*content=[BaseRequest request].baseUrlString;
        QRCodeString = [NSString stringWithFormat:@"%@/q/groupCard/%@/%@",content,self.groupDetailInfo.groupId,[UserInfoManager sharedManager].userId];
        self.tipsLabel.text=NSLocalizedString(@"Scan And Add Group Chat", 扫一扫二维码加入群聊);
        [self.bigIconImageView setImageWithString:self.groupDetailInfo.headImgUrl placeholder:GroupDefault];
        self.nameLabel.text=self.groupDetailInfo.name;
    }
    
    UIImage *QRImage = [UIImage dm_QRImageWithString:QRCodeString size:ScreenWidth-80];
    self.qrImageView.image = QRImage;
}
-(IBAction)shareBtnAction{
    self.shareButton.hidden=YES;
    self.saveButton.hidden=YES;
    //保存一个截图
    CGRect screenRect = [self.bgView bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size,YES, 0.0);
    [self.bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.shareButton.hidden=NO;
    self.saveButton.hidden=NO;
    [[IcanShareManager sharedManager]ftShareThumImage:snapshotImage sharingChannels:@[@{@"image":@"icon_share_wechat_user",@"title":@"WeChat".icanlocalized},@{@"image":@"icon_share_wechat_moments",@"title":@"friend.detail.listCell.Moments".icanlocalized}]];
}
-(IBAction)saveBtnAction{
    
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        self.shareButton.hidden=YES;
        self.saveButton.hidden=YES;
        [SaveViewManager captureImageFromView:self.bgView success:^{
            self.shareButton.hidden=NO;
            self.saveButton.hidden=NO;
            [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
        } failed:^{
            self.shareButton.hidden=NO;
            self.saveButton.hidden=NO;
            [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
        }];
        
        
    } failure:^{
        self.shareButton.hidden=NO;
        self.saveButton.hidden=NO;
    }];
    
}
@end
