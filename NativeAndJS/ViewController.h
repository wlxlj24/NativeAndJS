//
//  ViewController.h
//  NativeAndJS
//
//  Created by auxiphone on 15/9/10.
//  Copyright (c) 2015年 auxiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NativeJSExport <JSExport>
//JSExportAs(<#PropertyName#>, <#Selector#>)

-(void)jsCallNative;
-(NSString *)jsGetNativeStringData;
-(NSArray *)jsGetNativeArrayData;
-(NSDictionary *)jsGetNativeJsonData;

-(void)getTCTC;


@end


@interface ViewController : UIViewController<UIWebViewDelegate,NativeJSExport>

@property (nonatomic,weak) IBOutlet UIWebView *webView;
@property (nonatomic,strong) JSContext *context;


@end

