//
//  AnswerCell.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "AnswerCell.h"

@interface AnswerCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *answerContentLabel;
@property (nonatomic, strong) UILabel *answerTimeLabel;

@end


@implementation AnswerCell{

    BOOL needChoose;
    NSDictionary *data;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Model:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        data = dict;
        if ([dict[@"proceed_state"]isEqualToString:@"0"]) {
            needChoose = YES;
        }else{
            needChoose = NO;
        }
        [self setAllControlsFrame];

        [self addAllControls];
        
        
    }
    return self;
}



-(void)setAllControlsFrame{

    self.headImageView.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.034*SCREEN_WIDTH, 0.111*SCREEN_WIDTH, 0.111*SCREEN_WIDTH);
    self.nameLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.034*SCREEN_HEIGHT, SCREEN_WIDTH-0.151*SCREEN_WIDTH, 0.021*SCREEN_HEIGHT);
    CGSize textLabelSize;
    NSString *info = self.answerContentLabel.text;
    textLabelSize = [info boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-0.167*SCREEN_WIDTH,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.02*SCREEN_HEIGHT]} context:nil].size;
    
    self.answerContentLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.07666*SCREEN_HEIGHT, SCREEN_WIDTH-0.187*SCREEN_WIDTH, textLabelSize.height);
    self.answerTimeLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.07666*SCREEN_HEIGHT+textLabelSize.height + 0.009*SCREEN_HEIGHT, SCREEN_WIDTH/3, 0.035*SCREEN_HEIGHT);
    self.acceptBtn.frame = CGRectMake(0.8*SCREEN_WIDTH, 0.08*SCREEN_HEIGHT+textLabelSize.height + 0.009*SCREEN_HEIGHT, 0.151*SCREEN_WIDTH, 0.038*SCREEN_HEIGHT);
    CGFloat sizeHeight = CGRectGetMaxY(self.acceptBtn.frame);
    self.height = sizeHeight + 0.017*SCREEN_HEIGHT;
}

-(void)addAllControls{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.answerTimeLabel];
    [self addSubview:self.answerContentLabel];
    if (needChoose == YES) {
        [self addSubview:self.acceptBtn];
    }
}

-(void)acceptAnswer{

    NSLog(@"采纳回答");
}



#pragma mark -----getters-----
-(UIImageView *)headImageView{

    if (!_headImageView) {
        if (![data[@"user_photo"]isEqualToString:@""] && data[@"user_photo"] != nil) {
            _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:data[@"user_photo"]]]];
        }else{
            _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Logo"]];
        }
    }
    return _headImageView;
}

-(UILabel *)nameLabel{

    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = data[@"user_nickname"];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:0.02*SCREEN_HEIGHT];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

-(UILabel *)answerContentLabel{

    if (!_answerContentLabel) {
        _answerContentLabel = [[UILabel alloc]init];
        _answerContentLabel.text = data[@"answer_text"];
        _answerContentLabel.textColor = [UIColor grayColor];
        _answerContentLabel.font = [UIFont systemFontOfSize:0.02*SCREEN_HEIGHT];
        _answerContentLabel.textAlignment = NSTextAlignmentLeft;
        _answerContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _answerContentLabel.numberOfLines = 0;

    }
    return _answerContentLabel;
}

-(UILabel *)answerTimeLabel{
    
    if (!_answerTimeLabel) {
        _answerTimeLabel = [[UILabel alloc]init];
        _answerTimeLabel.text = data[@"answer_time"];
        _answerTimeLabel.textAlignment = NSTextAlignmentLeft;
        _answerTimeLabel.textColor = [UIColor grayColor];
        _answerTimeLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    }
    return _answerTimeLabel;
}

-(UIButton *)acceptBtn{

    if (!_acceptBtn) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptBtn setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(acceptAnswer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}


@end
