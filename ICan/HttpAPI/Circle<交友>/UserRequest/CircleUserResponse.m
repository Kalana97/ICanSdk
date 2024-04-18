//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserResponse.m
- Description:
- Function List:
*/
        

#import "CircleUserResponse.h"

@implementation CircleUserResponse

@end

@implementation HobbyTagsInfo
-(NSString *)showName{
    NSString*languages = [BaseSettingManager getCurrentLanguages];
    if ([languages hasPrefix:@"zh"]) {
        return self.name;;
    }else if ([languages isEqualToString:@"en"]){
        if (self.nameEn.length>0) {
            return self.nameEn;;
        }
        return self.name;
    }
    return self.name;
}
@end

@implementation ProfessionInfo
-(NSString *)showProfessionName{
    NSString*languages = [BaseSettingManager getCurrentLanguages];
    if ([languages hasPrefix:@"zh"]) {
        return self.professionName;;
    }else if ([languages isEqualToString:@"en"]){
        if (self.professionNameEn.length>0) {
            return self.professionNameEn;;
        }
        return self.professionName;
    }
    return self.professionName;;
}
@end
@implementation AreaInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"areas":[AreaInfo class]};
}
@end

@implementation LikeMeOrMeLikeCountInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[CircleUserInfo class]};
}
@end

@implementation CircleRecommendListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[CircleUserInfo class]};
}
@end
@implementation CircleILikeListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[CircleUserInfo class]};
}
@end

@implementation UserGoodInfo

@end
@implementation UsersonlineInfo

@end
@implementation PackagesTitleInfo
-(NSString *)showLocaltitle{
    NSString*languages = [BaseSettingManager getCurrentLanguages];
    if ([languages hasPrefix:@"zh"]) {
        return self.title;;
    }else if ([languages isEqualToString:@"en"]){
        if (self.titleEn.length>0) {
            return self.titleEn;;
        }
        return self.title;
    }
    return self.title;
}
-(NSString *)showLocalPackageName{
    NSString*languages = [BaseSettingManager getCurrentLanguages];
    if ([languages hasPrefix:@"zh"]) {
        return self.packageName;;
    }else if ([languages isEqualToString:@"en"]){
        if (self.packageNameEn.length>0) {
            return self.packageNameEn;;
        }
        return self.packageName;
    }
    return self.packageName;
}
@end
@implementation PackagesInfo

@end

@implementation MyPackagesInfo

@end
@implementation MyPackagesListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[MyPackagesInfo class]};
}
@end
@implementation CheckMyPackagesInfo

@end
@implementation ConsumptionRecordsInfo


@end
@implementation ConsumptionRecordsListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[ConsumptionRecordsInfo class]};
}
@end

@implementation PayMyPackagesInfo


@end
@implementation GetCircleDislikeMeInfo


@end
@implementation PostCircleReleaseBuyInfo


@end
@implementation PostReleaseMoneyInfo


@end
@implementation PhotoWallInfo


@end

@implementation PhotoWallListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[PhotoWallInfo class]};
}
@end
