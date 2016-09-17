//
//  YBZOrderDetailsModel.h
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/10.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBZOrderDetailsModel : NSObject
@property (nonatomic,strong)NSString *picUrlstr;//头像url地址
@property (nonatomic,strong)NSString *nameStr;//用户姓名
@property (nonatomic,strong)NSString *detailsNumberstr;//订单数目
@property (nonatomic,strong)NSString *detailsState;//订单状态
@property (nonatomic,strong)NSString *detailsType;//订单类型
@property (nonatomic,strong)NSString *haidouStr;//嗨豆数目
@property (nonatomic,strong)NSString *haibiStr;//嗨币数目



@property (nonatomic,strong)NSString *viewpicurlStr;
@property (nonatomic,strong)NSString *viewnaneStr;
@property (nonatomic,strong)NSString *viewlevelnumberStr;//等级数目
@property (nonatomic,strong)NSString *viewactivenumberStr;//活跃度数目

@end
