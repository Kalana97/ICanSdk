//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 28/5/2020
 - File name:  DomainExamineManager.m
 - Description:
 - Function List:
 */


#import "DomainExamineManager.h"
#import "AFNetworking.h"
#define Kdomain         @"domain"
#define KbaseUrl        @"baseUrl"
#define KwebsocketUrl   @"websocketUrl"
@interface DomainExamineManager ()
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end
@implementation DomainExamineManager
+ (instancetype)sharedManager {
    static DomainExamineManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[DomainExamineManager alloc] init];
        api.shouldDownload=YES;
    });
    return api;
}

-(void)checkShouldExchangeDomain{
    [self downloadDomainFileSuccess:^(NSURL *url) {
        NSLog(@"Success");
    } failure:^(NSError * fail) {
        NSLog(@"Fail");
    }];
}

-(void)startTestFromDomainFile{
    TestDomainRequest *request = [TestDomainRequest request];
    NSString *dowmin = self.domainItems.firstObject;
    dowmin = [dowmin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.baseUrl = dowmin;
    [self startDomainTestRequest:request success:^(id response) {//成功连接
        if (self.domainItems.count>0) {
            self.websocketUrl = [self.baseUrl componentsSeparatedByString:@"//"].lastObject;;
            //  #define SOCKET_URL  @"wss://service.woxingapp.com/sock/websocket?Token="
            NSString*newWebUrl;
            if ([self.baseUrl hasPrefix:@"https"]) {
                newWebUrl = [NSString stringWithFormat:@"wss://%@/sock/websocket?Token=",self.websocketUrl];
            }else if ([self.baseUrl hasPrefix:@"http"]){
                newWebUrl = [NSString stringWithFormat:@"ws://%@/sock/websocket?Token=",self.websocketUrl];
            }else{
                newWebUrl = SOCKET_URL;
            }
            DDLogInfo(@"self.websocketUrlstartDomainTest=%@",self.websocketUrl);
            //如果已经连接的url不等于拿到的url 那么重新连接url
            if (![newWebUrl isEqualToString:self.websocketUrl]) {
                self.websocketUrl = newWebUrl;
                [[WebSocketManager sharedManager]closeWebSocket];
                [[WebSocketManager sharedManager]initWebScoket];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSMutableArray *array = [NSMutableArray arrayWithArray: self.domainItems];
        if (array.count>0) {
            [array removeObjectAtIndex:0];
            self.domainItems = array;
            if (array.count == 0) {
                self.baseUrl = BASE_URL;
                self.websocketUrl = SOCKET_URL;
                if (self.shouldDownload) {
                    [self downloadDomainFileSuccess:^(NSURL * _Nonnull url) {
                    } failure:^(NSError * _Nonnull error) {
                    }];
                }else{
                    [[WebSocketManager sharedManager]closeWebSocket];
                    [[WebSocketManager sharedManager]initWebScoket];
                }
            }else{
                NSString *dowmin = self.domainItems.firstObject;
                dowmin = [dowmin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
                dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                self.baseUrl = dowmin;
                self.websocketUrl = [self.baseUrl componentsSeparatedByString:@"//"].lastObject;
                //  #define SOCKET_URL  @"wss://service.woxingapp.com/sock/websocket?Token="
                if ([self.baseUrl hasPrefix:@"https"]) {
                    self.websocketUrl = [NSString stringWithFormat:@"wss://%@/sock/websocket?Token=",self.websocketUrl];
                }else if ([self.baseUrl hasPrefix:@"http"]){
                    self.websocketUrl = [NSString stringWithFormat:@"ws://%@/sock/websocket?Token=",self.websocketUrl];
                }else{
                    self.websocketUrl = SOCKET_URL;
                }
                [self startDomainTest];
            }
        }else{
            self.baseUrl = BASE_URL;
            self.websocketUrl = SOCKET_URL;
            
            if (self.shouldDownload) {
                [self downloadDomainFileSuccess:^(NSURL * _Nonnull url) {
                } failure:^(NSError * _Nonnull error) {
                }];
            }else{
                [[WebSocketManager sharedManager]closeWebSocket];
                [[WebSocketManager sharedManager]initWebScoket];
            }
        }
    }];
}

-(void)startDomainTest{
    TestDomainRequest *request = [TestDomainRequest request];
    NSString *dowmin = BASE_URL;
    dowmin = [dowmin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    dowmin = [dowmin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.baseUrl = dowmin;
    [self startDomainTestRequest:request success:^(id response) {//成功连接
            self.websocketUrl = [self.baseUrl componentsSeparatedByString:@"//"].lastObject;;
            //  #define SOCKET_URL  @"wss://service.woxingapp.com/sock/websocket?Token="
            NSString *newWebUrl;
            if ([self.baseUrl hasPrefix:@"https"]) {
                newWebUrl = [NSString stringWithFormat:@"wss://%@/sock/websocket?Token=",self.websocketUrl];
            }else if ([self.baseUrl hasPrefix:@"http"]){
                newWebUrl = [NSString stringWithFormat:@"ws://%@/sock/websocket?Token=",self.websocketUrl];
            }else{
                newWebUrl = SOCKET_URL;
            }
            DDLogInfo(@"self.websocketUrlstartDomainTest=%@",self.websocketUrl);
            //如果已经连接的url不等于拿到的url 那么重新连接url
            if (![newWebUrl isEqualToString:self.websocketUrl]) {
                self.websocketUrl = newWebUrl;
                [[WebSocketManager sharedManager]closeWebSocket];
                [[WebSocketManager sharedManager]initWebScoket];
            }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self startTestFromDomainFile];
    }];
}

-(void)startDomainTestRequest:(BaseRequest *)request success:(SuccessCallback)success failure:(FailureCallback)failure{
    self.manager=[AFHTTPSessionManager manager];
    self.manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=2.0;
    [self.manager GET:request.pathUrlString parameters:request.parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(0);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error,[[NetworkErrorInfo alloc] init],400);
    }];
}
-(void)downloadDomainFileSuccess:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure{
    self.shouldDownload=NO;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval=100.0f;
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"domain.txt"];
    [DZFileManager removeFileOfPath:outputFielPath];
    NSLog(@"save path is :%@",outputFielPath);
    __block   NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
    NSLog(@"fileUrl:%@",fileUrl);
    NSLog(@"%@",DomainDownloadUrl);
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:DomainDownloadUrl]];
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *content = [[NSString alloc] initWithContentsOfFile:outputFielPath encoding:NSUTF8StringEncoding error:nil];
        DDLogInfo(@"content=%@",content);
        NSArray*domainItems= [content componentsSeparatedByString:@"\n"];
        self.domainItems=domainItems;
        success(fileUrl);
        if (self.domainItems.count>0) {
            [self startDomainTest];
        }else{
            self.websocketUrl=SOCKET_URL;
            self.baseUrl=BASE_URL;
            [[WebSocketManager sharedManager]initWebScoket];
        }
        
        
    }];
    
    //执行Task
    [download resume];
}
-(void)setDomainItems:(NSArray *)domainItems{
    [self setUserDefaultsWithObject:domainItems key:Kdomain];
}
-(NSArray *)domainItems{
    return [self gainObjectWithKey:Kdomain];
}
-(void)setBaseUrl:(NSString *)baseUrl{
    [self setUserDefaultsWithObject:baseUrl key:KbaseUrl];
}
-(NSString *)baseUrl{
    return [self gainObjectWithKey:KbaseUrl];
}
-(void)setWebsocketUrl:(NSString *)websocketUrl{
    [self setUserDefaultsWithObject:websocketUrl key:KwebsocketUrl];
}
-(NSString *)websocketUrl{
    return [self gainObjectWithKey:KwebsocketUrl];
}
-(void)setUserDefaultsWithObject:(id)object key:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}
- (id)gainObjectWithKey:(NSString *)key {
    id object = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return object;
}

@end
