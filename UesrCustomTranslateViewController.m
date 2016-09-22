//
//  UesrCustomTranslateViewController.m
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "UesrCustomTranslateViewController.h"
#import "CustomTranslateTableViewCell.h"
#import "CustomTranslateInfoModel.h"
#import "CustomTranslateCellFramInfo.h"
#import "UIAlertController+SZYKit.h"
#import "YBZOrderDetailsViewController.h"
#import "AFNetworking.h"
#import "WebAgent.h"


@interface UesrCustomTranslateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *mainTableView;
@property(nonatomic , strong)NSMutableArray *mArr;
@property(nonatomic , strong)NSString *userID;

@end

@implementation UesrCustomTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的定制";
    [self loadDate];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    [self.view addSubview:self.mainTableView];
    
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
-(NSString *)userID{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    if (!_userID) {
        _userID = [[NSString alloc]initWithString:user_id[@"user_id"]];
    }
    return _userID;
}
#pragma mark - laoddate

-(void)loadDate{
//http://127.0.0.1/TravelHelper/index.php/Home/CustomTranslate/load?user_id=D546A559_2D0D_4308_B3D6_67976EE64D83
//http://127.0.0.1/TravelHelper/index.php/Home/CustomTranslate/upload?user_id=D546A559_2D0D_4308_B3D6_67976EE64D83&&custom_id=25&&language=hanyullllll&&scene=yuyinnnnnnn&&content=mathhhhhhhh&&interpreter=lillilylilylilylilylily&&duration=1xiaoshi&&offer_money=100.0000000&&publish_time=2014.09.9&&state=0
//http://127.0.0.1/TravelHelper/index.php/Home/CustomTranslate/duration?custom_id=1
// http://127.0.0.1/TravelHelper/index.php/Home/CustomTranslate/delect?custom_id=23
    
    [WebAgent customtranslate_userid:self.userID success:^(id responseObject) {
        [self.view addSubview:self.mainTableView];

        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArr = dic[@"custom_info"];
        
        for (int i = 0 ; i < infoArr.count; i++) {
            NSDictionary *oneInfo = infoArr[i];
            
            CustomTranslateInfoModel *infoModel = [[CustomTranslateInfoModel alloc]initWithcustomID:oneInfo[@"custom_id"] langueKind:oneInfo[@"language"] scene:oneInfo[@"scene"] content:oneInfo[@"content"] interper:oneInfo[@"interpreter"] translateTime:oneInfo[@"custom_time"] duration:oneInfo[@"duration"] offerMoney:oneInfo[@"offer_money"] publishTime:oneInfo[@"publish_time"]  cellKind:oneInfo[@"state"]];

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
    CustomTranslateTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"--------------------custom_id-------------%@",cell.customID);
    
    
    if ([cell.infoModel.cellKind isEqualToString:@"0"]) {
        
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"是否需要删除？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            [cell removeFromSuperview];
            [self.mArr removeObjectAtIndex:indexPath.row];
            [self.mainTableView reloadData];
            
            [WebAgent delectByCustom_id:cell.infoModel.customID success:^(id responseObject) {
                 NSLog(@"have delected  !!!");
            } failure:^(NSError *error) {
                 NSLog(@"%@",error);
            }];
        }];
        
    }else{
        if ([cell.infoModel.cellKind isEqualToString:@"1"]) {
            
            [WebAgent custom_id:cell.customID success:^(id responseObject) {
                
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *tag = dic[@"duration"];
                
                 NSLog(@"%@",dic);
                
                if ([tag isEqualToString:@"comeout"]) {
                    
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
                    NSLog(@"-------请在开始15分钟内进入等候页------");
                    
                }else{
                    
                    NSLog(@"-----------进入等候页------");
                    [WebAgent custom_id:cell.customID state:@"2" success:^(id responseObject) {
                        NSLog(@"cell reset  success ");
                    } failure:^(NSError *error) {
                        NSLog(@"%@",error);
                    }];
                    
                }
                
            } failure:^(NSError *error) {
                 NSLog(@"%@",error);
            }];
            
           
        }else if ([cell.infoModel.cellKind isEqualToString:@"2"]) {
            NSLog(@"---2---点击进入“定制进行页面”----------");
        }else{
            NSLog(@"------点击可以评价进入“订单详情页”-------");
            YBZOrderDetailsViewController *details = [[YBZOrderDetailsViewController alloc]init];
            [self.navigationController pushViewController:details animated:YES];
            
        }
    }
}

@end
