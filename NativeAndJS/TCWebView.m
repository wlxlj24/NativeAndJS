//
//  TCWebView.m
//  TCWebView
//
//  Created by TailC on 16/3/22.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import "TCWebView.h"

@interface TCWebView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIWebViewDelegate>

@property (assign,nonatomic) BOOL isSupportWKWebView;	//iOS8以上，使用WKWebView

@property (strong,nonatomic) JSContext *context;

@end

@implementation TCWebView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;
		if (version >= 8.0) {
			self.isSupportWKWebView = YES;
		}else{
			self.isSupportWKWebView = NO;
		}
		
		if (self.isSupportWKWebView) {
			
			// 根据JS字符串初始化WKUserScript对象
			WKUserScript *script = [[WKUserScript alloc] initWithSource:self.jsCodeStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
			
			// 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
			WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
			[config.userContentController addUserScript:script];
			
			
			self.wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:config];
			self.wkWebView.navigationDelegate = self;
			self.wkWebView.UIDelegate = self;
			[self addSubview: self.wkWebView];
		}else{
			self.uiWebView = [[UIWebView alloc] initWithFrame:frame];
			self.uiWebView.delegate = self;
			[self addSubview:self.uiWebView];
		}
		
	}
	return self;
}

-(void)loadRequest:(NSURLRequest *)request{
	if (self.isSupportWKWebView) {
		[self.wkWebView loadRequest:request];
	}else{
		[self.uiWebView loadRequest:request];
	}
}

#pragma mark <WKNavigationDelegate>
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	
	NSLog(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	
	NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	
	NSLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	
	NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
	
	NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
	
	// 如果响应的地址是百度，则允许跳转
	if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
		
		// 允许跳转
		decisionHandler(WKNavigationResponsePolicyAllow);
		return;
	}
	// 不允许跳转
	decisionHandler(WKNavigationResponsePolicyCancel);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	
	// 如果请求的是百度地址，则延迟5s以后跳转
	if ([navigationAction.request.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
		
		// 允许跳转
		decisionHandler(WKNavigationActionPolicyAllow);
		return;
	}
	// 不允许跳转
	decisionHandler(WKNavigationActionPolicyCancel);
}


#pragma mark <WKUIDelegate>
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
	
}

#pragma mark <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
	NSLog(@"===========");
	NSLog(@"%s",__func__);
	NSLog(@"===========");
}


#pragma mark <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	
	self.context.exceptionHandler =
	^(JSContext *context, JSValue *exceptionValue)
	{
		context.exception = exceptionValue;
		NSLog(@"%@", exceptionValue);
	};
	
	// 以 JSExport 协议关联 native 的方法
	self.context[@"native"] = self;
	[self.context evaluateScript:@"getStirng()"];
	
}

-(void)callWithJSFouncationName:(NSString *)founcationName WithArguments:(NSArray *)arguments{
	[self.context[founcationName] callWithArguments:arguments];
}



@end
