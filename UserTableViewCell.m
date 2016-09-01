//
//  UserTableViewCell.m
//  YBZTravel
//
//  Created by sks on 16/7/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserTableViewCell.h"

#define KGap 10

@implementation UserTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(KGap*2,KGap*0.7,KGap*4,KGap*4)];
        [self addSubview:self.imgView];
 
        _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(KGap*7,KGap*0.7,KGap*8,KGap*4)];
        [self addSubview:self.nameLable];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    return self;
}






@end
