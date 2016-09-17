 //
//  YBZChooseTranslatorViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/7/26.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZChooseTranslatorViewController.h"
#import "YBZOtherViewController.h"
#import "WebAgent.h"
#import "UIImage+needkit.h"


@interface YBZChooseTranslatorViewController ()


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *chooseLanguageArr;
@property (nonatomic, strong) UILabel *userProtocol;
@property (nonatomic, strong) UIButton *protocolChooseBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation YBZChooseTranslatorViewController{

    BOOL isRead;
    int chooseNum;
    BOOL isTranslator;
    NSArray *selectedArr;
    NSString *addLanguage;
    NSString *userID;
    NSString *userLanguage;
    UIButton *chooseBtn;
}


- (instancetype)initWithIdentify:(NSString *)identify AndLanguageArr:(NSArray *)languageArr
{
    self = [super init];
    if (self) {
        if ([identify isEqualToString:@"译员"]) {
            isTranslator = YES;
        }else if([identify isEqualToString:@"普通"]){
            isTranslator = NO;
        }
        selectedArr = [NSArray arrayWithArray:languageArr];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    _chooseLanguageArr = [NSMutableArray array];
    isRead = NO;
    chooseNum = 0;
//    isTranslator = YES;
    [self getData];
    [self setBackgroundImagePict];
    [self setAllControlsFrame];
    [self addAllControls];
    addLanguage = [NSString string];

    
}

-(void)viewWillAppear:(BOOL)animated{

    if (isTranslator == YES) {
        [self.protocolChooseBtn removeFromSuperview];
        [self.userProtocol removeFromSuperview];
    }
    [self createLanguageImageWithData];
}


-(void)addLanguageArr{

    [_chooseLanguageArr addObject:addLanguage];
}

-(void)getData{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    userID = user_id[@"user_id"];
    if (selectedArr == nil) {
        NSArray *arr = @[];
        [_chooseLanguageArr addObjectsFromArray:arr];
    }else{
        [_chooseLanguageArr addObjectsFromArray:selectedArr];
    }
   }


-(void)setAllControlsFrame{
    
    self.topView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 0.264*SCREEN_HEIGHT-64);
    self.userProtocol.frame = CGRectMake(0.3*SCREEN_WIDTH, 0.694*SCREEN_HEIGHT, 0.7*SCREEN_WIDTH, 0.039*SCREEN_WIDTH);
    self.protocolChooseBtn.frame = CGRectMake(0.224*SCREEN_WIDTH, 0.689*SCREEN_HEIGHT, 0.059*SCREEN_WIDTH, 0.059*SCREEN_WIDTH);
    self.agreeBtn.frame = CGRectMake(0.234*SCREEN_WIDTH, 0.838*SCREEN_HEIGHT, 0.228*SCREEN_WIDTH, 0.05*SCREEN_HEIGHT);
    self.cancelBtn.frame = CGRectMake(0.538*SCREEN_WIDTH, 0.838*SCREEN_HEIGHT, 0.228*SCREEN_WIDTH, 0.05*SCREEN_HEIGHT);
}

-(void)addAllControls{
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.userProtocol];
    [self.view addSubview:self.protocolChooseBtn];
    [self.view addSubview:self.agreeBtn];
    [self.view addSubview:self.cancelBtn];
}


-(void)createLanguageImageWithData{

    if (_chooseLanguageArr.count == 6) {
        for (int i = 0 ; i < 3 ; i++ ) {
            for (int j = 0 ; j < 2; j++) {
                NSString *str = _chooseLanguageArr[i*2+j];
                [self creatBtnWithBorderAndLanguage:str Andi:i Andj:j];
            }
        }
    }else if (_chooseLanguageArr.count == 0){
        [self addSelectLanguageBtnWithCount:_chooseLanguageArr.count];
    }else{
        for (int i = 0 ; i < (float)(_chooseLanguageArr.count)/2 ; i++ ) {
            for (int j = 0 ; j+2*i<_chooseLanguageArr.count && j<2; j++) {
                NSString *str = _chooseLanguageArr[i*2+j];
                [self creatBtnWithBorderAndLanguage:str Andi:i Andj:j];
            }
        }
        [self addSelectLanguageBtnWithCount:_chooseLanguageArr.count];
    }
}



