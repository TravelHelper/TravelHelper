//
//  TopView.m
//  XWJTask
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 HuaXinSoftware. All rights reserved.
//

#import "TopView.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


@interface TopView ()

@property (nonatomic , strong) UILabel *leftLabel;

@end

@implementation TopView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:251 / 255.0 green:251 / 255.0 blue:251 / 255.0 alpha:1];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.leftLabel];
        [self addSubview:self.selectBankBut];
    }
    return self;
}

#pragma mark - 控件getters方法
-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.frame = CGRectMake(kScreenW*0.043, kScreenH*0.025, kScreenW*0.2, kScreenH*0.034);
        _leftLabel.font = FONT_14;
       _leftLabel.text = @"选择账户";
    }
    return _leftLabel;
}

-(UIButton *)selectBankBut
{
    if (!_selectBankBut) {
        
        _selectBankBut = [[UIButton alloc]initWithFrame:CGRectMake(self.leftLabel.frame.origin.x + kScreenW*0.238, kScreenH*0.028, kScreenW*0.233, kScreenH*0.034)];
        _selectBankBut.backgroundColor = [UIColor clearColor];
        [_selectBankBut setTitle:@"游币账户" forState:UIControlStateNormal];
        _selectBankBut.titleLabel.font = FONT_16;
        [_selectBankBut setTitleColor:[UIColor colorWithRed:78 / 255.0 green:193 / 255.0 blue:228 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_selectBankBut addTarget:self action:@selector(selectBankButClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectBankBut;
}

#pragma mark - 按钮的单击事件
-(void)selectBankButClick
{
    
}
@end
