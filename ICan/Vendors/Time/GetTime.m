//
//  GetTime.m
//  HaoYuanQu
//
//  Created by gd on 16/6/30.
//  Copyright © 2016年 HaoYuanQu. All rights reserved.
//

#import "GetTime.h"

@implementation GetTime

+ (NSString *)getCuttentWithFormatter:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = dateFormat;
    NSDate *date = [NSDate date];
    return [formatter stringFromDate:date];
}
+(NSString *)dateConversionTimeStamp:(NSDate *)date
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}
+ (NSString *)convertStrFromString:(NSString *)str{
    NSArray *timeArr = [str componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@年%@月",timeArr.firstObject,timeArr.lastObject];
}


+ (int)dateNowTimeDifferenceWithDate:(NSDate *)date {
    NSDate *now = [NSDate date];
    return [self dateTimeDifferenceWithStartDate:date endDate:now];
}

+ (int)dateTimeDifferenceWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [endDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    return value;
}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], NSLocalizedString(@"Sunday", 星期日), NSLocalizedString(@"Monday", 星期一), NSLocalizedString(@"Tuesday", 星期二), NSLocalizedString(@"Wednesday", 星期三), NSLocalizedString(@"Thursday", 星期四), NSLocalizedString(@"Friday", 星期五), NSLocalizedString(@"Saturday", 星期六), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}


+ (NSString *)rangeDateWithDay:(NSString *)timeStr{
    NSDate *date = [GetTime convertDateFromStringDay:timeStr withDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSInteger today = theComponents.weekday-1;
    
    NSTimeInterval oneDay = 24*60*60*1;
    
    NSDate *first;
    NSDate *last;
    
    if (today == 0)
    {
        first = [date initWithTimeIntervalSinceNow:oneDay*(today-6)];
        last = [date initWithTimeIntervalSinceNow:oneDay*(-today)];
    }
    else
    {
        first = [date initWithTimeIntervalSinceNow:oneDay*(1-today)];
        last = [date initWithTimeIntervalSinceNow:oneDay*(7-today)];
    }
    
    return [NSString stringWithFormat:@"%@至%@",[GetTime stringFromDate:first withDateFormat:@"yyyy-MM-dd"],[GetTime stringFromDate:last withDateFormat:@"yyyy-MM-dd"]];
}


+ (NSString *)firstDateWithDay:(NSString *)timeStr
{
    NSDate *date = [GetTime convertDateFromStringDay:timeStr withDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSInteger today = theComponents.weekday-1;
    
    NSTimeInterval oneDay = 24*60*60*1;
    
    NSDate *first;
    
    if (today == 0)
    {
        first = [date initWithTimeIntervalSinceNow:oneDay*(today-6)];
    }
    else
    {
        first = [date initWithTimeIntervalSinceNow:oneDay*(1-today)];
    }
    
    return [GetTime stringFromDate:first withDateFormat:@"yyyy-MM-dd"];
}


+ (NSDate *)convertDateFromStringDay:(NSString*)str withDateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:dateFormat];
    NSDate *date=[formatter dateFromString:str];
    return date;
}


+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma markj
+ (NSString *)getTimeFromFormatter:(NSString *)timeNum withDateFormat:(NSString *)dateFormat{
    NSTimeInterval _interval=[timeNum doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 将时间戳转化为特定格式的字符串 ==
+ (NSString *)convertDateWithString:(NSString *)dateStr dateFormmate:(NSString *)dateFormmate {
    
    if ([dateStr isEqual:[NSNull null]]) {
        return @"";
    }
    NSTimeInterval time=[dateStr doubleValue]/1000;
    NSDate *detaildate = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:dateFormmate];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSString *)convertDateWithString:(NSString *)dateStr {
    
    return [self convertDateWithString:dateStr dateFormmate:@"yyyy-MM-dd"];
}

#pragma mark = 判断是否过期 ==
+ (BOOL)compareDate:(NSString *)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date1 = [self convertDateWithString:date];
    NSString *date2 = [self getCuttentWithFormatter:@"yyyy-MM-dd"];
    NSDate *dt1 = [df dateFromString:date1];
    NSDate *dt2 = [df dateFromString:date2];
    NSComparisonResult result = [dt1 compare:dt2];
    
    // 是否过期
    BOOL isOut;
    switch (result) {
            //过期
        case NSOrderedAscending:
            isOut = NO;
            break;
            //未过期
        case NSOrderedDescending:
            isOut = YES;
            break;
            //date02=date01
        case NSOrderedSame:
            isOut = YES;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return isOut;
}

+ (BOOL)compareWIthYearMouthDay:(NSString *)date formatter:(NSString *)formatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:formatter];
    NSString *date2 = [self getCuttentWithFormatter:formatter];
    NSDate *dt1 = [df dateFromString:date];
    NSDate *dt2 = [df dateFromString:date2];
    NSComparisonResult result = [dt1 compare:dt2];
    
    // 是否过期
    BOOL isOut;
    switch (result) {
            //过期
        case NSOrderedAscending:
            isOut = NO;
            break;
            //未过期
        case NSOrderedDescending:
            isOut = YES;
            break;
            //date02=date01
        case NSOrderedSame:
            isOut = YES;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return isOut;
}


