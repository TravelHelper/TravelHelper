//
//  CustomTranslateCellFramInfo.m
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "CustomTranslateCellFramInfo.h"
#define kScreenWidth   [[UIScreen mainScreen]bounds].size.width
#define kbigH   [[UIScreen mainScreen]bounds].size.width*0.05
#define ksmalH   [[UIScreen mainScreen]bounds].size.width*0.04
#define kVMargin   [[UIScreen mainScreen]bounds].size.width*0.008
#define kHMargin   [[UIScreen mainScreen]bounds].size.width*0.005

@implementation CustomTranslateCellFramInfo

- (instancetype)initWithInfoModel:(CustomTranslateInfoModel *)infoModel
{
    self = [super init];
    if (self) {
        
        self.infoModel = infoModel;
        
        self.lageKFrame = CGRectMake(kScreenWidth*0.351, kScreenWidth*0.056, kScreenWidth*0.1, kbigH);
        self.langueKindLableFrame = CGRectMake(CGRectGetMaxX(self.lageKFrame)+kHMargin, CGRectGetMinY(self.lageKFrame), kScreenWidth*0.1, kbigH);
        self.scFrame = CGRectMake(kScreenWidth*0.586, CGRectGetMinY(self.lageKFrame), kScreenWidth*0.1, kbigH);
        self.sceneLableFrame = CGRectMake(CGRectGetMaxX(self.scFrame )+kHMargin, CGRectGetMinY(self.lageKFrame), kScreenWidth*0.1, kbigH);
        
        self.cntFrame = CGRectMake(CGRectGetMinX(self.lageKFrame), CGRectGetMaxY(self.lageKFrame)+kVMargin, kScreenWidth*0.1, ksmalH);
        self.contentLableFrame = CGRectMake(CGRectGetMaxX(self.cntFrame)+kHMargin, CGRectGetMaxY(self.lageKFrame)+kVMargin, kScreenWidth*0.1, ksmalH);
        
        if (self.infoModel.interper != NULL) {
            self.itpFrame = CGRectMake(kScreenWidth*0.5625, CGRectGetMaxY(self.lageKFrame)+kVMargin, kScreenWidth*0.153, ksmalH);
            self.interperLableFrame = CGRectMake(CGRectGetMaxX(self.itpFrame)+kHMargin, CGRectGetMaxY(self.lageKFrame)+kVMargin, kScreenWidth*0.1, ksmalH);
        }
       
        
        self.tslTimeFrame = CGRectMake(CGRectGetMinX(self.lageKFrame), CGRectGetMaxY(self.cntFrame)+kVMargin, kScreenWidth*0.153, ksmalH);
        self.translateTimeLableFrame = CGRectMake(CGRectGetMaxX(self.tslTimeFrame)+kHMargin, CGRectGetMaxY(self.cntFrame)+kVMargin, kScreenWidth*0.39, ksmalH);
        
        self.drtFrame = CGRectMake(CGRectGetMinX(self.lageKFrame), CGRectGetMaxY(self.tslTimeFrame)+kVMargin, kScreenWidth*0.1, ksmalH);
        self.durationLableFrame = CGRectMake(CGRectGetMaxX(self.drtFrame)+kHMargin, CGRectGetMaxY(self.tslTimeFrame)+kVMargin, kScreenWidth*0.3, ksmalH);
        
        self.ofmFrame = CGRectMake(CGRectGetMinX(self.lageKFrame), CGRectGetMaxY(self.drtFrame )+kVMargin, kScreenWidth*0.153, ksmalH);
        self.offerMoneyLableFrame = CGRectMake(CGRectGetMaxX(self.ofmFrame)+kHMargin, CGRectGetMaxY(self.drtFrame )+kVMargin, kScreenWidth*0.11, ksmalH);
        
        self.pbmFrame = CGRectMake(CGRectGetMinX(self.lageKFrame), CGRectGetMaxY(self.ofmFrame )+kVMargin, kScreenWidth*0.153, ksmalH);
        self.publishTimeLableFrame = CGRectMake(CGRectGetMaxX(self.pbmFrame)+kHMargin, CGRectGetMaxY(self.ofmFrame )+kVMargin, kScreenWidth*0.39, ksmalH);
        
        self.tagImgViewFrame = CGRectMake(kScreenWidth*0.109,kScreenWidth*0.03,kScreenWidth*0.09,kScreenWidth*0.24);
        
        self.cellViewFram = CGRectMake(kScreenWidth*0.025,kScreenWidth*0.04,kScreenWidth*0.95,kScreenWidth*0.336);
    }
    return self;
}
@end
