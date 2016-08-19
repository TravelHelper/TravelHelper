//
//  CollectionModel.h
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
@property (nonatomic , strong) NSString *userImage;
@property (nonatomic , strong) NSString *userName;
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *message;

@property (nonatomic , strong) NSString *number;
@property (nonatomic , strong) NSString *information;
@property (nonatomic , strong) NSString *walkerTime;


- (instancetype)initWithUserImage:(NSString *)userImage
                         UserName:(NSString *)userName
                             Time:(NSString *)time
                      Message:(NSString *)message;

- (instancetype)initWithNumber:(NSString *)number
                   Information:(NSString *)information
                    WalkerTime:(NSString *)walkerTime;

//- (instancetype)initWithUserName:(NSString *)userName
//                            Time:(NSString *)time
//                         Message:(NSString *)message;
@end
