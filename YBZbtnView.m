//
//  YBZbtnView.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/3.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZbtnView.h"

@implementation YBZbtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn01];
        [self addSubview:self.btn02];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.btn01.frame = CGRectMake(20, 20, 100, 50);
    self.btn02.frame = CGRectMake(SCREEN_WIDTH-120, 20, 100, 50);
}

-(UIButton *)btn01
{
    if(!_btn01)
    {
        _btn01 = [[UIButton alloc] init];
        _btn01.backgroundColor = [UIColor blueColor];
    }
    return _btn01;
}

-(UIButton *)btn02
{
    if(!_btn02)
    {
        _btn02 = [[UIButton alloc] init];
        _btn02.backgroundColor = [UIColor greenColor];
    }
    return _btn02;
}



@end
