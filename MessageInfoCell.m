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
//-(void)dictionaryData:(NSString *)reward_id key:(NSString *)key



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
        //_answerNickname.backgroundColor = [UIColor orangeColor];
        //NSDictionary *dic = [self dictionaryData];
        
    }
    
    return _answerNickname;
}

-(UILabel *)answerWord{
    if (!_answerWord) {
        _answerWord = [[UILabel alloc]initWithFrame:CGRectMake(margin+_answerImage.bounds.size.width+5, pardding+_answerImage.bounds.size.width,self.bounds.size.width - 60, 30)];
        //_answerWord.backgroundColor = [UIColor orangeColor];
    }
    return _answerWord;
}

-(UILabel *)lastTime{
    if (!_lastTime) {
        _lastTime = [[UILabel alloc]initWithFrame:CGRectMake(margin+_answerImage.bounds.size.width+5,110,30, 20)];
        //_lastTime.backgroundColor = [UIColor orangeColor];

    }
       return _lastTime;
}

-(UIButton *)acceptOrnot{
    if (!_acceptOrnot) {
        _acceptOrnot = [[UIButton alloc]initWithFrame:CGRectMake(354, 110, 40, 20)];
        _acceptOrnot.layer.cornerRadius=10.0f;
        _acceptOrnot.backgroundColor = [UIColor orangeColor];
    }
    return _acceptOrnot;
}
@end
