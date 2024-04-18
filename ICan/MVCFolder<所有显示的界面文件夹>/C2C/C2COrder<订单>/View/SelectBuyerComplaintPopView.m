//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 6/4/2022
 - File name:  SelectBuyerComplaintPopView.m
 - Description:
 - Function List:
 */


#import "SelectBuyerComplaintPopView.h"
#import "UIView+Nib.h"
@interface SelectBuyerComplaintPopView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIControl *reasonOneBgCon;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab1;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab2;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab3;
@end
@implementation SelectBuyerComplaintPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reasonOneAction:)];
    [self.reasonOneBgCon addGestureRecognizer:tap];
    self.titleLab.text = @"ReasonForAppeal".icanlocalized;
    self.reasonLab1.text = @"A1000000001".icanlocalized;
    self.reasonLab2.text = @"A1000000002".icanlocalized;
    self.reasonLab3.text = @"A1000000003".icanlocalized;
    
//    "A2000000001"="我收到来自买方的款项，但是金额不正确";
//    "A2000000002"="未收到款项";
//    "A2000000003"="我收到的款项来自第三方的账户";

}
-(void)setIsSeller:(BOOL)isSeller{
    _isSeller = isSeller;
    self.reasonLab1.text = @"A2000000001".icanlocalized;
    self.reasonLab2.text = @"A2000000002".icanlocalized;
    self.reasonLab3.text = @"A2000000003".icanlocalized;
}

-(void)hiddenView{
    [self removeFromSuperview];
}
+(instancetype)showBuyerComplaintView{
    SelectBuyerComplaintPopView *qRCodePopView = [SelectBuyerComplaintPopView loadFromNibWithFrame:[UIScreen mainScreen].bounds];
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:qRCodePopView];
    return qRCodePopView;
}
//"A1000000001"="我已付款，卖家未放行";
//"A1000000002"="我向卖家多付了钱";
//"A1000000003"="卖家涉嫌诈骗";
- (IBAction)reasonOneAction:(id)sender {
    !self.tapBblock?:self.tapBblock(self.isSeller?@"A2000000001":@"A1000000001");
    [self hiddenView];
}
- (IBAction)reasonTwoAction:(id)sender {
    !self.tapBblock?:self.tapBblock(self.isSeller?@"A2000000002":@"A1000000002");
    [self hiddenView];
}
- (IBAction)reasonThreeAction:(id)sender {
    !self.tapBblock?:self.tapBblock(self.isSeller?@"A2000000003":@"A1000000003");
    [self hiddenView];
}

@end

