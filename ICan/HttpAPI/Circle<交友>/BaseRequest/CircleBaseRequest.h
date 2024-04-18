//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleBaseRequest.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
/** HTTPS请求方式 */
NS_ASSUME_NONNULL_BEGIN

@interface CircleBaseRequest : NSObject
/**请求的域名*/
@property (nonatomic,copy)   NSString *  baseUrlString;
/**请求的地址*/
@property (nonatomic,copy)   NSString *  pathUrlString;
/** 请求的方法 */
@property (nonatomic,assign)  RequestMethod requestMethod;
/** 超时时间 */
@property (nonatomic,assign)  NSTimeInterval timeoutInterval;
/** 请求的接口名字 */
@property (nonatomic,copy)    NSString *  requestName;
/** 每个request对应的任务 */
@property (nonatomic,strong)  NSURLSessionDataTask * dataTask;
/** 是否是httpdata返回 默认就是NO  默认是json返回 */
@property (nonatomic,assign)  BOOL isHttpResponse;
/** 是否是body传递参数 */
@property (nonatomic, assign) BOOL isBodyParameter;
/** 请求参数 */
@property (nonatomic)         id  parameters;

@property (nonatomic,copy,nullable) NSString * ID;
@property (nonatomic,assign) bool isPrivatAPi;
+(instancetype _Nonnull )request;

@end
@interface CircleListRequest : CircleBaseRequest
@property(nonatomic, strong) NSNumber *current;
@property(nonatomic, strong) NSNumber *size;
@end
/**
 getSecurityToken
 /api/oss/securityToken
 */
@interface GetCircleOssRequest:BaseRequest
@end
NS_ASSUME_NONNULL_END
//@property(nonatomic, assign) NSInteger current;
///** 一共有多少页 */
//@property(nonatomic, assign) NSInteger pages;
//@property(nonatomic, strong) NSArray  *records;
//@property(nonatomic, assign) NSInteger size;
//@property(nonatomic, assign) NSInteger total;
