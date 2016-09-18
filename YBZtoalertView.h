//
//  YBZalertView.h
//  YBZTravel
//
//  Created by 刘芮东 on 16/9/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBZtoAlertModel.h"

@interface YBZtoalertView : UIView

- (instancetype)initWithFrame:(CGRect)frame andModel:(YBZtoAlertModel *)model;
-(void)addModel:(YBZtoAlertModel *)model;

@end
