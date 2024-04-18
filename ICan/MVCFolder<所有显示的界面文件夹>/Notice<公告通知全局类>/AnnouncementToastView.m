//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 21/4/2020
 - File name:  AnnouncementToastView.m
 - Description:
 - Function List:
 */


#import "AnnouncementToastView.h"
#import <WebKit/WebKit.h>
@interface AnnouncementToastView()
@property(nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UIImageView *lineImageView;
@property(nonatomic, weak) IBOutlet UITextView *contentView;
@property(nonatomic, weak) IBOutlet WKWebView *webView;
/** 关闭 */
@property (weak, nonatomic) IBOutlet UIButton * closeButton;
@end
@implementation AnnouncementToastView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgImgView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.right.equalTo(@-20);
        make.left.equalTo(@20);
        make.bottom.equalTo(@-60);
    }];
}
-(void)setAnnouncementsInfo:(AnnouncementsInfo *)announcementsInfo{
    _announcementsInfo=announcementsInfo;
    self.titleLabel.hidden=self.lineImageView.hidden=self.contentView.hidden=![announcementsInfo.announcementType isEqualToString:@"Text"];
    self.webView.hidden=[announcementsInfo.announcementType isEqualToString:@"Text"];
    self.contentView.text=announcementsInfo.context;
    self.titleLabel.text=announcementsInfo.title;
    if (![announcementsInfo.announcementType isEqualToString:@"Text"]) {
        NSURLRequest*request=[NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/public/announcements/%@",BASE_URL,announcementsInfo.ID]]];
        [self.webView loadRequest:request];
    }
   
}
-(void)showView{
    UIWindow*windonw=[UIApplication sharedApplication].windows.firstObject;
    [windonw addSubview:self];
}
-(IBAction)hiddenView{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAnnouncementsViewNotication" object:nil userInfo:nil];
}
-(WKWebView *)webView{
    if (!_webView) {
        _webView=[[WKWebView alloc]init];
        _webView.backgroundColor=UIColor.whiteColor;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
    }
    return _webView;;
}

@end
