//
//  YBZTranslatorDetailViewController.h
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZBaseViewController.h"

@interface YBZTranslatorDetailViewController : YBZBaseViewController


@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong) UITextView *answerTextView; //显示回答内容
@property(nonatomic,assign) NSString    *countPeople;
@property(nonatomic,strong) UILabel *showAnswerLabel;
@end
