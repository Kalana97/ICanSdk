/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/11
- System_Version_MACOS: 10.14
- EasyPay
- File name:  WCDBManager.h
- Description: 用来操作WCDB数据库的类
- Function List:  https://github.com/Tencent/wcdb/wiki/基础类、CRUD与Transaction
- History:
*/
        

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager : NSObject
/** 数据操作 */
@property (nonatomic,retain) WCTDatabase *wctDatabase;

+ (instancetype)sharedManager;


/**
 初始化当前的登录用户的数据库
 */
-(void)initCurrentUserWCDataBase;

/**
 生成messageID

 @return return value description
 */
-(NSString*)generateMessageID;

/// 删除某个会话下面的所有资源
/// @param chatId 删除的某个会话的ID
-(void)deleteResourceWihtChatId:(NSString*)chatId;
-(void)deleteAllResource;
-(void)cacheMessageWithChatModel:(ChatModel*)chatModel isNeedSend:(BOOL)isNeedSend;
@end

NS_ASSUME_NONNULL_END
