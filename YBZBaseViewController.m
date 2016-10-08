//
//  YBZBaseViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZBaseViewController.h"
#import "JPUSHService.h"

@interface YBZBaseViewController ()

@end

@implementation YBZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        UIView *topView = [[UIView alloc]init];
        topView.frame = CGRectMake(0, -20, SCREEN_WIDTH, 20);
        topView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:0 alpha:1.0f];
        [self.view addSubview:topView];
        self.title  = title;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    


}

@end
