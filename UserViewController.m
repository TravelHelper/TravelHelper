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
#import "YBZMoneyBagViewController.h"
#import "YBZUserFavoriteViewController.h"
#import "YBZUserEwalletsViewController.h"
#import "UserSetViewController.h"
#import "EditViewController.h"
#import "WebAgent.h"
#import "YBZLoginViewController.h"
#import "YBZBaseNaviController.h"
#import "YBZMyFavoriteViewController.h"
#import "MBProgressHUD+XMG.h"
#import "GTStarsScore.h"



@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,GTStarsScoreDelegate>
{
    Boolean is;
    Boolean it;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *url;
@property (nonatomic , strong) NSString *isLogin;
@property (nonatomic , strong) UILabel *alertLabel;
@property (nonatomic , strong) UIImageView *avatarImag;
@property(nonatomic,strong)UIImage *photoImg;
@property (nonatomic,strong)UIImageView *adImageView;
@property (nonatomic, strong)UITableView *translatorTableView;
@property (nonatomic, strong) GTStarsScore *starView;



@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//!!!!!!
    is=false;
    it=false;
    self.title = @"我的";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel:) name:@"setTextALabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadcell:) name:@"reloadcell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadoutcell:) name:@"reloadoutcell" object:nil];
//    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
//    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    //    [self.view addSubview:self.mainTableView];
    
//    
     [self.view addSubview:self.translatorTableView];
     [self.view addSubview:self.mainTableView];
//    
//    if(user_id[@"user_id"] != NULL)
//    {
//        //        [self.view addSubview:self.mainTableView];
//        [WebAgent getuserTranslateState:user_id[@"user_id"] success:^(id responseObject) {
//            NSData *data = [[NSData alloc]initWithData:responseObject];
//            NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSString *msg=dic[@"msg"];
//            if([msg isEqualToString:@"SUCCESS"]){
//                
//                NSString *user_identity=dic[@"user_identity"];
//                NSLog(@"%@",user_identity);
//                if([user_identity isEqualToString:@"TRANSTOR"]){
//                    [self.translatorTableView removeFromSuperview];
//                    
//                    [self.view addSubview:self.translatorTableView];
//                    
//                }else{
//                    
//                    [self.view addSubview:self.mainTableView];
//                    
//                }
//                
//                
//            }
//            
//            
//        } failure:^(NSError *error) {
//            
//            [MBProgressHUD showError:@"获取用户数据失败,请检查网络"];
//            
//        }];
//        
//    }else{
//        
//        [self.view addSubview:self.mainTableView];
//        
//    }

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
//    [self.view addSubview:self.mainTableView];

    
    
    
    if(user_id[@"user_id"] != NULL)
    {
//        [self.view addSubview:self.mainTableView];
        [WebAgent getuserTranslateState:user_id[@"user_id"] success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *msg=dic[@"msg"];
            if([msg isEqualToString:@"SUCCESS"]){
            
                NSString *user_identity=dic[@"user_identity"];
                NSLog(@"%@",user_identity);
                if([user_identity isEqualToString:@"TRANSTOR"]){
//                    [self.translatorTableView removeFromSuperview];
                    [self.mainTableView setHidden:YES];
                    [self.translatorTableView setHidden:NO];
                    [self.translatorTableView reloadData];
//                    [self.view addSubview:self.translatorTableView];
                    
                }else{
                
                    [self.mainTableView setHidden:NO];
                    [self.translatorTableView setHidden:YES];
//                    [self.view addSubview:self.mainTableView];
                    [self.mainTableView reloadData];
                }
                
            
            }
            
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD showError:@"获取用户数据失败,请检查网络"];
            
        }];
        
    }else{
        [self.mainTableView setHidden:NO];
        [self.translatorTableView setHidden:YES];

        [self.view addSubview:self.mainTableView];
    
    }


}


