//
//  PayMoneyViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
// https://www.jianshu.com/p/0af420d6345d循环引用

#import "PayMoneyViewController.h"
#import "PaySuccessTipView.h"
#import "PaySuccessTipViewController.h"
#import "ReceiptMoneyViewController.h"
#import "ChatModel.h"
@interface PayMoneyViewController ()<WebSocketManagerDelegate>
@property(nonatomic, strong) NSTimer*timer;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic, weak) IBOutlet UIView *bgContView;
@property(nonatomic, weak) IBOutlet UIView *topView;

@property(nonatomic, weak) IBOutlet UILabel *topTipsLabel;
@property(weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic, weak) IBOutlet UIControl *bottomViewControl;
@property(nonatomic, weak) IBOutlet UILabel *bottomTipsLabel;


@property(nonatomic, weak) IBOutlet UIControl *toReceiptControl;
@property(nonatomic, weak) IBOutlet UILabel *toReceiptLabel;

@property(nonatomic, weak) IBOutlet UIImageView *qrCodeImageView;
@end

@implementation PayMoneyViewController
-(void)dealloc{
    [self.timer invalidate];
    self.timer=nil;
    DDLogInfo(@"%s",__func__);
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorThemeMainColor;
    self.nameLabel.text=NSLocalizedString(@"payment", 付款);;
    [self getReceiptCodeRequest];
    [WebSocketManager sharedManager].delegate = self;
    [self startTimer];
    self.topTipsLabel.text=@"QR Code Payment".icanlocalized;
    self.bottomTipsLabel.text=@"Balance payment".icanlocalized;
    self.toReceiptLabel.text=@"QRCodeCollection".icanlocalized;
    [self.bgContView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    [self.toReceiptControl layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
   
    int minutes=self.info.receiptCodeExpirationTime/60;
    if (BaseSettingManager.isChinaLanguages) {
       self.tipsLabel.text=[NSString stringWithFormat:@"%@%d%@%@",@"PaymentCode".icanlocalized,minutes,@"minutes".icanlocalized,@"validFor".icanlocalized];
    }else{
        self.tipsLabel.text=[NSString stringWithFormat:@"%@%@%d%@",@"PaymentCode".icanlocalized,@"validFor".icanlocalized,minutes,@"minutes".icanlocalized];
    }
}
- (IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toreceiptAction:(id)sender {
    [[AppDelegate shared]pushViewController:[ReceiptMoneyViewController new] animated:YES];
}

-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if ([chatModel.messageType isEqualToString:Notice_PayQRType]) {
         Notice_PayQRInfo*info=[Notice_PayQRInfo mj_objectWithKeyValues:chatModel.messageContent];
        //这个是收到对方扫描你的付款二维码之后 你收到的信息
        if ([info.qrCodeType isEqualToString:@"payment"]) {
            PaySuccessTipViewController*vc=[PaySuccessTipViewController new];
            vc.isPay=YES;
            vc.userId=[NSString stringWithFormat:@"%zd",info.userId];
            vc.amountLabel.text=[NSString stringWithFormat:@"￥%.2f",info.money];
            [self.navigationController pushViewController:vc animated:YES];
            [QMUITipsTool showOnlyTextWithMessage:@"Payment successful".icanlocalized inView:nil];
        }
    }
}
/** 获取付款码的code */
-(void)getReceiptCodeRequest{
    GetCodeRequest*request=[GetCodeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/payQRCode/payment"];
    request.isHttpResponse=YES;
    request.money=self.amount;
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
            NSString* qrcode=[[BaseRequest request].baseUrlString stringByAppendingFormat:@"/q/payment/%@/%@",response,[UserInfoManager sharedManager].userId];
            UIImage*qrImage=[UIImage dm_QRImageWithString:qrcode size:ScreenWidth-80];
            self.qrCodeImageView.image=qrImage;
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)startTimer{
    if (self.info.receiptCodeExpirationTime>0) {
        @weakify(self);
        self.timer=[NSTimer scheduledTimerWithTimeInterval:self.info.receiptCodeExpirationTime repeats:YES block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self getReceiptCodeRequest];
        }];
    }else{
        @weakify(self);
        self.timer=[NSTimer scheduledTimerWithTimeInterval:120 repeats:YES block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self getReceiptCodeRequest];
        }];
    }
    
    
}
@end
