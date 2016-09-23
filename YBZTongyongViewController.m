//
//  YBZTongyongViewController.m
//  YBZTravel
//
//  Created by ydz on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZTongyongViewController.h"
#import "WebAgent.h"

@interface YBZTongyongViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tongyongTabView;
@end

@implementation YBZTongyongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tongyongTabView.delegate = self;
    self.tongyongTabView.dataSource = self;
    self.title = @"通用";
    [self.view addSubview:self.tongyongTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(UITableView *)tongyongTabView
{
    if(!_tongyongTabView){
        _tongyongTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    }
    return _tongyongTabView;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        self.wuraomoshi = @"0";
    }
    else
    {
        self.wuraomoshi = @"1";
    }
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    [WebAgent wuraomoshiWithuseId:user_id[@"user_id"] Withtranslatorallow:self.wuraomoshi success:^(id responseObject) {
        NSLog(@"aaa");
    } failure:^(NSError *error) {
        NSLog(@"bbb");
    }];
}

#pragma mark － 表示图协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //几组
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //几行
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //样式
     UITableViewCell *tuisongcell = [[UITableViewCell alloc]init];
 
   
        tuisongcell.textLabel.text = @"勿扰模式";
        UISwitch *tuisongswitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.8, tuisongcell.bounds.size.height*0.1, self.view.bounds.size.width*0.15, self.view.bounds.size.height*0.8)];
        [tuisongswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if ([self.wuraomoshi isEqualToString:@"0"]) {
            tuisongswitch.on = YES;
        }else{
            tuisongswitch.on = NO;
        }
        [tuisongcell addSubview:tuisongswitch];
    
        tuisongcell.selectionStyle = UITableViewCellSelectionStyleNone;

        return tuisongcell;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //组头高
    return 20;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行高
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转事件
}

@end
