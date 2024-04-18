
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 7/7/2021
- File name:  PayResultWebViewController.m
- Description:
- Function List:
*/
        

#import "PayResultWebViewController.h"
#import <WebKit/WebKit.h>
@interface PayResultWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic,strong) WKWebView * webView;

@end

@implementation PayResultWebViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight)];
        
    }
    return _webView;
}
-(void)initUI {
    self.title=@"Select43PayWayFooterView.payBtn".icanlocalized;
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
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.payUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:100];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    NSURLRequest*urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:self.payUrl]];
    [self.webView loadRequest:urlRequest];

    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {// 不显示竖直的滚动条
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
    [QMUITips hideAllTips];
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


@end
