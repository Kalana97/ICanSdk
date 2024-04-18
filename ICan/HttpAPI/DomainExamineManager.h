//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 28/5/2020
- File name:  DomainExamineManager.h
- Description:域名检测管理者
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomainExamineManager : NSObject
@property(nonatomic, strong) NSArray *domainItems;
@property(nonatomic, copy) NSString *baseUrl;
@property(nonatomic, copy) NSString *websocketUrl;
@property(nonatomic, assign) BOOL shouldDownload;
+ (instancetype)sharedManager;

/**
 发送普通的网络请求

 @param request baseRequest
 @param responseClass 响应的内容
 @param contentClass 内容所包含的model
 @param success 成功回调
 @param failure 失败回调
 */
-(void)startDomainTestRequest:(BaseRequest *)request
                   success:(SuccessCallback)success
                   failure:(FailureCallback)failure;

-(void)downloadDomainFileSuccess:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure;
-(void)checkShouldExchangeDomain;
@end

NS_ASSUME_NONNULL_END
