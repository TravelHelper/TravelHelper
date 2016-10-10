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



@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundStyle];
    [self getThreeLabelWithData];
    [self getImageView];

}

-(void)setBackgroundStyle{

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于嗨番";
}

-(void)getImageView{

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head"]];
    imageView.frame = CGRectMake(0.339*SCREEN_WIDTH, 0.245*SCREEN_HEIGHT, 0.322*SCREEN_WIDTH, 0.322*SCREEN_WIDTH);
    [self.view addSubview:imageView];
}

-(void)getThreeLabelWithData{
    
    UILabel *nameLabel = [self getLabelWithType:1 AndData:@"正在获取……"];
    UILabel *editionLabel = [self getLabelWithType:2 AndData:@"正在获取……"];
    UILabel *ownerLabel = [self getLabelWithType:3 AndData:@"正在获取……"];
    [self.view addSubview:nameLabel];
    [self.view addSubview:editionLabel];
    [self.view addSubview:ownerLabel];
    [WebAgent getHaveFunInfo:^(id responseObject) {
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        
        
        nameLabel.text =  [NSString stringWithFormat: @"应用名称：%@",dict[@"name"]];
        editionLabel.text = [NSString stringWithFormat: @"应用名称：%@",dict[@"edition"]];
        ownerLabel.text =  [NSString stringWithFormat: @"应用名称：%@",dict[@"owner"]];

    } failure:^(NSError *error) {
        
    }];

}


-(UILabel *)getLabelWithType:(int)type AndData:(NSString *)data{

    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:0.0371*SCREEN_WIDTH];
    label.textColor = [UIColor grayColor];


    switch (type) {
        case 1:
            NSLog(@"1");
            label.text = [NSString stringWithFormat: @"应用名称：%@",data];
            label.frame = CGRectMake(0.203*SCREEN_WIDTH, 0.5824*SCREEN_HEIGHT, 0.794*SCREEN_WIDTH, 0.062*SCREEN_WIDTH);
            break;
        case 2:
            NSLog(@"2");
            label.text = [NSString stringWithFormat: @"版本号：%@",data];
            label.frame = CGRectMake(0.203*SCREEN_WIDTH, 0.6324*SCREEN_HEIGHT, 0.794*SCREEN_WIDTH, 0.062*SCREEN_WIDTH);
            break;
        case 3:
            NSLog(@"3");
            label.text = [NSString stringWithFormat: @"公司名称：%@",data];
            label.frame = CGRectMake(0.203*SCREEN_WIDTH, 0.6824*SCREEN_HEIGHT, 0.794*SCREEN_WIDTH, 0.062*SCREEN_WIDTH);
            break;

        default:
            break;
    }
    return label;
}









@end
