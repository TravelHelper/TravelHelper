//
//  UserViewController.m
//  YBZTravel
//
//  Created by sks on 16/7/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserViewController.h"
#import "UserTableViewCell.h"
#import "YBZUserInfoViewController.h"
#import "YBZUserOrderViewController.h"
#import "YBZUserFavoriteViewController.h"
#import "YBZUserEwalletsViewController.h"
#import "UserSetViewController.h"
#import "EditViewController.h"
#import "WebAgent.h"
#import "YBZLoginViewController.h"
#import "YBZBaseNaviController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Boolean is;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *url;
@property (nonatomic , strong) NSString *isLogin;
@property (nonatomic , strong) UILabel *alertLabel;
@property (nonatomic , strong) UIImageView *avatarImag;


@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    is=false;
    self.title = @"我的";
    [self.view addSubview:self.mainTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel:) name:@"setTextALabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadcell:) name:@"reloadcell" object:nil];
}
-(void)reloadcell:(NSNotification *)noti
{
    NSDictionary *isLoginDic = [noti userInfo];
    NSString *isLoginstate = [isLoginDic objectForKey:@"状态"];
    if ([isLoginstate isEqual:@"true"]) {
        is = true;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self setHidesBottomBarWhenPushed:NO];
//    [super viewDidDisappear:animated];
//}

//观察者方法
-(void)setTextALabel:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UserTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:index];
    cell.nameLable.text = [textDic objectForKey:@"文本"];
    [self.mainTableView reloadData];
    [self.mainTableView layoutIfNeeded];
}
-(void)dealloc{
    //    free((__bridge void *)(self.textALabel));
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setTextALabel" object:nil];
}
//行数


//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
//    
//    
//    view.tintColor = [UIColor redColor];
//}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    view.tintColor = [UIColor redColor];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(section == 0)
    {
        return 1;
    }
    else
    {
        if(section == 1)
        {
            return 3;
        }
        else
        {
            if(section == 2)
            {
                return 2;
            }
            else
            {
                return 1;
            }
        }
    }

}

//分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.view.bounds.size.height * 0.007;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.view.bounds.size.height * 0.007;
}
//样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section != 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//最右边>号
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ( section == 0 && row == 0) {
        //----------------------------
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
                NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];

           _avatarImag = [[UIImageView alloc]initWithFrame:CGRectMake(12, self.view.bounds.size.height * 0.01, self.view.bounds.size.height * 0.07, self.view.bounds.size.height * 0.06)];
        if (is || [user_loginState[@"user_loginState"] isEqual:@"1"])    {
                            _avatarImag.image = [UIImage imageNamed:@"head"];
                            [cell.contentView addSubview:_avatarImag];
                                [WebAgent userid:user_id[@"user_id"] success:^(id responseObject) {
                                    NSLog(@"%@",user_id[@"user_id"]);
                                    NSData *data = [[NSData alloc]initWithData:responseObject];
                                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                    NSDictionary *userInfo = dic[@"user_info"];
                                    cell.nameLable.text = userInfo[@"user_nickname"];
            
            
                                }failure:^(NSError *error) {
                                    NSLog(@"%@",error);
                                }];
                                
                                      }else{
          
              _avatarImag.image = [UIImage imageNamed:@"head"];
                        [cell.contentView addSubview:_avatarImag];
                        cell.nameLable.text = @"登录／注册";
        }

         return cell;
    }
        else
        {
            if ( section == 1 && row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:@"order"];
                cell.nameLable.text = @"我的订单";
                 return cell;
            }
            else
            {
                if ( section == 1 && row == 1)
                {
                    cell.imageView.image = [UIImage imageNamed:@"collect"];
                    cell.nameLable.text = @"我的收藏";
                     return cell;
                }
                else
                {
                    if ( section == 1 && row == 2)
                    {
                        cell.imageView.image = [UIImage imageNamed:@"money"];
                        cell.nameLable.text = @"我的悬赏";
                         return cell;
                    }
                    else
                    {
                        if ( section == 2 && row == 0)
                        {
                            cell.imageView.image = [UIImage imageNamed:@"push"];
                            cell.nameLable.text = @"电子钱包";
                             return cell;
                        }
                        else
                        {
                            if ( section == 2 && row == 1)
                            {
                                cell.imageView.image = [UIImage imageNamed:@"set"];
                                cell.nameLable.text = @"设置";
                                 return cell;
                            }
                            else
                            {
                                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height * 0.12)];
                                imageV.image = [UIImage imageNamed:@"游广告"];
                                [cell.contentView addSubview:imageV];
                                return cell;
                            }
                        }
                    }
                }
                
            }
        }
        
   
    
}
//    if ( section == 1 && row == 0) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"order"];
//        cell.nameLable.text = @"我的订单";
//        
//    }
//    
//    if ( section == 1 && row == 1) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"collect"];
//        cell.nameLable.text = @"我的收藏";
//        
//    }
//    
//    if ( section == 1 && row == 2) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"money"];
//        cell.nameLable.text = @"我的悬赏";
//    
//    }
//    
//    if ( section == 2 && row == 0) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"push"];
//        cell.nameLable.text = @"电子钱包";
//        
//    }
//    
//    if ( section == 2 && row == 1) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"set"];
//        cell.nameLable.text = @"设置";
//        
//    }
//    
//    if ( section == 3 && row == 0) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"youbangzhuapp"];
//        cell.nameLable.text = @"游帮主app";
//        
//    }





