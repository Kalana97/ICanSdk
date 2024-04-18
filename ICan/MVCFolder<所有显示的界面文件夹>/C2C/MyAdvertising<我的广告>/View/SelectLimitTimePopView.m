//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "SelectLimitTimePopView.h"
@interface SelectLimitTimePopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *minute15BgView;
@property (weak, nonatomic) IBOutlet UILabel *minute15Label;

@property (weak, nonatomic) IBOutlet UIView *minute30BgView;
@property (weak, nonatomic) IBOutlet UILabel *minute30Label;

@property (weak, nonatomic) IBOutlet UIView *minute45BgView;
@property (weak, nonatomic) IBOutlet UILabel *minute45Label;

@property (weak, nonatomic) IBOutlet UIView *minute60BgView;
@property (weak, nonatomic) IBOutlet UILabel *minute60Label;

@property (weak, nonatomic) IBOutlet UIView *minute120BgView;
@property (weak, nonatomic) IBOutlet UILabel *minute120Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
@implementation SelectLimitTimePopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.text = @"PaymentTimeLimit".icanlocalized;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap15 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.minute15BgView addGestureRecognizer:tap15];
   
    UITapGestureRecognizer * tap30 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.minute30BgView addGestureRecognizer:tap30];
    
    UITapGestureRecognizer * tap45 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.minute45BgView addGestureRecognizer:tap45];
    UITapGestureRecognizer * tap60 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.minute60BgView addGestureRecognizer:tap60];
    
    UITapGestureRecognizer * tap120 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.minute120BgView addGestureRecognizer:tap120];
    
    self.minute15Label.textColor = UIColorThemeMainColor;
    self.minute30Label.textColor = UIColor102Color;
    self.minute45Label.textColor = UIColor102Color;
    self.minute60Label.textColor = UIColor102Color;
    self.minute120Label.textColor = UIColor102Color;
    self.minute15Label.text = @"15Minutes".icanlocalized;
    self.minute30Label.text = @"30Minutes".icanlocalized;
    self.minute45Label.text = @"60Minutes".icanlocalized;
    self.minute60Label.text = @"720Minutes".icanlocalized;
    self.minute120Label.text = @"1440Minutes".icanlocalized;
    
}
-(void)tapAction:(UITapGestureRecognizer*)gest{
    UIView * view = gest.view;
    switch (view.tag) {
        case 100:{
            !self.selectBlock?:self.selectBlock(@"15Minutes".icanlocalized);
            self.minute15Label.textColor = UIColorThemeMainColor;
            self.minute30Label.textColor = UIColor102Color;
            self.minute45Label.textColor = UIColor102Color;
            self.minute60Label.textColor = UIColor102Color;
            self.minute120Label.textColor = UIColor102Color;
        }
            
            break;
        case 101:{
            !self.selectBlock?:self.selectBlock(@"30Minutes".icanlocalized);
            self.minute15Label.textColor = UIColor102Color;
            self.minute30Label.textColor = UIColorThemeMainColor;
            self.minute45Label.textColor = UIColor102Color;
            self.minute60Label.textColor = UIColor102Color;
            self.minute120Label.textColor = UIColor102Color;
        }
            
            break;
        case 102:{
            !self.selectBlock?:self.selectBlock(@"60Minutes".icanlocalized);
            self.minute15Label.textColor = UIColor102Color;
            self.minute30Label.textColor = UIColor102Color;
            self.minute45Label.textColor = UIColorThemeMainColor;
            self.minute60Label.textColor = UIColor102Color;
            self.minute120Label.textColor = UIColor102Color;
        }
            
            break;
        case 103:{
            !self.selectBlock?:self.selectBlock(@"720Minutes".icanlocalized);
            self.minute15Label.textColor = UIColor102Color;
            self.minute30Label.textColor = UIColor102Color;
            self.minute45Label.textColor = UIColor102Color;
            self.minute60Label.textColor = UIColorThemeMainColor;
            self.minute120Label.textColor = UIColor102Color;
        }
            
            break;
        case 104:{
            !self.selectBlock?:self.selectBlock(@"1440Minutes".icanlocalized);
            self.minute15Label.textColor = UIColor102Color;
            self.minute30Label.textColor = UIColor102Color;
            self.minute45Label.textColor = UIColor102Color;
            self.minute60Label.textColor = UIColor102Color;
            self.minute120Label.textColor = UIColorThemeMainColor;
        }
            
            break;
        default:
            break;
    }
    [self hiddenView];
}

-(void)hiddenView{
    self.bottomConstraint.constant = -380;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
        [self layoutIfNeeded];
    }];
}
@end
