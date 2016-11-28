//
//  ViewController.h
//  EvaluatePeole
//
//  Created by sks on 16/7/13.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController

- (instancetype)initWithtargetID:(NSString *)targetID;
- (instancetype)initWithtargetID:(NSString *)targetID AndmassageId:(NSString *)msgId;

@end

