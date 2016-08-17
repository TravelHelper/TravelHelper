//
//  CollectionCellFrameInfo.h
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@interface CollectionCellFrameInfo : NSObject
@property (nonatomic , assign) CGRect userImageViewFrame;
@property (nonatomic , assign) CGRect userNameLabelFrame;
@property (nonatomic , assign) CGRect timeLabelFrame;
@property (nonatomic , assign) CGRect messageLabelFrame;
@property (nonatomic , assign) CGFloat cellHeight;

//- (instancetype)initWithCollectionModel:(CollectionModel *)collection;
- (instancetype)initWithCollectionModel:(NSDictionary *)dictionary;
@end
