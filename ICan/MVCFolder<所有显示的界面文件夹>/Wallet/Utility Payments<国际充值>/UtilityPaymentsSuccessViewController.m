//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/4/2021
 - File name:  UtilityPaymentsSuccessViewController.m
 - Description:
 - Function List:
 */


#import "UtilityPaymentsSuccessViewController.h"
#import "UIViewController+Extension.h"
#import "ShowUtilityFavoritesView.h"
@interface UtilityPaymentsSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLbl;
@property(nonatomic, strong) ShowUtilityFavoritesView *favoritesView;
@end

@implementation UtilityPaymentsSuccessViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"UtilityPaymentsPayViewController",@"SelectPayWayViewController",@"Select43PayWayViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //如果不是从收藏夹并且需要判断
    if (!self.isFromFavorite&&self.shouldCheck) {
        //判断该Dialog充值号码是否在收藏夹内
        CheckDialogFavoritesRequest*request=[CheckDialogFavoritesRequest request];
        if (self.isFromFavorite) {
            request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.dialogId,self.mobile];
        }else{
            request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.ID,self.mobile];
        }
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
            if ([response isEqualToString:@"false"]) {
                self.favoritesView=[[NSBundle mainBundle]loadNibNamed:@"ShowUtilityFavoritesView" owner:self options:nil].firstObject;
                self.favoritesView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.favoritesView.info=self.dialogInfo;
                [self.favoritesView showFavoritesView];
                @weakify(self);
                self.favoritesView.sureBlock = ^{
                    @strongify(self);
                    if (self.favoritesView.nameTextField.text.trimmingwhitespaceAndNewline.length==0) {
                        [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsPayViewController.tipError".icanlocalized inView:self.view];
                        return;
                    }
                    PostDialogFavoritesRequest*request=[PostDialogFavoritesRequest request];
                    request.dialogId=self.dialogInfo.ID;
                    request.nickname=self.favoritesView.nameTextField.text;
                    request.accountNumber=self.mobile;
                    request.parameters=[request mj_JSONObject];
                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                        [self.favoritesView hiddenFavoritesView];
                        [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
                        [QMUITips showSucceed:@"AddSuccess".icanlocalized inView:self.view];
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                    }];
                };
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }
//    [self.detailButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
//    [self.detailButton setTitle:@"View Details".icanlocalized forState:UIControlStateNormal];
    if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]){
        NSNumberFormatter *formatterConvert = [[NSNumberFormatter alloc] init];
        formatterConvert.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *convertedVal = [formatterConvert numberFromString:self.selectChannelInfo.convertedAmount];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 20;
        NSString *result = [formatter stringFromNumber:convertedVal];
        if([self.selectChannelInfo.acceptedCurrencyCode isEqualToString:@"USDT"]){
            self.moneyLabel.text = [NSString stringWithFormat:@"₮ %@",result];
        }else{
            self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",self.selectChannelInfo.acceptedCurrencyCode,result];
        }
    }else{
        self.moneyLabel.text=[NSString stringWithFormat:@"%@ %@.00",self.selectChannelInfo.acceptedCurrencyCode,self.selectChannelInfo.convertedAmount];
    }
}
- (IBAction)backControAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}

-(void)setupUI{
    if(self.isStatusPending == YES){
        self.statusTitleLbl.text= @"ProcessingRecharge".icanlocalized;
        self.logoIcon.image = [UIImage imageNamed:@"processing_icon"];
        self.tipsLabel.text = @"Processingpaymentrequest".icanlocalized;
    }else{
        self.statusTitleLbl.text=@"Success".icanlocalized;
        self.logoIcon.image = [UIImage imageNamed:@"Success"];
        self.tipsLabel.text = @"Transaction successful".icanlocalized;
    }
}
@end
