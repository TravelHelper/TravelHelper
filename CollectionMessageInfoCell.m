//
//  CollectionMessageInfoCell.m
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "CollectionMessageInfoCell.h"
@interface CollectionMessageInfoCell()
@end

@implementation CollectionMessageInfoCell

-(void)setCellData:(NSDictionary *)dictionary collectionFrameInfo:(CollectionCellFrameInfo *)collectionFrameInfo
{
    self.collectionFrameInfo = collectionFrameInfo;
    
    self.userImageView.image = [UIImage imageNamed:dictionary[@"UserImage"]];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 44.0f/2.0f;
    self.userImageView.layer.borderWidth = 1.0f;
    
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    
    self.userNameLabel.text = dictionary[@"UserName"];
    self.timeLabel.text = dictionary[@"Time"];
    self.messageLabel.text = dictionary[@"Message"];

    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.userNameLabel.frame = self.collectionFrameInfo.userNameLabelFrame;
    self.timeLabel.frame = self.collectionFrameInfo.timeLabelFrame;
    self.messageLabel.frame = self.collectionFrameInfo.messageLabelFrame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
