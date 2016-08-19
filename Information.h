//
//  Information.h
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject
@property (nonatomic , strong) NSString *titleText;
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *youBi;

- (instancetype)initWitTitleText:(NSString *)titleText
                            time:(NSString *)time
                           youBi:(NSString *)youBi;

@end
