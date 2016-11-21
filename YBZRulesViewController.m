//
//  YBZRulesViewController.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/21.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRulesViewController.h"

@interface YBZRulesViewController ()

@property (nonatomic,strong) UITextView *ruleTextView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *explain;

@end

@implementation YBZRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xF8F8F8);
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.ruleTextView];
    [self.contentView addSubview:self.explain];
    self.title=@"规则";
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.contentView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    self.ruleTextView.frame=CGRectMake(15, 20, SCREEN_WIDTH-30, SCREEN_HEIGHT/2-40);
    self.explain.frame=CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-20, SCREEN_WIDTH*2/3-15, 20);
}


-(UITextView *)ruleTextView{

    if(!_ruleTextView){
    
        _ruleTextView=[[UITextView alloc]init];
        
        _ruleTextView.backgroundColor=[UIColor whiteColor];
        _ruleTextView.font=[UIFont systemFontOfSize:0.04*SCREEN_WIDTH];
        _ruleTextView.textColor=[UIColor grayColor];
    }
    return _ruleTextView;

}
-(UIView *)contentView{

    if(!_contentView){
    
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=[UIColor whiteColor];
        
        
    }
    return _contentView;

}
-(UILabel *)explain{

    if(!_explain){
    
        _explain=[[UILabel alloc]init];
        _explain.font=[UIFont systemFontOfSize:0.04*SCREEN_WIDTH];
        _explain.text=@"最终解释权归 游帮主 所有";
        _explain.backgroundColor=[UIColor whiteColor];
        _explain.textColor=[UIColor grayColor];
        _explain.textAlignment=NSTextAlignmentRight;
    }
    return _explain;
}



@end
