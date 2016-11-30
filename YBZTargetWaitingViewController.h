//
//  YBZTargetWaitingViewController.h
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZTargetWaitingViewController : UIViewController

- (instancetype)initWithUserId:(NSString *)userId
                      targetId:(NSString *)targetId
                       andType:(NSString *)type
                     andIsCall:(BOOL)isCall
                       andName:(NSString *)name;

@end
