//
//  ChatRightAnimationView.m
//  ICan
//
//  Created by Kalana Rathnayaka on 16/02/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ChatRightAnimationView.h"
#import "FLAnimatedImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "WCDBManager+ChatModel.h"
#import "FLAnimatedImage.h"
@interface ChatRightAnimationView()
@property (strong, nonatomic)  UIView *imageBgView;
@property (strong, nonatomic)  UIView *NewView;
@property (strong, nonatomic)  FLAnimatedImageView *imageMessageView;
@property (strong, nonatomic)  FLAnimatedImageView *imageVieww;
@property (strong, nonatomic)  UIView *upLoadImageMaskView;
@property (strong, nonatomic)  UIActivityIndicatorView *loadProgressView;
@property (strong, nonatomic)  UILabel *loadPercentLB;
@end
@implementation ChatRightAnimationView
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self testGame];
}
-(void)getImages{
    UIImageView *abc = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0, 85, 85)];
    if ([self.imgName isEqualToString:@"Gamify_DICE_1"]) {
        abc.image = [UIImage imageNamed:@"diceface_1"];
        [self.imageMessageView addSubview:abc];
    }else if ([self.imgName isEqualToString:@"Gamify_DICE_2"]) {
        abc.image = [UIImage imageNamed:@"diceface_2"];
        [self.imageMessageView addSubview:abc];
    }else if ([self.imgName isEqualToString:@"Gamify_DICE_3"]) {
        abc.image = [UIImage imageNamed:@"diceface_3"];
        [self.imageMessageView addSubview:abc];
    }else if ([self.imgName isEqualToString:@"Gamify_DICE_4"]) {
        abc.image = [UIImage imageNamed:@"diceface_4"];
        [self.imageMessageView addSubview:abc];
    }else if ([self.imgName isEqualToString:@"Gamify_DICE_5"]) {
        abc.image = [UIImage imageNamed:@"diceface_5"];
        [self.imageMessageView addSubview:abc];
    }else if ([self.imgName isEqualToString:@"Gamify_DICE_6"]) {
        abc.image = [UIImage imageNamed:@"diceface_6"];
        [self.imageMessageView addSubview:abc];
    }
}
-(void)testGame{
    if (self.isAnimated == NO) {
        [self popUpShow:self];
    }else {
        [self getImages];
    }
}
-(void)popUpShow:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dice" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.imageVieww = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(220, 0, 85, 85)];
    self.imageVieww.animatedImage = image;
    [self.imageMessageView addSubview:self.imageVieww];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(self.currentChatModel.sendState == 1){
            [self popUpHide];
        }
    });
}
-(void)popUpHide{
    [self getImages];
    [self.imageVieww stopAnimating];
    [self.imageVieww removeFromSuperview];
    self.currentChatModel.gamificationStatus = 0;
    [[WCDBManager sharedManager] updateGamificationStatusWithChatModel:self.currentChatModel];
}
-(void)setImageModel:(ChatModel *)imageModel{
    _imageModel = imageModel;
    self.currentChatModel = imageModel;
}
-(void)setUpUI{
    [super setUpUI];
    [self.bodyContentView addSubview:self.imageMessageView];
    [self.bodyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@85);
        make.height.equalTo(@85);
        make.top.bottom.right.equalTo(@0);
        make.left.equalTo(@30);
    }];
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *imageLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageMessageView addGestureRecognizer:imageLongGesture];
    [self.imageMessageView addGestureRecognizer:imageTap];
    imageLongGesture.minimumPressDuration = 0.3;
//    [self.imageMessageView layerWithCornerRadius:5 borderWidth:0 borderColor:UIColorSeparatorColor];-----> this comment will need in futre enhancements
}
- (FLAnimatedImageView *)imageMessageView{
    if (!_imageMessageView) {
        _imageMessageView = [[FLAnimatedImageView alloc]init];
        _imageMessageView.userInteractionEnabled = YES;
    }
    return _imageMessageView;
}
-(UIView *)upLoadImageMaskView{
    if (!_upLoadImageMaskView) {
        _upLoadImageMaskView = [[UIView alloc]init];
        _upLoadImageMaskView.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
    }
    return _upLoadImageMaskView;
}
-(UILabel *)loadPercentLB{
    if (!_loadPercentLB) {
        _loadPercentLB = [UILabel centerLabelWithTitle:nil font:14 color:UIColorWhite];
    }
    return _loadPercentLB;
}
-(UIActivityIndicatorView *)loadProgressView{
    if (!_loadProgressView) {
        if (@available(iOS 13.0, *)) {
            _loadProgressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            _loadProgressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }
    }
    return _loadProgressView;
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    self.convertRectView = self.imageMessageView;
    [super longPress:longPressGes];
}
@end
