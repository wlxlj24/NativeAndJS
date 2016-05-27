//
//  ViewController.m
//  NativeAndJS
//
//  Created by auxiphone on 15/9/10.
//  Copyright (c) 2015年 auxiphone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ExampleApp.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Method 
- (IBAction)button1Clicked:(id)sender{
    [self.context[@"testInJS"] callWithArguments:@[@"我调用js文件内的方法看看"]];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 以 html title 设置 导航栏 title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
#pragma mark JSExport Methods
-(void)jsCallNative{
    
}

-(NSString *)jsGetNativeStringData{
    return @"this from native string";
    
}
-(NSArray *)jsGetNativeArrayData{
    return @[@"obj1",@"obj2"];
    
}
-(NSDictionary *)jsGetNativeJsonData{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:@[@"linpeng"] forKeys:@[@"name"]];
    return dic;
}

-(void)getTCTC{
	NSLog(@"===========");
	NSLog(@"fdsa");
	NSLog(@"===========");
}


@end
