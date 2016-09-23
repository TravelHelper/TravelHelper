//
//  CustomTranslateCellFramInfo.h
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomTranslateInfoModel.h"



@interface CustomTranslateCellFramInfo : NSObject

@property(nonatomic,strong)CustomTranslateInfoModel *infoModel;

@property(nonatomic,assign)CGRect cellViewFram;

@property(nonatomic,assign)CGRect langueKindLableFrame;
@property(nonatomic,assign)CGRect sceneLableFrame;
@property(nonatomic,assign)CGRect contentLableFrame;
@property(nonatomic,assign)CGRect interperLableFrame;
@property(nonatomic,assign)CGRect translateTimeLableFrame;
@property(nonatomic,assign)CGRect durationLableFrame;
@property(nonatomic,assign)CGRect offerMoneyLableFrame;
@property(nonatomic,assign)CGRect publishTimeLableFrame;

@property(nonatomic,assign)CGRect lageKFrame;
@property(nonatomic,assign)CGRect scFrame;
@property(nonatomic,assign)CGRect cntFrame;
@property(nonatomic,assign)CGRect itpFrame;
@property(nonatomic,assign)CGRect tslTimeFrame;
@property(nonatomic,assign)CGRect drtFrame;
@property(nonatomic,assign)CGRect ofmFrame;
@property(nonatomic,assign)CGRect pbmFrame;
@property(nonatomic,assign)CGRect tagImgViewFrame;

- (instancetype)initWithInfoModel:(CustomTranslateInfoModel *)infoModel;


@end
