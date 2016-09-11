//
//  YBZalertView.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/10.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZalertView.h"
#import "Masonry.h"
@interface YBZalertView ()
@property (nonatomic,strong)UIImageView *picimageView;
@property (nonatomic,strong)UIImageView *titleimageView;
@property (nonatomic,strong)UILabel *nicknameLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *levelLabel;
@property (nonatomic,strong)UILabel *levelnumberLabel;
@property (nonatomic,strong)UILabel *activelLabel;
@property (nonatomic,strong)UILabel *activenumberLabel;
@property (nonatomic,strong)UILabel *languagetypeLabel;


@end

@implementation YBZalertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(UIImageView *)titleimageView
{
    if(!_titleimageView)
    {
        _titleimageView = [[UIImageView alloc] init];
        _titleimageView.backgroundColor = [UIColor orangeColor];
    }
    return _titleimageView;
}

-(UIImageView *)picimageView
{
    if(!_picimageView)
    {
        _picimageView = [[UIImageView alloc] init];
        _picimageView.layer.masksToBounds = YES;
        _picimageView.layer.cornerRadius =  30;
        
    }
    return _picimageView;
}

-(UILabel *)nicknameLabel
{
    if(!_nicknameLabel)
    {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.backgroundColor = [UIColor orangeColor];
        
    }
    return _nicknameLabel;
}

-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"天空蔚蓝";
    }
    return _nameLabel;
}

-(UILabel *)levelLabel
{
    if(!_levelLabel)
    {
        _levelLabel = [[UILabel alloc] init];
        
    }
    return _levelLabel;
}

-(UILabel *)levelnumberLabel
{
    if(!_levelnumberLabel)
    {
        _levelnumberLabel = [[UILabel alloc] init];
        
    }
    return _levelnumberLabel;
}

-(UILabel *)activelLabel
{
    if(!_activelLabel)
    {
        _activelLabel = [[UILabel alloc] init];
        
    }
    return _activelLabel;
}

-(UILabel *)activenumberLabel
{
    if(!_activenumberLabel)
    {
        _activenumberLabel = [[UILabel alloc] init];
        
    }
    return _activenumberLabel;
}

-(UILabel *)languagetypeLabel
{
    if(!_languagetypeLabel)
    {
        _languagetypeLabel = [[UILabel alloc] init];
        
    }
    return _languagetypeLabel;
}










@end
