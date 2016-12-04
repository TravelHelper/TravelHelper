//
//  InterpretCustomTranslateViewController.m
//  YBZTravel
//
//  Created by 李连芸 on 16/9/18.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "InterpretCustomTranslateViewController.h"
#import "CustomTranslateTableViewCell.h"
#import "CustomTranslateInfoModel.h"
#import "CustomTranslateCellFramInfo.h"
#import "UIAlertController+SZYKit.h"
#import "AFNetworking.h"
#import "WebAgent.h"
#import "MBProgressHUD+XMG.h"
#import "YBZMyCustomViewController.h"

@interface InterpretCustomTranslateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *mainTableView;
@property(nonatomic , strong)NSMutableArray *mArr;
@end

@implementation InterpretCustomTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制翻译";
    
    UIBarButtonItem *callBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(myClick)];
    
    self.navigationItem.rightBarButtonItem = callBtnItem;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.mainTableView.frame=CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height-10);
    [self.view addSubview:self.mainTableView];
    
    
    //    [UIView transitionWithView:self.view
    //                      duration:0.5
    //                       options:UIViewAnimationOptionCurveEaseIn //any animation
    //                    animations:^ { [self.view addSubview:self.mainTableView]; }
    //                    completion:nil];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self loadDate];
    
}

#define mark - getters
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundImage"]];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(NSMutableArray *)mArr{
    if (!_mArr) {
        _mArr = [[NSMutableArray alloc]init];
    }
    return _mArr;
}

#pragma mark - laoddate

-(void)loadDate{
    self.mArr=[NSMutableArray array];
    [WebAgent selectLoadDatesuccess:^(id responseObject) {
        
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArr = dic[@"custom_info"];
        
        for (int i = 0 ; i < infoArr.count; i++) {
            NSDictionary *oneInfo = infoArr[i];
            
            CustomTranslateInfoModel *infoModel = [[CustomTranslateInfoModel alloc]initWithcustomID:oneInfo[@"custom_id"] langueKind:oneInfo[@"language"] scene:oneInfo[@"scene"] content:oneInfo[@"content"] interper:nil translateTime:oneInfo[@"custom_time"] duration:oneInfo[@"duration"] offerMoney:oneInfo[@"offer_money"] publishTime:oneInfo[@"publish_time"]  cellKind:@"0"];
            
            infoModel.user_id = oneInfo[@"user_id"];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
            if(![infoModel.user_id isEqualToString:user_id[@"user_id"]]){
            
                [self.mArr addObject:infoModel];

            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
            
        });
        
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
    }];
    
}


#pragma mark - 表示图协议

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.mArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    CustomTranslateTableViewCell *cell = [[CustomTranslateTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier contentModel:self.mArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.view.bounds.size.width*0.375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // http://127.0.0.1/TravelHelper/index.php/Home/CustomTranslate/resetcellstate?custom_id=2&&state=1
    
    CustomTranslateTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    NSString *user_id = cell.user_id;
    
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"是否接单？" cancelTitle:@"取消" confirmTitle:@"接单" cancelHandler:^(UIAlertAction *action) {
        
    } confirmHandler:^(UIAlertAction *action) {
        NSLog(@"user_id---%@",user_id);
        NSLog(@"customID---%@",cell.customID);
        
        [WebAgent custom_id:cell.customID success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(!dic){
                [MBProgressHUD showError:@"未知错误，请重试"];
            }else{
                NSString *tag = dic[@"duration"];
                NSNumber *number = dic[@"difference_time"];
                long differenceTime = [number longValue];
                
                if(differenceTime<0){
                
                    [MBProgressHUD showError:@"该订单已超时，无法接单"];
                    
                }else{
                
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
                    
                    CustomTranslateInfoModel *model=self.mArr[indexPath.row];
                    
                    NSString *custom_time = model.translateTime;
                    NSString *duration =  model.duration;

                    long customTime = [self changeTimeToSecond:custom_time];
                    int  a= [[duration substringWithRange:NSMakeRange(0,2)] intValue];
                    int b = [[duration substringWithRange:NSMakeRange(3, 2)]intValue];
                    float addTime = a*3600+b*60;
                    long fullTimeTime = customTime + addTime;
                    NSString *endTime =  [self changeSecondToTime:fullTimeTime];
                    [WebAgent checkTimeWithUser_id:user_id[@"user_id"] begin_time:custom_time end_time:endTime success:^(id responseObject) {
                        
                        NSData *data = [[NSData alloc]initWithData:responseObject];
                        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        long stateStr = [dict[@"allow"]longValue];
                        NSString *nowState = dict[@"state"];
                        
                        if([nowState isEqualToString:@"FAIL"]){
                            
                            stateStr= 1;
                            
                        }else{
                            
                            
                            
                        }
                        if(stateStr == 1){
                            [WebAgent custom_id:cell.customID state:@"1" accept_id:user_id[@"user_id"] success:^(id responseObject) {
                                NSLog(@"success ! !!");
                                if([tag isEqualToString:@"connecttimeout"]){
                                    
                                    [MBProgressHUD showSuccess:@"接单成功，临近预约时间，请立即前往"];
                                    
                                }else{
                                    [MBProgressHUD showSuccess:@"接单成功"];
                                }
                                
                                
                                CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
                                NSString *targetId=infoModel.user_id;
                                [WebAgent sendRemoteNotificationsWithuseId:targetId WithsendMessage:@"您的定制已被接单，请查看" WithType:@"9010" WithSenderID:user_id[@"user_id"] WithMessionID:@"" WithLanguage:@"" success:^(id responseObject) {
                                   
                                } failure:^(NSError *error) {
                                    
                                }];

                                
                                [self.mArr removeObjectAtIndex:indexPath.row];
                                [self.mainTableView reloadData];
                            } failure:^(NSError *error) {
                                NSLog(@"%@",error);
                                
                                [MBProgressHUD showError:@"接单失败，请重试"];
                                
                            }];

                            
                            
                        }else{
                        
                            [MBProgressHUD showError:@"与其他订单冲突，请检查"];
                        
                        }
                       
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    
                    
                    


                
                }
                
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
    }];
}



-(void)myClick{

    NSLog(@"我接受的定制");
    YBZMyCustomViewController *myCustom=[[YBZMyCustomViewController alloc]init];
    [self.navigationController pushViewController:myCustom animated:YES];
}
-(NSString *)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}


-(NSString *)changeDateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}


-(long)changeTimeToSecond:(NSString *)time{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    NSLog(@"%@", date);
    long timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
    
}
-(NSString *)changeSecondToTime:(long)second{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:confromTimesp];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}



@end