//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return self.view.bounds.size.height * 0.12;
    }else{
        return self.view.bounds.size.height * 0.08;
    }
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    CGSize size = [@"敬请期待!" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width - 30) / 2, ([UIScreen mainScreen].bounds.size.height - size.height - 60) / 2, size.width + 30, size.height + 40)];
    self.alertLabel.backgroundColor = [UIColor blackColor];
    self.alertLabel.layer.cornerRadius = 8;
    self.alertLabel.layer.masksToBounds = YES;
    self.alertLabel.alpha = 0.8;
    self.alertLabel.text = @"敬请期待!";
    self.alertLabel.font = [UIFont systemFontOfSize:22];
    [self.alertLabel setTextAlignment:NSTextAlignmentCenter];
    self.alertLabel.textColor = [UIColor whiteColor];
    
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if ( section == 0 && row == 0) {
        
        [self intoUserDetailInfoClick];
        
    }
    if ( section == 1) {
        
        [self.view addSubview:self.alertLabel];
        [UIView animateWithDuration:2 animations:^{
            self.alertLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.alertLabel removeFromSuperview];
        }];
        
    }
    if ( section == 2 && row == 0) {
        
        [self.view addSubview:self.alertLabel];
        [UIView animateWithDuration:2 animations:^{
            self.alertLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.alertLabel removeFromSuperview];
        }];
        
    }
    
    if ( section == 2 && row == 1) {
        
        [self intoInfoSettingClick];
        
    }
    
    if ( section == 3 && row == 0) {
        //        UIWebView *webView = [[UIWebView alloc]init];
        //        webView.delegate = self;
        //        NSURL *url = [[NSURL alloc]initWithString:@"http://www.baidu.com"];
        //        NSLog(@"%@-url地址",url);
        //        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //        [webView loadRequest:request];
        //        webView.opaque = NO;
        //        webView.backgroundColor = [UIColor redColor];
        //        self.view = webView;
    }
}

#pragma mark - 跳转事件

-(void)intoUserDetailInfoClick{
    
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];
    if(user_id[@"user_id"] == NULL)
    {
        YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
        YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
        logVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
        else
        {
            if([user_loginState[@"user_loginState"] isEqual:@"0"])
            {
                YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
                YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
                logVC.view.backgroundColor = [UIColor whiteColor];
                [self presentViewController:nav animated:YES completion:nil];
            }
            else{
                
                EditViewController *userInfoVC = [[EditViewController alloc]init];
                userInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userInfoVC animated:YES];
            }
        }
    }

-(void)intoMyOrderListClick{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    if(user_id[@"user_id"] == NULL)
    {
        YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
        YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
        logVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];
        if([user_loginState[@"user_loginState"] isEqual:@"1"])
        {
            YBZUserOrderViewController *userOrderVC = [[YBZUserOrderViewController alloc]initWithTitle:@"我的订单"];
            [self.navigationController pushViewController:userOrderVC animated:YES];

        }
        else{
            YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
            YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
            logVC.view.backgroundColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        
    }
    
}

-(void)intoMyFavoritePageClick{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];

    if(user_id[@"user_id"] == NULL)
    {
        YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
        YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
        logVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        if([user_loginState[@"user_loginState"] isEqual:@"0"])
        {

            YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
            YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
            logVC.view.backgroundColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        else{
            
        }
        
        
    }
    
}

-(void)intoMyEwalletsPageClick{
    
    YBZUserEwalletsViewController *EwalletsVC = [[YBZUserEwalletsViewController alloc]initWithTitle:@"电子钱包"];
    
    [self.navigationController pushViewController:EwalletsVC animated:YES];
    
}

-(void)intoInfoSettingClick{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    if(user_id[@"user_id"] == NULL)
    {
        YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
        YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
        logVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];
        if([user_loginState[@"user_loginState"] isEqual:@"1"])
        {
           UserSetViewController *settingVC = [[UserSetViewController alloc]init];
            
           [self.navigationController pushViewController:settingVC animated:YES];
        }
        else{
            YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
            YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
            logVC.view.backgroundColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark - getters

-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];

        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
    }
    return _mainTableView;
}
@end