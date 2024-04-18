//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/21
- System_Version_MACOS: 10.14
- EasyPay
- File name:  QMUIAlertControllerTool.m
- Description:
- Function List: 
- History:
*/
        

#import "QMUIAlertControllerTool.h"

@implementation QMUIAlertControllerTool
+(void)alertControllerToolWithMessage:(NSString *)message title:(NSString *)title style:(QMUIAlertControllerStyle)style titles:(NSArray *)titles block:(void (^)(NSInteger))block{
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    int i = 0;
    
    for (NSString *actionTitle in titles) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:actionTitle style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            block(i);
        }];
        
        [alertController addAction:action1];
        
        i++;
    }
    [alertController showWithAnimated:YES];
}
@end
