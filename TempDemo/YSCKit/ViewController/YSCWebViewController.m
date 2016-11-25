//
//  ZDYKWebViewController.m
//  HYTCosmetic
//
//  Created by yangshengchao on 14/12/22.
//  Copyright (c) 2014年 ZhongDaYunKe. All rights reserved.
//

#import "YSCWebViewController.h"

@interface YSCWebViewController () <UIWebViewDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTop;//64
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSURLRequest *request;
@property (assign, nonatomic) BOOL authenticated;
@end

@implementation YSCWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewTop.constant = (self.customTitleView ? 64 : 0);
    [self showHUDOnSelfView];
    self.webUrl = [NSString stringWithFormat:@"%@", self.params[kParamUrl]];
    if ( ! [self.webUrl isContains:@"http"]) {//兼容没有输入http://的情况
        self.webUrl = [NSString stringWithFormat:@"http://%@", self.webUrl];
    }
    if ([self.webUrl isWebUrl]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }
    else {
        [self showTipsWithMessage:@"传入的URL为空" buttonAction:nil];
        self.tipsView.actionButton.hidden = YES;
    }
}
- (NSString *)customTitleViewName {
    return [NSString stringWithFormat:@"%@", self.params[kParamTitleView]];
}

#pragma mark - UIWebViewDelegate
// Note: This method is particularly important. As the server is using a self signed certificate,
// we cannot use just UIWebView - as it doesn't allow for using self-certs. Instead, we stop the
// request in this method below, create an NSURLConnection (which can allow self-certs via the delegate methods
// which UIWebView does not have), authenticate using NSURLConnection, then use another UIWebView to complete
// the loading and viewing of the page. See connection:didReceiveAuthenticationChallenge to see how this works.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if ( ! self.authenticated) {
            self.request = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [self.webView stopLoading];
            return NO;
        }
    }
    return YES;
}
- (void)resizeWebviewHeight {
    @weakiy(self);
    [self bk_performBlock:^(id obj) {
        //延迟1.5秒可以解决：首次进入时webview.contentheight高度不正确的问题。
        [weak_self.webView.scrollView scrollsToTop];
    } afterDelay:1.5];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self resizeWebviewHeight];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (OBJECT_IS_EMPTY(self.navigationItem.title) && OBJECT_ISNOT_EMPTY(title)) {
        self.navigationItem.title = title;
    }
    [self hideTipsView:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    @weakiy(self);
    [self resizeWebviewHeight];
    NSString *errorMessage = GET_NSERROR_MESSAGE(error);
    [self hideHUDOnSelfView];
    [self showTipsWithMessage:errorMessage buttonAction:^{
        [weak_self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weak_self.webUrl]]];
    }];
}

#pragma mark - NURLConnection delegate
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL *baseURL = [self.request URL];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response; {
    [connection cancel];
    [self showHUDOnSelfView];
    self.authenticated = YES;
    [self.webView loadRequest:self.request];
}
@end
