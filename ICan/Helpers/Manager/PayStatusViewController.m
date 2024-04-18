
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/6/2021
- File name:  PayStatusViewController.m
- Description:
- Function List:
*/
        

#import "PayStatusViewController.h"

@interface PayStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation PayStatusViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.status==1) {
        self.titleLabel.text=@"payment successful".icanlocalized;
    }else{
        self.titleLabel.text=@"CircleUserDetailViewController.payFailTip".icanlocalized;
    }
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",self.detailInfo.amount.doubleValue];
    [self.btn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.btn setTitle:@"Returntobusiness".icanlocalized forState:UIControlStateNormal];
}
#pragma mark - Private
- (IBAction)backAction {
    NSURL*url=[NSURL URLWithString:self.backUrl.netUrlEncoded];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
@end
