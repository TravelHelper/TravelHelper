//
//  CollectionMessageInfoCell.h
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
#import "CollectionCellFrameInfo.h"

@interface CollectionMessageInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic , strong) CollectionModel *collectionModel;
@property (nonatomic , strong) CollectionCellFrameInfo *collectionFrameInfo;

-(void)setCellData:(NSDictionary *)dictionary collectionFrameInfo:(CollectionCellFrameInfo *)collectionFrameInfo;
@end
