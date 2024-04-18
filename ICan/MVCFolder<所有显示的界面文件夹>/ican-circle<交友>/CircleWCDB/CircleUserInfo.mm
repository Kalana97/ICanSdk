//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/6/2021
- File name:  CircleCacheUserInfo.mm
- Description:
- Function List:
*/
        

#import "CircleUserInfo+WCTTableCoding.h"
#import "CircleUserInfo.h"
#import <WCDB/WCDB.h>
@implementation CircleUserInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId":@"id"};
}
WCDB_IMPLEMENTATION(CircleUserInfo)
WCDB_SYNTHESIZE(CircleUserInfo, nickname)
WCDB_SYNTHESIZE(CircleUserInfo, gender)
WCDB_SYNTHESIZE(CircleUserInfo, avatar)
WCDB_SYNTHESIZE(CircleUserInfo, userId)
WCDB_SYNTHESIZE(CircleUserInfo, icanId)
WCDB_SYNTHESIZE(CircleUserInfo, enable)
WCDB_SYNTHESIZE(CircleUserInfo, yue)

//唯一主键
WCDB_PRIMARY(CircleUserInfo,userId)

+(NSDictionary *)mj_objectClassInArray{
    return @{@"userHobbyTags":[HobbyTagsInfo class],@"photoWalls":[PhotoWallInfo class]};
}

-(NSString *)showDistance{
    //浮点型数据不能直接笔记< > = 得出来的结果不准确
    double distance=self.distance.doubleValue;
    NSString*show;
    NSDecimalNumber*distanceNumber=[NSDecimalNumber decimalNumberWithString:self.distance.stringValue];
    NSComparisonResult result= [distanceNumber compare:@(0.0)];
    NSComparisonResult tworesult= [distanceNumber compare:@(1.0)];
    if (result==NSOrderedSame) {
        show=@"10m";
    }else if(tworesult==NSOrderedAscending){
        show=[NSString stringWithFormat:@"%.fm",distance*1000];
    }else{
        show=[NSString stringWithFormat:@"%.fkm",distance];
    }
    return show;
}
-(NSString *)showArea{
    if (self.countryId) {
        NSString*string=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"area" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSArray* currentAllAreaItems=[AreaInfo mj_objectArrayWithKeyValuesArray:string.mj_JSONString];
        NSMutableString*areal=[[NSMutableString alloc]init];
        AreaInfo*countryInfo;
        for (AreaInfo*info in currentAllAreaItems) {
            if (info.areaId==self.countryId.integerValue) {
                countryInfo=info;
                [areal appendString:countryInfo.areaName];
                break;
            }
        }
        AreaInfo*provinceInfo;
        if (countryInfo) {
            if (self.provinceId) {
                for (AreaInfo*info in countryInfo.areas) {
                    if (info.areaId==self.provinceId.integerValue) {
                        provinceInfo=info;
                        [areal appendString:@" "];
                        [areal appendString:provinceInfo.areaName];
                        break;
                    }
                }
            }
        }
        AreaInfo*cityInfo;
        if (provinceInfo) {
            if (self.cityId) {
                for (AreaInfo*info in provinceInfo.areas) {
                    if (info.areaId==self.cityId.integerValue) {
                        cityInfo=info;
                        [areal appendString:@" "];
                        [areal appendString:cityInfo.areaName];
                        break;
                    }
                }
            }
        }
        return areal;
    }
    return nil;
}
//根据星座字符串获取显示界面上的星座
+(NSString*)getXingZuoName:(NSString*)result{
    if ([result isEqualToString:@"Aries"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Aries".icanlocalized;
    }else if ([result isEqualToString:@"Taurus"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Taurus".icanlocalized;
    }else if ([result isEqualToString:@"Gemini"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Gemini".icanlocalized;
    }else if ([result isEqualToString:@"Cancer"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Cancer".icanlocalized;
    }else if ([result isEqualToString:@"Leo"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Leo".icanlocalized;
    }else if ([result isEqualToString:@"Virgo"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Virgo".icanlocalized;
    }else if ([result isEqualToString:@"Libra"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Libra".icanlocalized;
    }else if ([result isEqualToString:@"Scorpio"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Scorpio".icanlocalized;
    }else if ([result isEqualToString:@"Sagittarius"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Sagittarius".icanlocalized;
    }else if ([result isEqualToString:@"Capricorn"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Capricorn".icanlocalized;
    }else if ([result isEqualToString:@"Aquarius"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Aquarius".icanlocalized;
    }else if ([result isEqualToString:@"Pisces"]){
        return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Pisces".icanlocalized;
    }
    return @"CircleEditMydDataDetialInfoTableViewCell.Constellation.Pisces".icanlocalized;
}
//根据后台返回的学历字符串 ，显示本地语言的学历字符串
+(NSString*)getShowEducationStringByString:(NSString*)education{
    if ([education isEqualToString:@"PrimarySchool"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.PrimarySchool".icanlocalized;
    }else if ([education isEqualToString:@"JuniorHighSchool"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.JuniorHighSchool".icanlocalized;
    }else if ([education isEqualToString:@"HighSchool"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.HighSchool".icanlocalized;
    }else if ([education isEqualToString:@"Specialist"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.Specialist".icanlocalized;
    }else if ([education isEqualToString:@"Undergraduate"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.Undergraduate".icanlocalized;
    }else if ([education isEqualToString:@"Postgraduate"]) {
        return @"CircleEditMydDataDetialInfoTableViewCell.Education.Postgraduate".icanlocalized;
    }
    return nil;
}
//得到星座的算法
+(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29){
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    NSString*xingzuo=[result stringByAppendingString:@"座"];
    if ([result isEqualToString:@"白羊"]) {
        return @"Aries";
    }else if ([result isEqualToString:@"金牛"]){
        return @"Taurus";
    }else if ([result isEqualToString:@"双子"]){
        return @"Gemini";
    }else if ([result isEqualToString:@"巨蟹"]){
        return @"Cancer";
    }else if ([result isEqualToString:@"狮子"]){
        return @"Leo";
    }else if ([result isEqualToString:@"处女"]){
        return @"Virgo";
    }else if ([result isEqualToString:@"天秤"]){
        return @"Libra";
    }else if ([result isEqualToString:@"天蝎"]){
        return @"Scorpio";
    }else if ([result isEqualToString:@"射手"]){
        return @"Sagittarius";
    }else if ([result isEqualToString:@"摩羯"]){
        return @"Capricorn";
    }else if ([result isEqualToString:@"水瓶"]){
        return @"Aquarius";
    }else if ([result isEqualToString:@"双鱼"]){
        return @"Pisces";
    }
    return xingzuo;
    
}
/// 根据当前显示的学历字符串 显示后台需要的英文字符串
/// @param education 当前显示的字符串
+(NSString*)getEducationStringByString:(NSString*)education{
    if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.PrimarySchool".icanlocalized]) {
        return @"PrimarySchool";
    }else if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.JuniorHighSchool".icanlocalized]) {
        return @"JuniorHighSchool";
    }else if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.HighSchool".icanlocalized]) {
        return @"HighSchool";
    }else if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.Specialist".icanlocalized]) {
        return @"Specialist";
    }else if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.Undergraduate".icanlocalized]) {
        return @"Undergraduate";
    }else if ([education isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.Education.Postgraduate".icanlocalized]) {
        return @"Postgraduate";
    }
    return nil;
}
@end
