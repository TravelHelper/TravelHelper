//
//  ViewController.m
//  aboutYBZ
//
//  Created by sks on 16/7/14.
//  Copyright © 2016年 heyi. All rights reserved.
//

#import "AboutViewController.h"
#import "AFNetworking.h"
#import "WebAgent.h"
#import "APIClient.h"
#import "MBProgressHUD+XMG.h"
#import "ZLCWebView.h"

@interface AboutViewController ()<ZLCWebViewDelegate>

@property (nonatomic ,strong) UITextView *textView;
//@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关于嗨番";
    
    ZLCWebView *my = [[ZLCWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [my loadURLString:@"http://www.baidu.com"];
    my.delegate = self;
    [self.view addSubview:my];
    
   //
//    UIImage* image = [UIImage imageNamed:@"translator"];
//    UIImageView *logoYBZ   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 130)];
//    [logoYBZ setImage:image];
//    logoYBZ.contentMode =  UIViewContentModeCenter;
//    [self.view addSubview:logoYBZ];
//    
//    
//    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 194,self.view.bounds.size.width, self.view.bounds.size.height)];
//    self.textView.font = [UIFont boldSystemFontOfSize:20];
//    [self.view addSubview:self.textView];
//    
//    
//    
//    [WebAgent version_numAbout:@"1.0" success:^(id responseObject) {
//        NSData *data = [[NSData alloc]initWithData:responseObject];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
//        
//        NSDictionary *offsend = dic[@"official_send"];
//        NSString *aString = offsend[@"about-text"];
//        
//        NSLog(@"%@",aString);
//        self.textView.text = aString;
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
//    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [MBProgressHUD showMessage:@"界面加载中"];
  
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.webView = [[UIWebView alloc]initWitrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    

}
- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{

    NSLog(@"页面开始加载");
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
//    [MBProgressHUD hideHUD];
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
//    [MBProgressHUD hideHUD];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
