//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 29/10/2019
 - File name:  NSString+DZExtension.m
 - Description:
 - Function List:
 */


#import "NSString+DZExtension.h"
#import "GTMBase64.h"
@implementation NSString (DZRegular)
+ (BOOL)checkSMSCode:(NSString *)code {
    NSString *codeRegex = @"^\\d{6}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:code];
}

+ (BOOL)checkName:(NSString *)name {
    NSString *codeRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:name];
}

+(BOOL)checkMoney:(NSString *)num {
    NSString *codeRegex = @"^(([1-9]\\d*)|([0-9]\\d*\\.\\d?[1-9]{1}))$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:num];
}
+(BOOL)checkNumber:(NSString *)num {
    if (num.length == 0) {
        return NO;
    }
    NSString *codeRegex = @"^[0-9]*$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:num];
}

+ (BOOL)checkPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

+(BOOL)checkMobile:(NSString *)mobile {
    if (mobile.length == 0) {
        return NO;
    }
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)checkUsername:(NSString *)username {
    if (username.length == 0) {
        return NO;
    }
    NSString *usernameRegex = @"^(?!\\d+$)[a-zA-Z0-9]+$";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",usernameRegex];
    return [usernameTest evaluateWithObject:username];
}

#pragma mark - 邮箱校验
+(BOOL)checkIsEmail:(NSString *)email{
    if (email.length == 0) {
        return NO;
    }
    //设置邮箱地址格式
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:email]) {
        return NO;
    }
    
    return YES;
}
+ (BOOL) checkIsPureString:(NSString *)str{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:str];
    
}
#pragma mark -- 校验身份证
+ (BOOL)verifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}
#pragma mark -- 校验银行卡号
+ (BOOL) IsBankCard:(NSString *)cardNumber {
    if ([cardNumber length] == 0) {
        return NO;
    }
    
    NSString * lastNum = [[cardNumber substringFromIndex:(cardNumber.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[cardNumber substringToIndex:(cardNumber.length -1)] copy];//前15或18位
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<forwardNum.length; i++) {
        
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        
        [forwardArr addObject:subStr];
        
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i =((int)forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        
        int num = [forwardDescArr[i] intValue];
        
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInt:num]];
            
        }else{//奇数位
            
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInt:num * 2]];
                
            }else{
                int decadeNum = (num * 2) / 10;
                
                int unitNum = (num * 2) % 10;
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:unitNum]];
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNumTotal += [obj integerValue];
        
    }];
    __block NSInteger sumOddNum2Total = 0;
    
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNum2Total += [obj integerValue];
        
    }];
    __block NSInteger sumEvenNumTotal =0 ;
    
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumEvenNumTotal += [obj integerValue];
        
    }];
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

+ (BOOL)checkTwoDecimalPlaces:(NSString *)str{
    NSString *regex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: str];
}
//
+(NSArray<NSTextCheckingResult *> *)getTimelineMatchesInStringWithStr:(NSMutableAttributedString*)message{
    NSError *error;
    NSString * regulaStr=@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches =[regex matchesInString:message.string options:0 range:NSMakeRange(0, [message length])];
    return arrayOfAllMatches;
}

