//
//  CollectionAudioInfoCell.m
//  Test
//
//  Created by aGuang on 16/8/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "CollectionAudioInfoCell.h"
#define kSubViewHorizontalMargin  10
#define kSubViewVerticalMargin    10
#define kImageViewWidth           44
#define kImageViewHeight          44

@implementation CollectionAudioInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.collectionTimeLabel];
        [self.contentView addSubview:self.audioImage];

    }
    
    return self;
}
-(UIImageView *)userImage
{
    if(!_userImage)
    {
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(kSubViewHorizontalMargin, kSubViewVerticalMargin, kImageViewWidth, kImageViewHeight)];
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 44.0/2.0f;
        _userImage.layer.borderWidth = 1.0f;
    }
    return _userImage;
}
-(UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin + kImageViewWidth, self.userImage.frame.origin.y + kSubViewVerticalMargin, 200 , 30)];
    }
    return _userNameLabel;
}
-(UILabel *)collectionTimeLabel
{
    if (!_collectionTimeLabel) {
        _collectionTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110 - 2 * kSubViewHorizontalMargin, self.userImage.frame.origin.y + kSubViewVerticalMargin, 110, 30)];
        _collectionTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _collectionTimeLabel;
}
-(UIImageView *)audioImage
{
    if (!_audioImage) {
        _audioImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, kImageViewHeight +2 * kSubViewVerticalMargin, [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 70)];
        _audioImage.backgroundColor = [UIColor lightGrayColor];
        _audioTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 50, 20)];
        [_audioImage addSubview:_audioTimeLabel];
    }
    return _audioImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
