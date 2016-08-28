//
//  YBZRewardHallDetailModel.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/27.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRewardHallDetailModel.h"

@implementation YBZRewardHallDetailModel
- (instancetype)initWithTitle:(NSString *)title AndContent:(NSString *)content AndImageUrl:(NSString *)image AndTime:(NSString *)time AndTag:(NSString *)tag AndNumber:(NSUInteger)number AndAnswerList:(NSMutableArray *)array AndMoney:(NSString *)money
{
    self = [super init];
    if (self) {
        
        self.rewardTitle = title;
        self.rewardContent = content;
        self.rewardImageName = image;
        self.rewardTime = time;
        self.answerPeopleNum = number;
        self.rewardTag = tag;
        if (![array isKindOfClass:[NSString class]]) {
            self.answerArr = array;
        }else{
            self.answerArr = nil;
        }
        self.rewardMoney = money;
    }
    return self;
}

@end