+(NSArray<NSString*>*)getTimeLineUrlStringFromNSMutableAttributedString:(NSMutableAttributedString*)textAttributedString{
    NSArray *arrayOfAllMatches=  [self getTimelineMatchesInStringWithStr:textAttributedString];
    NSMutableArray*urlArray=[NSMutableArray array];
    NSMutableArray * matchArray=[NSMutableArray array];
    for (NSTextCheckingResult * match in arrayOfAllMatches) {
        NSString* substringForMatch = [textAttributedString attributedSubstringFromRange:match.range].string;
        [urlArray addObject:substringForMatch];
        [matchArray addObject:match];
    }
    return urlArray;
}
+(NSMutableAttributedString*)getUrl:(NSMutableAttributedString*)message{
    NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithAttributedString:message];
    NSMutableArray*emailurlArray=[NSMutableArray array];
    NSString *emailurlregulaStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *emailregex = [NSRegularExpression regularExpressionWithPattern:emailurlregulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *emailarrayOfAllMatches =[emailregex matchesInString:message.string options:0 range:NSMakeRange(0, [message.string length])];
    for (NSTextCheckingResult * match in emailarrayOfAllMatches) {
        NSString* substringForMatch = [message attributedSubstringFromRange:match.range].string;
        [emailurlArray addObject:substringForMatch];
    }
    NSArray *arrayOfAllMatches=  [NSString getUrlMatchesInStringWithStr:message];
    NSMutableArray*urlArray=[NSMutableArray array];
    for (NSTextCheckingResult * match in arrayOfAllMatches) {
        NSString* substringForMatch = [message attributedSubstringFromRange:match.range].string;
        BOOL isContail=NO;
        for (NSString*str in emailurlArray) {
            if ([str containsString:substringForMatch]) {
                isContail=YES;
                break;
            }
        }
        if (!isContail) {
            [urlArray addObject:substringForMatch];
            [string addAttribute:NSLinkAttributeName value:substringForMatch range:match.range];
        }
        
        
    }
    return string;
}
+(NSArray<NSTextCheckingResult *> *)getUrlMatchesInStringWithStr:(NSMutableAttributedString*)message{
    NSError *error;
    NSString * regulaStr=@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches =[regex matchesInString:message.string options:0 range:NSMakeRange(0, [message length])];
    return arrayOfAllMatches;
}
+(NSArray<NSString*>*)getEmailStringFromString:(NSString*)string{
    NSMutableArray*emailurlArray=[NSMutableArray array];
    NSString *emailurlregulaStr = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSRegularExpression *emailregex = [NSRegularExpression regularExpressionWithPattern:emailurlregulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *emailarrayOfAllMatches =[emailregex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult * match in emailarrayOfAllMatches) {
        NSString* substringForMatch = [string substringWithRange:match.range];
        [emailurlArray addObject:substringForMatch];
    }
    return emailurlArray;
}
+(NSArray<NSString*>*)getUrlStringFromNSMutableAttributedString:(NSMutableAttributedString*)textAttributedString{
    NSArray *arrayOfAllMatches=  [self getUrlMatchesInStringWithStr:textAttributedString];
    NSMutableArray*urlArray=[NSMutableArray array];
    for (NSTextCheckingResult * match in arrayOfAllMatches) {
        NSString* substringForMatch = [textAttributedString attributedSubstringFromRange:match.range].string;
        [urlArray addObject:substringForMatch];
    }
    return urlArray;
}
@end

@implementation NSString (DZExtension)

- (u_int64_t)lf_fileSize
{
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:self]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:self error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}
// MD5加密方法
- (NSString *)md5
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}
-(NSString *)removeprefixAndEndwhitespace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//判断是不是小写字母
+(BOOL)isLowerLetter:(NSString *)str{
    if ([str characterAtIndex:0] >= 'a' && [str characterAtIndex:0] <= 'z') {
        return YES;
    }
    return NO;
}
//判断是不是大写字母
+ (BOOL)isCatipalLetter:(NSString *)str{
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        return YES;
    }
    return NO;
    
}
+ (NSString *)firstCharactorWithString:(NSString *)string{
    if (string.length==0) {
        return @"#";
    }
    
    NSMutableString*str=[NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString*pinyin=[str capitalizedString];
    
    NSString*firstStr=[pinyin substringToIndex:1];
    
    if ([self isCatipalLetter:pinyin]) {
        return firstStr;
    }
    return @"#";
    
}

+ (NSString *)htmlForimagePath:(NSString*)imagePath {
    NSData *imageData=[NSData dataWithContentsOfFile:imagePath];
    NSString *imageSource = [NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    return imageSource;
}
+ (NSString *)htmlForimageData:(NSData *)imageData{
    NSString *imageSource = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    return imageSource;
    
}



+ (NSString *)convertStrToTime:(NSString *)timeStr WithDateFormat:(NSString *)dateFormat {
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
}

#pragma mark - Base64编码
/**
 *  对字符串进行base64编码
 *  @return 返回编码之后的字符串
 */
- (NSString *)base64Encode
{
    if(self == nil || [self length] == 0){
        return @"";
    }
    // 编码是针对二进制数据的
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    // 对字符串的二进制数据进行Base64编码,返回编码之后的字符串
    NSString *result = [data base64EncodedStringWithOptions:0];
    
    return result;
}

#pragma mark - Base64解码
/**
 *  对编码之后的字符串进行解码
 *  @return 返回解码之后的字符串
 */
- (NSString *)base64Decode
{
    // 提示 : 不能对空字符串解码
    if(self == nil || [self length] == 0){
        return @"";
    }
    
    // 把编码之后的字符串解码成二进制
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    // 把解码之后的二进制转成解码之后的字符串
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ree = %@",result);
    
    return result;
}


/**
 url编码
 
 @param characterSetStr 需要转义的特殊字符，例如@"/+=\n"
 @return 返回编码后的字符串
 */
-(NSString *)urlEncodeWithCharacterSet:(NSString *)characterSetStr{
    if(self == nil || [self length] == 0){
        return @"";
    }
    
    //设置需要转义的特殊字符，例如@"/+=\n"
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:characterSetStr] invertedSet];
    //返回转义后的字符串
    return [self stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
}


/**
 url解码
 
 @return 解码后字符串
 */
-(NSString *)urlDecode{
    if(self == nil || [self length] == 0){
        return @"";
    }
    
    return self.stringByRemovingPercentEncoding;
}

/**
 把姓名转化成拼音且首字母大写
 */
- (NSString *)transformCharacter {
    
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    return [pinYin uppercaseString];
}


//获取汉字的首字母
- (NSString *)firstCharactor:(NSString *)aString
{
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    NSString *pinYin = [str capitalizedString];
    
    NSString *firatCharactors = [NSMutableString string];
    for (int i = 0; i < pinYin.length; i++) {
        if ([pinYin characterAtIndex:i] >= 'A' && [pinYin characterAtIndex:i] <= 'Z') {
            firatCharactors = [firatCharactors stringByAppendingString:[NSString stringWithFormat:@"%C",[pinYin characterAtIndex:i]]];
        }
    }
    return firatCharactors;
}
+(NSString *)encodedUrlString:(NSString *)url  {
    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+-_.!~*;/?:@&=+$,#"].invertedSet];
//    return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
-(NSString *)netUrlEncoded{
    return  [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+(NSString*)decodeUrlString:(NSString*)string{
    return   [string stringByRemovingPercentEncoding];
}
- (NSString *)MD5String {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    uint32_t length = strlen(str);
    CC_MD5(str, length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    return ret;
}


+(BOOL)isEmptyString:(NSString *)string {
    if (!string) {//等价于if(string == ni||string == NULL)
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {//后台的数据可能是NSNull
        return YES;
    }
    if (!string.length) {//字符串长度
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
    if (!trimmedString.length) {//存在一些空格或者换行
        return YES;
    }
    return NO;
    
}




+ (NSString *)MD5ForUpper32Bate:(NSString *)str{
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}
+ (NSString *)encryptWithPhoneNum:(NSString *)phoneNum {
    if (phoneNum.length == 11) {
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:@"****"];
        
    }else{
        return phoneNum;
    }
}

-(NSString*)encryptBankCardNum{
    NSMutableString *mutableStr;
    if (self.length>8) {
        mutableStr = [NSMutableString stringWithString:self];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>3&&i<mutableStr.length - 4) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        return mutableStr;
    }
    return self;
}
#pragma mark -- 时间戳转日期
+(NSString *)timestampSwitchTime:(long long)timestamp andFormatter:(NSString *)format {
    
    NSTimeInterval interval = timestamp / 1000;
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
#pragma mark -- Date转自定义字符串
+(NSString*)getDateStringWithDate:(NSDate *)date Formatter:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *currentTimeString = [formatter stringFromDate:date];
    return currentTimeString;
}

+(NSString *)substringFromIndex:(NSInteger)index WithString:(NSString *)str {
    if (EMPTY_STRING(str)) {
        return str;
    }else {
        if (str.length > index) {
            return  [str substringFromIndex:str.length- index];
        }else {
            return str;
        }
    }
}

+ (NSString*)notRounding:(NSString *)num afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    //    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    ouncesDecimal = [[NSDecimalNumber alloc]initWithString:num];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    //    return roundedOunces;// 整数的不带小数点
    NSString* string = [NSString stringWithFormat:@"%@",roundedOunces];
    //    NSLog(@"此时是精度后的string:%@",string);
    if ([string rangeOfString:@"."].length==0) {
        if (position > 0) {
            string=  [string stringByAppendingString:@"."];
            for (NSInteger i = 0; i < position; i++) {
                string=  [string stringByAppendingString:@"0"];
            }
        }
        
    }else{
        NSRange range = [string rangeOfString:@"."];
        if (string.length-range.location-1 < position) {
            NSInteger diff = position - (string.length-range.location-1);
            for (NSInteger i = 0; i < diff; i++) {
                string = [string stringByAppendingString:@"0"];
            }
        }
    }
    return string;
}
#pragma mark -- 数值比较大小
+ (NSDecimalNumber *)comparPayVal:(NSString *)payVal BalanceVal:(NSString *)balanceVal {
    NSDecimalNumber *balanceNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",balanceVal.floatValue]];
    NSDecimalNumber *payNum= [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",payVal.floatValue]];
    NSLog(@"----%@----%@", balanceNum, payNum);
    return  [payNum  decimalNumberBySubtracting:balanceNum];
}

#pragma mark -- 获取BundleID
+(NSString*)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
- (NSUInteger)charactorNumber
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self charactorNumberWithEncoding:encoding];
}
-(NSString*)icanlocalized:(NSString*)valueExplain{
    return NSLocalizedString(self, valueExplain);
}
-(NSString*)icanlocalized{
    return NSLocalizedString(self, nil);
}
+(NSString*)getCFUUID{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    return cfuuidString;
}
+(NSString*)getArc4random5:(NSInteger)type{
    //0 image
    //image-yyyyMMddHHmmsssss-设备简写-5位random   0
    //   video-yyyyMMddHHmmsssss-设备简写-5位random 1
    //    voice-yyyyMMddHHmmsssss-设备简写-5位random 2
    int num = (arc4random() % 100000);
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    NSString*date=[GetTime convertDateWithString:timeSp dateFormmate:@"yyyyMMddHHmmsssss"];
    if (type==0) {
        return [NSString stringWithFormat:@"image-%@-i-%.5d",date,num];
    }else if (type==1){//视频
        return [NSString stringWithFormat:@"video-%@-i-%.5d",date,num];
    }
    return [NSString stringWithFormat:@"voice-%@-i-%.5d",date,num];
    
}
- (NSUInteger)charactorNumberWithEncoding:(NSStringEncoding)encoding{
    NSUInteger strLength = 0;
    char *p = (char *)[self cStringUsingEncoding:encoding];
    
    NSUInteger lengthOfBytes = [self lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}
+(NSString *)addHtmlHenderAndBody:(NSString *)htmlString{
    //    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
    //    "<head> \n"
    //    "<style type=\"text/css\"> \n"
    //    "body {font-size:15px;padding:0;margin:0;}\n"
    //    "</style> \n"
    //    "</head> \n"
    //    "<body>"
    //    "<script type='text/javascript'>"
    //    "window.onload = function(){\n"
    //    "var $img = document.getElementsByTagName('img');\n"
    //    "for(var p in  $img){\n"
    //    "$img[p].style.width = '%f';\n"
    //    "$img[p].style.height ='auto'\n"
    //    "}\n"
    //    "}"
    //    "</script>%@"
    //    "</body>""</html>",ScreenWidth*[UIScreen mainScreen].scale,htmlString];
    //    DDLogInfo(@"[UIScreen mainScreen].scale=%.2f",[UIScreen mainScreen].scale);
    //height:auto
    NSString *headerString = @"<head><style>img{width:100vw !important;height:auto}</style></head>";
    return [headerString stringByAppendingString:htmlString];
}
+ (NSString *)intoHtmlStringToString:(NSString *)htmlString{
    
    NSString *  newString =[NSString stringWithFormat:@"<html>"
                            "<head>"
                            "</head>"
                            "<body>%@</body>"
                            "</html>",htmlString];
    return newString;
}


+ (NSString *)addHtmlHenderAndBody:(NSString *)htmlString fontSize:(NSInteger)fontSize{
    
    if (fontSize <14) {
        fontSize = 14;
    }
    NSString *htmlstring =  [NSString stringWithFormat:@"<html>"
                             "<head>"
                             "<style>*{margin:3px 0px 3px 0px;padding:0 ;max-width:%f;} p{margin:0 0;}</style>"
                             "</head>"
                             "<body>%@</body>"
                             "</html>",htmlString];
    //line-height:1.4
    return htmlstring;
}

+ (NSString *)generateHTMLWithBody:(NSString *)body width:(NSInteger)width{
    if (body == nil || body.length == 0) {
        return @"";
    }
    body = [body stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</p><p>"];
    NSString *html = @"<!DOCTYPE html><html><head><base href=\"http://union.inhe.net:80/\"><title>功能介绍</title><meta name=\"viewport\" content=\"width=";
    html = [html stringByAppendingFormat:@"%d,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\"><meta http-equiv=\"pragma\" content=\"no-cache\"><meta http-equiv=\"cache-control\" content=\"no-cache\"><meta http-equiv=\"expires\" content=\"0\"><style type=\"text/css\">img{width: 100\%%;display: block;}body{margin: 8px 10px; font-size: 14px;word-break:break-all; width:%dpx;}</style></head>",(int)width,(int)width];
    if (![body containsString:@"<body"]) {
        html = [html stringByAppendingFormat:@"<body>%@</body></html>",body];
    }else{
        html = [html stringByAppendingFormat:@"%@</html>",body];
        
    }
    return html;
}

+ (NSMutableAttributedString *)changeHtmlStringToAttributeString:(NSString *)htmlString{
    NSString *newString = htmlString;
    //图片自适应宽高，只限制图片的最大显示宽度，这样就能做到自适应
    newString = [self addHtmlHenderAndBody:htmlString fontSize:14];
    return [self getAttributeString:newString];
}

+ (NSMutableAttributedString *)getAttributeString:(NSString *)htmlString{
    NSData *data = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *htmlAttribute = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置文字的行间距
    [paragraphStyle setLineSpacing:10];
    [htmlAttribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlAttribute length])];
    //设置文字的颜色
    [htmlAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, htmlAttribute.length)];
    //设置文字的大小
    [htmlAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, htmlAttribute.length)];
    
    return htmlAttribute;
}

+ (NSString *)replaceHTML:(NSString *)content {
    if (!content) {
        return @"";
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:content];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return content;
}

//  由文本生成attributedString
+ (NSAttributedString *)attributedStringWithText:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font hasUnderlineStyle:(BOOL)hasUnderLineStyle lineSpacing:(float)line paragraphSpacing:(float)paragraph {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSRange range = NSMakeRange(0, text.length);
    [paragraphStyle setLineSpacing:line];
    [paragraphStyle setParagraphSpacing:paragraph];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    
    if (hasUnderLineStyle) {
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    }
    return attributedString;
}

//  由图片生成attributedString
+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageBounds:(CGRect)bounds {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    NSAttributedString *attachmentAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    return attachmentAttributedString;
}

//  多个AttributedString拼接成一个resultAttributedString
+ (NSAttributedString *)jointAttributedStringWithItems:(NSArray *)items {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < items.count; i++) {
        if ([items[i] isKindOfClass:[NSAttributedString class]]) {
            [resultAttributedString appendAttributedString:items[i]];
        }
    }
    return resultAttributedString;
}