+ (NSString *)getTimeBeginTime:(NSString *)beginTime endTime:(NSString *)endTime {
    
    
    int seconds = (int)([endTime integerValue]/1000 - [beginTime integerValue] / 1000);
    
    int hours = (int)(seconds/3600);
    
    int minute = (int)(seconds-hours*3600)/60;
    
    int second = seconds-hours*3600-minute*60;
    
    NSMutableString *str = [NSMutableString string];
    if (hours && hours != 0) {
        [str appendString:[NSString stringWithFormat:@"%d小时", hours]];
    }
    if (minute && minute != 0) {
        [str appendString:[NSString stringWithFormat:@"%d分钟", minute]];
    }
    
    [str appendString:[NSString stringWithFormat:@"%d秒", second]];
    
    return str;
}

+ (NSDate *)dateWithLongLong:(long long)longlongValue{
    long long value = longlongValue/1000;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval
    NSTimeInterval nsTimeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

//获取当前时间的时间戳
+ (NSString*)getCurrentTimestamp {
    NSDate *datenow = [NSDate date];
    //时间转时间戳的方法:
    NSString *timeString = [NSString stringWithFormat:@"%.0f", [datenow timeIntervalSince1970] * 1000];
    return timeString;
}





#pragma mark == 获取多少秒之前的时间 ==
+ (NSDate *)getHistoryDateWithSeconds:(NSUInteger)seconds {
    NSDate *date = [NSDate date];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *timestamp = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval time = seconds;
    //得到多少秒前的当前时间（ - ：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    NSDate *lastdate = [date dateByAddingTimeInterval:-time];
    
    return lastdate;
}

#pragma mark == 时间戳转为 date ==
+ (NSDate *)dateConvertFromTimeStamp:(NSString *)timeStamp {
    
    NSTimeInterval time = [timeStamp doubleValue]/1000;
    
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return detaildate;
}


+(BOOL)messageCanWithdrawWithTime:(NSString*)time maxTime:(long)maxTime {
    NSInteger nowTime = [[NSDate date]timeIntervalSince1970];
    NSInteger messageTime = [time integerValue]/1000;
    return (nowTime-messageTime) <= maxTime;
}

#pragma mark = 判断是否可以 撤回 180s 以内
+ (BOOL)canWithDrawWith:(NSDate *)date {
    
    int difference = [GetTime dateNowTimeDifferenceWithDate:date];
    
    if (difference < 1800) {
        return YES;
    }
    return NO;
}
+ (BOOL)isToday:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return
    
    (selfCmps.year == nowCmps.year) &&
    
    (selfCmps.month == nowCmps.month) &&
    
    (selfCmps.day == nowCmps.day);
    
}
+(NSString*)getTimeWithMessageDate:(NSDate*)date{
    if (date) {
        if ([self isToday:date]) {
            return [self stringFromDate:date withDateFormat:@"MM-dd"] ;
        }
        return [self stringFromDate:date withDateFormat:@"MM-dd"] ;
    }
    return nil;
    
}
+(NSString*)getTime:(NSDate*)date{
    if (date) {
            return [self stringFromDate:date withDateFormat:@"HH:mm"] ;
    }
    return nil;
}
/*
 仿微信时间处理
 1：如果时间是今天 那么 按照上午下午来区分
 2：如果时间大于1天且小于7天 且当前时间大于消息时间大于1天且小于两天 那么显示为昨天 否则显示星期几
 3:若果时间大于七天 那么显示的就是星期几
 */
