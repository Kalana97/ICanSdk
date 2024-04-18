/**
- Copyright © 2019 LIMAOHUYU. All rights reserved.
- AUthor: Created  by DZL on 2019/9/5
- System_Version_MACOS: 10.14
- ChatIM
- File name:  BaseRequest.h
- Description: 作为基础的请求类 json<->model
- Function List: 
- History:
*/
        
/** HTTPS请求方式 */
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethod_Post,
    RequestMethod_Put,
    RequestMethod_Patch,
    RequestMethod_Get,
    RequestMethod_Delete,
};

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseRequest : NSObject
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
@interface ListRequest : BaseRequest
@property(nonatomic,strong,nullable) NSNumber *page;
@property(nonatomic,strong,nullable) NSNumber *size;
@end


NS_ASSUME_NONNULL_END
