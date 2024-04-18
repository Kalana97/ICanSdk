//
//  PopupView.m
//  ICan
//
//  Created by Kalana Rathnayaka on 28/02/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=UIColorMakeWithRGBA(27, 25, 39, 0.8);
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}
-(void)tap{
    [self hiddenQRCodeView];
}
-(void)showQRCodeView{
    
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
   
}
-(void)hiddenQRCodeView{
    [self removeFromSuperview];
}

@end