-(void)reloadcell:(NSNotification *)noti
{
    NSDictionary *isLoginDic = [noti userInfo];
    NSString *isLoginstate = [isLoginDic objectForKey:@"状态"];
    if ([isLoginstate isEqual:@"true"]) {
        is = true;
//        it = false;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)reloadoutcell:(NSNotification *)noti
{
    NSDictionary *isLoginDic = [noti userInfo];
    NSString *isLoginstate = [isLoginDic objectForKey:@"状态"];
    if ([isLoginstate isEqual:@"true"]) {
        is = false;
        it = true;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setTextALabel" object:nil];
}
//行数

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.mainTableView){
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
    }else{
    
        if(section == 0)
        {
            return 1;
        }
        else
        {
            if(section == 1)
            {
                return 1;
            }
            else
            {
                if(section == 2)
                {
                    return 3;
                }
                else
                {
                    return 2;
                }
            }
        }
    
    }

}

//分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.mainTableView){
        return 4;
    }else{
        return 4;
    }
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
    
    
    if(tableView==self.mainTableView){
    
    
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
//        [cell showStar];
        _avatarImag = [[UIImageView alloc]init];
        _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.01, self.view.bounds.size.height * 0.06, self.view.bounds.size.height * 0.06);
        _avatarImag.layer.masksToBounds=YES;
        _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.06/2.0f;
         NSLog(@"----------------------------------------------");
        NSLog(@"%hhu %@",is,user_loginState[@"user_loginState"]);
        if (is || [user_loginState[@"user_loginState"] isEqual:@"1"])    {
            
            NSString *name = user_id[@"user_id"];
            NSString *str=[NSString stringWithFormat:@"%@.jpg",name];
            NSString *url=[NSString stringWithFormat:@"http://%@/TravelHelper/uploadimg/%@",serviseId,str];
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            _photoImg=[UIImage imageWithData:data];
            if(_photoImg){
                _avatarImag.image = _photoImg;
                [cell addSubview:_avatarImag];
                it=false;
            }else{
                _avatarImag.image = [UIImage imageNamed:@"translator"];
                [cell addSubview:_avatarImag];
            }
            cell.nameLable.frame=CGRectMake(70, 7, 150, 40);
//            [cell addSubview:self.starView];
            [WebAgent userid:user_id[@"user_id"] success:^(id responseObject) {
                    NSLog(@"%@",user_id[@"user_id"]);
                    NSData *data = [[NSData alloc]initWithData:responseObject];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *userInfo = dic[@"user_info"];
                    cell.nameLable.text = userInfo[@"user_nickname"];
                
                
                
                
                
                    }failure:^(NSError *error) {
                            NSLog(@"%@",error);
                     }];}
        else{
          
            _avatarImag.image = [UIImage imageNamed:@"translator"];
            [cell.contentView addSubview:_avatarImag];
            
            cell.nameLable.frame=CGRectMake(70, 7, 120, 40);
            cell.nameLable.text = @"登录／注册";
        }
        if (it) {
            _avatarImag.image = [UIImage imageNamed:@"translator"];
            [cell.contentView addSubview:_avatarImag];
            cell.nameLable.frame=CGRectMake(70, 7, 120, 40);
            cell.nameLable.text = @"登录／注册";
        }
         return cell;
    }
        else
        {
            if ( section == 1 && row == 0)
            {
                
                _avatarImag = [[UIImageView alloc]init];
                _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                _avatarImag.layer.masksToBounds=YES;
                _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                _avatarImag.image= [UIImage imageNamed:@"order"];
                [cell addSubview:_avatarImag];
                cell.nameLable.text = @"我的订单";
                 return cell;
            }
            else
            {
                if ( section == 1 && row == 1)
                {
                    _avatarImag = [[UIImageView alloc]init];
                    _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                    _avatarImag.layer.masksToBounds=YES;
                    _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                    _avatarImag.image= [UIImage imageNamed:@"collect"];
                    [cell addSubview:_avatarImag];
                   
                    cell.nameLable.text = @"我的收藏";
                     return cell;
                }
                else
                {
                    if ( section == 1 && row == 2)
                    {
                        
                        _avatarImag = [[UIImageView alloc]init];
                        _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                        _avatarImag.layer.masksToBounds=YES;
                        _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                        _avatarImag.image= [UIImage imageNamed:@"money"];
                        [cell addSubview:_avatarImag];

                        
                       
                        cell.nameLable.text = @"我的悬赏";
                         return cell;
                    }
                    else
                    {
                        if ( section == 2 && row == 0)
                        {
                            
                            _avatarImag = [[UIImageView alloc]init];
                            _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                            _avatarImag.layer.masksToBounds=YES;
                            _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                            _avatarImag.image= [UIImage imageNamed:@"push"];
                            [cell addSubview:_avatarImag];

                            
                           
                            cell.nameLable.text = @"电子钱包";
                             return cell;
                        }
                        else
                        {
                            if ( section == 2 && row == 1)
                            {
                                
                                _avatarImag = [[UIImageView alloc]init];
                                _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                                _avatarImag.layer.masksToBounds=YES;
                                _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                                _avatarImag.image= [UIImage imageNamed:@"set"];
                                [cell addSubview:_avatarImag];

                                
                               
                                cell.nameLable.text = @"设置";
                                 return cell;
                            }
                            else
                            {
                                self.adImageView= [[UIImageView alloc]init];
                                self.adImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height * 0.12);
                                self.adImageView.image = [UIImage imageNamed:@"游广告"];
                                [cell.contentView addSubview:self.adImageView];
                                return cell;
                            }
                        }
                    }
                }
                
            }
        }
        
        
        
    }else{
        
        
        //翻译者的tableview造型！0.0
        
        UserTableViewCell *cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
        NSInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        if (section != 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//最右边>号
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ( section == 0 && row == 0) {
            //----------------------------
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
            NSDictionary *user_loginState = [userinfo dictionaryForKey:@"user_loginState"];
            //        [cell showStar];
            _avatarImag = [[UIImageView alloc]init];
            _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.01, self.view.bounds.size.height * 0.06, self.view.bounds.size.height * 0.06);
            _avatarImag.layer.masksToBounds=YES;
            _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.06/2.0f;
            NSLog(@"----------------------------------------------");
            NSLog(@"%hhu %@",is,user_loginState[@"user_loginState"]);
            if (is || [user_loginState[@"user_loginState"] isEqual:@"1"])    {
                
                NSString *name = user_id[@"user_id"];
                NSString *str=[NSString stringWithFormat:@"%@.jpg",name];
                NSString *url=[NSString stringWithFormat:@"http://%@/TravelHelper/uploadimg/%@",serviseId,str];
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                _photoImg=[UIImage imageWithData:data];
                if(_photoImg){
                    _avatarImag.image = _photoImg;
                    [cell addSubview:_avatarImag];
                    it=false;
                }else{
                    _avatarImag.image = [UIImage imageNamed:@"translator"];
                    [cell addSubview:_avatarImag];
                }
                cell.nameLable.frame=CGRectMake(70,  (self.view.bounds.size.height * 0.08-40)/2+5, 0.24*self.view.bounds.size.width, 40);
                [cell addSubview:self.starView];
                
      ///////////    ///////////    ///////////    ///////////    ///////////    ///////////    ///////////    ///////////    ///////////    ///////////    ///////////
                
                [self.starView setToValue:0.5];//设置分值
                [self.starView toRemoveGesture];
                
                UILabel *pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.76*self.view.bounds.size.width,  (self.view.bounds.size.height * 0.09-0.027*self.view.bounds.size.height)/2+5, 0.53*self.view.bounds.size.width, 0.02*self.view.bounds.size.height)];
                
                
                //设置显示分值
                pointLabel.text=@"2.5";
                pointLabel.textColor=[UIColor lightGrayColor];
                pointLabel.font=[UIFont systemFontOfSize:12.5];
                [cell addSubview:pointLabel];
                
                [WebAgent userid:user_id[@"user_id"] success:^(id responseObject) {
                    NSLog(@"%@",user_id[@"user_id"]);
                    NSData *data = [[NSData alloc]initWithData:responseObject];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *userInfo = dic[@"user_info"];
                    cell.nameLable.text = userInfo[@"user_nickname"];
                    
                    
                    
                    
                    
                }failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];}
            else{
                
                _avatarImag.image = [UIImage imageNamed:@"translator"];
                [cell.contentView addSubview:_avatarImag];
                cell.nameLable.text = @"登录／注册";
            }
            if (it) {
                _avatarImag.image = [UIImage imageNamed:@"translator"];
                [cell.contentView addSubview:_avatarImag];
                cell.nameLable.text = @"登录／注册";
            }
            return cell;
        }
        else
        {
            if ( section == 1 && row == 0)
            {
                //评价星级之类的！！
                CGFloat screenWidth=self.view.bounds.size.width;
                CGFloat screenHeight=self.view.bounds.size.height;
                UILabel *gradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.196*screenWidth, 0.015*screenHeight, 0.12*screenWidth, 0.022*screenHeight)];
