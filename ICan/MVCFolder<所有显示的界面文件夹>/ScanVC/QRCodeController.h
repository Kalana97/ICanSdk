//
//  QRCodeController.h
//  iOSCamera
// 上一次界面切换的动画尚未结束就试图进行新的
//  Created by 李达志 on 2018/4/24.
//  Copyright © 2018年 LDZ. All rights reserved.
// 二维码/条形码 扫描界面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,QRCodeControllerType){
    QRCodeControllerTypeNormal,
    QRCodeControllerTypeICanWallet,///钱包->扫描结果
};
@interface QRCodeController :BaseViewController
@property(nonatomic, assign) BOOL fromICanWallet;
@property(nonatomic, assign) QRCodeControllerType type;
@property (nonatomic,copy)void(^scanResultBlock)(NSString*result,BOOL isSucceed);
    //初始化函数
-(instancetype)initWithBlock:(void(^)(NSString*,BOOL))scanResult;
@end
