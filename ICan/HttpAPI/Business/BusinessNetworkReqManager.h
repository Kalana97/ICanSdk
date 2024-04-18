//
//  BusinessNetworkReqManager.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessBaseRequest.h"
#import "BussinessInfoManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessCallback)(id response);
typedef void(^FailureCallback)(NSError *error,NetworkErrorInfo*info,NSInteger statusCode);
@interface BusinessNetworkReqManager : NSObject
+ (instancetype)shareManager;
-(void)startRequest:(BusinessBaseRequest *)request
             responseClass:(Class)responseClass contentClass:(Class)contentClass
                   success:(SuccessCallback)success
                   failure:(FailureCallback)failure;
-(void)downloadWithUrl:(NSString*)url downloadTye:(DownloadTye)downloadTye path:(NSString*)path success:(void (^)(NSURL *url,NSString*path))success failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
