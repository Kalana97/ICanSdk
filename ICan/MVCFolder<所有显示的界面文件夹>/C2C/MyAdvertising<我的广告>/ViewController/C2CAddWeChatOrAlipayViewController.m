//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CAddBankCardViewController.m
- Description:
- Function List:
*/
        

#import "C2CAddWeChatOrAlipayViewController.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "C2COssWrapper.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CAddWeChatOrAlipayViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UILabel *receiveQRCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(nonatomic, copy) NSString *qrCodeUrl;
@end

@implementation C2CAddWeChatOrAlipayViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    "C2CBankCard"="银行卡";
//    "C2CWeChat"="微信";
//    "C2CAlipay"="支付宝";
    self.title = self.isWeChat?@"C2CAddWeChatOrAlipayViewControllerWechat".icanlocalized:@"C2CAddWeChatOrAlipayViewControllerAlipay".icanlocalized;
    self.nameLabel.text = @"C2CAddWeChatOrAlipayViewControllerNameLabel".icanlocalized;
    if (self.isWeChat) {
        self.accountLabel.text = @"C2CAddWeChatOrAlipayViewControllerWechatAccountLabel".icanlocalized;
        self.accountTextField.placeholder = @"C2CAddWeChatOrAlipayViewControllerWechatAccountTextField".icanlocalized;
    }else{
        self.accountLabel.text = @"C2CAddWeChatOrAlipayViewControllerAlipayAccountLabel".icanlocalized;
        self.accountTextField.placeholder = @"C2CAddWeChatOrAlipayViewControllerAlipayAccountTextField".icanlocalized;
    }
   
    self.receiveQRCodeLabel.text = @"C2CAddWeChatOrAlipayViewControllerReceiveQRCodeLabel".icanlocalized;
    self.uploadLabel.text = @"C2CAddWeChatOrAlipayViewControllerUploadLabel".icanlocalized;
    self.tipsLabel.text = @"C2CAddWeChatOrAlipayViewControllerTipsLabel".icanlocalized;
    [self.sureButton setTitle:@"C2CAddWeChatOrAlipayViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    self.deleteBtn.hidden = YES;
    self.sureButton.enabled = NO;
    RAC(self.sureButton,enabled)=[RACSignal combineLatest:@[
        self.nameTextField.rac_textSignal,
        self.accountTextField.rac_textSignal,
        ]reduce:^(NSString *name, NSString *account) {
        return @((name.length>0)&&account.length>0);
    }];
    [RACObserve(self, self.sureButton.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureButton.backgroundColor=UIColorThemeMainColor;
            [self.sureButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureButton.backgroundColor=UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.nameTextField.text = UserInfoManager.sharedManager.realname;
}
-(IBAction)sureButtonAction{
    C2CAddPaymentMethodRequest * request = [C2CAddPaymentMethodRequest request];
    if (self.isWeChat) {
        request.paymentMethodType = @"Wechat";
    }else{
        request.paymentMethodType = @"AliPay";
    }
    request.name = self.nameTextField.text;
    request.account = self.accountTextField.text;
    if (self.qrCodeUrl) {
        request.qrCode = self.qrCodeUrl;
    }
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddSuccess".icanlocalized inView:nil];
        !self.addSuccessBlock?:self.addSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
- (IBAction)deleteAction {
    self.qrCodeUrl = nil;
    self.qrCodeImageView.image = nil;
    self.deleteBtn.hidden = YES;
    self.uploadLabel.hidden = self.uploadImageView.hidden = NO;
}

- (IBAction)addQrCodeAction {
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:NO pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.deleteBtn.hidden = NO;
            self.uploadLabel.hidden = self.uploadImageView.hidden = YES;
            self.qrCodeImageView.image = photos.firstObject;
            [self setHeadPicWithImage:photos.firstObject];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
}
-(void)setHeadPicWithImage:(UIImage*)image{
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[C2COssWrapper shared]uploadImage:image successHandler:^(NSString * _Nonnull imgModels) {
        self.qrCodeUrl = imgModels;
        [QMUITips hideAllTips];
    }];
    
}
@end