+ (NSString *)getUnblockTime:(NSTimeInterval)timestamp {
    NSDate *unlockDate = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd MMM yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    return [dateFormatter stringFromDate:unlockDate];
}

+ (NSString *)getAppVersion{
    NSDictionary*infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString*app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//字典转json字符串
+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }
    else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

//字典转json字符串
+ (NSString *)convertJsonToString:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSMutableParagraphStyle *)paraStyle{
    return [self paraStyleWithLineSpacing:5 alignment:NSTextAlignmentLeft];
}

+ (NSMutableParagraphStyle *)paraStyleWithLineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:alignment];
    return paragraphStyle;
}

+ (CGSize)fontSize:(NSString *)content font:(UIFont *)font maxSize:(CGSize)maxSize {
    if (content && font) {
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize size = [content boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:font} context:nil].size;
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    return CGSizeMake(0, 0);
}

+ (CGSize)fontSize:(NSString *)content font:(UIFont *)font maxSize:(CGSize)maxSize paraStyle:(NSParagraphStyle *)paraStyle{
    if (content && font) {
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paraStyle,NSParagraphStyleAttributeName, nil];
        CGSize size = [content boundingRectWithSize:maxSize options:options attributes:attributes context:nil].size;
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    return CGSizeMake(0, 0);
}

