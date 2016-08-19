//
//  CellInformation.m
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "CellInformation.h"

#define kScreenWindth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

#define kSubViewHorizontalMargin 5//水平
#define kSubViewVerticalMargin   10//垂直
//题目的位置
#define knickNameX        15
#define knickNameY        10
@interface CellInformation()
@end
@implementation CellInformation
- (instancetype)initWithInformation:(Information *)information
{
    self = [super init];
    if (self) {
        //题目
        CGSize size = [information.titleText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.titleTextLableFrame = CGRectMake(knickNameX, knickNameY,size.width, size.height);
        
        //时间
        size = [information.time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.timeLabelFrame = CGRectMake(knickNameX, kSubViewHorizontalMargin+self.titleTextLableFrame.origin.y+self.titleTextLableFrame.size.height, size.width, size.height);
        
        //游币
        size = [information.youBi sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.youBiLableFrame = CGRectMake(kScreenWindth-size.width-10, kSubViewVerticalMargin+20, size.width, size.height);
        //cell高度
        self.cellHeight = self.timeLabelFrame.origin.y+self.timeLabelFrame.size.height+ kSubViewVerticalMargin;
        
    }
    return self;
}



@end
