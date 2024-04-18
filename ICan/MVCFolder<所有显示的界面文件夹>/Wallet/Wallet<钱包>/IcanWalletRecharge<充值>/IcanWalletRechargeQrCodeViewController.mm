//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletRechargeQrCodeViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletRechargeQrCodeViewController.h"
#import "QDNavigationController.h"
#import "IcanWalletSelecMainNetworkView.h"
#import "UIImage+colorImage.h"
#import "SaveViewManager.h"
#import "IcanShareManager.h"
#import "ChatUtil.h"
#import "ChatAlbumModel.h"
#import "TranspondTableViewController.h"
#import "OSSWrapper.h"
#import "OSSManager.h"
#import "WCDBManager+ChatModel.h"
#import "NSData+ImageContentType.h"
@interface IcanWalletRechargeQrCodeViewController ()
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UIImageView *qrCodeImgView;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *mainNerworkLabel;
@property(nonatomic, weak) IBOutlet UILabel *mainNerworkDetailLabel;

@property(nonatomic, weak) IBOutlet UILabel *rechargeTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *rechargeAddressLabel;

@property(nonatomic, weak) IBOutlet UILabel *minRechargeTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *minRechargeLabel;
///充值区块确认数
@property(nonatomic, weak) IBOutlet UILabel *rechargeSureTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *rechargeSureLabel;
///充值区块确认数
@property(nonatomic, weak) IBOutlet UILabel *withdrawSureTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *withdrawSureLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property(nonatomic, strong) IcanWalletSelecMainNetworkView *mainNetworkView;
@property(nonatomic, strong) ExternalWalletsInfo *walletsInfo;
@property(nonatomic, copy) NSString *code;
@property (weak, nonatomic) IBOutlet UIView *qrBgView;
@property (weak, nonatomic) IBOutlet UIView *qrImageCon;
@property (weak, nonatomic) IBOutlet UIView *creatingWalletCon;
@property (weak, nonatomic) IBOutlet UILabel *createWalletLab;
@property (weak, nonatomic) IBOutlet UILabel *createWalletDescLab;
@property (weak, nonatomic) IBOutlet UIView *screenShtView;
@property (weak, nonatomic) IBOutlet UIView *bottomVew;

@end

@implementation IcanWalletRechargeQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.code = self.balanceInfo?self.balanceInfo.code:self.currencyInfo.code;
    NSString *titleString = [NSString stringWithFormat:@"%@ %@",@"Top Up".icanlocalized,self.code];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.attributedText = attributedTitle;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    [self setMainNetwork];
    [self.saveBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",@"Top Up".icanlocalized,self.code];
    self.tipsLabel.text = [NSString stringWithFormat:@"%@%@",@"C2CQrCodeTips".icanlocalized,self.code];
    self.mainNerworkLabel.text = @"WalletRechargeMainnet".icanlocalized;
    self.rechargeTitleLabel.text = [NSString stringWithFormat:@"%@ %@",self.code,@"C2CQrCodeDepositAddress".icanlocalized];
    self.minRechargeTitleLabel.text = @"C2CQrCodeMinimumRecharge".icanlocalized;
    self.rechargeSureTitleLabel.text = @"C2CQrCodeConfirmation".icanlocalized;
    self.withdrawSureTitleLabel.text = @"C2CQrCodeWithdrawalUnlock".icanlocalized;
    self.createWalletLab.text = @"Creating Your Secure Wallet...".icanlocalized;
    self.createWalletDescLab.text = @"Please wait while we set up your wallet. This ensures the security of your funds and protects your assets.".icanlocalized;
    [self.saveBtn setTitle:@"C2CQrCodeSaveImg".icanlocalized forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"C2CQrCodeShare".icanlocalized forState:UIControlStateNormal];
    self.bottomVew.layer.cornerRadius = 10;
    self.bottomVew.layer.borderWidth = 1.0;
    self.bottomVew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        for (UIView *subview1 in self.navigationController.navigationBar.subviews) {
            for (UIView *subview in subview1.subviews) {
                    if ([subview isKindOfClass:[UIImageView class]]) {
                        UIImage *image = [UIImage imageNamed:@"p2p_box"];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        imageView.frame = CGRectMake(0, 0, subview.width, subview.height);
                        [subview addSubview:imageView];
                    }
            }
        }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    for (UIView *subview1 in self.navigationController.navigationBar.subviews) {
        for (UIView *subview in subview1.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                for (UIView *subview2 in subview.subviews) {
                    [subview2 removeFromSuperview];
                }
            }
        }
    }
}

