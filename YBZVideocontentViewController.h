//
//  YBZVideocontentViewController.h
//  YBZTravel
//
//  Created by 王俊钢 on 2016/10/23.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZVideocontentViewController : UIViewController

- (instancetype)initWithUserId:(NSString *)userId
                      targetId:(NSString *)targetId
                       andType:(NSString *)type
                     andIsCall:(BOOL)isCall;

@end
