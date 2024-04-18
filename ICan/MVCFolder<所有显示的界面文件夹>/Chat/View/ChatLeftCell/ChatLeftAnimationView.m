//
//  ChatLeftAnimationView.m
//  ICan
//
//  Created by Kalana Rathnayaka on 16/02/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ChatLeftAnimationView.h"
#import "FLAnimatedImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "WCDBManager+ChatModel.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImage.h"

@interface ChatLeftAnimationView ()
@property (strong, nonatomic)  UIView *imageBgView;
@property (strong, nonatomic)  UIView *NewView;
@property (strong, nonatomic)  FLAnimatedImageView *imageMessageView;
@property (strong, nonatomic)  FLAnimatedImageView *animatedImageView;
@property (strong, nonatomic)  UIView *upLoadImageMaskView;
@property (strong, nonatomic)  UIActivityIndicatorView *loadProgressView;
@property (strong, nonatomic)  UILabel *loadPercentLB;
@end

@implementation ChatLeftAnimationView
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self testGame];
}
-(void)getImages{
    UIImageView *abc = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 85, 85)];
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
//        [self performSelector:@selector(POPUpshow:) withObject:self afterDelay:0]; ==> I need this for future usage..
        [self popUpShow:self];
    }else {
        [self getImages];
    }
}
-(void)popUpShow:(id)sender{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dice" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(10, 0, 85, 85)];
    self.animatedImageView.animatedImage = image;
    [self.imageMessageView addSubview:self.animatedImageView];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self popUpHide];
    });
}
-(void)popUpHide{
    [self getImages];
    [self.animatedImageView stopAnimating];
    [self.animatedImageView removeFromSuperview];
    self.currentChatModel.gamificationStatus = 0;
    [[WCDBManager sharedManager]updateGamificationStatusWithChatModel:self.currentChatModel];
}
-(void)setImageModel:(ChatModel *)imageModel{
    _imageModel = imageModel;
    self.currentChatModel = imageModel;
}
-(void)setUpUI{
    [super setUpUI];
    [self.contentVerticalStackView addArrangedSubview:self.imageMessageView];
    [self.imageMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
    }];
    UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *imageLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageMessageView addGestureRecognizer:imageLongGesture];
    [self.imageMessageView addGestureRecognizer:imageTap];
    imageLongGesture.minimumPressDuration = 0.3;
//    [self.imageMessageView layerWithCornerRadius:5 borderWidth:0 borderColor:UIColorSeparatorColor]; ---> this comment is needed for future enhancements
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

