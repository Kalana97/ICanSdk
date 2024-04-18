//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/3/2021
- File name:  SurePayMessageViewController.m
- Description:
- Function List:
*/
        

#import "SurePayMessageViewController.h"

@interface SurePayMessageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *applogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong ,nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *icanMallLabel;
//收款方
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@end

@implementation SurePayMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorBg243Color;
    self.title=@"SurePayMessageViewController.title".icanlocalized;
    [self.applogoImageView layerWithCornerRadius:50 borderWidth:0 borderColor:nil];
    [self.sureButton layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
    self.icanMallLabel.text=self.detailInfo.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self getAmountConvert:self.detailInfo.amount]];
    [self.cancelBtn setTitle:@"SurePayMessageViewControllercancelBtn".icanlocalized forState:UIControlStateNormal];
    [self.sureButton setTitle:@"SurePayMessageViewControllersureButton".icanlocalized forState:UIControlStateNormal];
    self.receiveLabel.text = @"SurePayMessageViewControllerreceiveLabel".icanlocalized;
}

-(NSString *)getAmountConvert:(NSString *)amountValue{
    NSNumberFormatter *formatterConvert = [[NSNumberFormatter alloc] init];
    formatterConvert.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *convertedVal = [formatterConvert numberFromString:amountValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 8;
    formatter.minimumFractionDigits = 2;
    NSString *result = [formatter stringFromNumber:convertedVal];
    return result;
}


- (IBAction)sureButtonAction {
    !self.payBlock?:self.payBlock();
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setFrame:(CGRectMake(0, 0, 50, 30))];
        [_cancelBtn setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _cancelBtn;
}
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
}
@end
