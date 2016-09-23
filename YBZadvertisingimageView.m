//
//  YBZadvertisingimageView.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/22.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZadvertisingimageView.h"

@implementation YBZadvertisingimageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self addSubview:self.delbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.delbtn.frame = CGRectMake(self.frame.size.width-30, 0, 30, 30);
    
}

-(UIButton *)delbtn
{
    if(!_delbtn)
    {
        _delbtn = [[UIButton alloc] init];
        [_delbtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    return _delbtn;
}

-(void)closebtnclick
{
    [self removeFromSuperview];
}

@end
