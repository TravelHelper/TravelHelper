//
//  YBZOrderDetailsView.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/6.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZOrderDetailsView.h"
#import "Masonry.h"
@interface YBZOrderDetailsView ()
@property (nonatomic,strong) UILabel *toplabel;
@property (nonatomic,strong) UILabel *endlabel;

@end

@implementation YBZOrderDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.toplabel];
        [self addSubview:self.endlabel];
        [self addSubview:self.typelabel];
        [self addSubview:self.OrderViewnamelabel1];
        [self addSubview:self.OrderViewnamelabel2];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.toplabel.frame = CGRectMake(SCREEN_WIDTH/2-50, 15, 100, 30);
    self.endlabel.frame = CGRectMake(SCREEN_WIDTH/2-50, 200, 100, 30);
    self.typelabel.frame = CGRectMake(SCREEN_WIDTH/2-80, 50, 160, 30);
    self.OrderViewnamelabel1.frame = CGRectMake(70, 90, SCREEN_WIDTH/2-80, 60);
    self.OrderViewnamelabel2.frame = CGRectMake(SCREEN_WIDTH/2+10, 90, SCREEN_WIDTH/2-80, 60);
}

-(UILabel *)toplabel
{
    if(!_toplabel)
    {
        _toplabel = [[UILabel alloc] init];
        _toplabel.textAlignment = NSTextAlignmentCenter;
        _toplabel.text = @"支付详情";
    }
    return _toplabel;
}

-(UILabel *)endlabel
{
    if(!_endlabel)
    {
        _endlabel = [[UILabel alloc] init];
        _endlabel.textAlignment = NSTextAlignmentCenter;
        _endlabel.text = @"评价译员";
    }
    return _endlabel;
}

-(UILabel *)typelabel
{
    if(!_typelabel)
    {
        _typelabel = [[UILabel alloc] init];
        //_typelabel.backgroundColor = [UIColor greenColor];
        _typelabel.textAlignment = NSTextAlignmentCenter;
        _typelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _typelabel.text = @"交易类型：口语即时";
    }
    return _typelabel;
}

-(UILabel *)OrderViewnamelabel1
{
    if(!_OrderViewnamelabel1)
    {
        _OrderViewnamelabel1 = [[UILabel alloc] init];
        _OrderViewnamelabel1.text = @"20 嗨豆";
    }
    return _OrderViewnamelabel1;
}

-(UILabel *)OrderViewnamelabel2
{
    if(!_OrderViewnamelabel2)
    {
        _OrderViewnamelabel2 = [[UILabel alloc] init];
        _OrderViewnamelabel2.text = @"30 嗨币";
    }
    return _OrderViewnamelabel2;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    //把绘图信息添加到路径中
    CGPathMoveToPoint(path, NULL, 20, 30);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH/2-80, 30);
    //把绘图路径添加到上下文中
    CGContextAddPath(ctx, path);
    //渲染
    CGContextStrokePath(ctx);
    //释放
    CGPathRelease(path);
    
    
    CGContextRef ctx2 = UIGraphicsGetCurrentContext();
    CGMutablePathRef path2 = CGPathCreateMutable();
    //把绘图信息添加到路径中
    CGPathMoveToPoint(path2, NULL, SCREEN_WIDTH/2+80,30);
    CGPathAddLineToPoint(path2, NULL, SCREEN_WIDTH-20, 30);
    //把绘图路径添加到上下文中
    CGContextAddPath(ctx2, path2);
    //渲染
    CGContextStrokePath(ctx2);
    //释放
    CGPathRelease(path2);
    
    
    CGContextRef ctx3 = UIGraphicsGetCurrentContext();
    CGMutablePathRef path3 = CGPathCreateMutable();
    //把绘图信息添加到路径中
    CGPathMoveToPoint(path3, NULL, 20,220);
    CGPathAddLineToPoint(path3, NULL, SCREEN_WIDTH/2-80, 220);
    //把绘图路径添加到上下文中
    CGContextAddPath(ctx3, path3);
    //渲染
    CGContextStrokePath(ctx3);
    //释放
    CGPathRelease(path3);
    
    
    CGContextRef ctx4 = UIGraphicsGetCurrentContext();
    CGMutablePathRef path4 = CGPathCreateMutable();
    //把绘图信息添加到路径中
    CGPathMoveToPoint(path4, NULL, SCREEN_WIDTH/2+80,220);
    CGPathAddLineToPoint(path4, NULL, SCREEN_WIDTH-20,220);
    //把绘图路径添加到上下文中
    CGContextAddPath(ctx4, path4);
    //渲染
    CGContextStrokePath(ctx4);
    //释放
    CGPathRelease(path4);
}

@end