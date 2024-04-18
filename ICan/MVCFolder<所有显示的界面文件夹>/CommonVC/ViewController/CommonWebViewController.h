//
//  CommonWebViewController.h
//  EasyPay
// //提现协议 ican_chat_withdrawal_agreement.pdf
//收付款码协议 ican_chat_payment_agreement
//隐私权协议 ican_chat_privacy_agreement
//服务协议! ican_chat_service_agreement
//  Created by 刘志峰 on 2019/5/20.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "BaseViewController.h"
#import "QDCommonTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommonWebViewController : QDCommonTableViewController
@property(nonatomic,copy)   NSString *urlString;

@property(nonatomic,assign) BOOL isPresent;
@property(nonatomic,assign) BOOL isShare;
/** 本地filepath */
@property(nonatomic,copy)   NSString * localString;
@end

NS_ASSUME_NONNULL_END
