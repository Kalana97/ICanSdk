//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 7/4/2022
- File name:  C2CComplaintTipView.m
- Description:
- Function List:
*/
        

#import "C2CComplaintTipView.h"
#import "UIView+Nib.h"
@interface C2CComplaintTipView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab2;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab3;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@end
@implementation C2CComplaintTipView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLab.text = @"WarmReminder".icanlocalized;
    self.tipsLab1.text = @"C2CComplaintTips1".icanlocalized;
    self.tipsLab2.text = @"C2CComplaintTips2".icanlocalized;
    self.tipsLab3.text = @"C2CComplaintTips3".icanlocalized;
    [self.knowBtn setTitle:@"Iknow".icanlocalized forState:UIControlStateNormal];
    [self.knowBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    
}
- (IBAction)knowBtnAction {
    [self hiddenView];
}
-(void)hiddenView{
    [self removeFromSuperview];
}
+(instancetype)showC2CComplaintTipView{
    C2CComplaintTipView *qRCodePopView = [C2CComplaintTipView loadFromNibWithFrame:[UIScreen mainScreen].bounds];
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:qRCodePopView];
    return qRCodePopView;
}


@end
