//
//  UIImage+colorImage.h
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/12.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (colorImage)

+ (UIImage *)imageFromContextWithColor:(UIColor *)color; //一像素图片

+ (UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size;

+ (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;

/** 生成图片的缩略图
 *  size 缩略图的大小
 */
- (UIImage *)imageWithThumbScaleSize:(CGSize)size;

-(NSData*)imageWithThumbtoByte:(NSUInteger)maxLength;
/**
 压缩图片

 @param maxLength 最大大小
 @return return value description
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

/**
 压缩图片
 先压缩图片的质量 如果大于最大大小 再压缩尺寸
 @param maxLength 最大的大小
 @return return value description
 */
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;

+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

/**
 制作纯色图片

 @param color color description
 @return return value description
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 调整图片的方向

 @param image image description
 @return return value description
 */
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;


// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithTemplateImage:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

// 根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)imageURL;

// 制作图片的 尖头方向
+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender;
/**
 * 生成二维码图片
 *
 * @param string    二维码的字符串
 * @param size      图片的宽高尺寸
 */
+ (UIImage *)dm_QRImageWithString:(NSString *)string size:(CGFloat)size;

/**
 * 解析二维码图片表示的字符串
 */
- (NSString *)dm_QRString;

/**
 *返回中心拉伸的图片
 */
+(UIImage *)stretchedImageWithName:(NSString *)name;

/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;


/**
 获取启动页的图片

 @return return value description
 */
+(UIImage*)getLauchImage;
-(NSData*)thumbImageToByte:(NSUInteger)maxLength;

+(UIImage*)getBlurImage:(UIImage*)image;
@end
