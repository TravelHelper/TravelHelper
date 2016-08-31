//
//  YBZRewardHallDetailModel.h
//  YBZTravel
//
//  Created by 孙锐 on 16/8/27.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZRewardHallDetailModel : NSObject
@property (nonatomic, strong) NSString *rewardTitle;
@property (nonatomic, strong) NSString *rewardContent;
@property (nonatomic, strong) NSString *rewardImageName;
@property (nonatomic, strong) NSString *rewardTime;
@property (nonatomic, strong) NSString *rewardTag;
@property (nonatomic, strong) NSString *rewardMoney;
@property (nonatomic, assign) NSUInteger answerPeopleNum;
@property (nonatomic, strong) NSMutableArray *answerArr;

- (instancetype)initWithTitle:(NSString *)title AndContent:(NSString *)content AndImageUrl:(NSString *)image AndTime:(NSString *)time AndTag:(NSString *)tag AndNumber:(NSUInteger)number AndAnswerList:(NSMutableArray *)array AndMoney:(NSString* )money ;


@end
