
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/7/2021
- File name:  SelectPayWayHeadView.m
- Description:
- Function List:
*/
        

#import "SelectPayWayHeadView.h"

@interface SelectPayWayHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;
@property (weak, nonatomic) IBOutlet UILabel *wayLbl;

@end

@implementation SelectPayWayHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
//    "SelectPayWayViewController.tipsLabel"="支付方式";
    self.wayLbl.text=@"SelectPayWayViewController.tipsLabel".icanlocalized;
}

@end
