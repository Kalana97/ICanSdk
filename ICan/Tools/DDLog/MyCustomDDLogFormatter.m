//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/9
- System_Version_MACOS: 10.14
- EasyPay
- File name:  MyCustomDDLogFormatter.m
- Description:
- Function List: 
- History:
*/
        

#import "MyCustomDDLogFormatter.h"
#import "DDDispatchQueueLogFormatter.h"
static NSString * dateFormatString=@"yyyy-MM-dd HH:mm:ss";
@interface MyCustomDDLogFormatter (){
    DDAtomicCounter *atomicLoggerCounter;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end

@implementation MyCustomDDLogFormatter
- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = [atomicLoggerCounter value];
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:dateFormatString];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    NSString *logMsg = [NSString stringWithFormat:@" %@ | %@ (第%ld行)| %@",logMessage.queueLabel,logMessage->_function,logMessage.line,logMessage->_message];
    
    return [NSString stringWithFormat:@"%@ %@ | \n%@",dateAndTime, logLevel,logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    [atomicLoggerCounter increment];
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    [atomicLoggerCounter decrement];
}
@end
