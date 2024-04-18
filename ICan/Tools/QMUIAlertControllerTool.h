//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/21
- System_Version_MACOS: 10.14
- EasyPay
- File name:  QMUIAlertControllerTool.h
- Description:
- Function List: 
- History:
*/
        
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMUIAlertControllerTool : NSObject
+(void)alertControllerToolWithMessage:(NSString*)message title:(NSString*)title style:(QMUIAlertControllerStyle)style titles:(NSArray*)titles block:(void(^)(NSInteger index))block;;
@end

NS_ASSUME_NONNULL_END
