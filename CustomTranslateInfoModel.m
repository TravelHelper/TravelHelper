//
//  CustomTranslateInfoModel.m
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "CustomTranslateInfoModel.h"

@implementation CustomTranslateInfoModel
- (instancetype)initWithlangueKind:(NSString *)langueKind
                             scene:(NSString *)scene
                           content:(NSString *)content
                          interper:(NSString *)interper
                     translateTime:(NSString *)translateTime
                          duration:(NSString *)duration
                        offerMoney:(NSString *)offerMoney
                       publishTime:(NSString *)publishTime
                          cellKind:(NSString *)cellKind
{
    self = [super init];
    if (self) {
        self.langueKind = langueKind;
        self.scene = scene;
        self.content = content;
        self.interper = interper;
        self.translateTime = translateTime;
        self.duration = duration;
        self.offerMoney = offerMoney;
        self.publishTime = publishTime;
        self.cellKind = cellKind;
    }
    return self;
}
@end
