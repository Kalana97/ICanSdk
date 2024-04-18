//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 15/10/2019
- File name:  GroupResponse.m
- Description:
- Function List:
*/
        

#import "GroupResponse.h"

@implementation GroupResponse

@end

@implementation GroupDetailInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}

@end

@implementation CreateGroupInfo


@end
@implementation GroupUserInfo


@end


@implementation GroupUserListInfo

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"object":[GroupUserInfo class]};
}


@end


