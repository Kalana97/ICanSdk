//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/4/2021
- File name:  UtilityPaymentsFailViewController.m
- Description:
- Function List:
*/
        

#import "UtilityPaymentsFailViewController.h"

@interface UtilityPaymentsFailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStatusTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@end

@implementation UtilityPaymentsFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payStatusTitleLbl.text=@"fail".icanlocalized;
    if([self.selectChannelInfo.payType  isEqual: @"balance"]||[self.selectChannelInfo.payType  isEqual: @"CryptoPay"]){
        self.amountLbl.text = [NSString stringWithFormat:@"%@ %@",self.selectChannelInfo.acceptedCurrencyCode,self.selectChannelInfo.convertedAmount];
    }else{
        self.amountLbl.text = [NSString stringWithFormat:@"%@ %@.00",self.selectChannelInfo.acceptedCurrencyCode,self.selectChannelInfo.convertedAmount];
    }
    self.tipsLabel.text = @"Network Transfer Failed".icanlocalized;
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
