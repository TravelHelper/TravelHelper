//
//  CollectionCellFrameInfo.m
//  Test
//
//  Created by aGuang on 16/8/1.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "CollectionCellFrameInfo.h"
#define kSubViewHorizontalMargin    10
#define kSubViewVerticalMargin      10
#define kImageViewWidth             44
#define kImageViewHeight            44

@interface CollectionCellFrameInfo()
//@property (nonatomic , strong) CollectionModel *collection;
@end

@implementation CollectionCellFrameInfo
//- (instancetype)initWithCollectionModel:(CollectionModel *)collection
- (instancetype)initWithCollectionModel:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //头像
        self.userImageViewFrame = CGRectMake(kSubViewHorizontalMargin, kSubViewVerticalMargin, kImageViewWidth, kImageViewHeight);
        
        //名字
        CGSize size = [dictionary[@"UserName"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.userNameLabelFrame = CGRectMake(2 * kSubViewHorizontalMargin + kImageViewWidth, self.userImageViewFrame.origin.y + kSubViewVerticalMargin, size.width, size.height);
        //时间
//        size = [dictionary[@"Time"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.timeLabelFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120 - 2 * kSubViewHorizontalMargin, self.userImageViewFrame.origin.y + kSubViewVerticalMargin, 120, 30);
        //信息
//        CGFloat messageW = [UIScreen mainScreen].bounds.size.width - 2 * kSubViewHorizontalMargin - kImageViewWidth / 2;
//        size = [dictionary[@"Message"] boundingRectWithSize:CGSizeMake(messageW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        size = [dictionary[@"Message"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        self.messageLabelFrame = CGRectMake(kSubViewHorizontalMargin + kImageViewWidth / 2, 2 * kSubViewVerticalMargin + kImageViewHeight , [UIScreen mainScreen].bounds.size.width - (kSubViewHorizontalMargin + kImageViewWidth / 2) - 2 * kSubViewHorizontalMargin, size.height);
        self.cellHeight = self.messageLabelFrame.origin.y + self.messageLabelFrame.size.height + kSubViewVerticalMargin;
        
    }
    return self;
}
@end




