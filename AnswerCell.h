//
//  AnswerCell.h
//  YBZTravel
//
//  Created by 孙锐 on 16/8/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIButton *acceptBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Model:(NSDictionary *)dict;
@end
