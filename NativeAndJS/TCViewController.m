//
//  TCViewController.m
//  NativeAndJS
//
//  Created by TailC on 16/3/23.
//  Copyright © 2016年 auxiphone. All rights reserved.
//

#import "TCViewController.h"
#import "TCWebView.h"

@interface TCViewController ()

@property (strong,nonatomic) TCWebView *webView;

@end

@implementation TCViewController

-(void)viewDidLoad{
	NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ExampleApp.html"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
	[self.webView loadRequest:request];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	
}

@end
