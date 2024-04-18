//
//  AppDelegate.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/18.
//  Copyright © 2019 EasyPay. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WebSocketManager.h"
#ifdef ICANTYPE
#import <CallKit/CallKit.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate,WebSocketManagerDelegate>
@property (nonatomic,copy) NSString * deviceToken;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSUUID *callKitID;
@property (nonatomic, assign) BOOL isCallkitAnswered;
@property (nonatomic, assign) BOOL isCallkitDeclined;
#ifdef ICANTYPE
@property (nonatomic, strong) CXProvider *provider;
@property (nonatomic, strong) CXCallController *callController;
@property (nonatomic, strong) CXCallUpdate *callUpdate;
#endif
@end

