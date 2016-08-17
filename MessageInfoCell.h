//
//  MessageInfoCell.h
//  YBZTravel
//
//  Created by sks on 16/8/13.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfoCellData.h"
@interface MessageInfoCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier setCellData:(MessageInfoCellData *)data;

@end
