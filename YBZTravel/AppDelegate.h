//
//  AppDelegate.h
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZMyWindow.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSDictionary *userDic;

@property (nonatomic, strong) UIWindow *thisAlertWindow;

@property (nonatomic,strong) YBZMyWindow *myWindow;
@end

