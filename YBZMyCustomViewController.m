//
//  YBZMyCustomViewController.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/10.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyCustomViewController.h"
#import "CustomTranslateTableViewCell.h"
#import "CustomTranslateInfoModel.h"
#import "CustomTranslateCellFramInfo.h"
#import "UIAlertController+SZYKit.h"
#import "AFNetworking.h"
#import "WebAgent.h"
#import "MBProgressHUD+XMG.h"
#import "YBZCountDownViewController.h"
#import "YBZVideocontentViewController.h"
#import "YBZOrderDetailsViewController.h"
#import "YBZPrepareViewController.h"
@interface YBZMyCustomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *mainTableView;
@property(nonatomic , strong)NSMutableArray *mArr;
@end

@implementation YBZMyCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制翻译";
    
//    UIBarButtonItem *callBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(myClick)];
//    
//    self.navigationItem.rightBarButtonItem = callBtnItem;
    
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
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    [WebAgent selectAcceptaccept_id:user_id[@"user_id"] success:^(id responseObject) {
        
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArr = dic[@"custom_info"];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];

        for (int i = 0 ; i < infoArr.count; i++) {
            NSDictionary *oneInfo = infoArr[i];
            
            CustomTranslateInfoModel *infoModel = [[CustomTranslateInfoModel alloc]initWithcustomID:oneInfo[@"custom_id"] langueKind:oneInfo[@"language"] scene:oneInfo[@"scene"] content:oneInfo[@"content"] interper:user_id[@"user_id"] translateTime:oneInfo[@"custom_time"] duration:oneInfo[@"duration"] offerMoney:oneInfo[@"offer_money"] publishTime:oneInfo[@"publish_time"]  cellKind:oneInfo[@"state"]];
            
//            infoModel.star=oneInfo[@"star"];
            infoModel.user_id = oneInfo[@"user_id"];
            
            infoModel.star= oneInfo[@"star"];
            infoModel.proceedState=oneInfo[@"proceed_state"];
            infoModel.firstTime=oneInfo[@"first_time"];

            
//            if(![infoModel.user_id isEqualToString:user_id[@"user_id"]]){
            
                [self.mArr addObject:infoModel];
                
//            }
            
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
    CustomTranslateTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"--------------------custom_id-------------%@",cell.customID);
    
    
    if ([cell.infoModel.cellKind isEqualToString:@"0"]) {
        
//        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"是否需要删除？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action) {
//            
//        } confirmHandler:^(UIAlertAction *action) {
//            [cell removeFromSuperview];
//            [self.mArr removeObjectAtIndex:indexPath.row];
//            [self.mainTableView reloadData];
//            
//            [WebAgent delectByCustom_id:cell.infoModel.customID success:^(id responseObject) {
//                NSLog(@"have delected  !!!");
//                [MBProgressHUD showSuccess:@"删除成功！"];
//            } failure:^(NSError *error) {
//                NSLog(@"%@",error);
//                [MBProgressHUD showError:@"删除失败,请检查网络"];
//            }];
//        }];
        
    }else{
        if ([cell.infoModel.cellKind isEqualToString:@"1"]) {
            //             [self waitBtnClick];
            [WebAgent custom_id:cell.customID success:^(id responseObject) {
                
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if(!dic){
                    [MBProgressHUD showError:@"未知错误，请重试"];
                }else{
                    NSString *tag = dic[@"duration"];
                    NSNumber *number = dic[@"difference_time"];
                    long differenceTime = [number longValue];
                    
                    //                long differenceTime=dic[@"difference_time"];
                    NSLog(@"%@",dic);
                    
                    if([tag isEqualToString:@"timeout"]){
                        
                        [MBProgressHUD showError:@"请求已过时很久"];
                        
                    }else if([tag isEqualToString:@"connecttimeout"]){
                        
                        [MBProgressHUD showMessage:@"您迟到了"];
                        
                    }else if ([tag isEqualToString:@"comeout"]) {
                        
                        //                    NSString *str = @"请在开始15分钟内进入等候页";
                        //                    CGSize sizeh = [str boundingRectWithSize:CGSizeMake(110, 100) options:NSStringDrawingUsesLineFragmentOrigin    attributes:@{NSFontAttributeName:FONT_14} context:nil].size;
                        //
                        //                    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width -  sizeh.width-50) / 2, 250, sizeh.width+50, sizeh.height+50)];
                        //
                        //                    alertLabel.backgroundColor = [UIColor blackColor];
                        //                    alertLabel.layer.cornerRadius = 5;
                        //
                        //                    //将UiLabel设置圆角 此句不可少
                        //                    alertLabel.layer.masksToBounds = YES;
                        //                    alertLabel.alpha = 0.8;
                        //                    alertLabel.text = str;
                        //                    alertLabel.font = FONT_14;
                        //                    [alertLabel setTextAlignment:NSTextAlignmentCenter];
                        //                    alertLabel.textColor = [UIColor whiteColor];
                        //                    [alertLabel setNumberOfLines:0];
                        //                    [self.mainTableView addSubview:alertLabel];
                        //
                        //                    //设置动画
                        //                    [UIView animateWithDuration:4 animations:^{
                        //                        alertLabel.alpha = 0;
                        //                    } completion:^(BOOL finished) {
                        //                        //将警告Label透明后 在进行删除
                        //                        [alertLabel removeFromSuperview];
                        //                    }];
                        
                        
                        [UIAlertController showAlertAtViewController:self title:@"温馨提示" message:@"请在开始15分钟内进入等候页" confirmTitle:@"ok" confirmHandler:^(UIAlertAction *action) {
                            //
                        }];
                        
                        
                        
                        [UIAlertController showAlertAtViewController:self title:@"" message:@"" cancelTitle:@"" confirmTitle:@"" cancelHandler:^(UIAlertAction *action) {
                            
                        } confirmHandler:^(UIAlertAction *action) {
                            
                        }];
                        
                        NSLog(@"-------请在开始15分钟内进入等候页------");
                        
                        
                        
                        
                        
                        
                    }else if([tag isEqualToString:@"comein"]){
                        
                        NSLog(@"-----------进入等候页------");
                        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
                        [WebAgent updateCustomTranState:cell.customID andUser_id:user_id[@"user_id"] success:^(id responseObject) {
                            NSData *data = [[NSData alloc]initWithData:responseObject];
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            NSDictionary *toneeddic = dic[@"data"];
                            
                            NSString *firstTime=toneeddic[@"first_time"];
                            
                            CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
                            
                            NSMutableDictionary *needDic = [NSMutableDictionary dictionary];
                            
                            needDic[@"user_name"]=user_id[@"user_id"];
                            needDic[@"first_time"]=firstTime;
                            needDic[@"custom_time"]=infoModel.translateTime;
                            needDic[@"duration"]=infoModel.duration;
                            NSString *typeStr=infoModel.scene;
                            needDic[@"success"]=dic[@"success"];
                            needDic[@"mission_id"]=infoModel.customID;
                            YBZPrepareViewController *prepareController =[[YBZPrepareViewController alloc]initWithType:typeStr AndState:toneeddic[@"proceed_state"] AndInfo:needDic];
                            [self.navigationController pushViewController:prepareController animated:YES];
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD showError:@"等候页面进入失败，请重试"];
                        }];
                        
                        
                        [WebAgent custom_id:cell.customID state:@"2" accept_id:user_id[@"user_id"] success:^(id responseObject) {
                            NSLog(@"cell reset  success ");
                            
                            //                            CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
                            
                            
                            //                            [self waitBtnClick];
                            
                        } failure:^(NSError *error) {
                            NSLog(@"%@",error);
                            
                        }];
                        
                        
                        
                    }else{
                        
                        [MBProgressHUD showError:@"未知错误，请重试"];
                        
                    }
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"网络不稳定，请重试"];
            }];

            
            
        }else if ([cell.infoModel.cellKind isEqualToString:@"2"]) {
            NSLog(@"---2---点击进入“定制进行页面”----------");
            
            CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
            
            //            NSString *typeStr=infoModel.scene;
            
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
            [WebAgent updateCustomTranState:cell.customID andUser_id:user_id[@"user_id"] success:^(id responseObject) {
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *toneeddic = dic[@"data"];
                
                NSString *firstTime=toneeddic[@"first_time"];
                
                CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
                
                NSMutableDictionary *needDic = [NSMutableDictionary dictionary];
                
                needDic[@"user_name"]=user_id[@"user_id"];
                needDic[@"first_time"]=firstTime;
                needDic[@"custom_time"]=infoModel.translateTime;
                needDic[@"duration"]=infoModel.duration;
                NSString *typeStr=infoModel.scene;
                needDic[@"success"]=dic[@"success"];
                needDic[@"mission_id"]=infoModel.customID;
                YBZPrepareViewController *prepareController =[[YBZPrepareViewController alloc]initWithType:typeStr AndState:toneeddic[@"proceed_state"] AndInfo:needDic];
                [self.navigationController pushViewController:prepareController animated:YES];
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"等候页面进入失败，请重试"];
            }];
            
            

            
            
        }else{
            NSLog(@"------点击可以评价进入“订单详情页”-------");
            
            CustomTranslateInfoModel *infoModel = self.mArr[indexPath.row];
            
            NSString *star= infoModel.star;
            
            if(star ==NULL){
            
                [MBProgressHUD showNormalMessage:@"对方尚未对此订单进行评价哦"];
            
            }else{
            
                NSString *needStr=[NSString stringWithFormat:@"订单已被评价 星级:%@星",star];
                [MBProgressHUD showNormalMessage:needStr];
            
            }
            
//            YBZOrderDetailsViewController *details = [[YBZOrderDetailsViewController alloc]init];
//            [self.navigationController pushViewController:details animated:YES];
            
        }
    }
}




-(void)myClick{
    
    
    NSLog(@"我接受的定制");
    
}

-(void)waitBtnClick{
    
    YBZCountDownViewController *countDownCoutroller=[[YBZCountDownViewController alloc]init];
    [self.navigationController pushViewController:countDownCoutroller animated:YES];
    
}
-(void)textClick{
    
    NSLog(@"tiaozhuan");
    YBZVideocontentViewController *videoVC = [[YBZVideocontentViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
}



@end
