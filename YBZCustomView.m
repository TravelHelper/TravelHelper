//
//  YBZCustomView.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/1.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZCustomView.h"



@interface YBZCustomView()


    @property (nonatomic, strong) UIView *circleView;
    @property (nonatomic, strong) UILabel *contentLabel;


@end


@implementation YBZCustomView

- (instancetype)initWithFrame:(CGRect)frame
                     AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentLabel.text=title;
        [self addSubview:self.circleView];
        [self addSubview:self.contentLabel];
//        self.backgroundColor=[UIColor grayColor];
    }
    return self;
}

//-(void)layoutSubviews{
//
//    
//
//}

-(UIView *)circleView{


    if(!_circleView){
    
        _circleView=[[UIView alloc]initWithFrame:CGRectMake(5, self.bounds.size.height*0.325, self.bounds.size.height*0.35, self.bounds.size.height*0.35)];
        _circleView.backgroundColor=UIColorFromRGB(0xffd703);
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.cornerRadius = (self.bounds.size.height*0.35)/2;
        
    }
    return _circleView;

}

-(UILabel *)contentLabel{

    if(!_contentLabel){
    
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.height*0.8, 5, self.bounds.size.width-self.bounds.size.height-5, self.bounds.size.height-10)];
        _contentLabel.textColor=[UIColor blackColor];
        _contentLabel.font=[UIFont systemFontOfSize:0.04*SCREEN_WIDTH];
        
    }
    return _contentLabel;
}


@end

