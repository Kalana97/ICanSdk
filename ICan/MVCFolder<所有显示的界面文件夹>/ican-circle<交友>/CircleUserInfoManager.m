//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserInfoManager.m
- Description:
- Function List:
*/
        

#import "CircleUserInfoManager.h"

@implementation CircleUserInfoManager
+ (instancetype)shared{
    static CircleUserInfoManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[CircleUserInfoManager alloc] init];
    });
    return api;
}
-(void)setUserId:(NSString *)userId{
    [self setUserDefaultsWithObject:userId key:@"circleuserId"];
}
-(NSString *)userId{
    return [self gainObjectWithKey:@"circleuserId"];
}
-(void)setToken:(NSString *)token{
    [self setUserDefaultsWithObject:token key: @"circletoken"];
}
-(NSString *)token{
    return [self gainObjectWithKey:@"circletoken"];
}

-(void)setAge:(NSInteger)age{
    [self setUserDefaultsWithObject:@(age) key:@"circleage"];
}
-(NSInteger)age{
    NSNumber*age=[self gainObjectWithKey:@"circleage"];
    return age.integerValue;
}
-(void)setAreaId:(NSInteger)areaId{
    [self setUserDefaultsWithObject:@(areaId) key:@"circleareaId"];
}
-(NSInteger)areaId{
    NSNumber*areaId=[self gainObjectWithKey:@"circleareaId"];
    return areaId.integerValue;
}
-(void)setNickname:(NSString *)nickname{
    [self setUserDefaultsWithObject:nickname key:@"nickname"];
}
-(NSString *)nickname{
    return [self gainObjectWithKey:@"nickname"];
}
- (void)setAvatar:(NSString *)avatar{
    [self setUserDefaultsWithObject:avatar key:@"circleavatar"];
}
-(NSString *)avatar{
    return [self gainObjectWithKey:@"circleavatar"];
}
-(void)setCheckAvatar:(NSString *)checkAvatar{
    [self setUserDefaultsWithObject:checkAvatar key:@"checkAvatar"];
}
-(NSString *)checkAvatar{
    return [self gainObjectWithKey:@"checkAvatar"];
}
-(void)setDateOfBirth:(NSString *)dateOfBirth{
    [self setUserDefaultsWithObject:dateOfBirth key:@"circledateOfBirth"];
}
-(NSString *)dateOfBirth{
    return [self gainObjectWithKey:@"circledateOfBirth"];
}
-(void)setEnable:(BOOL)enable{
    [self setUserDefaultsWithObject:@(enable) key:@"enable"];
}
-(BOOL)enable{
    return [[self gainObjectWithKey:@"enable"] boolValue];
}
-(void)setYue:(BOOL)yue{
    [self setUserDefaultsWithObject:@(yue) key:@"yue"];
}
-(BOOL)yue{
    return [[self gainObjectWithKey:@"yue"] boolValue];
}
-(void)setUserDefaultsWithObject:(id)object key:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}
- (id)gainObjectWithKey:(NSString *)key {
    id object = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return object;
}
- (void)removeObjectWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
