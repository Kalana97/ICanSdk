//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 1/11/2019
 - File name:  PrivacyPermissionsTool.m
 - Description:
 - Function List:
 */


#import "PrivacyPermissionsTool.h"
#import "LocalAuthentication/LAContext.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@implementation PrivacyPermissionsTool
+(void)judgeCameraAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
            break;
        case AVAuthorizationStatusDenied:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithMessage:@"Please set to allow APP to access your camera".icanlocalized];
                failure();
            });
        }
            break;
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_main_async_safe(^{
                        success();
                    });
                }else{
                    
                    dispatch_main_async_safe(^{
                        [self showAlertWithMessage:@"Please set to allow APP to access your camera".icanlocalized];
                        failure();
                    });
                    
                }
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
            dispatch_main_async_safe(^{
                success();
            });
            
            break;
    }
    
}
+(void)judgeAlbumAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted://// 这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
        case PHAuthorizationStatusDenied:
            // 用户已经明确否认了这个应用程序访问图片数据
            dispatch_main_async_safe(^{
                [self showAlertWithMessage:@"Please set to allow APP to access your photo album and use your picture resources".icanlocalized];
                failure();
            });
            
            break;
        case PHAuthorizationStatusAuthorized://// 用户授权此应用程序访问图片数据
            dispatch_main_async_safe(^{
                success();
            });
            break;
        case PHAuthorizationStatusNotDetermined:{//// 用户还没有关于这个应用程序做出了选择
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status==PHAuthorizationStatusAuthorized) {
                    dispatch_main_async_safe(^{
                        success();
                    });
                }else{
                    
                    dispatch_main_async_safe(^{
                        failure();
                        [self showAlertWithMessage:@"Please set to allow APP to access your photo album and use your picture resources".icanlocalized];
                    });
                    
                }
            }];
        }
            
            break;
    }
    
}

+(void)judgeLocationAuthorizationSuccess:(void(^)(void))success failure:(void(^)(void))failure{
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            [self showAlertWithMessage:@"Please set to allow APP to access your location".icanlocalized];
            failure();
            break;
           
        default:
            success();
            break;
    }
}
+ (void)judgeSupporFaceIDOrTouchID:(void(^)(NSString*str))support{
    LAContext *context = [[LAContext alloc] init];
    if (@available(iOS 8.0, *)) {
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        
        if (authError) {
            support(@"NOSUPPORT");
            return;
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (context.biometryType) {
                        case LABiometryTypeNone:
                        {
                            support(@"NOSUPPORT");
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            support(@"TOUCHID");
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            support(@"FACEID");
                        }
                            break;
                        default:
                            break;
                    }
                }
                
            } else {
                support(@"NOSUPPORT");
            }
        }
        
    } else {
        support(@"NOSUPPORT");
        
    }
}
+(void)judgeMicrophoneAuthorizationSuccess:(void (^)(void))success notDetermined:(void (^)(void))notDetermined failure:(void (^)(void))failure{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            [self showAlertWithMessage:@"Please set to allow APP to access your microphone".icanlocalized];
            failure();
            break;
            
        case AVAuthorizationStatusAuthorized:
            dispatch_main_async_safe(^{
                success();
            });
            break;
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_main_async_safe(^{
                        notDetermined();
                    });
                }else{
                    dispatch_main_async_safe(^{
                        [self showAlertWithMessage:@"Please set to allow APP to access your microphone".icanlocalized];
                        failure();
                    });
                    
                }
            }];
        }
            break;
            
    }
}


+ (void)judgeContactAuthorizationSuccess:(void (^)(void))success failure:(void (^)(void))failure{
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authorizationStatus) {
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied:
            dispatch_main_async_safe(^{
                [self showAlertWithMessage:@"Please set to allow APP to access your address book".icanlocalized];
                failure();
            });
           
            break;
        case CNAuthorizationStatusAuthorized:
            success();
            break;
        case CNAuthorizationStatusNotDetermined:{
            [[[CNContactStore alloc]init]requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_main_async_safe(^{
                    if (granted) {
                        success();
                    }else{
                        [self showAlertWithMessage:@"Please set to allow APP to access your address book".icanlocalized];
                        failure();
                    }
                })
                
            }];
        }
            
            break;
    }
}
+(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PrivacyPermissionsTool goToAppSystemSetting];
        
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [[AppDelegate shared]presentViewController:alertVc animated:YES completion:^{
        
    }];
    
}


// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}
@end
