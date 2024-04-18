//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleNetRequestManager.m
- Description:
- Function List:
*/
        

#import "C2CNetRequestManager.h"
#import "AFNetworking.h"
@interface C2CNetRequestManager ()
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

@implementation C2CNetRequestManager
+ (instancetype)shareManager {
    static C2CNetRequestManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[C2CNetRequestManager alloc] init];
        api.manager=[AFHTTPSessionManager manager];
        api.manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        api.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        api.manager.requestSerializer.timeoutInterval = 5;
        
    });
    return api;
}
/**
 发送普通的网络请求
 
 @param request baseRequest
 @param responseClass 响应的内容
 @param contentClass 内容所包含的model
 @param success 成功回调
 @param failure 失败回调
 */
-(void)startRequest:(C2CBaseRequest *)request
      responseClass:(Class)responseClass contentClass:(Class)contentClass
            success:(SuccessCallback)success
            failure:(FailureCallback)failure{
    
    [self startIndicator];
    request.pathUrlString=request.pathUrlString.netUrlEncoded;
    self. manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString * requestMethod;
    switch (request.requestMethod) {
        case RequestMethod_Get:
            requestMethod=@"GET";
            break;
        case RequestMethod_Put:
            requestMethod=@"PUT";
            break;
        case RequestMethod_Post:
            requestMethod=@"POST";
            break;
        case RequestMethod_Patch:
            requestMethod=@"PATCH";
            break;
        case RequestMethod_Delete:
            requestMethod=@"DELETE";
            break;
        default:
            break;
    }
    NSMutableURLRequest*req;
    if (request.requestMethod==RequestMethod_Get) {
        req=[[AFHTTPRequestSerializer serializer]requestWithMethod:requestMethod URLString:request.pathUrlString parameters:request.parameters error:nil];
    }else{
        req=[[AFHTTPRequestSerializer serializer]requestWithMethod:requestMethod URLString:request.pathUrlString parameters:nil error:nil];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData*bodyData;
        if (request.parameters) {
            if ([request.parameters isKindOfClass:[NSString class]]) {
                bodyData=[request.parameters dataUsingEncoding:NSUTF8StringEncoding];
            }else if ([request.parameters isKindOfClass:[NSArray class]]){
                bodyData= [NSJSONSerialization dataWithJSONObject:request.parameters options:NSJSONWritingPrettyPrinted error:nil];
            } else{
                bodyData=[request mj_JSONData];
            }
            [req setHTTPBody:bodyData];
        }
    }
    if (request.isPrivatAPi) {
        [req setValue:C2CUserManager.shared.token forHTTPHeaderField:@"token"];
    }
    [req setValue:@"ican" forHTTPHeaderField:@"app-id"];
    
    req.timeoutInterval=request.timeoutInterval;
    NSURLSessionDataTask*reqe =[self.manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self stopIndicator];
        [self _operateSuccessWithNSURLResponse:response error:error responseObject:responseObject responseClass:responseClass contentClass:contentClass success:success failure:failure baserRequest:request nSMutableURLRequest:req];
    }];
    [reqe resume];
}
-(void)_operateSuccessWithNSURLResponse:(NSURLResponse*)response error:(NSError *)error responseObject:(id)responseObject responseClass:(Class)responseClass  contentClass:(Class)contentClass success:(SuccessCallback)success failure:(FailureCallback)failure baserRequest:(C2CBaseRequest*)request nSMutableURLRequest:(NSMutableURLRequest*)nsMutableURLRequest {
    NSHTTPURLResponse*httpResponse=(NSHTTPURLResponse*)response;
    if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"2"]) {
        id ftResponse=nil;
        if ([responseClass isEqual:[NSString class]]) {
            ftResponse =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        }else if ([responseClass isEqual:[NSArray class]]){
            ftResponse = [contentClass mj_objectArrayWithKeyValuesArray:responseObject];
        }else{
            ftResponse =[responseClass mj_objectWithKeyValues:responseObject];
        }
        success(ftResponse);
    } else if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"4"]) {
        NetworkErrorInfo*info=[NetworkErrorInfo mj_objectWithKeyValues:responseObject];
        failure(error,info,httpResponse.statusCode);
        
    }else{
        NetworkErrorInfo*info=[NetworkErrorInfo mj_objectWithKeyValues:responseObject];
        failure(error,info,httpResponse.statusCode);
    }
    [self _operateLogRequestWithNSHTTPURLResponse:httpResponse error:error responseObject:responseObject baserRequest:request responseClass:responseClass contentClass:(Class)contentClass success:success failure:failure nSMutableURLRequest:nsMutableURLRequest];
    
}
-(void)_operateLogRequestWithNSHTTPURLResponse:(NSHTTPURLResponse*)response error:(NSError *)error responseObject:(id)responseObject baserRequest:(C2CBaseRequest*)request responseClass:(Class)responseClass contentClass:(Class)contentClass  success:(SuccessCallback)success failure:(FailureCallback)failure nSMutableURLRequest:(NSMutableURLRequest*)nsMutableURLRequest{
    [self _logCurlStringWithDict:nsMutableURLRequest.allHTTPHeaderFields request:request];
    [self _logHttpResultWithRequest:request responseObject:responseObject responseClass:responseClass contentClass:contentClass httpResponse:response httpHeadDic:nsMutableURLRequest.allHTTPHeaderFields];
    
    
}
-(NSString*)logResponesDataWith:(id)responseObject responseClass:(Class)responseClass contentClass:(Class)contentClass hTTPURLResponse:(NSHTTPURLResponse*)httpResponse{
    NSMutableString * contentStr=[[NSMutableString alloc]initWithString:@""];
    NSString * result=@"";
    if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"2"]) {
        return [responseObject mj_JSONString];
    } else if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"4"]) {
        NetworkErrorInfo*info=[NetworkErrorInfo mj_objectWithKeyValues:responseObject];
        result= [info mj_JSONString];
        [contentStr appendString:[NSString stringWithFormat:@"请求出错:\n%@\n",result]];
    }else{
        NetworkErrorInfo*info=[NetworkErrorInfo mj_objectWithKeyValues:responseObject];
        result= [info mj_JSONString];
        [contentStr appendString:[NSString stringWithFormat:@"请求出错:\n%@\n",result]];
    }
    return  contentStr;
}
-(void)_logHttpResultWithRequest:(C2CBaseRequest*)request responseObject:(id)responseObject responseClass:(Class)responseClass contentClass:(Class)contentClass httpResponse:(NSHTTPURLResponse*)response httpHeadDic:(NSDictionary*)headDict{
    NSString * requestMethod;
    switch (request.requestMethod) {
        case RequestMethod_Get:
            requestMethod=@"GET";
            break;
        case RequestMethod_Put:
            requestMethod=@"PUT";
            
            break;
        case RequestMethod_Post:
            requestMethod=@"POST";
            break;
        case RequestMethod_Patch:
            requestMethod=@"PATCH";
            break;
        case RequestMethod_Delete:
            requestMethod=@"DELETE";
            break;
        default:
            break;
    }
    NSMutableString * contentStr=[[NSMutableString alloc]init];
    [contentStr appendString:[NSString stringWithFormat:@"请求头:%@\n",headDict]];
    if (response) {
        [contentStr appendString:[NSString stringWithFormat:@"请求http状态码:%ld\n",(long)(long)response.statusCode]];
    }
    [contentStr appendString:[NSString stringWithFormat:@"请求名称:%@ **** ",request.requestName]];
    [contentStr appendString:[NSString stringWithFormat:@"请求方法:%@\n",requestMethod]];
    [contentStr appendString:[NSString stringWithFormat:@"请求url:%@\n",request.pathUrlString]];
    if (request.parameters) {
        [contentStr appendString:[NSString stringWithFormat:@"请求参数:%@\n",request.parameters]];
    }
   NSString*resutl= [self logResponesDataWith:responseObject responseClass:responseClass contentClass:contentClass hTTPURLResponse:response];
    if (responseClass) {
        [contentStr appendString:[NSString stringWithFormat:@"请求返回解析对象%@\n",NSStringFromClass(responseClass)]];
    }
    [contentStr appendString:[NSString stringWithFormat:@"\n%@",resutl]];
    DDLogDebug(@"%@",contentStr);
    
}
-(void)_logCurlStringWithDict:(NSDictionary*)headDict request:(C2CBaseRequest*)request{
    NSMutableString*curlStr=[[NSMutableString alloc]init];
    [curlStr appendString:@"curl "];
    [curlStr appendString:@"'"];
    [curlStr appendString:request.pathUrlString];
    if (request.requestMethod==RequestMethod_Get){
        if (request.parameters) {
            [curlStr appendString:@"?"];
            NSDictionary*dict=(NSDictionary*)request.parameters;
            NSArray*keys=[dict allKeys];
            for (int i=0; i<keys.count; i++) {
                if (i!=0) {
                    [curlStr appendString:@"&"];
                }
                NSString*key=keys[i];
                [curlStr appendFormat:@"%@=%@",key,[dict objectForKey:key]];
            }
        }
    }
    [curlStr appendString:@"'"];
    for (NSString*key in headDict.allKeys) {
        NSString*value=[headDict objectForKey:key];
        [curlStr appendString:@" -H "];
        [curlStr appendString:@"'"];
        [curlStr appendString:key];
        [curlStr appendString:@":"];
        [curlStr appendString:value];
        [curlStr appendString:@"'"];
    }
    if (request.requestMethod==RequestMethod_Post) {
        [curlStr appendString:@" -X POST"];
        
    }else if (request.requestMethod==RequestMethod_Delete){
        [curlStr appendString:@" -X DELETE"];
    }else if (request.requestMethod==RequestMethod_Put){
        [curlStr appendString:@" -X PUT"];
    }else if (request.requestMethod==RequestMethod_Get){
        DDLogDebug(@"curl=%@",curlStr);
        return;
    }
    if (request.parameters) {
        if ([request.parameters isKindOfClass:[NSString class]]) {
            [curlStr appendString:@" -d "];
            [curlStr appendString:@"'"];
            [curlStr appendString:[NSString stringWithFormat:@"%@",[request.parameters mj_JSONString]]];
            [curlStr appendString:@"'"];
        }else if ([request.parameters isKindOfClass:[NSDictionary class]]){
            [curlStr appendString:@" -d "];
            [curlStr appendString:@"'"];
            [curlStr appendString:[NSString stringWithFormat:@"%@",[request.parameters mj_JSONString]]];
            [curlStr appendString:@"'"];
        }
        
    }
    
    DDLogDebug(@"curl=%@",curlStr);
}


- (void)startIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
}

- (void)stopIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
}
@end
