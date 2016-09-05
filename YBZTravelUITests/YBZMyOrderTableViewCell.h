//
//  YBZMyOrderTableViewCell.h
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/2.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBZMyOrderModel;
@interface YBZMyOrderTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *infolabel;
@property (nonatomic,strong) UILabel *completelabel;
@property (nonatomic,strong) UILabel *timelabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setCellDate:(YBZMyOrderModel *)order;
@end
