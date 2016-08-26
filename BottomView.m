//
//  BottomView.m
//  XWJTask
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 HuaXinSoftware. All rights reserved.
//

#import "BottomView.h"
#import "WebAgent.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface BottomView ()<UITextFieldDelegate>

@property (nonatomic , strong) UILabel *tiXianLabel;
@property (nonatomic , strong) UIImageView *youBiImageView;
@property (nonatomic , strong) UILabel *lineLabel;

@end

@implementation BottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self returnMoney];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tiXianLabel];
        [self addSubview:self.youBiImageView];
        [self addSubview:self.moneyTextField];
        [self addSubview:self.lineLabel];
        [self addSubview:self.getAllBut];
        [self addSubview:self.alertLabel];
        [self addSubview:self.allMoneyLabel];
        [self addSubview:self.eDuLabel];
}
    return self;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.moneyTextField) {
        [self.moneyTextField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moneyTextField resignFirstResponder];

}
#pragma mark - 借口方法
-(void)returnMoney{

}
#pragma mark - 控件的getters方法
-(UILabel *)tiXianLabel
{
    if (!_tiXianLabel) {
        _tiXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(32,kScreenH*0.051, kScreenW/2, kScreenH*0.034)];
        _tiXianLabel.text = @"悬赏金额";
    }
    return _tiXianLabel;
}

-(UIImageView *)youBiImageView
{
    if (!_youBiImageView) {
        _youBiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.tiXianLabel.frame.origin.y + 50, 26, 26)];
        _youBiImageView.image = [UIImage imageNamed:@"youBiLogal"];
        
    }
    return _youBiImageView;
}

-(UITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.youBiImageView.frame)+10, self.youBiImageView.frame.origin.y-kScreenH*0.017, [UIScreen mainScreen].bounds.size.width*0.716, kScreenH*0.085)];
        _moneyTextField.font = [UIFont systemFontOfSize:40];
        _moneyTextField.delegate = self;
        _moneyTextField.backgroundColor= [UIColor whiteColor];
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        [[UITextField appearance]setTintColor:[UIColor blackColor]];
    }
    return _moneyTextField;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.youBiImageView.frame)+10, CGRectGetMaxY(self.moneyTextField.frame)+2, kScreenW*0.75, 1.5)];
        _lineLabel.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
    }
    return _lineLabel;
}
-(UILabel *)allMoneyLabel{
    NSString *money;
    [WebAgent restMoenyUser_id:@"0003" success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *str= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.amountYouBi = str[@"money_youbi"];
        NSLog(@"----------------->%@",self.amountYouBi);
        
    } failure:^(NSError *error) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertVC addAction:okAction];
    }];

    money = self.amountYouBi;
    NSString *labelText = [NSString stringWithFormat:@"%@游币",self.amountYouBi];
    CGSize size = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _allMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.eDuLabel.frame.origin.x + self.eDuLabel.bounds.size.width + 5, self.eDuLabel.frame.origin.y, size.width, size.height)];
    _allMoneyLabel.text = labelText;
    _allMoneyLabel.font = [UIFont systemFontOfSize:14];
    _allMoneyLabel.textColor = [UIColor colorWithRed:87 / 255.0 green:134 / 255.0 blue:157 / 255.0 alpha:1];
    

    return _allMoneyLabel;
}

-(UILabel *)eDuLabel
{
    if (!_eDuLabel) {
        CGSize size = [@"游币账户余额，" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _eDuLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, self.lineLabel.frame.origin.y + 10, size.width, size.height)];
        _eDuLabel.text = @"游币账户余额，";
        _eDuLabel.font = [UIFont systemFontOfSize:14];
        _eDuLabel.textColor = [UIColor colorWithRed:87 / 255.0 green:134 / 255.0 blue:157 / 255.0 alpha:1];
    }
    return _eDuLabel;
}
-(UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, self.lineLabel.frame.origin.y + 30, 200 , 20)];
        _alertLabel.backgroundColor = [UIColor whiteColor];
        _alertLabel.text = @"游币账户余额不足";
        _alertLabel.font = [UIFont systemFontOfSize:14];
        _alertLabel.textColor = [UIColor redColor];
        _alertLabel.hidden = YES;
    }
    return _alertLabel;
}

@end
