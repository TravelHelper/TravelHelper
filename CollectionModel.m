//
//  CollectionModel.m
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype)initWithUserImage:(NSString *)userImage
                         UserName:(NSString *)userName
                             Time:(NSString *)time
                          Message:(NSString *)message
{
    self = [super init];
    if (self) {
        self.userImage = userImage;
        self.userName = userName;
        self.time = time;
        self.message = message;
    }
    return self;
}


- (instancetype)initWithNumber:(NSString *)number
                   Information:(NSString *)information
                    WalkerTime:(NSString *)walkerTime
{
    self = [super init];
    if (self) {
        self.number = number;
        self.information = information;
        self.walkerTime = walkerTime;
    }
    return self;
}
//- (instancetype)initWithUserName:(NSString *)userName
//                             Time:(NSString *)time
//                      Message:(NSString *)message
//{
//    self = [super init];
//    if (self) {
//        self.userName = userName;
//        self.time = time;
//        self.message = message;
//    }
//    return self;
//}
@end
