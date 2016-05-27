//
//  TCWebView.h
//  TCWebView
//
//  Created by TailC on 16/3/22.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol TCWebViewDelegate <NSObject>

@optional


@end

@interface TCWebView : UIView

@property (strong,nonatomic) UIWebView *uiWebView;
@property (strong,nonatomic) WKWebView *wkWebView;

/**
 *  需执行的JS代码
 */
@property (strong,nonatomic) NSString *jsCodeStr;

@property (weak,nonatomic) id<TCWebViewDelegate> delegate;

/**
 *  初始化
 */
-(instancetype)initWithFrame:(CGRect)frame;

/**
 *  加载一个URL Requst
 *
 *  @param request URL Request
 */
-(void)loadRequest:(NSURLRequest *)request;

-(void)callWithJSFouncationName:(NSString *)founcationName WithArguments:(NSString *)arguments;

@end
