//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 8/11/2019
 - File name:  SMSCodeButton.m
 - Description:
 - Function List:
 */


#import "SMSCodeButton.h"

@interface SMSCodeButton()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t _timer;
@end

@implementation SMSCodeButton
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font=[UIFont systemFontOfSize:11];
    [self setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = KHeightRatio(17);
    //设置边框的颜
    [self.layer setBorderColor:UIColorThemeMainColor.CGColor];
    //设置边框的粗细
    [self.layer setBorderWidth:1.0];
    [self setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addTarget:self action:@selector(openCount) forControlEvents:UIControlEventTouchUpInside];
}
-(instancetype)init{
    if (self=[super init]) {
        [self setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = KHeightRatio(17);
        //设置边框的颜
        [self.layer setBorderColor:UIColorThemeMainColor.CGColor];
        //设置边框的粗细
        [self.layer setBorderWidth:1.0];
        [self.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [self setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addTarget:self action:@selector(openCount) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)stopTimer{
    if(self._timer){
        dispatch_source_cancel(self._timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
            self.userInteractionEnabled = YES;
            [self setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        });
    }
}
-(void)starTimer{
    __block NSInteger time = 59; //倒计时时间
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self._timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self setTitle:NSLocalizedString(@"Resend",重新发送) forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                [self setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self setTitle:[NSString stringWithFormat:@"%.2dS", seconds] forState:UIControlStateNormal];
                [self setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(self._timer);
}
-(void)openCount{
    
    
}
@end
