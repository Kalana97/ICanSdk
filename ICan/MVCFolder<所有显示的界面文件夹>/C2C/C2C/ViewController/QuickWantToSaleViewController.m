//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  QuickWantToSaleViewController.m
- Description:
- Function List:
*/
        

#import "QuickWantToSaleViewController.h"

@interface QuickWantToSaleViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
//划转
@property (weak, nonatomic) IBOutlet UILabel *transferLabel;
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *textFieldLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *serviceTipsLabel;
@end

@implementation QuickWantToSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.textField layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
   
    self.contentBgView.layer.cornerRadius = 5;
    self.contentBgView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.contentBgView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.contentBgView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.contentBgView.layer.shadowRadius = 5;
}
//划转
- (IBAction)transferAction {
}
//全部
- (IBAction)allAction {
}
//按金额出售
- (IBAction)saleTypeAction {
    
}
//全部
- (IBAction)sureAction {
    
}

@end