//获取字符串的字节数
+ (NSUInteger )getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
//切割字符串
+ (NSString *)subStringWithString:(NSString *)string withLength:(NSInteger )count
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:enc];
    NSData *subData;
    if (data.length%2 == 0) {
        subData = [data subdataWithRange:NSMakeRange(0, count)];
    }else{
        subData = [data subdataWithRange:NSMakeRange(0, count - 1)];
    }
    return [[NSString alloc] initWithData:subData encoding:enc];
}

/*
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+(NSString *)reviseString:(NSString *)str {
    if (!str) {
        return @"";
    }
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+(NSString *)reviseNumberToString:(CGFloat)conversionValue {
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}


//+(NSString *)dataNmImageUrl:(NSString *)str type:(NSInteger)type {
//    NSString *url = str;
//    if (![url hasPrefix:@"http"]) {
//        NSString *header = @"";
//        switch (type) {
//            case 1:
//                header = SoccerDataSSlogo;
//                break;
//            case 2:
//                header = SoccerDataQDlogo;
//                break;
//            case 3:
//                header = SoccerDataQYlogo;
//                break;
//            case 4:
//                header = SoccerDataGQlogo;
//                break;
//            case 5:
//                header = SoccerDataRYlogo;
//                break;
//            default:
//                break;
//        }
//        url = [NSString stringWithFormat:@"%@%@",header,str];
//    }
//    return url;
//}


+ (NSAttributedString *)txtArr:(NSArray<NSString*> *)txtArr colorArr:(NSArray<UIColor*> *)colorArr fontArr:(NSArray<NSString*> *)fontArr isBold:(BOOL)isbold{
    
    NSInteger okCount = 0;
    okCount = txtArr.count < colorArr.count ? txtArr.count : colorArr.count;
    okCount = okCount < fontArr.count ? okCount : fontArr.count;
    
    NSMutableString *txt = [NSMutableString string];
    for (NSString *str in txtArr) {
        [txt appendString:str];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:txt];
    NSInteger startLoc = 0;
    for (int i = 0; i < okCount; i++) {
        [str addAttributes:@{NSForegroundColorAttributeName:colorArr[i], NSFontAttributeName:isbold?[UIFont boldSystemFontOfSize:[fontArr[i] integerValue]]:[UIFont systemFontOfSize:[fontArr[i] integerValue]]} range:NSMakeRange(startLoc, [txtArr[i] length])];
        startLoc += [txtArr[i] length];
    }
    return str;
}
- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}
-(NSString *)currencyString{
    
    NSRange dianRange = [self rangeOfString:@"."];
    NSString * lastring = self;
    if (dianRange.location == NSNotFound) {
        lastring = [NSString stringWithFormat:@"%@.00",self];
    }else{
        float lastLenth = [self substringFromIndex:dianRange.location].length;
        if (lastLenth<=2) {
            lastring =  [NSString stringWithFormat:@"%.2f",self.doubleValue];
        }
        if (lastLenth>6) {
            lastring =  [NSString stringWithFormat:@"%.6f",self.doubleValue];
        }
    }
    return lastring;
}

@end

@implementation NSString (Frame)
+ (CGFloat)heightForString:(NSString *)str withFontSize:(CGFloat)size width:(CGFloat)width {
    // 获取文本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:size], NSFontAttributeName, nil];
    // 根据字符串， str 绘制一个矩形
    CGRect bound = [str boundingRectWithSize:(CGSizeMake(width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return bound.size.height;
}


+ (NSInteger)numberOfRowForString:(NSString *)str withFontSize:(CGFloat)size width:(CGFloat)width{
    
    // 获取文本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:size], NSFontAttributeName, nil];
    // 根据字符串， str 绘制一个矩形
    CGRect bound = [str boundingRectWithSize:(CGSizeMake(width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.numberOfLines = 1;
    label.text = str;
    [label sizeToFit];
    CGFloat rowHeight =  label.frame.size.height;
    CGFloat numberLow = bound.size.height/rowHeight;
    
    
    int a;
    a = ceil(numberLow);
    
    return a;
    
}

+ (CGFloat)widthForString:(NSString *)str withFontSize:(CGFloat)size height:(CGFloat)height {
    
    return [self widthForString:str withFont:[UIFont systemFontOfSize:size] height:height];
}

+ (CGFloat)widthForString:(NSString *)str withFont:(UIFont *)font height:(CGFloat)height {
    // 获取文本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    // 根据字符串， str 绘制一个矩形
    CGRect bound = [str boundingRectWithSize:(CGSizeMake(MAXFLOAT, height)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return bound.size.width;
}
+ (CGFloat)getYYTextViewHeightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont{
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    textView.textContainerInset=UIEdgeInsetsZero;
    textView.font = [UIFont systemFontOfSize:cgflotTextFont];
    textView.attributedText = content;
    [textView sizeToFit];
    CGFloat rowHeight =  textView.frame.size.height;
    
    return rowHeight;
}
+ (CGFloat)getHeightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont numberOfLines:(NSInteger)numberOfLines{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:cgflotTextFont];
    label.numberOfLines = numberOfLines;
    label.attributedText = content;
    [label sizeToFit];
    CGFloat rowHeight =  label.frame.size.height;
    
    return rowHeight;
}
+ (CGFloat)heightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont  {
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 1000)];
    textView.attributedText=content;
    textView.font=[UIFont systemFontOfSize:cgflotTextFont];
    CGFloat resultHeight= flat([textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
    return resultHeight;
}

+ (CGFloat)widthWithAttrbuteString:(NSAttributedString *)content height:(CGFloat)height cgflotTextFont:(CGFloat)cgflotTextFont {
    //   CGSize attSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    //    return attSize.width;
    UILabel *textLB = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 0, height))];
    textLB.font=[UIFont systemFontOfSize:cgflotTextFont];
    textLB.numberOfLines = 0;
    [textLB setAttributedText:content];
    
    @try {
        [textLB sizeToFit];
        return textLB.width;
    } @catch (NSException *exception) {
        return 0;
    } @finally {
        
    }
}

//银行卡校验
+(BOOL)checkIsBankCardNumber:(NSString*)cardNumber{
    int oddSum =0;    // 奇数和
    int evenSum =0;    // 偶数和
    int allSum =0;    // 总和
    // 循环加和
    for(NSInteger i =1; i <= cardNumber.length; i++){
        NSString *theNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length-i,1)];
        int lastNumber = [theNumber intValue];
        if(i%2==0){
            // 偶数位
            lastNumber *=2;
            if(lastNumber >9) {
                lastNumber -=9;
            }
            evenSum += lastNumber;
            
        }else{
            // 奇数位
            oddSum += lastNumber;
        }
        
    }
    
    allSum = oddSum + evenSum;
    // 是否合法
    if(allSum%10==0){
        return YES;
        
    }else{
        return NO;
    }
    
}

#pragma mark - 拼接成中间有空格的字符串
+ (NSString *)jointWithString:(NSString *)str
{
    NSString *getString = @"";
    
    int a = (int)str.length/4;
    int b = (int)str.length%4;
    int c = a;
    if (b>0)
    {
        c = a+1;
    }
    else
    {
        c = a;
    }
    for (int i = 0 ; i<c; i++)
    {
        NSString *string = @"";
        
        if (i == (c-1))
        {
            if (b>0)
            {
                string = [str substringWithRange:NSMakeRange(4*(c-1), b)];
            }
            else
            {
                string = [str substringWithRange:NSMakeRange(4*i, 4)];
            }
            
        }
        else
        {
            string = [str substringWithRange:NSMakeRange(4*i, 4)];
        }
        getString = [NSString stringWithFormat:@"%@ %@",getString,string];
    }
    return getString;
}

+(NSString*)getHasNameData:(NSData*)data {
    /*测试链接
     http://yqq.file.mediportal.com.cn/yqq_5b911b43955f06317c6bd792/3974e8eaab11b2dd5b357e60e5a587d1  etag:FtfVrVsdpVf9t_tCfyvsVC-1p6aW
     4M以上文件亲测正确
     */
    //
    //    NSURL *url = [NSURL URLWithString:@"http://yqq.file.mediportal.com.cn/yqq_5b911b43955f06317c6bd792/3974e8eaab11b2dd5b357e60e5a587d1"];
    //    NSError *error;
    //    NSData * data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    NSString *etag = [NSString caculateETagWith:data];
    return etag;
}

