
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayFooterView.m
- Description:
- Function List:
*/
        

#import "Select43PayWayFooterView.h"

@interface Select43PayWayFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UILabel *fitstLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@end

@implementation Select43PayWayFooterView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorViewBgColor;
//    "Select43PayWayFooterView.payBtn"="支付";
//    "Select43PayWayFooterView.clearBtn"="清除快捷";
//    "Select43PayWayFooterView.fitstLabel"="*卡号支付：不保存卡号等相关信息";
//    "Select43PayWayFooterView.twoLabel"="*清除快捷：将清除之前的快捷支付";
    [self.payBtn layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    [self.clearBtn layerWithCornerRadius:45/2 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self.payBtn setTitle:@"Select43PayWayFooterView.payBtn".icanlocalized forState:UIControlStateNormal];
    [self.clearBtn setTitle:@"Select43PayWayFooterView.clearBtn".icanlocalized forState:UIControlStateNormal];
    self.fitstLabel.text=@"Select43PayWayFooterView.fitstLabel".icanlocalized;
    self.twoLabel.text=@"Select43PayWayFooterView.twoLabel".icanlocalized;
    self.fitstLabel.textColor= UIColorThemeMainSubTitleColor;

}
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

- (IBAction)payAction:(id)sender {
    !self.payBlock?:self.payBlock();
}
- (IBAction)clearAction:(id)sender {
    !self.clearBlock?:self.clearBlock();
}
@end
