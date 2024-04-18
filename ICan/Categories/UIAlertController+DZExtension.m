//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/3
- ICan
- File name:  UIAlertController+DZExtension.m
- Description:
- Function List:
*/
        

#import "UIAlertController+DZExtension.h"
#import "AppDelegate+DZExtension.h"


@implementation UIAlertController (DZExtension)
static ActionBlock _actionBlock;

+ (UIAlertController *)alertCTWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)titles handler:(ActionBlock)handler {
    
    _actionBlock = [handler copy];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(preferredStyle)];

    
    int i = 0;
    
    for (NSString *actionTitle in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (_actionBlock) {
                _actionBlock(i);
                _actionBlock = nil;
            }
        }];
        
        [alert addAction:action];
        
        i++;
    }
 
    return alert;
}


+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message target:(id)target preferredStyle:(UIAlertControllerStyle)preferredStyle actionTitles:(NSArray *)titles handler:(ActionBlock)handler {
    
    _actionBlock = [handler copy];
    
    if (!message || [message isEqual:[NSNull null]]) {
        message = @"";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(preferredStyle)];
    
    int i = 0;
    
    for (NSString *actionTitle in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if (_actionBlock) {
                _actionBlock(i);
                _actionBlock = nil;
            }
        }];
        
        [alert addAction:action];
        
        i++;
    }
    
    dispatch_main_async_safe(^{
         [[AppDelegate shared]presentViewController:alert animated:YES completion:^{
                   
               }];
        
    });
    
}



@end
