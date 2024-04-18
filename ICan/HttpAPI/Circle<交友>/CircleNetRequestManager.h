//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleNetRequestManager.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
#import "CircleBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,DownloadTye){
    DownloadTye_AllArea,
};
typedef void(^SuccessCallback)(id response);
typedef void(^FailureCallback)(NSError *error,NetworkErrorInfo*info,NSInteger statusCode);
@interface CircleNetRequestManager : NSObject
+ (instancetype)shareManager;
/**
 发送普通的网络请求

 @param request baseRequest
 @param responseClass 响应的内容
 @param contentClass 内容所包含的model
 @param success 成功回调
 @param failure 失败回调
 */
-(void)startRequest:(CircleBaseRequest *)request
             responseClass:(Class)responseClass contentClass:(Class)contentClass
                   success:(SuccessCallback)success
                   failure:(FailureCallback)failure;
-(void)downloadWithUrl:(NSString*)url downloadTye:(DownloadTye)downloadTye path:(NSString*)path success:(void (^)(NSURL *url,NSString*path))success failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
