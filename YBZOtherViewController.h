//
//  YBZOtherViewController.h
//  YBZTravel
//
//  Created by tjufe on 16/8/4.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBZOtherViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *chooseLanguageArr;
@property (nonatomic, copy) void(^addLanguageBlock)(NSString *language);



@end
