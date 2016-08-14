//
//  YBZWaitingViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZWaitingViewController.h"
#import "WebAgent.h"

@interface YBZWaitingViewController ()

@end

@implementation YBZWaitingViewController{

    NSString *userID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    userID = user_id[@"user_id"];
  
    [self.view addSubview:[self getReturnBtn]];
}

-(UIButton *)getReturnBtn{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:@"取消等候" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(70, 200, 100,100);
    return btn;
}

-(void)viewWillAppear:(BOOL)animated{

    
}

-(void)popToRoot{

    [WebAgent removeFromWaitingQueue:userID success:^(id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}


@end
