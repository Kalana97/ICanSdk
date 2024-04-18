//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/9
- System_Version_MACOS: 10.14
- ICan
- File name:  NetworkRequestManager.h
- Description:
- Function List: 
- History:
*/
        

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
@class ChatModel;
@class ReplyMessageInfo;
//NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessCallback)(id response);
typedef void(^FailureCallback)(NSError *error,NetworkErrorInfo*info,NSInteger statusCode);
@interface NetworkRequestManager : NSObject

+ (instancetype)shareManager;
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
                   failure:(FailureCallback)failure;




-(void)downloadFileWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel * chatModel))downloadProgress success:(void(^)(ChatModel*chatModel))success failure:(void(^)(NSError *error))failure;

-(void)downloadVideoWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure;

-(void)downloadVideoWithUrl:(NSString*)url success:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure;

-(void)translateGeogleLanguageWithText:(NSString *)text success:(void (^)(NSString *translate))success failure:(void (^)(NSError *error))failure;
-(void)translateGoogleTextString:(NSString *) languageCode text:(NSString *)text success:(void (^)(NSString *translate))success failure:(void (^)(NSError *error))failure;
/// 下载收藏列表的文件
/// @param fileUrl 文件网络路径
/// @param downloadProgress downloadProgress description
/// @param success success description
/// @param failure failure description
-(void)downloadCollectFileWithUrl:(NSString *)fileUrl downloadProgress:(void (^)(NSString * progress))downloadProgress success:(void(^)(NSString*localPath))success failure:(void(^)(NSError *error))failure;

/// 下载回复的文件
/// @param replyInfo replyInfo description
/// @param downloadProgressBar downloadProgressBar description
/// @param success success description
/// @param failure failure description
-(void)downloadReplyFileWithReplayMessageInfo:(ReplyMessageInfo *)replyInfo downloadProgress:(void (^)(NSString *))downloadProgressBar success:(void (^)(ReplyMessageInfo *))success failure:(void (^)(NSError *))failure;
@end

//NS_ASSUME_NONNULL_END
