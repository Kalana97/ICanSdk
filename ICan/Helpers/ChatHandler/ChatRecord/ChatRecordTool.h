//
//  ChatRecordTool.h
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/18.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ChatRecordToolDelegate <NSObject>


- (void)endConvertWithData:(NSData *)voiceData seconds:(NSTimeInterval)time localPath:(NSString*)localPath;

@end
@interface ChatRecordTool : NSObject
@property(nonatomic, weak) id <ChatRecordToolDelegate> delegate;
@property(nonatomic, assign) BOOL beginRecoder;
//初始化录音蒙板
+ (instancetype)chatRecordTool;
//开始录音
- (void)beginRecord;
//取消录音
- (void)cancelRecord;
- (void)stopRecord;
//手指移开录音按钮
- (void)moveOut;
//继续录制
- (void)continueRecord;

@end
