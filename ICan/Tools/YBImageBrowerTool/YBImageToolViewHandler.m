//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 3/1/2020
 - File name:  YBImageToolViewHandler.m
 - Description:
 - Function List:
 */


#import "YBImageToolViewHandler.h"
#import "YBIBImageData.h"
#import "YBIBToastView.h"
#import <SDWebImage/SDWebImage.h>
#import "SaveViewManager.h"
#import "YBIBTopView.h"
@interface YBImageToolViewHandler()
@property (nonatomic, strong) UIButton *viewOriginButton;
@property(nonatomic, strong) UIButton *saveButton;


@end
@implementation YBImageToolViewHandler
#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentPage = _yb_currentPage;
@synthesize yb_totalPage = _yb_totalPage;
@synthesize yb_currentOrientation = _yb_currentOrientation;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.viewOriginButton];
    [self.yb_containerView addSubview:self.saveButton];
    [self.yb_containerView addSubview:self.pageLabel];
    [self.yb_containerView addSubview:self.operationButton];
    CGFloat top=isIPhoneX?74:60;
    CGSize size = self.yb_containerSize(self.yb_currentOrientation());
    self.saveButton.frame=CGRectMake(ScreenWidth-55, ScreenHeight-120, 40, 40);
    self.viewOriginButton.center = CGPointMake(size.width / 2.0, size.height - 80);
    
    self.pageLabel.frame=CGRectMake(ScreenWidth-55, top, 80, 20);
    self.pageLabel.center = CGPointMake(size.width / 2.0, top);
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.equalTo(self.pageLabel.mas_centerY);
        make.width.height.equalTo(@50);
    }];
//    self.operationButton.frame=CGRectMake(ScreenWidth-55, top, 50, 50);
}

- (void)yb_hide:(BOOL)hide {
    self.viewOriginButton.hidden = hide;
    self.saveButton.hidden=hide;
    YBIBImageData *data = (YBIBImageData*)self.yb_currentData();
    // 有原图就显示按钮
      [self.viewOriginButton setTitle:@"View Original Photo".icanlocalized forState:UIControlStateNormal];
    if (data.extraData) {
        self.viewOriginButton.hidden = !data.extraData;
        
    }else{
        self.viewOriginButton.hidden =YES;
    }
}

- (void)yb_pageChanged {
    // 拿到当前的数据对象（此案例都是图片）
    YBIBImageData *data = (YBIBImageData*)self.yb_currentData();
    // 有原图就显示按钮
      [self.viewOriginButton setTitle:@"View Original Photo".icanlocalized forState:UIControlStateNormal];
    if (data.extraData) {
        self.viewOriginButton.hidden = !data.extraData;
        
    }else{
        self.viewOriginButton.hidden =YES;
    }
    [self setPage:self.yb_currentPage() totalPage:self.yb_totalPage()];
  
    [self updateViewOriginButtonSize];
}
- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage {
    if (totalPage <= 1) {
        self.pageLabel.hidden = YES;
    } else {
        self.pageLabel.hidden  = NO;
        
        NSString *text = [NSString stringWithFormat:@"%ld/%ld", page + (NSInteger)1, (long)totalPage];
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = 4;
        shadow.shadowOffset = CGSizeMake(0, 1);
        shadow.shadowColor = UIColor.darkGrayColor;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName:shadow}];
        self.pageLabel.attributedText = attr;
    }
}
- (void)yb_orientationChangeAnimationWithExpectOrientation:(UIDeviceOrientation)orientation {
    // 旋转的效果自行处理了
}

#pragma mark - private

- (void)updateViewOriginButtonSize {
    CGSize size = self.viewOriginButton.intrinsicContentSize;
    self.viewOriginButton.bounds = (CGRect){CGPointZero, CGSizeMake(size.width + 15, size.height)};
}

#pragma mark - event

- (void)clickViewOriginButton:(UIButton *)button {
    
    // 拿到当前的数据对象（此案例都是图片）
    YBIBImageData *data = (YBIBImageData*)self.yb_currentData();
    
    // 拿到原图的地址（这里直接使用一样的地址是为了演示，业务中请关联真正的原图地址）
    NSURL *originURL = data.extraData;
    //下载
    SDWebImageDownloaderOptions options = SDWebImageDownloaderLowPriority | SDWebImageDownloaderAvoidDecodeImage;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:originURL options:options context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //仅当下载的 data 是当前显示的 data 时才更新进度
            if (data == self.yb_currentData()) {
                CGFloat progress = receivedSize * 1.0 / expectedSize ?: 0;
                NSString *text = [NSString stringWithFormat:@"%.0lf%@", progress * 100, @"%"];
                [self.viewOriginButton setTitle:text forState:UIControlStateNormal];
                [self updateViewOriginButtonSize];
            }
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable imageData, NSError * _Nullable error, BOOL finished) {
        
        //仅当下载的 data 是当前显示的 data 时处理 UI
        if (data == self.yb_currentData()) {
            if (error) {
                [self.yb_containerView ybib_showForkToast:@"Download Failed".icanlocalized];
                return;
            }
            //隐藏按钮
            self.viewOriginButton.hidden = YES;
        }
        
        //终止处理数据
        [data stopLoading];
        //清除缓存
        [data clearCache];
        //清除原图地址
        data.extraData = nil;
        //清除之前的图片数据
        data.imageURL = nil;
        //赋值新的数据
        data.imageData = ^NSData * _Nullable{
            return imageData;
        };
        
        //重载
        [data loadData];
        [[SDImageCache sharedImageCache]storeImageDataToDisk:imageData forKey:originURL.absoluteString];
    }];
}

#pragma mark - getters
-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setImage:UIImageMake(@"scan_preserve") forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
-(void)saveButtonAction{
   // 拿到当前的数据对象（此案例都是图片）
    YBIBImageData *data = (YBIBImageData*)self.yb_currentData();
    if (data.originImage) {
        [SaveViewManager saveImageToPhotos:data.originImage success:^{
             [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
        } failed:^{
             [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
        }];
    }
    
}
- (UIButton *)viewOriginButton {
    if (!_viewOriginButton) {
        _viewOriginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewOriginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_viewOriginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _viewOriginButton.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.75];
        _viewOriginButton.layer.cornerRadius = 5.0;
        [_viewOriginButton addTarget:self action:@selector(clickViewOriginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewOriginButton;
}
- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont boldSystemFontOfSize:17];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _pageLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _operationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationButton setTitle:@"Delete".icanlocalized forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(clickOperationButton) forControlEvents:UIControlEventTouchUpInside];
        _operationButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _operationButton.layer.shadowOffset = CGSizeMake(0, 1);
        _operationButton.layer.shadowOpacity = 1;
        _operationButton.layer.shadowRadius = 4;
    }
    return _operationButton;
}
-(void)clickOperationButton{
    if (self.deleImgeBlock) {
        self.deleImgeBlock(self.yb_currentPage());
    }
}
@end
