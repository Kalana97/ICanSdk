//WebSocketManager 处理收到的消息
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/10/3
- System_Version_MACOS: 10.14
- EasyPay
- File name:  WebSocketManager+HandleMessage.h
- Description:
- Function List: 
- History:
*/
        


#import "WebSocketManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager (HandleMessage)

-(void)didReceiveMessage:(NSString*)message;
/// 处理通过接口拿到的离线消息
/// @param messageOfflineInfo messageOfflineInfo description
-(void)handleMessageOffline:(MessageOfflineInfo*)messageOfflineInfo;
-(NSString *)getPushBodyStr:(ChatModel *)model msgType:(NSString *)msgType;
@end

NS_ASSUME_NONNULL_END
