//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 18/8/2020
 - File name:  TimelineBrowseImageViewCollectionViewCell.m
 - Description:
 - Function List:
 */


#import "TimelineBrowseImageViewCollectionViewCell.h"
#import "SDImageCache.h"
@implementation TimelineBrowseImageViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topImageVIew.backgroundColor=UIColor.clearColor;
    self.bottomImageView.hidden=YES;
}
-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl=imageUrl;
    [self.topImageVIew sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}
-(UIImage*)getBlurImage:(UIImage*)image{
    /*..CoreImage中的模糊效果滤镜..*/
    //CIImage,相当于UIImage,作用为获取图片资源
    CIImage * ciImage = [[CIImage alloc]initWithImage:image ];
    //CIFilter,高斯模糊滤镜
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //将图片输入到滤镜中
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    //用来查询滤镜可以设置的参数以及一些相关的信息
    NSLog(@"%@",[blurFilter attributes]);
    //设置模糊程度,默认为10,取值范围(0-100)
    [blurFilter setValue:@(20) forKey:@"inputRadius"];
    //将处理好的图片输出
    CIImage * outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    //CIContext
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取CGImage句柄,也就是从数据流中取出图片
    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
    //最终获取到图片
    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
    //释放CGImage句柄
    CGImageRelease(outCGImage);
    return blurImage;
}
@end
