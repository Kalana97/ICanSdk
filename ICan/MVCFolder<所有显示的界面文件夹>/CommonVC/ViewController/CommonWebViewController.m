//
//  CommonWebViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/20.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>


@interface CommonWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic,strong) WKWebView * webView;
@end
@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPresent) {
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_pop_close_white") target:self action:@selector(closeButtonAction)];
    }
    
    if (self.isShare) {
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_red_more") target:self action:@selector(shareButtonAction)];
    }
    
    
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)initUI {
    [self.view addSubview:self.webView];
    // UI代理
    self.webView.UIDelegate = self;
    // 导航代理
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = false;//禁止滑动
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    //    self.webView.allowsBackForwardNavigationGestures = YES;
    //    [self.webView goBack];
    //    //页面前进
    //    [self.webView goForward];
    NSURLRequest *urlRequest;
    if (self.localString) {
        urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.localString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        [self.webView loadRequest:urlRequest];
    }else if (self.urlString){
        NSString *encodedString = self.urlString.netUrlEncoded;
        NSURL *weburl = [NSURL URLWithString:encodedString];
        urlRequest= [NSURLRequest requestWithURL:weburl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        [self.webView loadRequest:urlRequest];
    }
    for (UIView *subView in [self.webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]){// 不显示竖直的滚动条
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
        }
    }
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
  
  
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"内容开始返回");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [QMUITips hideAllTips];
    DDLogInfo(@"页面加载完成");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    DDLogInfo(@"页面加载失败");
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"接收到服务器跳转请求");
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    DDLogInfo(@"收到响应后 %@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

-(void)closeButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareButtonAction{
    
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:@"Using the alert controller" preferredStyle:UIAlertControllerStyleActionSheet];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//            // Cancel button tappped.
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//            // Distructive button tapped.
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }]];
//
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//            // OK button tapped.
//
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }]];
//
//        // Present action sheet.
//        [self presentViewController:actionSheet animated:YES completion:nil];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-HomeIndicatorHeight)];
    }
    return _webView;
}
@end
