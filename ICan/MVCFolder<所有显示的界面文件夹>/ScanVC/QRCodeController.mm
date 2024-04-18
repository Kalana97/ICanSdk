//
//  QRCodeController.m
//  iOSCamera
//
//  Created by 李达志 on 2018/4/24.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import "QRCodeController.h"
#import "FriendDetailViewController.h"
#import "QrScanResultAddRoomController.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "PrivacyPermissionsTool.h"
#import "SweepLoginCodeViewController.h"
#import <WebKit/WebKit.h>
#import "PayReceiptMentViewController.h"
#import "SetMoneyViewController.h"
#import "VoicePlayerTool.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "PaySuccessTipViewController.h"
#import "IcanWalletPayQrCodeInputMoneyViewController.h"
#define  SCANIMAGEVIEWWH  ScreenWidth-100//扫描框的宽高
#define MaginTB  (ScreenHeight-(SCANIMAGEVIEWWH)-StatusBarAndNavigationBarHeight)/2
#define ScanLineViewMaxTop KScreenHeight-((ScreenHeight-(SCANIMAGEVIEWWH)-StatusBarAndNavigationBarHeight)/2)-2 //扫描线距离顶部的高度
@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,WKNavigationDelegate>{ 
    
}
//输入设备
@property (nonatomic,strong) AVCaptureDeviceInput * aVCaptureDeviceInput;
// 输出元数据
@property (nonatomic,strong) AVCaptureMetadataOutput * metadataOutput;
//中间链接器 用来链接输入和输出
@property (nonatomic,strong) AVCaptureSession * session;
@property (nonatomic,strong)  AVCaptureDevice *device;
// 预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIView * leftView;
@property (nonatomic,strong) UIView * rightView;
@property (nonatomic,strong) UIView * bottomView;
//扫描边框
@property (nonatomic,strong) UIImageView * scanImageView;
//扫描线
@property (nonatomic,strong) UIView * scanLineView;
//开灯
@property (nonatomic,strong) UIButton * openButton;
@property(nonatomic, strong) UIControl * openCon;
@property(nonatomic, strong) UILabel *  openTitle;
//相册
@property (nonatomic,strong) UIButton  *  photoButton;
@property(nonatomic, strong) UIControl *  photoCon;
@property(nonatomic, strong) UILabel   *  photoTitle;
/** 扫描线距离顶部的距离 */
@property (nonatomic,assign) CGFloat scanLineTopMargin;
@property (strong, nonatomic) UIImageView *focusCursor; //聚焦光标
//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
@property (nonatomic,strong) UILabel * tipsLabel;
@property (nonatomic,strong) UIImagePickerController*uiImagePicker;
@property(nonatomic, assign) BOOL successSweep;
@end

