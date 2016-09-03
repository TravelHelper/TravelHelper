//
//  YBZMyOrderTableViewCell.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/2.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyOrderTableViewCell.h"
#import "YBZMyOrderModel.h"
@implementation YBZMyOrderTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infolabel];
        [self.contentView addSubview:self.completelabel];
        [self.contentView addSubview:self.timelabel];
    }
    return self;
}

-(void)setCellDate:(YBZMyOrderModel *)order
{
    self.infolabel.text = order.infostr;
    self.completelabel.text = order.completestr;
    self.timelabel.text = order.timestr;
    [self layoutIfNeeded];
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    self.infolabel.frame = CGRectMake(10, 10, 130, 30);
    self.completelabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 20, 80, 40);
    self.timelabel.frame = CGRectMake(10, 50, 250, 20);
}

-(UILabel *)infolabel
{
    if(!_infolabel)
    {
        _infolabel = [[UILabel alloc] init];
        //_infolabel.backgroundColor = [UIColor orangeColor];
    }
    return _infolabel;
}

-(UILabel *)completelabel
{
    if(!_completelabel)
    {
        _completelabel = [[UILabel alloc] init];
        
    }
    return _completelabel;
}

-(UILabel *)timelabel
{
    if(!_timelabel)
    {
        _timelabel = [[UILabel alloc] init];
        //_timelabel.backgroundColor = [UIColor blueColor];
    }
    return _timelabel;
}








@end
