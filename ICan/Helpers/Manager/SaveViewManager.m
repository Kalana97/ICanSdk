//
//  SaveViewManager.m
//  OneChatAPP
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 DW. All rights reserved.
// //

#import "SaveViewManager.h"

@implementation SaveViewManager
static void(^ _success)(void);
static void(^ _failed)(void);


+ (void)saveImageToPhotos:(UIImage*)savedImage success:(void(^)(void))success failed:(void(^)(void))failed {
    _success = [success copy];
    _failed = [failed copy];
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//截图功能
+ (void)captureImageFromView:(UIView *)view success:(void(^)(void))success failed:(void(^)(void))failed  {
    
    CGRect screenRect = [view bounds];
    
    //    UIGraphicsBeginImageContext(screenRect.size);
    //
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //
    //    [view.layer renderInContext:ctx];
    //
    //    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(screenRect.size,YES, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //      return snapshotImage;
    [self saveImageToPhotos:snapshotImage success:success failed:failed];
}


+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo
{
    if(error != NULL) {
        if (_failed) {
            _failed();
        }
    } else {
        
        if (_success) {
            _success();
        }
    }
}

@end
