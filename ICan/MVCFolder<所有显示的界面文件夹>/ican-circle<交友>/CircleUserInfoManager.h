//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleUserInfoManager.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleUserInfoManager : NSObject
+ (instancetype)shared;
/** 用户的交友ID */
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, assign) BOOL enable;
/** 用户的聊天ID */
@property(nonatomic, copy) NSString *icanId;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, strong) NSString * avatar;
@property(nonatomic, copy) NSString *checkAvatar;
@property (nonatomic, assign) NSInteger bodyWeight;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString * constellation;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * dateOfBirth;
@property (nonatomic, strong) NSString * education;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * lastLoginTime;
@property (nonatomic, assign) NSInteger latitude;
@property (nonatomic, assign) NSInteger longitude;
@property (nonatomic, assign) BOOL newUser;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) NSInteger numberId;
@property (nonatomic, strong) NSArray * photos;
@property (nonatomic, strong) NSString * poiAddress;
@property (nonatomic, assign) NSInteger professionId;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * updateTime;
@property(nonatomic, assign) BOOL yue;
@property (nonatomic, strong) NSArray * userHobbyTags;
//用户的职业
@property(nonatomic, strong) NSArray<ProfessionInfo*>* professionArray;
- (void)removeObjectWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
