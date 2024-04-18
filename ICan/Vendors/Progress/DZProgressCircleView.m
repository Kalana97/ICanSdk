
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/9/2021
- File name:  DZProgressCircleView.m
- Description:
- Function List:
*/
        

#import "DZProgressCircleView.h"
#import "DZCircleView.h"
@interface DZProgressCircleView ()
@property (weak, nonatomic) IBOutlet DZCircleView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation DZProgressCircleView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    self.tipsLabel.text=@"VideoUploading".icanlocalized;
}
#pragma mark - Setter
-(void)setProgress:(CGFloat)progress{
    _progress=progress;
    self.circleView.progress=progress;
}
-(void)setTipTitle:(NSString *)tipTitle{
    _tipTitle = tipTitle;
    self.tipsLabel.text=tipTitle;
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
