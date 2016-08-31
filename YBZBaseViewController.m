//
//  YBZBaseViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZBaseViewController.h"

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
      
        self.title  = title;
        
    }
    return self;
}


@end
