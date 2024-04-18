//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 14/4/2020
 - File name:  SystemResponse.m
 - Description:
 - Function List:
 */


#import "SystemResponse.h"

@implementation SystemResponse

@end

@implementation PrivateParameterInfo

@end

@implementation VersionsInfo

@end
@implementation AnnouncementsInfo

@end
@implementation GetPublicStartInfo
/**
 保存数据时调用
 
 在该方法中声明哪些属性需要保存
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.linkUrl forKey:@"linkUrl"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeInteger:self.startTime forKey:@"startTime"];
    [aCoder encodeInteger:self.endTime forKey:@"endTime"];
    [aCoder encodeInteger:self.closeTime forKey:@"closeTime"];
    [aCoder encodeObject:self.jumpType forKey:@"jumpType"];
    
}

/**
 解析数据时调用
 
 该方法中会获取需要读取的数据
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.linkUrl = [aDecoder decodeObjectForKey:@"linkUrl"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.startTime = [aDecoder decodeIntegerForKey:@"startTime"];
        self.endTime = [aDecoder decodeIntegerForKey:@"endTime"];
        self.closeTime = [aDecoder decodeIntegerForKey:@"closeTime"];
        self.jumpType = [aDecoder decodeObjectForKey:@"jumpType"];
        
        
    }
    return self;
}
+(BOOL)supportsSecureCoding{

    return YES;

}
@end

