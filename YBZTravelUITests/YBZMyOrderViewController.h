//
//  YBZMyOrderViewController.h
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/2.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

@protocol myScrollTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end
@interface YBZMyOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) id  <myScrollTabBarDelegate>delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property(nonatomic,copy)NSArray *myTitleArray;
@end
