//
//  CustomTranslateInfoModel.h
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTranslateInfoModel : NSObject

@property(nonatomic ,strong)NSString *customID;
@property(nonatomic ,strong)NSString *langueKind;
@property(nonatomic ,strong)NSString *scene;
@property(nonatomic ,strong)NSString *content;
@property(nonatomic ,strong)NSString *interper;
@property(nonatomic ,strong)NSString *translateTime;
@property(nonatomic ,strong)NSString *duration;
@property(nonatomic ,strong)NSString *offerMoney;
@property(nonatomic ,strong)NSString *publishTime;
@property(nonatomic ,strong)NSString *cellKind;
@property(nonatomic ,strong)NSString *user_id;

@property(nonatomic ,strong)NSString *star;


- (instancetype)initWithcustomID:(NSString *)customID
                      langueKind:(NSString *)langueKind
                           scene:(NSString *)scene
                           content:(NSString *)content
                          interper:(NSString *)interper
                     translateTime:(NSString *)translateTime
                          duration:(NSString *)duration
                        offerMoney:(NSString *)offerMoney
                       publishTime:(NSString *)publishTime
                          cellKind:(NSString *)cellKind;

@end