- (UIColor *)navigationBarTintColor{
    return UIColorWhite;
}

-(void)setMainNetwork{
    self.mainNerworkDetailLabel.text = self.mainNetworkInfo.channelName;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",self.mainNetworkInfo.channelCode];
    self.walletsInfo = [C2CUserManager.shared.userInfo.externalWallets filteredArrayUsingPredicate:predicate].firstObject;
    self.rechargeAddressLabel.text = self.walletsInfo.walletAddress;
    self.minRechargeLabel.text = [NSString stringWithFormat:@"%@%@",[self.mainNetworkInfo.rechargeMin calculateByNSRoundDownScale:2].currencyString,self.code];
    self.rechargeSureLabel.text = [NSString stringWithFormat:@"%@ %@",self.mainNetworkInfo.rechargeConfirmNumber.stringValue,@"C2CQrCodeBlockConfirmation".icanlocalized];
    self.withdrawSureLabel.text = [NSString stringWithFormat:@"%@ %@",self.mainNetworkInfo.withdrawConfirmNumber.stringValue,@"C2CQrCodeBlockConfirmation".icanlocalized];
    self.qrCodeImgView.image = [UIImage dm_QRImageWithString:self.walletsInfo.walletAddress size:140];
    
    if (self.walletsInfo.walletAddress != nil){
        self.creatingWalletCon.hidden = YES;
        self.qrImageCon.hidden = NO;
        self.createWalletLab.hidden = YES;
        self.createWalletDescLab.hidden = YES;
        self.saveBtn.hidden = NO;
        self.shareBtn.hidden = NO;
        
    }else if(self.walletsInfo.walletAddress == nil && self.walletsInfo.externalWalletId > 0) {
        self.creatingWalletCon.hidden = NO;
        self.qrImageCon.hidden = YES;
        self.createWalletLab.hidden = NO;
        self.createWalletDescLab.hidden = NO;
        self.tipsLabel.hidden = YES;
        self.saveBtn.hidden = YES;
        self.shareBtn.hidden = YES;
    }
}
- (IBAction)copyAction {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.walletsInfo.walletAddress;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)seelectMainNetworkAction {
    [self.mainNetworkView showView];
}
- (IBAction)saveAction {
    [SaveViewManager captureImageFromView:self.screenShtView success:^{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
    } failed:^{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
    }];
}
- (IBAction)shareAction {
    CGRect screenRect = [self.qrBgView bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size,YES, 0.0);
    [self.qrBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    IcanShareManager * manager = [IcanShareManager sharedManager];
    [manager ftShareThumImage:snapshotImage sharingChannels:@[@{@"image":@"icon_share_wechat_user",@"title":@"WeChat".icanlocalized},@{@"image":@"icon_share_wechat_moments",@"title":@"friend.detail.listCell.Moments".icanlocalized},@{@"image":@"applogo",@"title":@"iCan Chat"}]];
    
    manager.tapIndexBlock = ^(NSInteger index) {
        TranspondTableViewController*vc = [[TranspondTableViewController alloc]init];
        vc.transpondType=TranspondType_Image;
        vc.endBlock = ^(NSArray * _Nonnull toModelItems, NSArray * _Nonnull messageItems) {
            for (ChatModel*messageModel in messageItems) {
                if (![messageModel.messageType isEqualToString:TextMessageType] || ![messageModel.messageType isEqualToString:URLMessageType]) {
                    ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
                    imageModel.isOrignal = NO;
                    imageModel.picSize = snapshotImage.size;
                    imageModel.name =[NSString getArc4random5:0];
                    imageModel.compressImageData= [snapshotImage thumbImageToByte:1024*1024];
                    imageModel.orignalImageData = UIImageJPEGRepresentation(snapshotImage, 0.8);
                    NSString*hashId=[NSString getHasNameData:imageModel.orignalImageData];
                    [self checkFileHasExistRequestWithHashId:hashId successBlock:^(NSString *response) {
                        if (response.length>0) {
                            for (ChatModel*configModel in toModelItems) {
                                ChatModel * model = [ChatUtil initPicMessage:@[imageModel] config:configModel isGif:NO].firstObject;
                                model.fileServiceUrl=response;
                                model.uploadProgress=@"100%";
                                model.uploadState=1;
                                model.sendState=1;
                                model.imageUrl=response;
                                UIImage*image=[UIImage imageWithData:model.orignalImageData];
                                ImageMessageInfo*imageInfo=[[ImageMessageInfo alloc]init];
                                imageInfo.imageUrl = model.imageUrl;
                                imageInfo.height=image.size.height ;
                                imageInfo.width=image.size.width;
                                imageInfo.isFull=!model.isOrignal;
                                model.messageContent=[imageInfo mj_JSONString];
                                [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
                            }
                        }else{
                            OSSPutObjectRequest*  request = [OSSPutObjectRequest new];
                            request.bucketName = [BaseSettingManager sharedManager].bucket;
                            SDImageFormat format = [NSData sd_imageFormatForImageData:imageModel.orignalImageData];
                            NSString*mimeType;
                            //判断图片类型
                            switch (format) {
                                case SDImageFormatGIF:{
                                    mimeType=@"gif";
                                }
                                    break;
                                case SDImageFormatPNG:
                                    mimeType=@"png";
                                    break;
                                case SDImageFormatHEIC:
                                    mimeType=@"heic";
                                    break;
                                case SDImageFormatJPEG:
                                    mimeType=@"jpeg";
                                    break;
                                case SDImageFormatTIFF:
                                    break;
                                case SDImageFormatWebP:
                                    break;
                                case SDImageFormatUndefined:
                                    break;
                                default:
                                    break;
                            }
                            request.objectKey = [NSString stringWithFormat:@"chat/%@/%@.%@",[GetTime getTimeNow],imageModel.name,mimeType];
                            request.uploadingData=imageModel.orignalImageData;
                            request.isAuthenticationRequired = YES;
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                OSSTask * task = [[OSSManager sharedManager].defaultClient putObject:request];
                                [task continueWithBlock:^id(OSSTask *task) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (task.error) {
                                            
                                        } else {
                                            for (ChatModel*configModel in toModelItems) {
                                                ChatModel * model = [ChatUtil initPicMessage:@[imageModel] config:configModel isGif:NO].firstObject;
                                                NSString*urlStr=[NSString stringWithFormat:@"%@/%@",[BaseSettingManager sharedManager].urlBegin,request.objectKey];
                                                model.fileServiceUrl=urlStr;
                                                model.uploadProgress=@"100%";
                                                model.uploadState=1;
                                                model.sendState=1;
                                                model.imageUrl=urlStr;
                                                UIImage*image=[UIImage imageWithData:model.orignalImageData];
                                                ImageMessageInfo*imageInfo=[[ImageMessageInfo alloc]init];
                                                imageInfo.imageUrl = model.imageUrl;
                                                imageInfo.height=image.size.height ;
                                                imageInfo.width=image.size.width;
                                                imageInfo.isFull=!model.isOrignal;
                                                model.messageContent=[imageInfo mj_JSONString];
                                                [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
                                            }
                                        }
                                    });
                                    
                                    return nil;
                                }];
                            });
                        }
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        
                    }];
                    
                }
                
            }
        };
        vc.shareImg = snapshotImage;
        QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle=UIModalPresentationFullScreen;
        [[AppDelegate shared] presentViewController:nav animated:YES completion:nil];
    };
}
-(void)checkFileHasExistRequestWithHashId:(NSString*)hashId successBlock:(void(^)(NSString*response))successBlock failure:(void (^_Nullable)(NSError *error, NetworkErrorInfo *info, NSInteger statusCode))failure{
    CheckFileHasExistRequest*request=[CheckFileHasExistRequest request];
    request.hashId=hashId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
        successBlock(response);
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        failure(error,info,statusCode);
    }];
}
-(IcanWalletSelecMainNetworkView *)mainNetworkView{
    if (!_mainNetworkView) {
        _mainNetworkView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelecMainNetworkView" owner:self options:nil].firstObject;
        _mainNetworkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _mainNetworkView.mainNetworkItems = self.mainNetworkItems;
        @weakify(self);
        _mainNetworkView.selectBlock = ^(ICanWalletMainNetworkInfo * _Nonnull info) {
            @strongify(self);
            self.mainNetworkInfo = info;
            [self setMainNetwork];
        };
        
    }
    return _mainNetworkView;
}

@end
