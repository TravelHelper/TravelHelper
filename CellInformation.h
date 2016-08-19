//
//  CellInformation.h
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Information.h"

@interface CellInformation : NSObject

@property (nonatomic , assign) CGRect titleTextLableFrame;
@property (nonatomic , assign) CGRect timeLabelFrame;
@property (nonatomic , assign) CGRect youBiLableFrame;
@property (nonatomic , assign) CGFloat cellHeight;


// 数据源方法
-(instancetype)initWithInformation:(Information *)information;

@end
