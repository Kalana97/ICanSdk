//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 16/4/2020
 - File name:  NTESNotificationCenter.m
 - Description:
 - Function List:
 */


#import "NTESNotificationCenter.h"
#import <NIMAVChat/NIMAVChat.h>
#import "NTESAudioChatViewController.h"
#import "NTESVideoChatViewController.h"
#import "QDTabBarViewController.h"
#import "WCDBManager+UserMessageInfo.h"
#import "QDNavigationController.h"
#import "PrivacyPermissionsTool.h"
#import "LocalNotificationManager.h"

#import "AudioPlayerManager.h"
#import "TimelinePlayVideoTool.h"
#import "DZAVPlayerView.h"
@interface NTESNotificationCenter ()<NIMNetCallManagerDelegate>
@property(nonatomic, strong) NSMutableArray *callWindows;
@property(nonatomic, strong) UIWindow *myWindow;
@end
@implementation NTESNotificationCenter
+ (instancetype)sharedCenter{
    static NTESNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance.callWindows = [[NSMutableArray alloc] init];
        instance = [[NTESNotificationCenter alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if(self) {
        //        NSURL *url = [[NSBundle mainBundle] URLForResource:@"message" withExtension:@"wav"];
        //        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        //        _notifier = [[NTESAVNotifier alloc] init];
        
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
        //        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        //
        //        [[NIMAVChatSDK sharedSDK].rtsManager addDelegate:self];
        //        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        //        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        //
        //        [[NIMSDK sharedSDK].signalManager addDelegate:self];
        //        [[NIMSDK sharedSDK].conversationManager addDelegate:self];
        
        
    }
    return self;
}
#pragma mark - NIMNetCallManagerDelegate

/// 收到会话请求
/// @param callID 后台生成的ID
/// @param caller 注册的名字
/// @param type 音频还是视频
/// @param extendMessage 扩展消息
- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallMediaType)type message:(NSString *)extendMessage{
    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    [[NSNotificationCenter defaultCenter]postNotificationName:KStopPlayVideoOrAudioNotification object:nil];
    QDTabBarViewController *tabVC = [QDTabBarViewController instance];
    [tabVC.view endEditing:YES];
    QDNavigationController *nav = tabVC.selectedViewController;
    if ([self shouldResponseBusy]){
        [[NIMAVChatSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
    }
    else {
       
        
        //        if ([self shouldFireNotification:caller]) {
        //            NSString *text = [self textByCaller:caller
        //                                           type:type];
        //            [_notifier start:text];
        //        }
        //还需要另外的提示语
        //        [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        //            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    UIViewController *vc;
        //                    switch (type) {
        //                        case NIMNetCallMediaTypeVideo:{
        //                            vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
        //                        }
        //                            break;
        //                        case NIMNetCallMediaTypeAudio:{
        //                            vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
        //                        }
        //                            break;
        //                        default:
        //                            break;
        //                    }
        //                    [self presentCallViewController:vc];
        //                });
        //
        //
        //            } notDetermined:^{
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    UIViewController *vc;
        //                    switch (type) {
        //                        case NIMNetCallMediaTypeVideo:{
        //                            vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
        //                        }
        //                            break;
        //                        case NIMNetCallMediaTypeAudio:{
        //                            vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
        //                        }
        //                            break;
        //                        default:
        //                            break;
        //                    }
        //                     [self presentCallViewController:vc];
        //                });
        //            } failure:^{
        //
        //            }];
        //
        //        } failure:^{
        //
        //        }];
        UIViewController *vc;
        switch (type) {
            case NIMNetCallMediaTypeVideo:{
                vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];

            }
                break;
            case NIMNetCallMediaTypeAudio:{
                vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
            }
                break;
            default:
                break;
        }
        [self presentCallViewController:vc];
        
        //        vc.modalPresentationStyle=UIModalPresentationFullScreen;
        //        if (nav.presentedViewController) {
        //            // fix bug MMC-1431
        //            [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        //        }
        //        //        [nav p:vc animated:NO];
        //        [nav presentViewController:vc animated:NO completion:nil];
        //        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        //        CATransition *transition = [CATransition animation];
        //        transition.duration = 0.25;
        //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        //        transition.type = kCATransitionPush;
        //        transition.subtype = kCATransitionFromTop;
        //        [nav.view.layer addAnimation:transition forKey:nil];
        //        if (nav.presentedViewController) {
        //            // fix bug MMC-1431
        //            [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        //        }
        //        [nav pushViewController:vc animated:NO];
    }
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user{
    //    [_notifier stop];
}

- (void)onRTSRequest:(NSString *)sessionID
                from:(NSString *)caller
            services:(NSUInteger)types
             message:(NSString *)info
{
    //    if ([self shouldResponseBusy]) {
    //        [[NIMAVChatSDK sharedSDK].rtsManager responseRTS:sessionID accept:NO option:nil completion:nil];
    //    }
    //    else {
    //
    //        if ([self shouldFireNotification:caller]) {
    //            NSString *text = [self textByCaller:caller];
    //            [_notifier start:text];
    //        }
    //        NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:sessionID
    //                                                                                            peerID:caller
    //                                                                                             types:types
    //                                                                                              info:info];
    //        if (@available(iOS 13, *)) {
    //            vc.modalPresentationStyle = UIModalPresentationFullScreen;
    //        }
    //        [self presentModelViewController:vc];
    //    }
}

- (void)presentCallViewController:(UIViewController *)viewController {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIWindow *activityWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    activityWindow.windowLevel = UIWindowLevelNormal;
    activityWindow.rootViewController = viewController;
    [activityWindow makeKeyAndVisible];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionMoveIn;     //可更改为其他方式
    animation.subtype = kCATransitionFromTop; //可更改为其他方式
    [[activityWindow layer] addAnimation:animation forKey:nil];
    self.myWindow=activityWindow;
    //    [self.callWindows addObject:activityWindow];
}
- (void)dismissCallViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[NTESNetChatViewController class]]) {
        UIViewController *rootVC = viewController;
        while (rootVC.parentViewController) {
            rootVC = rootVC.parentViewController;
        }
        viewController = rootVC;
    }
    [self.myWindow resignKeyWindow];
    self.myWindow.hidden = YES;
    [[UIApplication sharedApplication].delegate.window makeKeyWindow];
    //    for (UIWindow *window in self.callWindows) {
    //        if (window.rootViewController == viewController) {
    //            [window resignKeyWindow];
    //            window.hidden = YES;
    //            [[UIApplication sharedApplication].delegate.window makeKeyWindow];
    //            [self.callWindows removeObject:window];
    //            break;
    //        }
    //    }
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)presentModelViewController:(UIViewController *)vc
{
    //    NTESMainTabController *tab = [NTESMainTabController instance];
    //    [tab.view endEditing:YES];
    //    if (tab.presentedViewController) {
    //        __weak NTESMainTabController *wtabVC = tab;
    //        [tab.presentedViewController dismissViewControllerAnimated:NO completion:^{
    //            [wtabVC presentViewController:vc animated:NO completion:nil];
    //        }];
    //    }else{
    //        [tab presentViewController:vc animated:NO completion:nil];
    //    }
}

- (void)onRTSTerminate:(NSString *)sessionID
                    by:(NSString *)user
{
    //    [_notifier stop];
}

- (BOOL)shouldResponseBusy{
    QDTabBarViewController *tabVC = [QDTabBarViewController instance];
    QDNavigationController  *nav = tabVC.selectedViewController;
    return [nav.topViewController isKindOfClass:[NTESNetChatViewController class]];
    
}
- (void)start{
    DDLogInfo(@"Notification Center Setup");
}

@end
