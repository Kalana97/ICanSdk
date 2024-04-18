//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 6/4/2022
- File name:  C2CBuyerQuestionViewController.m
- Description:
- Function List:
*/
        

#import "C2CBuyerQuestionViewController.h"
#import "C2COrderDetailViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "C2CCancelOrderViewController.h"
@interface C2CBuyerQuestionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *questionALab;
@property (weak, nonatomic) IBOutlet UILabel *answerALab;

@property (weak, nonatomic) IBOutlet UILabel *questionBLab;
@property (weak, nonatomic) IBOutlet UILabel *answerBLab;

@property (weak, nonatomic) IBOutlet UILabel *questionCLab;
@property (weak, nonatomic) IBOutlet UILabel *answerCLab;

@property (weak, nonatomic) IBOutlet UILabel *questionDLab;
@property (weak, nonatomic) IBOutlet UILabel *answerDLab;

@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation C2CBuyerQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"C2CProblempayment".icanlocalized;
    self.questionALab.text = @"C2CQuestion1".icanlocalized;
    self.answerALab.text = @"C2CQuestion1Answer".icanlocalized;
    self.questionBLab.text = @"C2CQuestion2".icanlocalized;
    self.answerBLab.text = @"C2CQuestion2Answer".icanlocalized;
    self.questionCLab.text = @"C2CQuestion3".icanlocalized;
    self.answerCLab.text = @"C2CQuestion3Answer".icanlocalized;
    self.questionDLab.text = @"C2CQuestion4".icanlocalized;
    self.answerDLab.text = @"C2CQuestion4Answer".icanlocalized;
    
    [self.contactBtn setTitle:@"C2CPaymentViewControllerRelationLabel".icanlocalized forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"C2CCancelOrderViewControllerTitle".icanlocalized forState:UIControlStateNormal];
    [self.cancelBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self starTimer];
   
}
-(void)starTimer{
    NSTimeInterval currenTime = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval creatTime = self.orderInfo.createTime.integerValue;
    __block NSTimeInterval time =self.orderInfo.payCancelTime*60- (currenTime-creatTime)/1000;
    if (currenTime-creatTime>self.orderInfo.payCancelTime*60*1000) {
        self.timeLab.hidden = YES;
        //设置按钮的样式
        C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
        vc.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLab.hidden = YES;
                    C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                    vc.orderInfo = self.orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
//                请在16:15内付款给卖家
                    if (BaseSettingManager.isChinaLanguages) {
                        NSString * timeStr = [self setTimeLabelWith:time];
                        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请在%@内付款给卖家",timeStr]];
                        [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(2, timeStr.length)];
                        self.timeLab.attributedText = att;
                    }else{
                        NSString * timeStr = [self setTimeLabelWith:time];
                        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Please pay the seller within %@",timeStr]];
                        [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(att.length-timeStr.length, timeStr.length)];
                        self.timeLab.attributedText = att;
                    }
                    
                });
                time--;
            }
        });
        dispatch_resume(_timer);
    }
}
-(NSString*)setTimeLabelWith:(NSInteger)second{
    if (second<60) {
        return [NSString stringWithFormat:@"%.2ld",second];
    }else if (60<=second&&second<3600){
        return [NSString stringWithFormat:@"%.2ld:%.2ld",second/60,second%60];
    }
    NSInteger hour = second/3600;
    NSInteger minute = second/60%60;
    NSInteger seconds = second%60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,seconds];
}
- (IBAction)contachSellAction {
    //如果购买的人和自己是同一个人
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.sellUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.sellUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.buyUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.buyUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)cancelAction {
    C2CCancelOrderViewController * vc = [C2CCancelOrderViewController new];
    vc.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