-(void)addSelectLanguageBtnWithCount:(NSUInteger)count{

     chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setBackgroundImage:[UIImage imageNamed:@"addLanguage"] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(pushSelectLanguageView) forControlEvents:UIControlEventTouchUpInside];
    int j = count%2;
    int i = (int)count/2;
    chooseBtn.frame = CGRectMake(0.297*SCREEN_WIDTH+j*0.234*SCREEN_WIDTH, 0.3117*SCREEN_HEIGHT+i*0.1124*SCREEN_HEIGHT, 0.171875*SCREEN_WIDTH, 0.171875*SCREEN_WIDTH);
    chooseBtn.tag = 1000;
    [self.view addSubview:chooseBtn];
}




-(void)creatBtnWithBorderAndLanguage:(NSString *)language Andi:(int)i Andj:(int)j{

    UIView *view = [[UIView alloc]init];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.cornerRadius = 0.015*SCREEN_WIDTH;
    view.layer.borderWidth = 0.003125*SCREEN_WIDTH;
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0.297*SCREEN_WIDTH+j*0.234*SCREEN_WIDTH, 0.3117*SCREEN_HEIGHT+i*0.1124*SCREEN_HEIGHT, 0.171875*SCREEN_WIDTH, 0.171875*SCREEN_WIDTH);
    UIImage *img = [UIImage imageNamed:language];
    UIButton *languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [languageBtn setBackgroundImage:img forState:UIControlStateNormal];
    languageBtn.frame = CGRectMake(0.0054*SCREEN_WIDTH, 0.0054*SCREEN_WIDTH, 0.161*SCREEN_WIDTH, 0.161*SCREEN_WIDTH);
    languageBtn.tag = j+i*2;
    [languageBtn addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:languageBtn];
    view.tag = 100+j*10+i*10;
    [self.view addSubview:view];
    
}


-(void)clearAllViews{

    for (UIView *view in self.view.subviews) {
        if (view.tag>=100) {
            [view removeFromSuperview];
        }
    }
}


-(void)setBackgroundImagePict{

    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:0 alpha:1.0f];
}




#pragma mark -----onClick-----
-(void)loginAndBackToRoot{

    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)chooseReadOrNot{

    if (isRead == NO) {
        self.protocolChooseBtn.selected = YES;
        self.agreeBtn.enabled = YES;
        [self.agreeBtn setBackgroundColor:[UIColor whiteColor]];
        isRead = YES;
    }else{
        self.protocolChooseBtn.selected = NO;
        self.agreeBtn.enabled = NO;
        [self.agreeBtn setBackgroundColor:[UIColor grayColor]];

        isRead = NO;
    }
}


