//
//  MessageInfoCell.m
//  YBZTravel
//
//  Created by sks on 16/8/13.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import "MessageInfoCell.h"
#import "AFNetworking.h"
#define margin 10
#define pardding 10


@interface MessageInfoCell ()

@property (nonatomic, strong)UIImageView* answerImage;
@property (nonatomic, strong)UILabel* answerNickname;
@property (nonatomic, strong)UILabel* answerWord;
@property (nonatomic, strong)UILabel* lastTime;
@property (nonatomic, strong)UIButton* acceptOrnot;
@property (nonatomic, strong)NSDictionary *myData;

@property (nonatomic, strong)MessageInfoCellData *data;

//NSLog(@"%@",dic[@"data"][@"user_nickname"]);
@end


@implementation MessageInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier setCellData:(MessageInfoCellData *)data{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.data = data;
     // [self dictionaryData];
      [self addSubview:self.answerImage];
    
      [self addSubview:self.answerNickname];
      self.answerNickname.text = self.data.answerNickname;
    
      [self addSubview:self.answerWord];
      self.answerWord.text = self.data.answerWord;
    
       [self addSubview:self.lastTime];
       self.lastTime.text = self.data.lastTime;
    
      [self addSubview:self.acceptOrnot];
      return self;
}
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
/*+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}*/


-(UIImageView *)answerImage{
    if(!_answerImage){
    _answerImage = [[UIImageView alloc]initWithFrame:CGRectMake(margin, pardding, 50, 50)];
    _answerImage.layer.masksToBounds=YES;
    _answerImage.layer.cornerRadius=50/2.0f; //设置为图片宽度的一半出来为圆形
    _answerImage.layer.borderWidth=1.0f; //边框宽度
    _answerImage.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    _answerImage.backgroundColor = [UIColor orangeColor];
   //
    }
    return _answerImage;
}

-(UILabel *)answerNickname{
    if (!_answerNickname) {
        _answerNickname = [[UILabel alloc]initWithFrame:CGRectMake(margin+_answerImage.bounds.size.width +5, pardding+10,40, 30)];
        _answerNickname.textColor = [UIColor grayColor];
        //_answerNickname.backgroundColor = [UIColor orangeColor];
        //NSDictionary *dic = [self dictionaryData];
        
    }
    
    return _answerNickname;
}

-(UILabel *)answerWord{
    if (!_answerWord) {
        CGSize sizeToFit = [self.data.answerWord sizeWithFont:[UIFont systemFontOfSize:16]
                                            constrainedToSize:CGSizeMake(334, CGFLOAT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        _answerWord = [[UILabel alloc]initWithFrame:CGRectMake(margin+_answerImage.bounds.size.width+5, pardding+_answerImage.bounds.size.width,334, sizeToFit.height)];
        CGFloat oneLineH = [@"这是一行" boundingRectWithSize:CGSizeMake(334, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size.height;
        _answerWord.textColor = [UIColor grayColor];
        _answerWord.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        _answerWord.numberOfLines = sizeToFit.height/oneLineH;
        _answerWord.backgroundColor = [UIColor orangeColor];
    }
    return _answerWord;
}

-(UILabel *)lastTime{
    if (!_lastTime) {
        _lastTime = [[UILabel alloc]initWithFrame:CGRectMake(margin+_answerImage.bounds.size.width+5,pardding*2+_answerImage.bounds.size.width +_answerWord.bounds.size.height+3,30, 20)];
        _lastTime.textColor = [UIColor grayColor];
        _lastTime.backgroundColor = [UIColor orangeColor];

    }
       return _lastTime;
}

-(UIButton *)acceptOrnot{
    if (!_acceptOrnot) {
        _acceptOrnot = [[UIButton alloc]initWithFrame:CGRectMake(349, pardding*2+_answerImage.bounds.size.width +_answerWord.bounds.size.height, 55, 26)];
        _acceptOrnot.layer.cornerRadius=15.0f;
        _acceptOrnot.backgroundColor = [UIColor orangeColor];
        [_acceptOrnot addTarget:self action:@selector(acceptOrnotAction) forControlEvents:UIControlEventTouchDown];
        if ([self.data.rightOrnot  isEqual: @"yes"]) {
            [_acceptOrnot setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
        
        [_acceptOrnot setImage:[UIImage imageNamed:@"receive"] forState:UIControlStateNormal];
        }
    }
    return _acceptOrnot;
}

-(void)acceptOrnotAction{
  if ([self.data.rightOrnot  isEqual: @"no"]) {
    NSLog(@"success");
  }
}
@end
