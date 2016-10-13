//
//  ZDYKWebViewController.m
//  HYTCosmetic
//
//  Created by yangshengchao on 14/12/22.
//  Copyright (c) 2014年 ZhongDaYunKe. All rights reserved.
//

#import "YSCWebViewController.h"

#define KeyOfCachedHtmlString(type)       [NSString stringWithFormat:@"KeyOfCachedHtmlString_%@", (type)]

@interface YSCWebViewController () <UIWebViewDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *htmlString;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSURLRequest *request;
@property (assign, nonatomic) BOOL authenticated;

@end

@implementation YSCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipsView = [YSCKTipsView CreateYSCTipsViewOnView:self.webView edgeInsets:UIEdgeInsetsZero withMessage:@"" iconImage:[UIImage imageNamed:kDefaultTipsEmptyIcon] buttonTitle:nil buttonAction:nil];
    self.tipsView.actionButton.hidden = YES;
    self.tipsView.hidden = YES;
    
    if (self.params[kParamUrl]) {
        NSString *url = Trim(self.params[kParamUrl]);
        if (NO == [url isContains:@"http"]) {//兼容没有输入http://的情况
            url = [NSString stringWithFormat:@"http://%@", url];
        }
        if ([url isUrl]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
        else {
            self.tipsView.hidden = NO;
            self.tipsView.messageLabel.text = @"传入的URL为空";
        }
    }
    else if (self.params[kParamContent]) {
        NSString *content = Trim(self.params[kParamContent]);
        [self.webView loadHTMLString:content baseURL:nil];
    }
    else if (self.params[kParamMethod]) {
        NSString *method = Trim(self.params[kParamMethod]);
        NSDictionary *params = self.params[kParamParams];
        self.type = params[kParamType];
        if ([NSString isEmpty:self.type] || [NSString isEmpty:method]) {
            [self showResultThenBack:@"参数有误"];
            return;
        }
        self.htmlString = [self cachedObjectForKey:KeyOfCachedHtmlString(self.type)];
        [self layoutHtmlString];
        [self laodHtmlWithMethod:method andParams:params];
    }
}

//直接显示html数据
- (void)layoutHtmlString {
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}

#pragma mark - 网络访问
- (void)laodHtmlWithMethod:(NSString *)method andParams:(NSDictionary *)params {
    WEAKSELF
    [BaseDataModel GetByMethod:method
                        params:params
                         block:^(NSObject *object, NSString *errorMessage) {
                             if (isEmpty(errorMessage)) {
                                 weakSelf.htmlString = (NSString *)object;
                                 [weakSelf saveObject:object forKey:KeyOfCachedHtmlString(weakSelf.type)];
                                 [weakSelf layoutHtmlString];
                             }
                             else {
                                 [UIView showResultThenHideOnWindow:errorMessage];
                             }
                         }];
}

#pragma mark - UIWebViewDelegate
// Note: This method is particularly important. As the server is using a self signed certificate,
// we cannot use just UIWebView - as it doesn't allow for using self-certs. Instead, we stop the
// request in this method below, create an NSURLConnection (which can allow self-certs via the delegate methods
// which UIWebView does not have), authenticate using NSURLConnection, then use another UIWebView to complete
// the loading and viewing of the page. See connection:didReceiveAuthenticationChallenge to see how this works.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showHUDLoading:@""];
    NSString *scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (NO == self.authenticated) {
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
    [self hideHUDLoading];
    WEAKSELF
    [self bk_performBlock:^(id obj) {//延迟1秒可以解决：首次进入时webview.contentheight高度不正确的问题。
        [weakSelf.webView.scrollView scrollsToTop];
    } afterDelay:1.5];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self resizeWebviewHeight];
    self.tipsView.hidden = YES;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (isEmpty(self.navigationItem.title) && isNotEmpty(title)) {
        self.navigationItem.title = title;
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self resizeWebviewHeight];
    self.tipsView.hidden = NO;
    self.tipsView.messageLabel.text = GetNSErrorMsg(error);
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
    self.authenticated = YES;
    [self.webView loadRequest:self.request];
}


@end
