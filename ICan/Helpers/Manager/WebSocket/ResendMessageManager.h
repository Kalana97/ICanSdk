//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/11/2020
- File name:  ResendMessageManager.h
- Description:用来处理消息重发
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResendMessageManager : NSObject
/**
 当前正在发送中的消息
 */
@property(nonatomic, strong) NSMutableArray *currentSendingMsgs;
@property(nonatomic, strong) NSMutableArray *currentSendingFailedMsgs;
-(void)startResendMessage;
+(instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
