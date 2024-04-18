//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 26/9/2019
 - File name:  WCDBManager+UserMessageInfo.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "WCDBManager+UserMessageInfo.h"
#import "UserMessageInfo+WCTTableCoding.h"
@implementation WCDBManager (UserMessageInfo)
-(void)insertUserMessageInfoWithArray:(NSArray<UserMessageInfo *> *)array{
    [self.wctDatabase deleteObjectsFromTable:KWCUserMessageInfoTable where:{UserMessageInfo.isFriend==1}];
    [self.wctDatabase insertOrReplaceObjects:array into:KWCUserMessageInfoTable];
}
-(void)insertUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    @try{
        [self.wctDatabase insertOrReplaceObjects:@[userMessageInfo] into:KWCUserMessageInfoTable];
    } @catch(NSException *exception){
        NSLog(@"An exception was caught: %@", [exception reason]);
    }
}
-(NSArray<UserMessageInfo *> *)fetchFriendList{
    NSArray<UserMessageInfo*>*array= [self.wctDatabase getObjectsOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:{UserMessageInfo.isFriend==1}];
    return array;
}
-(void)updateFriendRemarkNameWithUserId:(NSString *)userId remark:(NSString *)remark{
    [self.wctDatabase updateRowsInTable:KWCUserMessageInfoTable onProperty:{UserMessageInfo.remarkName} withValue:remark where:UserMessageInfo.userId==userId];
}
-(void)updateUserHeadImgWith:(NSString*)headImgUrl chatId:(NSString*)chatId{
    if (headImgUrl) {
        [self.wctDatabase updateRowsInTable:KWCUserMessageInfoTable onProperty:{UserMessageInfo.headImgUrl} withValue:headImgUrl where:UserMessageInfo.userId==chatId];
    }
    
}
-(void)updateFriendRelationWithUserId:(NSString *)userId isFriend:(BOOL)isFriend{
    UserMessageInfo*model=  [self.wctDatabase getOneObjectOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:UserMessageInfo.userId==userId ];
    if (model) {
        [self.wctDatabase updateRowsInTable:KWCUserMessageInfoTable onProperty:{UserMessageInfo.isFriend} withValue:@(isFriend) where:UserMessageInfo.userId==userId];
    }else{
        [self fetchUserMessageWithmerchantcode:userId successBlock:nil];
    }
}
-(UserMessageInfo *)fetchUserMessageInfoWithUserId:(NSString *)userId{
    return  [self.wctDatabase getOneObjectOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:UserMessageInfo.userId==userId];
}
-(void)fetchUserMessageInfoWithUserId:(NSString *)userId successBlock:(void (^)(UserMessageInfo * _Nonnull))successBlock{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:UserMessageInfo.userId==userId];
    if (array.count>0) {
        
        successBlock(array.firstObject);
    }else{
        [self fetchUserMessageWithmerchantcode:userId successBlock:successBlock];
    }
}
-(void)fetchUserMessageWithmerchantcode:(NSString *)userId successBlock:(void (^)(UserMessageInfo * ))successBlock{
    if (userId) {
        if (![userId isEqualToString:PayHelperMessageType]&&![userId isEqualToString:SystemHelperMessageType]) {
            GetUserMessageRequest*request=[GetUserMessageRequest request];
            request.userId=userId;
            request.parameters=[request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
                if (successBlock) {
                    successBlock(response);
                }
                [self insertUserMessageInfo:response];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }
        
        
    }
    
}
-(void)judgeIsFriendWithUserId:(NSString *)userId successBlock:(void (^)(BOOL))successBlock{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:UserMessageInfo.userId==userId];
    if (array.count>0) {
        UserMessageInfo*info=array.firstObject;
        successBlock(info.isFriend);
    }else{
        if (userId) {
            GetUserMessageRequest*request=[GetUserMessageRequest request];
            request.userId=userId;
            request.parameters=[request mj_JSONObject];
            
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
                
                successBlock(response.isFriend);
                
                [self insertUserMessageInfo:response];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
            
        }
    }
}
-(void)deleteUserMessageInfoWithUserId:(NSString *)userId{
    [self.wctDatabase deleteObjectsFromTable:KWCUserMessageInfoTable where:UserMessageInfo.userId==userId];
}
-(void)updateUserReadReceipt:(BOOL)readReceipt chatId:(NSString*)chatId{
    [self.wctDatabase updateRowsInTable:KWCUserMessageInfoTable onProperty:{UserMessageInfo.readReceipt} withValue:@(readReceipt) where:UserMessageInfo.userId==chatId];
}
-(void)fetchUserMessageInfoWithNumberId:(NSString *)numberId successBlock:(void (^)(UserMessageInfo *))successBlock{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[UserMessageInfo class] fromTable:KWCUserMessageInfoTable where:UserMessageInfo.numberId==numberId];
    if (array.count>0) {
        UserMessageInfo*info=array.firstObject;
        successBlock(info);
    }else{
        if (numberId) {
            GetUserListByNumberIdRequest*request=[GetUserListByNumberIdRequest request];
//            request.numberIds =
            request.parameters = @[numberId];;
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
                successBlock(response);
                if (response) {
                    [self insertUserMessageInfo:response];
                }
                
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
            
        }
    }
}
@end
