//
//  GetTime.h
//  HaoYuanQu
//
//  Created by gd on 16/6/30.
//  Copyright © 2016年 HaoYuanQu. All rights reserved.
//
/*
 [dateStringFormatter setDateFormat:@"y"]; // 2017
 [dateStringFormatter setDateFormat:@"yy"]; // 17
 [dateStringFormatter setDateFormat:@"yyy"]; // 2017
 [dateStringFormatter setDateFormat:@"yyyy"]; // 2017

 [dateStringFormatter setDateFormat:@"M"]; // 8
 [dateStringFormatter setDateFormat:@"MM"]; // 08
 [dateStringFormatter setDateFormat:@"MMM"]; // 8月
 [dateStringFormatter setDateFormat:@"MMMM"]; // 八月

 [dateStringFormatter setDateFormat:@"d"]; // 3
 [dateStringFormatter setDateFormat:@"dd"]; // 03
 [dateStringFormatter setDateFormat:@"D"]; // 215,一年中的第几天

 [dateStringFormatter setDateFormat:@"h"]; // 4
 [dateStringFormatter setDateFormat:@"hh"]; // 04
 [dateStringFormatter setDateFormat:@"H"]; // 16 24小时制
 [dateStringFormatter setDateFormat:@"HH"]; // 16

 [dateStringFormatter setDateFormat:@"m"]; // 28
 [dateStringFormatter setDateFormat:@"mm"]; // 28
 [dateStringFormatter setDateFormat:@"s"]; // 57
 [dateStringFormatter setDateFormat:@"ss"]; // 04

 [dateStringFormatter setDateFormat:@"E"]; // 周四
 [dateStringFormatter setDateFormat:@"EEEE"]; // 星期四
 [dateStringFormatter setDateFormat:@"EEEEE"]; // 四
 [dateStringFormatter setDateFormat:@"e"]; // 5 (显示的是一周的第几天（weekday），1为周日。)
 [dateStringFormatter setDateFormat:@"ee"]; // 05
 [dateStringFormatter setDateFormat:@"eee"]; // 周四
 [dateStringFormatter setDateFormat:@"eeee"]; // 星期四
 [dateStringFormatter setDateFormat:@"eeeee"]; // 四

 [dateStringFormatter setDateFormat:@"z"]; // GMT+8
 [dateStringFormatter setDateFormat:@"zzzz"]; // 中国标准时间

 [dateStringFormatter setDateFormat:@"ah"]; // 下午5
 [dateStringFormatter setDateFormat:@"aH"]; // 下午17
 [dateStringFormatter setDateFormat:@"am"]; // 下午53
 [dateStringFormatter setDateFormat:@"as"]; // 下午52
 */
#import <Foundation/Foundation.h>
/**
 *  关于时间的方法
 */
@interface GetTime : NSObject
/**
 *  获取当前时间
 */
+ (NSString *)getCuttentWithFormatter:(NSString *)dateFormat;

+(NSString *)dateConversionTimeStamp:(NSDate *)date;
/**
 计算到当前时间的差值
 *
 */
+ (int)dateNowTimeDifferenceWithDate:(NSDate *)date;

// 计算两个时间差值
+ (int)dateTimeDifferenceWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;


//+(NSString*)getDellaocTimeWithSeconds:(NSString*)seconds;
/**
 *  转换年月 yyyy-MM 转为 yyyy年MM月
 */
+ (NSString *)convertStrFromString:(NSString *)str;

/**
 *  获得星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 *  字符串转Date dateFormat为时间格式
 */

+ (NSDate *)convertDateFromStringDay:(NSString*)str withDateFormat:(NSString *)dateFormat;

/**
 *  Date转字符串 dateFormat为时间格式
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;
/**
 * 时间戳转时间 13位
 */
+ (NSString *)getTimeFromFormatter:(NSString *)timeNum withDateFormat:(NSString *)dateFormat;

/**
 *  将时间戳转为yyyy-MM-dd
 */
+ (NSString *)convertDateWithString:(NSString *)dateStr;

/**
 *  - 将时间戳转化为特定格式的字符串 ==
 */
+ (NSString *)convertDateWithString:(NSString *)dateStr dateFormmate:(NSString *)dateFormmate;

/**
 *  比较日期对比当前时间，是否过期
 *
 *  @param date 传过来的时间
 *
 *  @return yes 未过期
 */
+ (BOOL)compareDate:(NSString *)date;

/**
 *  按当前日期返回本周的范围
 */
+ (NSString *)rangeDateWithDay:(NSString *)timeStr;

/**
 *  按当前日期返回本周星期一的日期
 */
+ (NSString *)firstDateWithDay:(NSString *)timeStr;

/**
 *  根据当前时间
 */
+ (NSString *)getTimeBeginTime:(NSString *)beginTime endTime:(NSString *)endTime;

#pragma mark == 获取当前时间的时间戳 ==
+ (NSString*)getCurrentTimestamp;


#pragma mark == 获取多少秒之前的时间 ==
+ (NSDate *)getHistoryDateWithSeconds:(NSUInteger)seconds;

#pragma mark == 时间戳转为 date ==
+ (NSDate *)dateConvertFromTimeStamp:(NSString *)timeStamp;

#pragma mark = 判断是否可以 撤回 180s 以内
+ (BOOL)canWithDrawWith:(NSDate *)date;

+(BOOL)messageCanWithdrawWithTime:(NSString*)time maxTime:(long)maxTime;

#pragma mark == 判断是否在某一节点
+ (BOOL)compareWIthYearMouthDay:(NSString *)date formatter:(NSString *)formatter ;

/**
 仿微信的聊天界面时间处理

 @param msgDate 消息时间
 @return 格式 如 上午：9：60 昨天 
 */
+(NSString*)getWeixintime:(NSString*)messageTime;
/**
   @method

  @brief 获取两个日期之间的天数
  @param fromDate       起始日期
  @param toDate         终止日期
  @return    总天数
 */
+(NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+(NSDate*)getBeijingTime;

+(NSString*)getTimeWithMessageDate:(NSDate*)date;

+(NSString*)getTime:(NSDate*)date;

+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate ;

+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval;

/// 判断是不是同一天
/// @param iTime1 13位时间戳
/// @param iTime2 13位时间戳
+ (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2;
+(NSString*)timelinesTime:(NSInteger)timelineTime;
+(NSString*)getShowLastLoginTime:(NSString*)time;

+(NSString*)daysCountOfMonth:(NSString*)month year:(NSString*)year;
+(NSString *)getTimeNow;

/// 根据秒数得到时分秒
/// @param seconds 秒数
+(NSString*)getMinutesAndSeconds:(int)seconds;
@end
