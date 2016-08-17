//
//  FreeWalkerInfoCell.m
//  Test
//
//  Created by aGuang on 16/8/2.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "FreeWalkerInfoCell.h"
#define kSubViewHorizontalMargin  10
#define kSubViewVerticalMargin    10
#define kImageViewWidth             44
#define kImageViewHeight            44

@implementation FreeWalkerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.walkerTimeLabel];
        [self.contentView addSubview:self.informationLabel];
    }
    
    return self;
}

-(UILabel *)numberLabel
{
    if(!_numberLabel)
    {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, 2 *kSubViewVerticalMargin, 200, 20)];
        _numberLabel.font = [UIFont systemFontOfSize:18];
    }
    return _numberLabel;
}

-(UILabel *)walkerTimeLabel
{
    if(!_walkerTimeLabel)
    {
        _walkerTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110 - 2 * kSubViewHorizontalMargin, 2 * kSubViewVerticalMargin, 110,20)];
        _walkerTimeLabel.font = [UIFont systemFontOfSize:18];
        _walkerTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _walkerTimeLabel;
}

-(UILabel *)informationLabel
{
    if(!_informationLabel)
    {
        _informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin , 4 * kSubViewVerticalMargin + _numberLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 20)];
        _informationLabel.font = [UIFont systemFontOfSize:18];
    }
    return _informationLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
