//
//  BusinessBaseRequest.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessBaseRequest : NSObject
@property (nonatomic, copy) NSString *baseUrlString;
@property (nonatomic, copy) NSString *pathUrlString;
@property (nonatomic, assign) RequestMethod requestMethod;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, copy) NSString *requestName;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign)  BOOL isHttpResponse;
@property (nonatomic, assign) BOOL isBodyParameter;
@property (nonatomic) id  parameters;
@property (nonatomic, copy, nullable) NSString *ID;
@property (nonatomic, assign) bool isPrivatAPi;
+(instancetype _Nonnull )request;
@end

@interface BusinessListRequest : BusinessBaseRequest
@property(nonatomic, strong) NSNumber *current;
@property(nonatomic, strong) NSNumber *size;
@end

@interface PutBusinessUserPOIRequest :BusinessBaseRequest
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, copy, nullable) NSString *poiAddress;
@end

NS_ASSUME_NONNULL_END
