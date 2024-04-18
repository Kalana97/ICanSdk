//
//  BussinessInfoManager.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-08.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BussinessInfoManager.h"

@implementation BussinessInfoManager
+ (instancetype)shared{
    static BussinessInfoManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[BussinessInfoManager alloc] init];
    });
    return api;
}

-(void)setToken:(NSString *)token{
    [self setUserDefaultsWithObject:token key: @"bussinesstoken"];
}

-(NSString *)token{
    return [self gainObjectWithKey:@"bussinesstoken"];
}

-(void)setArea:(NSString *)area{
    [self setUserDefaultsWithObject:area key:@"area"];
}

-(NSString *)area{
    return [self gainObjectWithKey:@"area"];
}

-(void)setAreaEn:(NSString *)areaEn{
    [self setUserDefaultsWithObject:areaEn key:@"areaEn"];
}

-(NSString *)areaEn{
    return [self gainObjectWithKey:@"areaEn"];
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

-(void)setBusinessName:(NSString *)businessName{
    [self setUserDefaultsWithObject:businessName key:@"businessName"];
}

-(NSString *)businessName{
    return [self gainObjectWithKey:@"businessName"];
}

-(void)setBusinessId:(NSString *)businessId{
    [self setUserDefaultsWithObject:businessId key:@"businessId"];
}

-(NSString *)businessId{
    return [self gainObjectWithKey:@"businessId"];
}

-(void)setEnable:(BOOL)enable{
    [self setUserDefaultsWithObject:@(enable) key:@"enable"];
}

-(BOOL)enable{
    return [[self gainObjectWithKey:@"enable"] boolValue];
}

-(void)setDeleted:(BOOL)deleted{
    [self setUserDefaultsWithObject:@(deleted) key:@"deleted"];
}

-(BOOL)deleted{
    return [[self gainObjectWithKey:@"deleted"] boolValue];
}

-(void)setIcanId:(NSInteger)icanId{
    [self setUserDefaultsWithObject:@(icanId) key:@"iCanId"];
}

-(NSInteger )icanId{
    return [[self gainObjectWithKey:@"iCanId"] integerValue];
}

-(void)setUserDefaultsWithObject:(id)object key:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
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
