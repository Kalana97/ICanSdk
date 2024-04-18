
#import <Foundation/Foundation.h>

@interface ChatAlbumModel : NSObject
/** 是否是GIF */
@property(nonatomic, assign) BOOL isGif;
//是否为原图
@property (nonatomic, assign) BOOL isOrignal;
//名字
@property (nonatomic, copy) NSString *name;
//图片压缩过的data
@property (nonatomic, strong) NSData *compressImageData;
//图片无压缩data
@property (nonatomic, strong) NSData *orignalImageData;
//音频data
@property (nonatomic, strong) NSData *audioData;
//图片尺寸
@property (nonatomic, assign) CGSize  picSize;
//视频缓存地址
@property (nonatomic, strong) PHAsset *videoAsset;
//视频缩略图
@property (nonatomic, strong) UIImage *videoCoverImg;
//视频 , 语音时长
@property (nonatomic, copy) NSString *duration;
/** 本地的路径 */
@property (nonatomic,copy)  NSString * localPath;
@end
