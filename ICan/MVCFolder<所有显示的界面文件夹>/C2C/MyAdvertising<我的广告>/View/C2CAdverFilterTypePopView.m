//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CAdverFilterTypePopView.h"
@interface C2CAdverFilterTypePopView()
@property (weak, nonatomic) IBOutlet UIView *allStateBgView;
@property (weak, nonatomic) IBOutlet UILabel *allStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allStateImgView;
//购买
@property (weak, nonatomic) IBOutlet UIView *putawayStateBgView;
@property (weak, nonatomic) IBOutlet UILabel *putawayStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *putawayStateImgView;
//出售
@property (weak, nonatomic) IBOutlet UIView *soldawayStateBgView;
@property (weak, nonatomic) IBOutlet UILabel *soldawayStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soldawayStateImgView;

@end
@implementation C2CAdverFilterTypePopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap15 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.allStateBgView addGestureRecognizer:tap15];

    UITapGestureRecognizer * tap30 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.putawayStateBgView addGestureRecognizer:tap30];

    UITapGestureRecognizer * tap45 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.soldawayStateBgView addGestureRecognizer:tap45];

//    "C2CAdverFilterTypePopViewAllType"="所有类型";
//    "C2CAdverFilterTypePopViewBuy"="购买";
//    "C2CAdverFilterTypePopViewSale"="出售";
    self.allStateLabel.text = @"C2CAdverFilterTypePopViewAllType".icanlocalized;
    self.putawayStateLabel.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
    self.soldawayStateLabel.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
    self.hidden = YES;
}
-(void)tapAction:(UITapGestureRecognizer*)gest{
    UIView * view = gest.view;
    switch (view.tag) {
        case 100:{
            !self.selectBlock?:self.selectBlock(@"C2CAdverFilterTypePopViewAllType".icanlocalized);
            self.allStateLabel.textColor = UIColorThemeMainColor;
            self.putawayStateLabel.textColor = UIColor252730Color;
            self.soldawayStateLabel.textColor = UIColor252730Color;
            self.allStateImgView.hidden = NO;
            self.putawayStateImgView.hidden = YES;
            self.soldawayStateImgView.hidden = YES;
        }
            
            break;
        case 101:{
            !self.selectBlock?:self.selectBlock(@"C2CAdverFilterTypePopViewBuy".icanlocalized);
            self.allStateLabel.textColor = UIColor252730Color;
            self.putawayStateLabel.textColor = UIColorThemeMainColor;
            self.soldawayStateLabel.textColor = UIColor252730Color;
            self.allStateImgView.hidden = YES;
            self.putawayStateImgView.hidden = NO;
            self.soldawayStateImgView.hidden = YES;
        }
            break;
        case 102:{
            !self.selectBlock?:self.selectBlock(@"C2CAdverFilterTypePopViewSale".icanlocalized);
            self.allStateLabel.textColor = UIColor252730Color;
            self.putawayStateLabel.textColor = UIColor252730Color;
            self.soldawayStateLabel.textColor = UIColorThemeMainColor;
            self.allStateImgView.hidden = YES;
            self.putawayStateImgView.hidden = YES;
            self.soldawayStateImgView.hidden = NO;
        }
            
            break;
    }
    [self hiddenView];
}

-(void)hiddenView{
    self.hidden = YES;
    !self.hiddenBlock?:self.hiddenBlock();
    [self removeFromSuperview];
}
-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end
