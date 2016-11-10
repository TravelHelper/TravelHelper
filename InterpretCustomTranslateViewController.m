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

    [super viewWillAppear:animated];
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
    
    [WebAgent selectLoadDatesuccess:^(id responseObject) {
        
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArr = dic[@"custom_info"];
        
        for (int i = 0 ; i < infoArr.count; i++) {
            NSDictionary *oneInfo = infoArr[i];
            
            CustomTranslateInfoModel *infoModel = [[CustomTranslateInfoModel alloc]initWithcustomID:oneInfo[@"custom_id"] langueKind:oneInfo[@"language"] scene:oneInfo[@"scene"] content:oneInfo[@"content"] interper:nil translateTime:oneInfo[@"custom_time"] duration:oneInfo[@"duration"] offerMoney:oneInfo[@"offer_money"] publishTime:oneInfo[@"publish_time"]  cellKind:@"0"];
            
            infoModel.user_id = oneInfo[@"user_id"];
            
            [self.mArr addObject:infoModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view addSubview:self.mainTableView];
            
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
                
                    
                    [WebAgent custom_id:cell.customID state:@"1" success:^(id responseObject) {
                        NSLog(@"success ! !!");
                        if([tag isEqualToString:@"connecttimeout"]){
                            
                            [MBProgressHUD showSuccess:@"接单成功，临近预约时间，请立即前往"];
                            
                        }
                        [MBProgressHUD showSuccess:@"接单成功"];
                    } failure:^(NSError *error) {
                        NSLog(@"%@",error);
                        
                        [MBProgressHUD showError:@"接单失败，请重试"];
                        
                    }];
                    

                
                }
                
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
    }];
}



-(void)myClick{


    NSLog(@"我接受的定制");

}




@end
