//
//  AddSucessViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "AddSucessViewController.h"
#import "AddBankCardViewController.h"
#import "BindingAlipayViewController.h"
#import "UIViewController+Extension.h"
@interface AddSucessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *sucessLabel;

@end

@implementation AddSucessViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"BindingAlipayViewController",@"AddBankCardViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"BindingSuccess",绑定成功);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.iconImageView setImage:UIImageMake(@"img_addbankcard_placeholder")];
    if (BaseSettingManager.isChinaLanguages) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"~ 您已绑定成功啦 ~"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:16.0f] range:NSMakeRange(0, 6)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 6)];

        // text-style1
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:16.0f] range:NSMakeRange(6, 2)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:60.0f/255.0f green:118.0f/255.0f blue:233.0f/255.0f alpha:1.0f] range:NSMakeRange(6, 2)];
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:16.0f] range:NSMakeRange(8, 3)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] range:NSMakeRange(8, 3)];
        
        self.sucessLabel.attributedText = attributedString;
    }else{
        self.sucessLabel.text = @"Bank card binding success";
    }
    
    

    
}

-(void)back{
    !self.addSucessBlock?:self.addSucessBlock();
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
