//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 29/10/2019
- File name:  NSString+DZExtension.h
- Description:
- Function List:
*/
        
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (DZRegular)
/// 判断是否是手机号码
/// @param mobile mobile description
+(BOOL)checkMobile:(NSString *)mobile;

/// 判断是否是邮箱
/// @param email email description
+ (BOOL)checkIsEmail:(NSString *)email;

// username validation
+ (BOOL)checkUsername:(NSString *)username;


/// 判断是否是纯数字
/// @param str str description
+ (BOOL) checkIsPureString:(NSString *)str;

/** --  6位数字验证码校验 */
+ (BOOL)checkSMSCode:(NSString *)code;

/// -- 校验是否是汉字
/// @param name 字符串
+ (BOOL)checkName:(NSString *)name;

/// 校验金额
/// @param num 金额
+(BOOL)checkMoney:(NSString *)num;

/// 校验数字
/// @param num num description
+(BOOL)checkNumber:(NSString *)num;

/// 用户密码8-16位数字和字母组合
/// @param password password description
+ (BOOL)checkPassword:(NSString *) password;


/// 校验身份证
/// @param value value description
+ (BOOL)verifyIDCardNumber:(NSString *)value;

/// 校验银行卡号
/// @param cardNumber cardNumber description
+ (BOOL) IsBankCard:(NSString *)cardNumber;

/// 正则限定两位小数
/// @param str str description
+ (BOOL)checkTwoDecimalPlaces:(NSString *)str;
+(NSArray<NSTextCheckingResult *> *)getTimelineMatchesInStringWithStr:(NSMutableAttributedString*)message;
+(NSArray<NSString*>*)getTimeLineUrlStringFromNSMutableAttributedString:(NSMutableAttributedString*)textAttributedString;
+(NSMutableAttributedString*)getUrl:(NSMutableAttributedString*)message;

+(NSArray<NSTextCheckingResult *> *)getUrlMatchesInStringWithStr:(NSMutableAttributedString*)message;
+(NSArray<NSString*>*)getEmailStringFromString:(NSString*)string;
/** 获取字符串中的url */
+(NSArray<NSString*>*)getUrlStringFromNSMutableAttributedString:(NSMutableAttributedString*)textAttributedString;
@end

@interface NSString (DZExtension)

- (u_int64_t)lf_fileSize;
// MD5加密方法
- (NSString *)md5;
/// 判断字符串是否为空
/// @param string string description
+(BOOL)isEmptyString:(NSString *)string;

+(BOOL)isLowerLetter:(NSString *)str;
+ (BOOL)isCatipalLetter:(NSString *)str;
-(NSString *)removeprefixAndEndwhitespace;
#pragma mark -- MD5
+ (NSString *)MD5ForUpper32Bate:(NSString *)str;
#pragma mark -- 手机号中间字符加密
+ (NSString *)encryptWithPhoneNum:(NSString *)phoneNum;

/// 将银行卡号中间添加****
-(NSString*)encryptBankCardNum;
/**
 获取首字母

 @param string string description
 @return return value description
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;


#pragma mark --图片资源路径转Base64
+ (NSString *)htmlForimagePath:(NSString*)imagePath;

#pragma mark --图片资源转Base64
+ (NSString *)htmlForimageData:(NSData *)imageData;


#pragma mark --毫秒时间转日期
+ (NSString *)convertStrToTime:(NSString *)timeStr WithDateFormat:(NSString *)dateFormat;


#pragma mark --对字符串进行base64编码
/**
 *  @return 返回编码之后的字符串
 */
- (NSString *)base64Encode;

#pragma mark - Base64解码
/**
 *  对编码之后的字符串进行解码
 *  @return 返回解码之后的字符串
 */
- (NSString *)base64Decode;

/**
 url编码
 @param characterSetStr 需要转义的特殊字符，例如@"/+=\n"
 @return 返回编码后的字符串
 */
-(NSString *)urlEncodeWithCharacterSet:(NSString *)characterSetStr;

/**
 url解码

 @return 解码后字符串
 */
-(NSString *)urlDecode;

- (NSString *)transformCharacter;
- (NSString *)firstCharactor:(NSString *)aString;

/**
 将URL中的中文字符转码

 @param url url description
 @return return value description
 */
+(NSString *)encodedUrlString:(NSString *)url;
-(NSString *)netUrlEncoded;
+(NSString*)decodeUrlString:(NSString*)string;

- (NSString *)MD5String;


#pragma mark -- 时间戳转日期
+(NSString *)timestampSwitchTime:(long long)timestamp andFormatter:(NSString *)format;
 #pragma mark -- 获取当前的时间
+(NSString*)getDateStringWithDate:(NSDate *)date Formatter:(NSString *)formatterStr;

#pragma mark -- 从末尾截取一定长度的字符串
+(NSString *)substringFromIndex:(NSInteger)index WithString:(NSString *)str;

#pragma mark -- 数字变小数，四舍五入
+ (NSString*)notRounding:(NSString *)num afterPoint:(NSInteger)position;
#pragma mark -- 数值比较大小
+ (NSDecimalNumber *)comparPayVal:(NSString *)payVal BalanceVal:(NSString *)balanceVal;
#pragma mark -- 获取BundleID
+(NSString*)getBundleID;
/**
 获取字节数
 */
- (NSUInteger)charactorNumber;

/// 返回本地化
/// @param valueExplain 中文意思
-(NSString*)icanlocalized:(NSString*)valueExplain;
-(NSString*)icanlocalized;