@implementation QRCodeController
-(instancetype)initWithBlock:(void (^)(NSString *, BOOL))scanResult{
    if (self=[super init]) {
        self.scanResultBlock=scanResult;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    //二维码
    self.title = @"chatlist.menu.list.scan".icanlocalized;
    @weakify(self);
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        @strongify(self);
        [self setUpView];
        [self setUpScanning];
        self.focusCursor=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_focus"]];
        self.focusCursor.hidden=YES;
        
        self.focusCursor.frame=CGRectMake(0, 0, 60, 60 );
        self.focusCursor.center=self.view.center;
        [self.view addSubview:self.focusCursor];
        [self addGenstureRecognizer];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startRuning) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    } failure:^{
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startRuning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopRuning];
}
-(void)startRuning{
    [self.session startRunning];
    CABasicAnimation * lineAnimation = [self animationWith:@(0) toValue:@(ScreenWidth-100-2) repCount:MAXFLOAT duration:1.5f];
    [self.scanLineView.layer addAnimation:lineAnimation forKey:@"scningLineView"];
    
}
-(void)stopRuning{
    [self.session stopRunning];
    [self.scanLineView.layer removeAllAnimations];
}
-(void)setUpView{
    [self.view addSubview:self.scanImageView];
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(SCANIMAGEVIEWWH));
        make.top.equalTo(@(MaginTB));
        make.left.equalTo(@50);
        
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.scanImageView.mas_bottom);
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(MaginTB));
    }];
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(MaginTB));
        make.bottom.equalTo(self.scanImageView.mas_bottom);
        make.width.equalTo(@50);
        
    }];
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@(MaginTB));
        make.bottom.equalTo(self.scanImageView.mas_bottom);
        make.width.equalTo(@50);
    }];
    [self.view addSubview:self.scanLineView];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.scanImageView.mas_bottom).offset(10);
    }];
    [self.view addSubview:self.openCon];
    [self.openCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-30);
        make.height.equalTo(@100);
        make.width.equalTo(@(100));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
    }];
    [self.openCon addSubview:self.openButton];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.openCon.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
        make.top.equalTo(@10);
        
    }];
    [self.openCon addSubview:self.openTitle];
    [self.openTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.openCon.mas_centerX);
        make.bottom.equalTo(@-10);
    }];
    
    
    [self.view addSubview:self.photoCon];
    [self.photoCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.height.equalTo(@100);
        make.width.equalTo(@(100));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
    }];
    [self.photoCon addSubview:self.photoButton];
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoCon.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
        make.top.equalTo(@10);
        
    }];
    [self.photoCon addSubview:self.photoTitle];
    [self.photoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoCon.mas_centerX);
        make.bottom.equalTo(@-10);
    }];
    
}



