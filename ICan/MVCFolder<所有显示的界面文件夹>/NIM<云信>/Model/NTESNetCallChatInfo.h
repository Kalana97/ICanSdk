//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 16/4/2020
- File name:  NTESNetCallChatInfo.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESNetCallChatInfo : NSObject
/** 发起者账号
 */
@property(nonatomic,strong) NSString *caller;
/**
 被呼叫者的账号
 */
@property(nonatomic,strong) NSString *callee;
/**
 当前的通话ID
 */
@property(nonatomic,assign) UInt64 callID;
/** 当前的会话类型
 */
//@property(nonatomic,assign) NIMNetCallMediaType callType;

@property(nonatomic,assign) NSTimeInterval startTime;
/** 是否开始
 */
@property(nonatomic,assign) BOOL isStart;
/** 是否静音
 */
@property(nonatomic,assign) BOOL isMute;
/** 是否开启扬声器
 */
@property(nonatomic,assign) BOOL useSpeaker;

@property(nonatomic,assign) BOOL disableCammera;

@property(nonatomic,assign) BOOL localRecording;

@property(nonatomic,assign) BOOL otherSideRecording;

@property(nonatomic,assign) BOOL audioConversation;
@property(nonatomic, assign) BOOL isSuccessEstablished;
@property(nonatomic, copy) NSString *headImg;
@property(nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
