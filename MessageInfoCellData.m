//
//  MessageInfoCellData.m
//  YBZTravel
//
//  Created by sks on 16/8/13.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import "MessageInfoCellData.h"

@implementation MessageInfoCellData

- (instancetype)initWithimagePath:(NSString*)imagepath
                   answerNickname:(NSString*)answernickname
                       answerWord:(NSString*)answerword
                         lastTime:(NSString*)lasttime
                      acceptOrnot:(NSString*)acceptornot
{
    self = [super init];
    if (self) {
        self.imagePath = imagepath;
        self.answerNickname = answernickname;
        self.answerWord = answerword;
        self.lastTime = lasttime;
        self.rightOrnot = acceptornot;
    }
    return self;
}

@end