#pragma mark - 扫码line滑动动画
- (CABasicAnimation*)animationWith:(id)fromValue toValue:(id)toValue repCount:(CGFloat)repCount duration:(CGFloat)duration{
    
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    lineAnimation.fromValue = fromValue;
    lineAnimation.toValue = toValue;
    lineAnimation.repeatCount = repCount;
    lineAnimation.duration = duration;
    lineAnimation.fillMode = kCAFillModeForwards;
    lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return lineAnimation;
}
//设置扫描输入输出
-(void)setUpScanning{
    
    //设置高质量采集
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    // 1.判断是否能够将输入添加到会话中
    if (![self.session canAddInput:self.aVCaptureDeviceInput]) {
        return;
    }
    
    // 2.判断是否能够将输出添加到会话中
    if (![self.session canAddOutput:self.metadataOutput]) {
        return;
    }
    
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 3.将输入和输出都添加到会话中
    [self.session addInput:self.aVCaptureDeviceInput];
    
    [self.session addOutput:self.metadataOutput];
    
    // 4.设置输出能够解析的数据类型
    // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
    self.metadataOutput.metadataObjectTypes =  @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // 经实践发现  (0,0,,1,1)这个写法有点坑   实际为(y,x,h,w)  即坐标y,x  尺寸高,宽(h,w)
    //rectOfInterest 的是比例来的
    [self.metadataOutput setRectOfInterest : CGRectMake (( MaginTB)/ ScreenHeight ,(50)/ ScreenWidth , SCANIMAGEVIEWWH / ScreenHeight , SCANIMAGEVIEWWH / ScreenWidth)];
    
    // 5.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 6.告诉session开始扫描
    [self.session startRunning];
}
/**
 *  当从二维码中获取到信息时，就会调用下面的方法
 *
 *  @param captureOutput   输出对象
 *  @param metadataObjects 信息
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0 || metadataObjects == nil) {
        return;
    }
    // 1.获取扫描到的数据
    // 注意: 要使用stringValue
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects lastObject];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] && [metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            [self stopRuning];
            [[VoicePlayerTool sharedManager]playScanSuccessVoice];
            [self searchResurltStr:metadataObj.stringValue];
        }
    }
    
    
    
}

#pragma mark 懒加载
// 会话
- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}
-(AVCaptureDeviceInput *)aVCaptureDeviceInput{
    if (!_aVCaptureDeviceInput) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _aVCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _aVCaptureDeviceInput;
}
-(AVCaptureMetadataOutput *)metadataOutput{
    if (!_metadataOutput) {
        _metadataOutput=[[AVCaptureMetadataOutput alloc]init];
    }
    return _metadataOutput;
}
-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //铺满屏幕
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
    }
    return _previewLayer;
}
-(UIView *)leftView{
    if (!_leftView) {
        _leftView=[[UIView alloc]init];
        _leftView.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    }return _leftView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]init];
        _bottomView.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    }return _bottomView;
}
-(UIView *)rightView{
    if (!_rightView) {
        _rightView=[[UIView alloc]init];
        _rightView.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    }return _rightView;
}
-(UIView *)topView{
    if (!_topView) {
        _topView=[[UIView alloc]init];
        _topView.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    }return _topView;
}
-(UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_qrcode_border"]];
    }return _scanImageView;
}
-(UIView *)scanLineView{
    if (!_scanLineView) {
        _scanLineView=[[UIView alloc]initWithFrame:CGRectMake(52, MaginTB, ScreenWidth-104, 2)];
        _scanLineView.backgroundColor=UIColorThemeMainColor;
    }
    return _scanLineView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[[UILabel alloc]init];
        _tipsLabel.font=[UIFont systemFontOfSize:12];
        _tipsLabel.text=NSLocalizedString(@"Align QR Code/barcode within frame to scan", 将取景框对准二维码即可自动扫描);
        _tipsLabel.textColor=[UIColor whiteColor];
        _tipsLabel.hidden=YES;
    }
    return _tipsLabel;
}
-(UIControl *)openCon{
    if (!_openCon) {
        _openCon=[[UIControl alloc]init];
        [_openCon addTarget:self action:@selector(openButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCon;
}
-(UILabel *)openTitle{
    if (!_openTitle) {
        _openTitle=[UILabel centerLabelWithTitle:@"Light".icanlocalized font:14 color:UIColor.whiteColor];
    }
    return _openTitle;
}
-(UIButton *)openButton{
    if (!_openButton) {
        _openButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"icon_qrcode_scan_flash_nor"] forState:UIControlStateNormal];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"icon_qrcode_scan_flash_sel"] forState:UIControlStateHighlighted];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"icon_qrcode_scan_flash_sel"] forState:UIControlStateSelected];
        [_openButton addTarget:self action:@selector(openButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _openButton;
}
-(void)openButtonAction{
    self.openButton.selected=!self.openButton.selected;
    if ([self.device hasTorch]) {
        //2.锁定当前设备为使用者
        [self.device lockForConfiguration:nil];
        [self.device setTorchMode:self.openButton.isSelected?AVCaptureTorchModeOn:AVCaptureTorchModeOff];
        //4.使用完成后解锁
        [self.device unlockForConfiguration];
    }
}

-(UIButton *)photoButton{
    if (!_photoButton) {
        _photoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setBackgroundImage:[UIImage imageNamed:@"icon_qrcode_scan_picture_nor"] forState:UIControlStateNormal];
        [_photoButton setBackgroundImage:[UIImage imageNamed:@"icon_qrcode_scan_picture_sel"] forState:UIControlStateHighlighted];
        [_photoButton addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _photoButton;
}
-(UIControl *)photoCon{
    if (!_photoCon) {
        _photoCon=[[UIControl alloc]init];
        [_photoCon addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoCon;
}
-(UILabel *)photoTitle{
    if (!_photoTitle) {
        _photoTitle=[UILabel centerLabelWithTitle:@"Photos".icanlocalized font:14 color:UIColor.whiteColor];
    }
    return _photoTitle;
}
-(void)photoButtonAction{
    [self presentViewController:self.uiImagePicker animated:YES completion:nil];
}

-(UIImagePickerController *)uiImagePicker{
    if (!_uiImagePicker) {
        _uiImagePicker=[[UIImagePickerController alloc]init];
        _uiImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _uiImagePicker.delegate=self;
        [_uiImagePicker.navigationBar setBarTintColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
        _uiImagePicker.navigationBar.titleTextAttributes  = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:19.0f], NSFontAttributeName,nil];
        
        [_uiImagePicker.navigationBar setTintColor:[UIColor whiteColor]];
        
        _uiImagePicker.navigationBar.titleTextAttributes  = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:19.0f], NSFontAttributeName,nil];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        _uiImagePicker.navigationBar.barTintColor=UIColorMake(246, 246, 246);
        _uiImagePicker.navigationBar.tintColor=[UIColor blackColor];
        
        
        
    }
    return _uiImagePicker;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count) {
        [self stopRuning];
        CIQRCodeFeature *feature=[features lastObject];
        //self.ScanResult(feature.messageString, YES);
        [self getQrCodeRequest:feature.messageString];
        [self.uiImagePicker dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        //识别不了二维码
        [self.uiImagePicker dismissViewControllerAnimated:YES completion:nil];
        [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:NSLocalizedString(@"UnabletorecognizeQRcodeinformation", 无法识别二维码信息)] inView:self.view];
        [self startRuning];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    self.focusCursor.hidden=NO;
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.view];
        //将UI坐标转化为摄像头坐标
        //        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self.device lockForConfiguration:nil];
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [self.device unlockForConfiguration];
        [self setFocusCursorWithPoint:point];
        
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    
    self.focusCursor.center=point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
    }];
    
}
-(void)onHiddenFocusCurSorAction{
    self.focusCursor.hidden=YES;
    //    NSURLRequest*request=[[NSURLRequest alloc]init];
    NSMutableURLRequest*urlRequest=[[NSMutableURLRequest alloc]init];
    WKWebView*view=[[WKWebView alloc]init];
    [view loadRequest:urlRequest];
    
}
#pragma mark -- 扫一扫结果处理 --
- (void)searchResurltStr:(NSString *)str {
    //https://server.im.fortune.mingshz.com/q/groupCard/113/7?appIdentity=www.weiquan.socialcontact
    //https://fm.im.fortune.mingshz.com/?code=userCard%3Fid%3D7&guiderId=7
    
    [self getQrCodeRequest:str];
}

-(void)getQrCodeRequest:(NSString*)result{
    [self stopRuning];
    if (self.fromICanWallet) {
        if (self.scanResultBlock) {
            self.scanResultBlock(result, YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //  个人二维码  http://service.woxingtest.site:9902/q/userCard/23
        //  群       http://service.woxingtest.site:9902/q/groupCard/40/23
        // Login=41d7f0cecaa74a0790c899ed80f7e632 扫码登录
        /*
         收款码
         http://chat.t.shinianwangluo.com/q/receive/8a5c011c417c4e38b67bd58045a2eb4e/111184/M
         M 代表金额 -1则表示没有传收款金额
         */
        /*
         付款码
         /q/payment/{code}/{userId}
         http://chat.t.shinianwangluo.com/q/payment/2c9187b2c5834760b5f465173aab0f66/111184
         
         c2c收款码
         //    /q/c2c/receive/{code}/{c2cUserId}/{m}/{unit}
         */
        NSString * personContentString = @"/q/userCard/";
        NSString * groupContentString =@"/q/groupCard/";
        NSString * receiveContentString=@"/q/receive/";
        NSString * paymentContentString=@"/q/payment/";
        NSString * c2cReceive = @"/q/c2c/receive/";
        if ([result containsString:personContentString]) {
            NSArray * array= [result componentsSeparatedByString:@"/"];
            [self handerPersonalResultWithId:array.lastObject];
        }else if ([result containsString:groupContentString]) {
            NSArray * array= [result componentsSeparatedByString:@"/"];
            NSString *groupId = array[array.count-2];
            NSString *inviterId = array[array.count-1];
            [self handerGroupResultWithId:groupId inviterId:inviterId];
            
        }else if ([result containsString:@"Login"]){
            SweepLoginCodeViewController*vc=[[SweepLoginCodeViewController alloc]init];
            NSString*uuid=[result componentsSeparatedByString:@"="].lastObject;
            vc.uuId=uuid;
            vc.isLoginClient=YES;
            vc.dimssBlock = ^{
                
            };
            vc.modalPresentationStyle=UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else if([result containsString:@"G_O_L"]){//群主登录
            //UUID规则
            //G_O_L_uuid
            SweepLoginCodeViewController*vc=[[SweepLoginCodeViewController alloc]init];
            NSString*uuid=result;
            vc.isLoginClient=NO;
            vc.uuId=uuid;
            vc.dimssBlock = ^{
                
            };
            vc.modalPresentationStyle=UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else if ([result containsString:receiveContentString]){//收款码
            NSArray*array=[result componentsSeparatedByString:@"receive/"];
            NSArray*codeArray=[array.lastObject componentsSeparatedByString:@"/"];
            NSString*code;
            NSString*userId;
            NSString*money;
            PayReceiptMentViewController*vc=[[PayReceiptMentViewController alloc]init];
            if (codeArray.count==3) {
                code=codeArray.firstObject;
                userId=codeArray[1];
                money=codeArray.lastObject;
                vc.money=money;
            }else{
                code=codeArray.firstObject;
                userId=codeArray[1];
            }
            
            vc.code=code;
            vc.userId=userId;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([result containsString:paymentContentString]){//付款码
            [self receiveMoneyWitString:result];
            //        SetMoneyViewController*vc=[[SetMoneyViewController alloc]init];;
            //        vc.isPayment=YES;
            //        vc.codeStr=result;
            //        [self.navigationController pushViewController:vc animated:YES];
        }else if ([result containsString:c2cReceive]){//c2c收款码
            ////p/c2c/receive/{code}/{c2cUserId}/{m}/{unit}
            IcanWalletPayQrCodeInputMoneyViewController * vc = [[IcanWalletPayQrCodeInputMoneyViewController alloc]init];
            NSArray*array=[result componentsSeparatedByString:c2cReceive];
            NSArray * allItems = [array.lastObject componentsSeparatedByString:@"/"];
            vc.userId = allItems[1];
            vc.code = allItems[0];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:result]]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:result] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }else{
                [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:NSLocalizedString(@"UnabletorecognizeQRcodeinformation", 无法识别二维码信息)] inView:self.view];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
}
-(NSDictionary *) parameterWithURL:(NSURL *) url {
    if (!url) {
        return nil;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}
-(void)handerPersonalResultWithId:(NSString *)ID{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = ID;
    vc.friendDetailType=FriendDetailType_push;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)handerGroupResultWithId:(NSString *)groupId inviterId:(NSString *)inviterId{
    
    GetGroupDetailRequest * request =[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo * response) {
        if (response.isInGroup) {
            [self gotoChatGroupControllerWithId:response.groupId groupName:response.name];
            
        }else{
            [self gotoAddGroupViewControllerWithGroupDetailInfo:response inviterId:inviterId];
        }
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
}

-(void)gotoChatGroupControllerWithId:(NSString *)ID groupName:(NSString *)groupName{
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:ID,kchatType:GroupChat,kauthorityType:AuthorityType_friend}];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoAddGroupViewControllerWithGroupDetailInfo:(GroupListInfo *)groupDetailInfo inviterId:(NSString *)inviterId{
    QrScanResultAddRoomController * vc = [QrScanResultAddRoomController new];
    vc.groupDetailInfo = groupDetailInfo;
    vc.inviterId = inviterId;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)receiveMoneyWitString:(NSString*)codeStr{
    NSString*codeStr2=[codeStr componentsSeparatedByString:@"payment/"].lastObject;
    PayQRCodePaymentRequest*request=[PayQRCodePaymentRequest request];
    NSString*code=[codeStr2 componentsSeparatedByString:@"/"].firstObject;
    NSString*userId=[codeStr2 componentsSeparatedByString:@"/"].lastObject;
    request.code=code;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[PayQrcodeInfo class] contentClass:[PayQrcodeInfo class] success:^(PayQrcodeInfo* response) {
        if(response.status == 2 || response.status == 3){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            PaySuccessTipViewController*vc=[PaySuccessTipViewController new];
            vc.isPay=NO;
            vc.userId=userId;
            vc.amountLabel.text=[NSString stringWithFormat:@"￥%.2f",response.money];
            [self.navigationController pushViewController:vc animated:YES];
            [QMUITipsTool showOnlyTextWithMessage:@"Successfully Received".icanlocalized inView:nil];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self startRuning];
    }];
}
@end


