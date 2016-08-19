//
//  MessageInfoCellData.h
//  YBZTravel
//
//  Created by sks on 16/8/13.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfoCellData : NSObject

@property(nonatomic,strong) NSString *imagePath;
@property(nonatomic,strong) NSString *answerNickname;
@property(nonatomic,strong) NSString *answerWord;
@property(nonatomic,strong) NSString *lastTime;
@property(nonatomic,strong) NSString *rightOrnot;

- (instancetype)initWithimagePath:(NSString*)imagepath
                   answerNickname:(NSString*)answernickname
                       answerWord:(NSString*)answerword
                         lastTime:(NSString*)lasttime
                      acceptOrnot:(NSString*)acceptornot;
@end
