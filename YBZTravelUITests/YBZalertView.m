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

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UICollectionView *collectionImage;
@end

@implementation YBZalertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleimageView];
        [self addSubview:self.picimageView];
        [self addSubview:self.nicknameLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.levelnumberLabel];
        [self addSubview:self.levelLabel];
        [self addSubview:self.activelLabel];
        [self addSubview:self.activenumberLabel];
        [self addSubview:self.languagetypeLabel];
        [self addSubview:self.triangleView];
        [self addSubview:self.starView];
        [self addSubview:self.triangleView2];
        [self addSubview:self.reservationBtn];
        
        
       // [self addSubview:self.table];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleimageView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    self.picimageView.frame = CGRectMake(self.frame.size.width/2-30, 15, 60, 60);
    self.starView.frame =  CGRectMake(self.frame.size.width/2-25, 80, 50, 10);
    self.triangleView.frame = CGRectMake(self.frame.size.width/8, 100, 10, 10);
    self.nicknameLabel.frame = CGRectMake(self.frame.size.width/8+20, 95, self.frame.size.width/4, 20);
    self.nameLabel.frame = CGRectMake(self.frame.size.width/2, 95, self.frame.size.width/4, 20);
    self.levelLabel.frame = CGRectMake(self.frame.size.width/8, 120, self.frame.size.width/4, 15);
    self.levelnumberLabel.frame = CGRectMake(self.frame.size.width/8, 135, self.frame.size.width/4, 15);
    
    self.activelLabel.frame = CGRectMake(self.frame.size.width/2, 120, self.frame.size.width/4, 15);
    self.activenumberLabel.frame = CGRectMake(self.frame.size.width/2, 135, self.frame.size.width/4, 15);
    
    self.triangleView2.frame = CGRectMake(self.frame.size.width/8, 155, 10, 10);
    self.languagetypeLabel.frame = CGRectMake(self.frame.size.width/8+20, 150, self.frame.size.width/4, 20);
    
    self.reservationBtn.frame = CGRectMake(self.frame.size.width/2-50, self.frame.size.height-30, 100, 30);
    self.table.frame = CGRectMake(self.frame.size.width/8, 180, self.frame.size.width-self.frame.size.width/4, self.frame.size.height/3.5);
    
}



-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        _table.backgroundColor = [UIColor redColor];
    }
    return _table;
}



-(UIImageView *)titleimageView
{
    if(!_titleimageView)
    {
        _titleimageView = [[UIImageView alloc] init];
        _titleimageView.image = [UIImage imageNamed:@"bg"];
        
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
       // _nicknameLabel.backgroundColor = [UIColor orangeColor];
        _nicknameLabel.text = @"译员昵称";
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.adjustsFontSizeToFitWidth = YES;
        _nicknameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        
    }
    return _nicknameLabel;
}

-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
       // _nameLabel.text = @"天空蔚蓝";
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    }
    return _nameLabel;
}

-(UILabel *)levelLabel
{
    if(!_levelLabel)
    {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.adjustsFontSizeToFitWidth = YES;
        _levelLabel.text = @"等级";
        _levelLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        //_levelLabel.backgroundColor = [UIColor orangeColor];
    }
    return _levelLabel;
}

-(UILabel *)levelnumberLabel
{
    if(!_levelnumberLabel)
    {
        _levelnumberLabel = [[UILabel alloc] init];
        //_levelnumberLabel.backgroundColor = [UIColor orangeColor];
        _levelnumberLabel.adjustsFontSizeToFitWidth = YES;
        _levelnumberLabel.textAlignment = NSTextAlignmentCenter;
       // _levelnumberLabel.text = @"23";
        _levelnumberLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _levelnumberLabel.textColor = [UIColor blueColor];
    }
    return _levelnumberLabel;
}

-(UILabel *)activelLabel
{
    if(!_activelLabel)
    {
        _activelLabel = [[UILabel alloc] init];
        _activelLabel.adjustsFontSizeToFitWidth = YES;
        _activelLabel.textAlignment = NSTextAlignmentCenter;
        _activelLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        _activelLabel.text = @"活跃度";
        //_activelLabel.backgroundColor = [UIColor orangeColor];
    }
    return _activelLabel;
}

-(UILabel *)activenumberLabel
{
    if(!_activenumberLabel)
    {
        _activenumberLabel = [[UILabel alloc] init];
        _activenumberLabel.adjustsFontSizeToFitWidth = YES;
        _activenumberLabel.textAlignment = NSTextAlignmentCenter;
        _activenumberLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _activenumberLabel.textColor = [UIColor orangeColor];
     //   _activenumberLabel.text = @"142";
    }
    return _activenumberLabel;
}

-(UILabel *)languagetypeLabel
{
    if(!_languagetypeLabel)
    {
        _languagetypeLabel = [[UILabel alloc] init];
        //_languagetypeLabel.backgroundColor = [UIColor orangeColor];
        _languagetypeLabel.adjustsFontSizeToFitWidth = YES;
        _languagetypeLabel.textAlignment = NSTextAlignmentCenter;
        _languagetypeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _languagetypeLabel.text = @"擅长语种";
        
    }
    return _languagetypeLabel;
}


-(UIImageView *)triangleView
{
    if(!_triangleView)
    {
        _triangleView = [[UIImageView alloc] init];
        _triangleView.image = [UIImage imageNamed:@"triangle"];
    }
    return _triangleView;
}

-(UIImageView *)triangleView2
{
    if(!_triangleView2)
    {
        _triangleView2 = [[UIImageView alloc] init];
        _triangleView2.image = [UIImage imageNamed:@"triangle"];
    }
    return _triangleView2;
}

-(TQStarRatingView *)starView
{
    if(!_starView)
    {
        _starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, 80, 50, 10) numberOfStar:kNUMBER_OF_STAR];
       // _starView.backgroundColor = [UIColor orangeColor];
        
    }
    return _starView;
}


-(UIButton *)reservationBtn
{
    if(!_reservationBtn)
    {
        _reservationBtn = [[UIButton alloc] init];
        _reservationBtn.backgroundColor = [UIColor orangeColor];
        _reservationBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [_reservationBtn setTitle:@"预定定制翻译" forState:UIControlStateNormal];
    }
    return _reservationBtn;
}












@end