+(NSString*)getCFUUID;
+(NSString*)getArc4random5:(NSInteger)type;

+(NSString*)addHtmlHenderAndBody:(NSString *)htmlString;

+ (NSString *)intoHtmlStringToString:(NSString *)htmlString;
/**
 包装成完成的Html
 @param htmlString htmlString
 @param fontSize Body 中的字体大小 默认14px

 */
+ (NSString *)addHtmlHenderAndBody:(NSString *)htmlString fontSize:(NSInteger)fontSize;

+ (NSString *)generateHTMLWithBody:(NSString *)body width:(NSInteger)width;

/**
 把html转换为SMutableAttributedString
 @param htmlString html

 */
+ (NSMutableAttributedString *)changeHtmlStringToAttributeString:(NSString *)htmlString;

/**
  把html转换为SMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttributeString:(NSString *)htmlString;

//去掉HTML标签
+ (NSString *)replaceHTML:(NSString *)content;

/**
 由文本生成attributedString

 @param text 文字
 @param color 颜色
 @param font 字体大小
 @param hasUnderLineStyle 是否有下划线
 @param line 文字的行间距
 @param paragraph 行间距
 @return 结果
 */
+ (NSAttributedString *)attributedStringWithText:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font hasUnderlineStyle:(BOOL)hasUnderLineStyle lineSpacing:(float)line paragraphSpacing:(float)paragraph ;


/**
 由图片生成attributedString

 @param image 图片
 @param bounds 图片大小
 @return 结果
 */
+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageBounds:(CGRect)bounds;


/**
  多个AttributedString拼接成一个resultAttributedString

 @param items 数组
 @return 结果
 */
+ (NSAttributedString *)jointAttributedStringWithItems:(NSArray *)items;

/**
 Pay Password Block
 */
+ (NSString *)getUnblockTime:(NSTimeInterval)timestamp;

/**
 获取版本号
 
 */
+ (NSString *)getAppVersion;
/**
 字典转json字符串
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
//字典转json字符串
+ (NSString *)convertJsonToString:(NSDictionary *)dict;



/**
 排版样式

 @return NSMutableParagraphStyle
 */
+ (NSMutableParagraphStyle *)paraStyle;

+ (NSMutableParagraphStyle *)paraStyleWithLineSpacing:(CGFloat)lineSpacing
                                            alignment:(NSTextAlignment)alignment;

/**
 计算字体size

 @param content 内容
 @param font 字体
 @param maxSize 最大size
 @return size
 */
+ (CGSize)fontSize:(NSString *)content
              font:(UIFont *)font
           maxSize:(CGSize)maxSize;

+ (CGSize)fontSize:(NSString *)content
              font:(UIFont *)font
           maxSize:(CGSize)maxSize
         paraStyle:(NSParagraphStyle *)paraStyle;

//获取字符串的字节数
+ (NSUInteger )getToInt:(NSString*)strtemp;

//切割字符串
+ (NSString *)subStringWithString:(NSString *)string withLength:(NSInteger )count;

/*
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+(NSString *)reviseString:(NSString *)str;

+(NSString *)reviseNumberToString:(CGFloat)conversionValue;

/**
 @param txtArr 文字数组
 @param colorArr 颜色数组
 @param fontArr 字体数组
 @param isbold  是否加粗
 */
+ (NSAttributedString *)txtArr:(NSArray<NSString*> *)txtArr colorArr:(NSArray<UIColor*> *)colorArr fontArr:(NSArray<NSString*> *)fontArr isBold:(BOOL)isbold;
/**
 转换成拼音
 */
- (NSString *)transformToPinyin;
/**
 获取类似于 5.00
 5.8999
 5.90
 */
-(NSString *)currencyString;
@end

@interface NSString (Frame)
/**
 *  自适应高度
 *
 *  @param str   所需字符串
 *  @param size  字号
 *  @param width 宽度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)str withFontSize:(CGFloat)size width:(CGFloat)width;

+ (NSInteger)numberOfRowForString:(NSString *)str withFontSize:(CGFloat)size width:(CGFloat)width;

#pragma mark ----  ----
/**
 *  自适应宽度
 *
 *  @param str    所需字符串
 *  @param size   字号
 *  @param height 高度
 *
 *  @return 宽度
 */
+ (CGFloat)widthForString:(NSString *)str withFontSize:(CGFloat)size height:(CGFloat)height;

+ (CGFloat)widthForString:(NSString *)str withFont:(UIFont *)font height:(CGFloat)height;


+ (CGFloat)heightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont ;

+ (CGFloat)getHeightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont numberOfLines:(NSInteger)numberOfLines;

+ (CGFloat)widthWithAttrbuteString:(NSAttributedString *)content height:(CGFloat)height cgflotTextFont:(CGFloat)cgflotTextFont;
+ (CGFloat)getYYTextViewHeightWithAttrbuteString:(NSAttributedString *)content width:(CGFloat)width cgflotTextFont:(CGFloat)cgflotTextFont;
//银行卡校验
+(BOOL)checkIsBankCardNumber:(NSString*)cardNumber;
// 银行卡号每4位插一个空格
+ (NSString *)jointWithString:(NSString *)str;
+(NSString*)getHasNameData:(NSData*)data;
//去掉所有空格
-(NSString*)remove;

/// 去掉首尾空格
-(NSString*)trimmingwhitespaceAndNewline;
///获取字节数
-(int)getLenth;
@end
NS_ASSUME_NONNULL_END