//算法实现
+ (NSString *)caculateETagWith:(NSData *)data
{
    unsigned long blockSize = 4 * 1024 * 1024;
    NSMutableData *sha1Data = [NSMutableData data];
    Byte prefix = 0x16;
    int blockCount = 0;
    
    unsigned long bufferSize = [data length];
    //获取余数
    unsigned long remainder = bufferSize % blockSize;
    //获取商
    double fa = (double)bufferSize / blockSize;
    //向下取整
    blockCount = floor(fa);
    
    if (bufferSize > blockSize) {//大于4M的文件
        NSMutableData *sha2Data = [NSMutableData data];
        for (int i = 0; i < blockCount+1; i++) {
            NSUInteger length = blockSize;
            if (i == blockCount && remainder > 0) {
                length = remainder;
            }
            //将每个块（包括4M块和小于4M的块）进行sha1加密并拼接起来
            NSData *subData = [data subdataWithRange:NSMakeRange(i * blockSize, length)];
            [sha2Data appendData:[NSString sha1:subData]];
        }
        //将拼接块进行二次sha1加密
        [sha1Data appendData:[NSString sha1:sha2Data]];
    } else {
        [sha1Data appendData:[NSString sha1:data]];
    }
    
    if (!sha1Data.length) return @"Fto5o-5ea0sNMlW_75VgGJCv2AcJ";
    
    NSData *sha1Buffer = sha1Data;
    if (bufferSize > blockSize) {
        //大于4M，头部拼接0x96单个字节
        prefix = 0x96;
    }
    
    Byte preByte[] = {prefix};
    NSMutableData *mutaData = [NSMutableData dataWithBytes:preByte length:1];
    [mutaData appendData:sha1Buffer];
    //将长度为21个字节的二进制数据进行url_safe_base64计算
    return [NSString safeBase64WithSha1Str:mutaData];
}

