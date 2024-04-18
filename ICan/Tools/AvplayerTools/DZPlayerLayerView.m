//
/**
- Copyright © 2020 dzl. All rights reserved.
- AUthor: Created  by DZL on 2020/2/22
- ICan
- File name:  DZPlayerLayerView.m
- Description:
- Function List:
*/
        

#import "DZPlayerLayerView.h"
@interface DZPlayerLayerView ()
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@end
@implementation DZPlayerLayerView
- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer {
    
    _playerLayer = playerLayer;
     playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    //AVLayerVideoGravityResizeAspectFill 视频充满
    //AVLayerVideoGravityResizeAspect 视频完全显示
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_playerLayer];
}



- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    _playerLayer.frame = self.bounds;
}


@end