+(NSString*)getWeixintime:(NSString*)messageTime{
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日。利用日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    // 获取消息发送时间的年、月、日
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:messageTime.longLongValue/1000];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:msgDate];
    NSInteger msgYear = components.year;
    NSInteger msgMonth = components.month;
    NSInteger msgDay = components.day;
    NSInteger msghours = components.hour;
    NSString * dateStr;
    NSInteger coutDay=[self numberOfDaysWithFromDate:msgDate toDate:currentDate];
    // 进行判断
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        
        if (msghours<12) {
            dateStr=[GetTime stringFromDate:msgDate withDateFormat:@"a h:mm"];
        }else{
            dateStr=[GetTime stringFromDate:msgDate withDateFormat:@"a h:mm"];
        }
        
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateStr= @"yesterday".icanlocalized;
    }else if(currentYear == msgYear&&coutDay>=1&&coutDay<=7 ){//同一年
        //昨天以前
        dateStr=[GetTime stringFromDate:msgDate withDateFormat:@"eeee"];
    }else{
        dateStr=[GetTime stringFromDate:msgDate withDateFormat:@"yyyy/MM/dd"];
    }
    // 返回处理后的结果
    return dateStr;
}
+(NSString *)getTimeNow{
    //取出个随机数
    NSDateFormatter * yearformatter = [[NSDateFormatter alloc ] init];
    [yearformatter setDateFormat:@"yyyy/M/d"];
    NSString*  year = [yearformatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@",year];
    return timeNow;
}
+(NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    return labs(comp.day) ;
}
+(NSDate *)getBeijingTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *timestamp = [date  dateByAddingTimeInterval: interval];
    return timestamp;
}
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval{
    
    NSDate *date =[self dateWithYMD:[NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue/1000]] ; //此处根据项目需求,选择是否除以1000 , 如果时间戳精确到秒则去掉1000
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //今天
    if ([self isToday:date]) {
        return @"今天";
    }else{
        if ([self isYesterday:date]) {
            return @"昨天";
        }else if ([self isSameWeek:date]){
            return [self weekdayStringFromDate:date];
            //直接显示年月日
        }else{
            
            formatter.dateFormat = @"yy-MM-dd  HH:mm";
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}


//是否在同一周
+ (BOOL)isSameWeek:(NSDate*)date
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}
//是否为昨天
+(BOOL)isYesterday:(NSDate*)date{
    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    
    return cmps.day == 1;
}
+ (NSDate *)dateWithYMD:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfStr = [fmt stringFromDate:date];
    
    return [fmt dateFromString:selfStr];
}
+ (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2{
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
+(NSString*)timelinesTime:(NSInteger)timelineTime{
    NSInteger nowTime=[[NSDate date]timeIntervalSince1970]*1000;
    NSString * timeTitle;
    NSInteger diff=(nowTime-timelineTime)/1000;
    NSInteger day=diff/(24*60*60);
    NSInteger hour=diff/3600;
    NSInteger minute=diff/60;
    if (day>1) {
        timeTitle=[NSString stringWithFormat:@"%ld %@",day,@"Days ago".icanlocalized];
    }else if (day==1){
        timeTitle=[NSString stringWithFormat:@"%ld %@",day,@"Day ago".icanlocalized];
    }else if (hour>1){
        timeTitle=[NSString stringWithFormat:@"%ld %@",hour,@"Hours ago".icanlocalized];
    }else if (hour==1){
        timeTitle=[NSString stringWithFormat:@"%ld %@",hour,@"Hour ago".icanlocalized];
    }else if (minute>1&&minute<59){
        timeTitle=[NSString stringWithFormat:@"%ld %@",minute,@"Minutes ago".icanlocalized];
    }else{
        timeTitle=[NSString stringWithFormat:@"%@",@"Just now".icanlocalized];
    }
    return timeTitle;
}
+(NSString*)getShowLastLoginTime:(NSString*)dateStr{
    if ([dateStr isEqual:[NSNull null]]) {
        return @"";
    }
    NSTimeInterval time=[dateStr doubleValue]/1000;
    NSDate *detaildate = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDate *currentDate = [NSDate date];
    // 获取当前时间的年、月、日。利用日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    // 获取消息发送时间的年、月、日
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:detaildate];
    NSInteger msgYear = components.year;
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    if (currentYear==msgYear) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Last login", 上次登录),currentDateStr];;
}
+(NSString*)daysCountOfMonth:(NSString*)month year:(NSString*)year{
    if ([month isEqualToString:@"01"]||[month isEqualToString:@"03"]||[month isEqualToString:@"05"]||[month isEqualToString:@"07"]||[month isEqualToString:@"08"]||[month isEqualToString:@"10"]||[month isEqualToString:@"12"]) {
        return @"31";
        
    }else if ([month isEqualToString:@"02"]){
        NSInteger ayear = [year intValue];
        if ((ayear%4 == 0&&ayear%100 != 0) ||(ayear%400 == 0)) {
            //润年
            return @"29";

        }else{
            return @"28";
        }
    }
    return @"30";
    
}
+(NSString *)getMinutesAndSeconds:(int)seconds{
    if (seconds <= 0) {
        return @"00:00";
    }
    int hours = seconds/3600;
    int minute = seconds / 60;
    int second = (int)seconds % 60;
    NSString * timeStr;

    if (hours>=1) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minute, second];
    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    return timeStr;
}

@end
