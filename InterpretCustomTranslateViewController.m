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

@interface InterpretCustomTranslateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *mainTableView;
@property(nonatomic , strong)NSMutableArray *mArr;
@end

@implementation InterpretCustomTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制翻译";
    [self loadDate];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
}
#define mark - getters
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundImage"]];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
        [self.view addSubview:self.mainTableView];
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArr = dic[@"custom_info"];
        
        for (int i = 0 ; i < infoArr.count; i++) {
            NSDictionary *oneInfo = infoArr[i];
            
            CustomTranslateInfoModel *infoModel = [[CustomTranslateInfoModel alloc]initWithcustomID:oneInfo[@"custom_id"] langueKind:oneInfo[@"language"] scene:oneInfo[@"scene"] content:oneInfo[@"content"] interper:nil translateTime:oneInfo[@"custom_time"] duration:oneInfo[@"duration"] offerMoney:oneInfo[@"offer_money"] publishTime:oneInfo[@"publish_time"]  cellKind:@"0"];
            
            infoModel.user_id = oneInfo[@"user_id"];
            
            [self.mArr addObject:infoModel];
        }
        
        [self.mainTableView reloadData];
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
        
        [WebAgent custom_id:cell.customID state:@"1" success:^(id responseObject) {
            NSLog(@"success ! !!");
            
        } failure:^(NSError *error) {
             NSLog(@"%@",error);
        }];
        
    }];
}

@end
