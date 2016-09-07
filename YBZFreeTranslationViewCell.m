//
//  YBZFreeTranslationViewCell.m
//  YBZTravel
//
//  Created by 孟宪璞 on 16/7/26.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZFreeTranslationViewCell.h"

#define margin UIScreenWidth * 0.09




@implementation YBZFreeTranslationViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codex
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.CNTitleLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.symbolTitleLabel];
        [self.contentView addSubview:self.leftCountryImageView];
        [self.contentView addSubview:self.rightCountryImageView];
        [self.contentView addSubview:self.btn];
        
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews{
    
    
    
    
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - getters

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UILabel alloc]initWithFrame:CGRectMake(margin, UIScreenWidth * 0.04, UIScreenWidth - margin * 2, UIScreenWidth * 0.2)];
        //_bottomView.backgroundColor = [UIColor colorWithRed:168 / 255.0 green:168 / 255.0 blue:168 / 255.0 alpha:1];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  UIScreenWidth - margin * 2, UIScreenWidth * 0.2)];
        [imgView setImage:[UIImage imageNamed:@"国旗后灰色"]];
        [self.bottomView addSubview:imgView];
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.masksToBounds = YES;
        
    }
    return _bottomView;
}

- (UIImageView *)leftCountryImageView{
    
    if (!_leftCountryImageView) {
        _leftCountryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin + UIScreenWidth * 0.05, UIScreenWidth * 0.045, UIScreenWidth * 0.19, UIScreenWidth * 0.19)];
        _leftCountryImageView.backgroundColor = [UIColor clearColor];
    }
    return _leftCountryImageView;
}

- (UIImageView *)rightCountryImageView{
    
    if (!_rightCountryImageView) {
        _rightCountryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth - margin - UIScreenWidth * 0.24 , UIScreenWidth * 0.045, UIScreenWidth * 0.19, UIScreenWidth * 0.19)];
        _rightCountryImageView.backgroundColor = [UIColor clearColor];
    }
    return _rightCountryImageView;
}

- (UILabel *)CNTitleLabel{
    
    if (!_CNTitleLabel) {
        _CNTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenWidth / 2 - 50, UIScreenWidth * 0.08 - 20, 80, 15 + 35)];
        
        _CNTitleLabel.backgroundColor = [UIColor clearColor];
        
        _CNTitleLabel.text = @"中文";
        
        //_CNTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _CNTitleLabel;
}


- (UILabel *)symbolTitleLabel{
    
    if (!_symbolTitleLabel) {
        _symbolTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenWidth / 2 - 50, CGRectGetMidY(self.bottomView.frame) - 7, 100, 10)];
        
        _symbolTitleLabel.backgroundColor = [UIColor clearColor];
        
        _symbolTitleLabel.text = @"——";
        
        _symbolTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _symbolTitleLabel;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenWidth / 2 - 50, UIScreenWidth * 0.08 + 20, 100, UIScreenWidth * 0.04 + 30)];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _titleLabel;
}


@end
