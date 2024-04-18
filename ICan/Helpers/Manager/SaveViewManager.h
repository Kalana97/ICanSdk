//
//  SaveViewManager.h
//  OneChatAPP
//  保存图片到相册
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 DW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveViewManager : NSObject

// 保存图片
+ (void)saveImageToPhotos:(UIImage*)savedImage success:(void(^)(void))success failed:(void(^)(void))failed;

//截图功能
+ (void)captureImageFromView:(UIView *)view success:(void(^)(void))success failed:(void(^)(void))failed;

@end
