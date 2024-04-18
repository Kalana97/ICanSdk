//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/6/2021
- File name:  CircleCacheUserInfo.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
@class HobbyTagsInfo;
@class AreaInfo;
@class UploadImgModel;
NS_ASSUME_NONNULL_BEGIN
static NSString *  const KWCCircleUserInfoTable= @"CircleUserInfo";
@interface CircleUserInfo : NSObject
@property (nonatomic,copy,nullable) NSString * userId;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong ,nullable) NSNumber* areaId;
@property (nonatomic, strong) NSString * avatar;
/**
 待审核头像
 */
@property(nonatomic, copy) NSString *checkAvatar;
/**
 待审核照片    
 */
@property (nonatomic, strong) NSArray * checkPhotos;
@property (nonatomic, strong ,nullable) NSNumber* bodyHeight;
@property (nonatomic, strong ,nullable) NSNumber* bodyWeight;
@property (nonatomic, strong ,nullable) NSNumber* cityId;
@property (nonatomic, strong) NSString * constellation;
@property (nonatomic, strong ,nullable) NSNumber* countryId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong,nullable) NSString * dateOfBirth;
@property (nonatomic, strong,nullable) NSString * education;
//性别,可用值:Male,Female,Unknown
@property (nonatomic, strong,nullable) NSString * gender;
@property (nonatomic, assign) NSInteger icanId;
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
@property (nonatomic, strong ,nullable) NSNumber* provinceId;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * updateTime;
/** 待审核的签名 */
@property(nonatomic, copy) NSString *checkSignature;
/** 背景图片 */
@property(nonatomic, copy) NSString *background;
/** 待审核的背景图片 */
@property(nonatomic, copy) NSString *checkBackground;
///是否注销
@property(nonatomic, assign) BOOL deleted;
/** 单位千米 */
@property(nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSArray<HobbyTagsInfo*> * userHobbyTags;
/**
 是否不喜欢
 */
@property(nonatomic, assign) BOOL isDislike;
/**
 是否喜欢我
 */
@property(nonatomic, assign) BOOL isLikeMe;
/**
 是否我喜欢
 */
@property(nonatomic, assign) BOOL isMeLike;
/** 已经收费发布  */
@property(nonatomic, assign) BOOL publish;
/** 是否启用 */
@property(nonatomic, assign) BOOL enable;
/** 是否约 */
@property(nonatomic, assign) BOOL yue;
@property(nonatomic, strong) NSArray *photoWalls;
//手动添加的数据
/**
 用来保存用户当前选择的地区
 */
@property(nonatomic, strong) NSArray<AreaInfo*> *currentSelectItems;

@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectImgs;
/**
 需要显示的距离
 */
@property(nonatomic, copy) NSString *showDistance;
@property(nonatomic, copy) NSString *showArea;

/// 根据星座字符串获取显示界面上的星座
/// @param result 后台返回的星座字符串
+(NSString*)getXingZuoName:(NSString*)result;

/// 根据后台返回的学历字符串 ，显示本地语言的学历字符串
/// @param education 后台返回的学历字符串
+(NSString*)getShowEducationStringByString:(NSString*)education;

/// 到星座的算法
/// @param m 月
/// @param d 日
+(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d;
/// 根据当前显示的学历字符串 显示后台需要的英文字符串
/// @param education 当前显示的字符串
+(NSString*)getEducationStringByString:(NSString*)education;

@end
NS_ASSUME_NONNULL_END
