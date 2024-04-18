

//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 3/9/2020
 - File name:  PayMentAgreementView.m
 - Description:
 - Function List:
 */


#import "BindingTipsView.h"
@interface BindingTipsView()
@property(nonatomic, weak) IBOutlet UIStackView *bgView;

@end

@implementation BindingTipsView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.2);
    self.tipsLabel.text=@"Binding Prompt".icanlocalized;
    [self.agreeButton layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    [self.refuseButton setTitle:@"Logout".icanlocalized forState:UIControlStateNormal];
    [self.agreeButton setTitle:@"Go to bind".icanlocalized forState:UIControlStateNormal];
}

- (IBAction)agreeButtonAction:(id)sender {
    self.hidden=YES;
    UserConfigurationInfo*info=[BaseSettingManager sharedManager].userConfigurationInfo;
    info.isAgreePayment=YES;
    [BaseSettingManager sharedManager].userConfigurationInfo=info;
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}

- (IBAction)refuseButtonAction:(id)sender {
    self.hidden = YES;
    if (self.logoutBlock) {
        self.logoutBlock();
    }
}



@end
