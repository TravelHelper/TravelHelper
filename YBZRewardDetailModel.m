//
//  YBZRewardDetailModel.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRewardDetailModel.h"

@implementation YBZRewardDetailModel

- (instancetype)initWithTitle:(NSString *)title AndContent:(NSString *)content AndImageUrl:(NSString *)image AndTime:(NSString *)time AndTag:(NSString *)tag AndNumber:(NSUInteger)number AndAnswerList:(NSMutableArray *)array AndState:(NSString *)state AndAcceptId:(NSString *)accept_id
{
    self = [super init];
    if (self) {
        
        self.rewardTitle = title;
        self.rewardContent = content;
        self.rewardImageName = image;
        self.rewardTime = time;
        self.answerPeopleNum = number;
        self.rewardTag = tag;
        self.acceptAnswer = accept_id;
        if (![array isKindOfClass:[NSString class]]) {
            self.answerArr = array;
        }else{
            self.answerArr = nil;
        }
        self.rewardState = state;
    }
    return self;
}



@end