//                gradeLabel.backgroundColor=[UIColor redColor];
                gradeLabel.text=@"等级";
                [cell addSubview:gradeLabel];
                
                UIView *scorllView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-0.5, screenHeight*0.01, 1, screenHeight*0.1)];
                scorllView.backgroundColor=[UIColor grayColor];
                scorllView.alpha=0.3;
                
                [cell addSubview:scorllView];
                
                UILabel *activityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.672*screenWidth, 0.015*screenHeight, 0.18*screenWidth, 0.022*screenHeight)];
                //                gradeLabel.backgroundColor=[UIColor redColor];
                activityLabel.text=@"活跃度";
                [cell addSubview:activityLabel];
                
                
                
                return cell;
            }
            else
            {
                if ( section == 2 && row == 0)
                {
                    _avatarImag = [[UIImageView alloc]init];
                    _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                    _avatarImag.layer.masksToBounds=YES;
                    _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                    _avatarImag.image= [UIImage imageNamed:@"order"];
                    [cell addSubview:_avatarImag];
                    cell.nameLable.text = @"我的订单";
                    return cell;                }
                else
                {
                    if ( section == 2 && row == 1)
                    {
                        
                        _avatarImag = [[UIImageView alloc]init];
                        _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                        _avatarImag.layer.masksToBounds=YES;
                        _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                        _avatarImag.image= [UIImage imageNamed:@"collect"];
                        [cell addSubview:_avatarImag];
                        
                        cell.nameLable.text = @"我的收藏";
                        return cell;
                    }
                    else
                    {
                        if ( section == 2 && row == 2)
                        {
                            
                            _avatarImag = [[UIImageView alloc]init];
                            _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                            _avatarImag.layer.masksToBounds=YES;
                            _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                            _avatarImag.image= [UIImage imageNamed:@"money"];
                            [cell addSubview:_avatarImag];
                            
                            
                            
                            cell.nameLable.text = @"我的悬赏";
                            return cell;
                        }
                        else
                        {
                            if ( section == 3 && row == 0)
                            {
                                
                                _avatarImag = [[UIImageView alloc]init];
                                _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                                _avatarImag.layer.masksToBounds=YES;
                                _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                                _avatarImag.image= [UIImage imageNamed:@"push"];
                                [cell addSubview:_avatarImag];
                                
                                
                                
                                cell.nameLable.text = @"电子钱包";
                                return cell;

                            }
                            else
                            {
                                
                                
                                _avatarImag = [[UIImageView alloc]init];
                                _avatarImag.frame = CGRectMake(12, self.view.bounds.size.height * 0.02, self.view.bounds.size.height * 0.05, self.view.bounds.size.height * 0.05);
                                _avatarImag.layer.masksToBounds=YES;
                                _avatarImag.layer.cornerRadius=self.view.bounds.size.height * 0.05/2.0f;
                                _avatarImag.image= [UIImage imageNamed:@"set"];
                                [cell addSubview:_avatarImag];
                                
                                
                                
                                cell.nameLable.text = @"设置";
                                return cell;
                            }
                        }
                    }
                }
                
            }
        }
        
        
        
    
    }
    
   
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if(tableView==self.mainTableView){
        if (indexPath.section == 3) {
            return self.view.bounds.size.height * 0.12;
        }else{
            return self.view.bounds.size.height * 0.08;
        }
    }else{
        if(indexPath.section==1){
            return self.view.bounds.size.height * 0.12;
        }else{
            return self.view.bounds.size.height * 0.08;
        }
        
    }
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    
    if(tableView==self.mainTableView){
    
    
    
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
    if ( section == 1 && row==1) {
        
        YBZMyFavoriteViewController *myVC = [[YBZMyFavoriteViewController alloc]init];
        myVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    if ( section == 2 && row == 0) {
        
        YBZMoneyBagViewController *bagVC = [[YBZMoneyBagViewController alloc]init];
        bagVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bagVC animated:YES];
        
    }
    
    if ( section == 2 && row == 1) {
        
        [self intoInfoSettingClick];
        
    }
    
    if ( section == 3 && row == 0) {

    }
        
        
        
        
    }else{
    
    //翻译者tableview的点击事件~~
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
        if ( section == 2 && row==1) {
            
            YBZMyFavoriteViewController *myVC = [[YBZMyFavoriteViewController alloc]init];
            myVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myVC animated:YES];
            
        }
        if ( section == 3 && row == 0) {
            
            YBZMoneyBagViewController *bagVC = [[YBZMoneyBagViewController alloc]init];
            bagVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bagVC animated:YES];
            
        }
        
        if ( section == 3 && row == 1) {
            
            [self intoInfoSettingClick];
            
        }
        
        

   
    
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
    else{
        if(is || [user_loginState[@"user_loginState"] isEqual:@"1"]){
            EditViewController *userInfoVC = [[EditViewController alloc]init];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
        else{
            YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
            YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
            logVC.view.backgroundColor = [UIColor whiteColor];
            [self presentViewController:nav animated:YES completion:nil];
            
            }
        }
    if (it) {
        YBZLoginViewController *logVC = [[YBZLoginViewController alloc]initWithTitle:@"登录"];
        YBZBaseNaviController *nav = [[YBZBaseNaviController alloc]initWithRootViewController:logVC];
        logVC.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
       
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



- (void)starsScore:(GTStarsScore *)starsScore valueChange:(CGFloat)value{
    
    
    //    starValue=value/2;
    //
    //    if(starValue>=0.48){
    //
    //        starValue=0.5;
    //    }
    //    if(starValue<=0.02){
    //
    //        starValue=0.0;
    //    }
    
    NSLog(@"%lf",value);
    
}



#pragma mark - getters

-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];

        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
    }
    return _mainTableView;
}

-(UITableView *)translatorTableView{
    
    if (!_translatorTableView) {
        _translatorTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        
        _translatorTableView.delegate = self;
        _translatorTableView.dataSource = self;
        
    }
    return _translatorTableView;
}

-(GTStarsScore *)starView{
    
    if(!_starView){
        
        _starView=[[GTStarsScore alloc]initWithFrame:CGRectMake(80+ 0.24*self.view.bounds.size.width, (self.view.bounds.size.height * 0.08-0.027*self.view.bounds.size.height)/2+5, 0, 0.027*self.view.bounds.size.height)];
        _starView.delegate=self;
        
    }
    return _starView;
    
}



@end