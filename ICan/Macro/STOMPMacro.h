//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/10
- System_Version_MACOS: 10.14
- EasyPay
- File name:  STOMPMacro.h
- Description: 用来宏定义一系列的订阅关系
- Function List: 
- History:
*/
        

#ifndef STOMPMacro_h
#define STOMPMacro_h

//收到单聊消息
#define RecivePersonMessage @"/user/topic/person"
//发送单聊消息
#define SendPersonMessage  @"/app/chat.send2user"
//发送群聊消息
#define SendGroupMessage   @"/app/chat.send2group"
//收到的群聊消息
#define ReciveGroupMessage @"/user/topic/send2group"

#endif /* STOMPMacro_h */
