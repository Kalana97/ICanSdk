//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/27
- ICan
- File name:  TranspondTableViewController.h
- Description: 点击转发显示的页面
- Function List:
*/
        

#import "QDCommonTableViewController.h"
#import "WCDBManager+ChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TranspondTableViewController : QDCommonTableViewController
/** 当前需要转发的消息数据 */
@property(nonatomic, strong) NSMutableArray<ChatModel*> *selectMessagegArray;

@property(nonatomic, assign) TranspondType transpondType;

@property(nonatomic, copy) void (^pushChatViewBlock)(ChatModel*toModel,NSArray*messageItems);

@property(nonatomic, copy) void (^endBlock)(NSArray*toModel,NSArray*messageItems);
/**
 分享的是其他应用 例如商品详情
 */
@property(nonatomic, strong) ChatOtherUrlInfo *chatOtherUrlInfo;
/**
 分享的是朋友圈发送给朋友
 */
@property(nonatomic, strong) ChatPostShareMessageInfo *chatPostShareMessageInfo;

@property(nonatomic, strong) UIImage *shareImg;
@end

NS_ASSUME_NONNULL_END
