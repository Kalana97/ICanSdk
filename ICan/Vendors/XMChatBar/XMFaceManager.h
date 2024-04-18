//
//  XMFaceManager.h
//  XMChatBarExample
//
//  Created by shscce on 15/8/25.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#define kFaceIDKey          @"face_id"
#define kFaceNameKey        @"face_name"
#define kFaceImageNameKey   @"face_image_name"

#define kFaceRankKey        @"face_rank"
#define kFaceClickKey       @"face_click"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  表情管理类,可以获取所有的表情名称
 *  直接获取所有的表情Dict,添加排序功能,对表情进行排序,常用表情排在前面
 */
@interface XMFaceManager : NSObject

+ (instancetype)shareInstance;
#pragma mark - emoji表情相关

/**
 *  获取所有的表情图片名称
 *
 *  @return 所有的表情图片名称
 */
+ (NSArray *)emojiFaces;

+ (NSString *)faceImageNameWithFaceID:(NSUInteger)faceID;

+ (NSString *)faceNameWithFaceID:(NSUInteger)faceID;

+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text isOutGoing:(BOOL)isOutGoing;
/** 拿到文字 */
+ (NSMutableAttributedString *)getEmotionStrWithString:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor*)color;

+ (NSArray *)recentFaces;


+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text;


/**
 *  存储一个最近使用的face
 *
 *  @param dict 包含以下key-value键值对
 *  face_id     表情id
 *  face_name   表情名称
 *  @return 是否存储成功
 */
+ (BOOL)saveRecentFace:(NSDictionary *)dict;

+ (NSMutableAttributedString *)getReplyEmotionStrWithString:(NSString *)text isShowReplayView:(BOOL)isShowReplayView;
@end
