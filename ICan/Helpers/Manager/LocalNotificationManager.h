//
//  LocalNotificationManager.h
//  GongShuQu
//  本地通知管理类
//  Created by SevenCat on 16/6/17.
//  Copyright © 2016年 拱墅区. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  本地通知管理类
 */
@interface LocalNotificationManager : NSObject


+ (void)setLacalNotificationWithTitle:(NSString *)title user:(NSString *)user value:(NSString*)value;
+(void)setLacalAvdioOrAudioNotificationWithMediaType:(NSString*)type user:(NSString *)user;

@end