-(void)agreeToBecomeTranslator{

    NSLog(@"1");
    userLanguage = [NSString string];
    for (int i=0; i<_chooseLanguageArr.count; i++) {
        NSString *str = _chooseLanguageArr[i];
        if (i==0) {
            userLanguage = str;
        }else{
            userLanguage = [userLanguage stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
    }
    
    [WebAgent userIdentity:@"译员" userLanguage:userLanguage userID:userID success:^(id responseObject) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    
}


-(void)pushSelectLanguageView{
    
    [self clearAllViews];
    YBZOtherViewController *vc = [[YBZOtherViewController alloc]init];
    vc.chooseLanguageArr = [NSMutableArray array];
    [vc.chooseLanguageArr addObjectsFromArray:_chooseLanguageArr];
    
    [vc setAddLanguageBlock:^(NSString *string) {
        [_chooseLanguageArr addObject:string];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)changeLanguage:(UIButton *)sender{

    NSString *language = _chooseLanguageArr[sender.tag];
    for (NSString *str in _chooseLanguageArr) {
        if (language == str) {
            [_chooseLanguageArr removeObject:str];
            break;
        }
    }
    [self clearAllViews];
    
    NSLog(@"%@",language);
    YBZOtherViewController *vc = [[YBZOtherViewController alloc]init];
    vc.chooseLanguageArr = [NSMutableArray array];
    [vc.chooseLanguageArr addObjectsFromArray:_chooseLanguageArr];
    [vc setAddLanguageBlock:^(NSString *string) {
        [_chooseLanguageArr addObject:string];
    }];
    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark -----getters-----

-(UIView *)topView{

    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor clearColor];
        UILabel * firstLabel;
        if (isTranslator == NO) {
            firstLabel = [self getLabelWithFont:0.0887*SCREEN_WIDTH AndText:@"想要成为译员 ?" AndFrame:CGRectMake(0,0.127*SCREEN_HEIGHT-64 ,SCREEN_WIDTH , 0.0887*SCREEN_WIDTH)];
        }else{
            firstLabel = [self getLabelWithFont:0.0887*SCREEN_WIDTH AndText:@"需要修改语言 ?" AndFrame:CGRectMake(0,0.127*SCREEN_HEIGHT-64 ,SCREEN_WIDTH , 0.0887*SCREEN_WIDTH)];
        }

        UILabel *secondLabel = [self getLabelWithFont:0.0359*SCREEN_WIDTH AndText:@"请选择您擅长的语种（可多选）" AndFrame:CGRectMake(0,0.2*SCREEN_HEIGHT-64 ,SCREEN_WIDTH , 0.0359*SCREEN_WIDTH)];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白色下三角"]];
        imgView.frame = CGRectMake(0.4758*SCREEN_WIDTH, 0.236*SCREEN_HEIGHT-64, 0.0484*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT);
        
        [_topView addSubview:imgView];
        [_topView addSubview:firstLabel];
        [_topView addSubview:secondLabel];
    }
    return _topView;
}

-(UILabel *)userProtocol{

    if (!_userProtocol) {
        _userProtocol = [[UILabel alloc]init];
        _userProtocol.text = @"我已阅读《译员用户协议》";
        _userProtocol.textColor = [UIColor blackColor];
        _userProtocol.font = [UIFont systemFontOfSize:0.039*SCREEN_WIDTH];
        _userProtocol.textAlignment = NSTextAlignmentLeft;
    }
    return _userProtocol;
}

-(UIButton *)protocolChooseBtn {

    if (!_protocolChooseBtn) {
        _protocolChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolChooseBtn addTarget:self action:@selector(chooseReadOrNot) forControlEvents:UIControlEventTouchUpInside];
        [_protocolChooseBtn setBackgroundImage:[UIImage imageNamed:@"同意"] forState:UIControlStateSelected];
        [_protocolChooseBtn setBackgroundImage:[UIImage imageNamed:@"不同意"] forState:UIControlStateNormal];
    }
    return _protocolChooseBtn;
}

-(UIButton *)agreeBtn{

    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.backgroundColor = [UIColor whiteColor];
        _agreeBtn.layer.cornerRadius = 0.015*SCREEN_WIDTH;
        if (isTranslator == YES) {
            [_agreeBtn setTitle:@"确 认" forState:UIControlStateNormal];
        }else{
            [_agreeBtn setTitle:@"同 意" forState:UIControlStateNormal];
            _agreeBtn.enabled = NO;
            [_agreeBtn setBackgroundColor:[UIColor grayColor]];
        }
        [_agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(agreeToBecomeTranslator) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

-(UIButton *)cancelBtn{
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = 0.015*SCREEN_WIDTH;
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(loginAndBackToRoot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


#pragma mark -----get方法的辅助方法-----

-(UILabel *)getLabelWithFont:(CGFloat)fontSize AndText:(NSString *)text AndFrame:(CGRect)frame{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    return label;
}

@end
