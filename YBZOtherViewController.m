//
//  YBZOtherViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/8/4.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZOtherViewController.h"


@interface YBZOtherViewController ()

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation YBZOtherViewController{

    NSArray *languageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImagePict];
    [self getLanguageInfo];
    [self addLanguageBtn];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.backgroundScrollView];
}


-(void)setBackgroundImagePict{
    
        self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:0 alpha:1.0f];
}


-(void)getLanguageInfo{

    languageArr = @[@"英语",@"美式英语",@"粤语",@"日语",@"韩语",@"法语",@"西班牙语",@"泰语",@"阿拉伯语",@"俄语",@"葡萄牙语",@"德语",@"意大利语",@"希腊语",@"荷兰语",@"波兰语",@"丹麦语",@"芬兰语",@"捷克语",@"瑞典语",@"匈牙利语"];
}

-(void)addLanguageBtn{

    for (int i=0 ; i<7; i++) {
        for (int j = 0; j<3; j++) {
            [self creatBtnWithBorderAndLanguage:languageArr[i*3+j] Andi:i Andj:j];
        }
    }
}


-(void)creatBtnWithBorderAndLanguage:(NSString *)language Andi:(int)i Andj:(int)j{
    
    UIView *view = [self getBorderView];
    UIButton *languageBtn = [self getBtnWithLanguage:language];
    UILabel *languageLabel = [self getLabelWithLanguage:language];
    view.frame = CGRectMake(0.18*SCREEN_WIDTH+j*0.234*SCREEN_WIDTH, 0.0517*SCREEN_HEIGHT+i*0.1411*SCREEN_HEIGHT, 0.171875*SCREEN_WIDTH, 0.200575*SCREEN_WIDTH);
    languageBtn.frame = CGRectMake(0.0054*SCREEN_WIDTH, 0.0054*SCREEN_WIDTH, 0.161*SCREEN_WIDTH, 0.161*SCREEN_WIDTH);
    languageBtn.tag = i*3+j;
    languageLabel.frame = CGRectMake( 0 ,CGRectGetMaxY(languageBtn.frame), view.bounds.size.width, 0.0267*SCREEN_WIDTH);
    [view addSubview:languageBtn];
    [view addSubview:languageLabel];
    
    
    [self.backgroundScrollView addSubview:view];
    
}


-(UIView *)getBorderView{

    UIView *view = [[UIView alloc]init];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.cornerRadius = 0.015*SCREEN_WIDTH;
    view.layer.borderWidth = 0.003125*SCREEN_WIDTH;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIButton *)getBtnWithLanguage:(NSString *)language{

    UIImage *img = [UIImage imageNamed:language];
    UIButton *languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [languageBtn setBackgroundImage:img forState:UIControlStateNormal];
    [languageBtn addTarget:self action:@selector(chooseLanguageOfBtnTag:) forControlEvents:UIControlEventTouchUpInside];
    return languageBtn;
}

-(UILabel *)getLabelWithLanguage:(NSString *)language{

    UILabel *languageLabel = [[UILabel alloc]init];
    languageLabel.text = language;
    languageLabel.textAlignment = NSTextAlignmentCenter;
    languageLabel.font = [UIFont systemFontOfSize:0.0267*SCREEN_WIDTH];
    languageLabel.textColor = [UIColor blackColor];
    return languageLabel;
}



#pragma mark -----onClick-----
-(void)chooseLanguageOfBtnTag:(UIButton *)sender{

    BOOL hasLanguage = NO;
    int i = (int)sender.tag;
    NSString *language = languageArr[i];
    for (NSString *str in _chooseLanguageArr) {
        if ([language isEqualToString:str]) {
            hasLanguage = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已选择该语言，请勿重新选择" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (hasLanguage == NO) {
        NSLog(@"%@",language);
        self.addLanguageBlock([NSString stringWithString:language]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)cancelBtnClick{

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----getters-----
-(UIScrollView *)backgroundScrollView{

    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc]init];
        _backgroundScrollView.backgroundColor = [UIColor clearColor];
        _backgroundScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        _backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 6.8*SCREEN_HEIGHT/6);
        _backgroundScrollView.scrollEnabled = YES;
    }
    return _backgroundScrollView;
}

-(UIButton *)cancelBtn{

    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.04, SCREEN_WIDTH*0.11, SCREEN_WIDTH*0.25, SCREEN_WIDTH*0.08)];
        [_cancelBtn setTitle:@"放弃选择" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:0.05*SCREEN_WIDTH];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelBtn;
}


@end
