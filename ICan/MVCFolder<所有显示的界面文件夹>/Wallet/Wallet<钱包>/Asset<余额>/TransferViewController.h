//
//  TranferViewController.h
//  ICan
//  转账页面
//  Created by Limaohuyu666 on 2019/11/8.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QDCommonViewController.h"
typedef NS_ENUM(NSInteger,TranferFromType) {
    TranfetFrom_chatView,//聊天页面
    TranfetFrom_wallet,// 从钱包页面进来
};


NS_ASSUME_NONNULL_BEGIN

@interface TransferViewController : QDCommonViewController

@property (nonatomic,strong) UserMessageInfo * userMessageInfo;
@property (nonatomic,assign) TranferFromType tranferType;
@property(nonatomic, strong) C2CBalanceListInfo *currencyBalanceListInfo;
/** 默认是人命币 */
@property(nonatomic, assign) BOOL isCNY;
@property(nonatomic, assign) BOOL isUsdTransfer;
@property(copy, nonatomic) void(^backAction)(void);
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@end

NS_ASSUME_NONNULL_END