/*
 sha1加密（加密后的data长度为20）
 */
+ (NSData*)sha1:(NSData *)data
{
    //注：如果用以下代码，转换出的data长度为40
    //    const char *cstr = [sourceStr cStringUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [NSData dataWithBytes:cstr length:sourceStr.length];
    //    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    //    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    //        [output appendFormat:@"%02x", digest[i]];
    //    return output;
    
    //sha1Data长度为20（CC_SHA1_DIGEST_LENGTH系统设定为20）
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSData * sha1Data = [[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    return sha1Data;
}

+ (NSString *)safeBase64WithSha1Str:(NSData *)base64
{
    //Base64编码中包含有"+,/,="不安全的URL字符串，我们要对这些字符进行转换
    NSString *base64Str = [GTMBase64 encodeBase64Data:base64];
    
    NSMutableString *safeBase64Str = [[NSMutableString alloc] initWithString:base64Str];
    
    safeBase64Str = (NSMutableString *)[safeBase64Str stringByReplacingOccurrencesOfString:@"+"withString:@"-"];
    
    safeBase64Str = (NSMutableString *)[safeBase64Str stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
    
    safeBase64Str = (NSMutableString *)[safeBase64Str stringByReplacingOccurrencesOfString:@"="withString:@""];
    
    return safeBase64Str;
}
-(NSString *)remove{
    [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return self;
}
-(NSString*)trimmingwhitespaceAndNewline{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(int)getLenth
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
@end
