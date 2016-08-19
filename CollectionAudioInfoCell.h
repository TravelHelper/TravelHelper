//
//  CollectionAudioInfoCell.h
//  Test
//
//  Created by aGuang on 16/8/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionAudioInfoCell : UITableViewCell
@property (nonatomic , strong) UIImageView *userImage;
@property (nonatomic , strong) UILabel *userNameLabel;
@property (nonatomic , strong) UILabel *collectionTimeLabel;
@property (nonatomic , strong) UIImageView *audioImage;
@property (nonatomic , strong) UILabel *audioTimeLabel;

@end
