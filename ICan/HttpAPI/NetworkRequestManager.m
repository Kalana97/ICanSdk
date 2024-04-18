//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/9
 - System_Version_MACOS: 10.14
 - ICan
 - File name:  NetworkRequestManager.m
 - Description:
 - Function List:
 - History:
 */


#import "NetworkRequestManager.h"
#import "AFNetworking.h"
#import "ChatModel.h"
@interface NetworkRequestManager ()
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

@implementation NetworkRequestManager
+ (instancetype)shareManager {
    static NetworkRequestManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[NetworkRequestManager alloc] init];
        api.manager=[AFHTTPSessionManager manager];
        api.manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        api.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        api.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded",@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil, nil];
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
-(void)startRequest:(BaseRequest *)request
      responseClass:(Class)responseClass contentClass:(Class)contentClass
            success:(SuccessCallback)success
            failure:(FailureCallback)failure{
    [self startIndicator];
    //URL编码 为了防止中文的URL奔溃情况
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
    req.timeoutInterval=request.timeoutInterval;
    NSDictionary*dict=[self settingHeaderFieldWithBaseRequest:request];
    for (NSString*key in dict.allKeys) {
        [req setValue:dict[key] forHTTPHeaderField:key];
    }
    request.dataTask =[self.manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self stopIndicator];
        [self _operateSuccessWithNSURLResponse:response error:error responseObject:responseObject responseClass:responseClass contentClass:contentClass success:success failure:failure baserRequest:request nSMutableURLRequest:req];
    }];
    [request.dataTask resume];
}
-(void)_operateSuccessWithNSURLResponse:(NSURLResponse*)response error:(NSError *)error responseObject:(id)responseObject responseClass:(Class)responseClass  contentClass:(Class)contentClass success:(SuccessCallback)success failure:(FailureCallback)failure baserRequest:(BaseRequest*)request nSMutableURLRequest:(NSMutableURLRequest*)nsMutableURLRequest {
    if(response) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"2"]) {
            id ftResponse = nil;
            if ([responseClass isEqual:[NSString class]]) {
                ftResponse = [responseClass mj_objectWithKeyValues:responseObject];
                if(ftResponse == nil) {
                    ftResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                }
            }else if ([responseClass isEqual:[NSArray class]]) {
                ftResponse = [contentClass mj_objectArrayWithKeyValuesArray:responseObject];
            }else{
                ftResponse = [responseClass mj_objectWithKeyValues:responseObject];
            }
            success(ftResponse);
        } else if ([[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]hasPrefix:@"4"]) {//请求已经成功 但是有可能是参数错误返回的失败
            NetworkErrorInfo *info = [NetworkErrorInfo mj_objectWithKeyValues:responseObject];
            failure(error,info,httpResponse.statusCode);
            
        }else{
            NetworkErrorInfo *info = [NetworkErrorInfo mj_objectWithKeyValues:responseObject];
            failure(error,info,httpResponse.statusCode);
            //手动取消任务
            if (error.code == NSURLErrorCancelled) {
                
            }else{
                
            }
            
        }
        [self _operateLogRequestWithNSHTTPURLResponse:httpResponse error:error responseObject:responseObject baserRequest:request responseClass:responseClass contentClass:(Class)contentClass success:success failure:failure nSMutableURLRequest:nsMutableURLRequest];
    }
    
}
-(void)_operateLogRequestWithNSHTTPURLResponse:(NSHTTPURLResponse*)response error:(NSError *)error responseObject:(id)responseObject baserRequest:(BaseRequest*)request responseClass:(Class)responseClass contentClass:(Class)contentClass  success:(SuccessCallback)success failure:(FailureCallback)failure nSMutableURLRequest:(NSMutableURLRequest*)nsMutableURLRequest{
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
-(void)_logHttpResultWithRequest:(BaseRequest*)request responseObject:(id)responseObject responseClass:(Class)responseClass contentClass:(Class)contentClass httpResponse:(NSHTTPURLResponse*)response httpHeadDic:(NSDictionary*)headDict{
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
-(void)_logCurlStringWithDict:(NSDictionary*)headDict request:(BaseRequest*)request{
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

- (NSMutableDictionary*)settingHeaderFieldWithBaseRequest:(BaseRequest *)request {
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setValue:[BaseSettingManager sharedManager].userAgent forKey:@"User-Agent"];
    NSArray *arLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *strLang = [arLanguages objectAtIndex:0];
    if ([strLang containsString:@"zh-Hans"]) {
        strLang=@"zh-Hans";
    }else if ([strLang containsString:@"zh-Hant"]){
        strLang=@"zh-Hant";
    }else if ([strLang containsString:@"vi"]){
        strLang=@"vi";
    }else if ([strLang containsString:@"tr"]){
        strLang=@"tr";
    }
    [dict setValue:strLang forKey:@"Accept-Language"];
    [dict setValue:@"application/json" forKey:@"Content-Type"];
    [dict setValue:@"application/json" forKey:@"Accept"];
    NSDate*date=[NSDate date];
    NSTimeInterval timeinterval=[date timeIntervalSince1970];
    NSString * timeStr=[NSString stringWithFormat:@"%.f",timeinterval*1000];
    [dict setValue:timeStr forKey:@"X-Timestamp"];
    NSMutableString * stStr=[[NSMutableString alloc]init];
    [stStr appendString:timeStr];
    [stStr appendString:kRSAPublicKey];
    [stStr appendString:[BaseSettingManager sharedManager].userAgent];
    NSString *endPoint = [request.pathUrlString substringFromIndex:request.baseUrlString.length];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\?.*" options:0 error:nil];
    NSString *filteredEndPoint = [regex stringByReplacingMatchesInString:endPoint options:0 range:NSMakeRange(0, [endPoint length]) withTemplate:@""];
    [stStr appendString: filteredEndPoint];
    [dict setValue:[stStr MD5String] forKey:@"X-ST"];
    if (request.isPrivatAPi) {
        [dict setValue:[UserInfoManager sharedManager].token forKey:@"Token"];
    }
    return dict;
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
-(void)downloadVideoWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure{
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=200.0f;
    [DZFileManager creatDirectoryWithPath:MessageVideoCache(chatmodel.chatID)];
    NSString *downloadFilePath = [MessageVideoCache(chatmodel.chatID) stringByAppendingPathComponent:chatmodel.fileCacheName];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:chatmodel.fileServiceUrl]];
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            chatmodel.downloadState=2;
            chatmodel.completedUnitCount=downloadProgress.completedUnitCount;
            chatmodel.totalUnitCount=downloadProgress.totalUnitCount;
            downloadProgressBar(chatmodel);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        chatmodel.hasRead=YES;
        chatmodel.downloadState=1;
        if (error) {
            failure(error);
        }else{
            DDLogInfo(@"下载地址是=%@",response.URL.absoluteString);
            DDLogInfo(@"下载成功，缓存地址是=%@",filePath);
            success(chatmodel);
        }
        
    }];
    
    //执行Task
    [download resume];
}
-(void)downloadCollectFileWithUrl:(NSString *)fileUrl downloadProgress:(void (^)(NSString *))downloadProgress success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=100.0f;
    [DZFileManager creatDirectoryWithPath:MessageCollectFileCache];
    NSString *downloadFilePath = [[MessageCollectFileCache stringByAppendingPathComponent:[fileUrl md5]]stringByAppendingString:[NSString stringWithFormat:@".%@",fileUrl.pathExtension]];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl.netUrlEncoded]];
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success(downloadFilePath);
        
    }];
    
    //执行Task
    [download resume];
}
-(void)downloadReplyFileWithReplayMessageInfo:(ReplyMessageInfo *)replyInfo downloadProgress:(void (^)(NSString *))downloadProgressBar success:(void (^)(ReplyMessageInfo *))success failure:(void (^)(NSError *))failure{
    FileMessageInfo*info=[FileMessageInfo mj_objectWithKeyValues:replyInfo.jsonMessage];
    NSString* fileCacheName=[NSString stringWithFormat:@"%@.%@",[info.fileUrl MD5String],info.fileUrl.pathExtension];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=100.0f;
    NSString*cacheId=replyInfo.groupId?:replyInfo.userId;
    [DZFileManager creatDirectoryWithPath:MessageFileCache(cacheId)];
    NSString *downloadFilePath = [MessageFileCache(cacheId) stringByAppendingPathComponent:fileCacheName];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:info.fileUrl.netUrlEncoded]];
    
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success(replyInfo);
        
        
    }];
    
    //执行Task
    [download resume];
}
-(void)downloadFileWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure{
    NSString*fileCacheName=[[NSString getCFUUID]stringByAppendingFormat:@".%@",chatmodel.showFileName.pathExtension];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=100.0f;
    [DZFileManager creatDirectoryWithPath:MessageFileCache(chatmodel.chatID)];
    NSString *downloadFilePath = [MessageFileCache(chatmodel.chatID) stringByAppendingPathComponent:fileCacheName];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:chatmodel.fileServiceUrl.netUrlEncoded]];
    
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            chatmodel.completedUnitCount=downloadProgress.completedUnitCount;
            chatmodel.totalUnitCount=downloadProgress.totalUnitCount;
            downloadProgressBar(chatmodel);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        chatmodel.uploadState=1;
        chatmodel.fileCacheName=fileCacheName;
        chatmodel.hasRead=YES;
        if (error) {
            failure(error);
        }else{
            DDLogInfo(@"下载地址是=%@",response.URL.absoluteString);
            DDLogInfo(@"下载成功，缓存地址是=%@",filePath);
            success(chatmodel);
        }
        
    }];
    
    //执行Task
    [download resume];
}
-(void)downloadVideoWithUrl:(NSString*)url success:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=100.0f;
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
    NSLog(@"save path is :%@",outputFielPath);
    __block   NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
    NSLog(@"fileUrl:%@",fileUrl);
    //下载必须先移除原来的缓存内容 不然就无法追加文件内容
    [DZFileManager removeFileOfPath:outputFielPath];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success(fileUrl);
    }];
    
    //执行Task
    [download resume];
}
//TODO 还可以取消任务
-(void)translateGeogleLanguageWithText:(NSString *)text success:(void (^)(NSString *translate))success failure:(void (^)(NSError *error))failure{
    __block BOOL translateSuccess=NO;
    __block BOOL geogleFailure=NO;
    __block BOOL baiduFailure=NO;
    NSDictionary * dict = [BaseSettingManager getPreferredLanguages];
    NSString * google = [dict objectForKey:@"google"];
    NSString * baidu = [dict objectForKey:@"baidu"];
    NSURLSessionDataTask*baduitask;
    //    https://www.googleapis.com/language/translate/v2?key=AIzaSyCBZFCklNVc2RQc3bC6QT7TRRsTOSOCx3k&target=en&q=
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=15.0f;
    NSString *path = @"https://translation.googleapis.com/language/translate/v2?key=AIzaSyBMOQCFs9MZOmQJ8whbfXMMP6GnaC3ujtc".netUrlEncoded;
    NSDictionary*geoglePatm=@{@"target":google,@"q":text};
    NSURLSessionDataTask*geogleTask= [self.manager POST:path parameters:geoglePatm headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!translateSuccess) {
            NSDictionary*dict=[responseObject mj_JSONObject];
            NSDictionary*dataDict=dict[@"data"];
            NSMutableString*translateString=[NSMutableString string];
            if (dataDict) {
                translateSuccess=YES;
                NSArray*array=[dataDict objectForKey:@"translations"];
                for (int i=0; i<array.count; i++) {
                    if (i!=0) {
                        [translateString appendString:@"\n"];
                    }
                    NSDictionary*resu=array[i];
                    [translateString appendString:resu[@"translatedText"]];
                }
                success(translateString);
            }else{
                geogleFailure=YES;
                if (geogleFailure&&baiduFailure) {
                    failure(task.error);
                }
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        geogleFailure=YES;
        translateSuccess=NO;
        if (geogleFailure&&baiduFailure) {
            failure(task.error);
        }
    }];
    //百度翻译
    NSString*baiduappid = @"20200327000406811";
    NSString*baidukey = @"Xp7h2pVIijF7nWuR0Isu";
    NSInteger salt = [[NSDate date]timeIntervalSince1970];
    NSString*md5 = [[NSString stringWithFormat:@"%@%@%@%@",baiduappid,text,[NSString stringWithFormat:@"%ld",salt],baidukey] MD5String]; NSDictionary*parm=@{@"q":text,@"from":@"auto",@"to":baidu,@"appid":baiduappid,@"salt":@(salt),@"sign":md5};
    self.manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer*requestSerializer=[AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer       = requestSerializer;
    [requestSerializer setValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    self.manager.requestSerializer.timeoutInterval=15.0f;
    [self.manager POST:@"http://api.fanyi.baidu.com/api/trans/vip/translate" parameters:parm headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!translateSuccess) {
            NSDictionary*dict=[responseObject mj_JSONObject];
            //翻译失败
            if (dict[@"error_code"]) {
                baiduFailure=YES;
                if (geogleFailure&&baiduFailure) {
                    failure(task.error);
                }
            }else{
                translateSuccess=YES;
                NSMutableString*appdendingStr=[NSMutableString string];
                NSArray*trans_resultArray=dict[@"trans_result"];
                for (int i=0; i<trans_resultArray.count; i++) {
                    if (i!=0) {
                        [appdendingStr appendString:@"\n"];
                    }
                    NSDictionary*resu=trans_resultArray[i];
                    [appdendingStr appendString:resu[@"dst"]];
                }
                success(appdendingStr);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        baiduFailure=YES;
        if (geogleFailure&&baiduFailure) {
            failure(task.error);
        }
    }];
    
    
}
-(void)translateGoogleTextString:(NSString *) languageCode text:(NSString *)text success:(void (^)(NSString *translate))success failure:(void (^)(NSError *error))failure{
    __block BOOL translateSuccess = NO;
    __block BOOL geogleFailure = NO;
    __block BOOL baiduFailure = NO;
    NSDictionary *dict = [BaseSettingManager getSelectedLanguage:languageCode];
    NSString *google = [dict objectForKey:@"google"];
    NSString *baidu = [dict objectForKey:@"baidu"];
    NSURLSessionDataTask *baduitask;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 15.0f;
    NSString *path = @"https://translation.googleapis.com/language/translate/v2?key=AIzaSyBMOQCFs9MZOmQJ8whbfXMMP6GnaC3ujtc".netUrlEncoded;
    NSDictionary *geoglePatm = @{@"target":google,@"q":text};
    NSURLSessionDataTask *geogleTask = [self.manager POST:path parameters:geoglePatm headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!translateSuccess) {
            NSDictionary *dict = [responseObject mj_JSONObject];
            NSDictionary *dataDict = dict[@"data"];
            NSMutableString *translateString = [NSMutableString string];
            if (dataDict) {
                translateSuccess = YES;
                NSArray *array = [dataDict objectForKey:@"translations"];
                for (int i=0; i<array.count; i++) {
                    if (i!=0) {
                        [translateString appendString:@"\n"];
                    }
                    NSDictionary *resu = array[i];
                    [translateString appendString:resu[@"translatedText"]];
                }
                success(translateString);
            }else{
                geogleFailure = YES;
                if (geogleFailure&&baiduFailure) {
                    failure(task.error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        geogleFailure = YES;
        translateSuccess = NO;
        if (geogleFailure && baiduFailure) {
            failure(task.error);
        }
    }];
    //Baidu translator
    NSString *baiduappid = @"20200327000406811";
    NSString *baidukey = @"Xp7h2pVIijF7nWuR0Isu";
    NSInteger salt = [[NSDate date]timeIntervalSince1970];
    NSString *md5 = [[NSString stringWithFormat:@"%@%@%@%@",baiduappid,text,[NSString stringWithFormat:@"%ld",salt],baidukey] MD5String]; NSDictionary *parm = @{@"q":text,@"from":@"auto",@"to":baidu,@"appid":baiduappid,@"salt":@(salt),@"sign":md5};
    self.manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer = requestSerializer;
    [requestSerializer setValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    self.manager.requestSerializer.timeoutInterval = 15.0f;
    [self.manager POST:@"http://api.fanyi.baidu.com/api/trans/vip/translate" parameters:parm headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!translateSuccess) {
            NSDictionary *dict = [responseObject mj_JSONObject];
            if (dict[@"error_code"]) {
                baiduFailure = YES;
                if (geogleFailure && baiduFailure) {
                    failure(task.error);
                }
            }else{
                translateSuccess = YES;
                NSMutableString *appdendingStr = [NSMutableString string];
                NSArray *trans_resultArray = dict[@"trans_result"];
                for (int i=0; i<trans_resultArray.count; i++) {
                    if (i!=0) {
                        [appdendingStr appendString:@"\n"];
                    }
                    NSDictionary *resu = trans_resultArray[i];
                    [appdendingStr appendString:resu[@"dst"]];
                }
                success(appdendingStr);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        baiduFailure = YES;
        if (geogleFailure && baiduFailure) {
            failure(task.error);
        }
    }];
}

@end
