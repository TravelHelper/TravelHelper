//
//  YBZChangeLanguageViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZChangeLanguageViewController.h"
#import "YBZInterpretViewController.h"
#import "YBZChangeLanguageCell.h"
#import "YBZChangeLanguageInfo.h"
#import "YBZLanguageSearchResultViewController.h"
#import "YBZWaitViewController.h"
#import "QuickTransViewController.h"
#import "WebAgent.h"
#import "AFNetworking.h"

@interface YBZChangeLanguageViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


//@property (nonatomic ,strong) UIView *bottomView;

//@property (nonatomic ,strong) UITextField *searchTextField;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic ,strong) UITableView *cellView;


@property (nonatomic ,strong) NSMutableArray *cellArr;
@property (nonatomic ,strong) NSMutableArray *searchArr;
//搜索结果的表格视图
@property (nonatomic ,strong) UITableViewController *searchTableView;


@end

@implementation YBZChangeLanguageViewController{

    NSString *user_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _searchArr = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *selfID = [defaults objectForKey:@"user_id"];
    user_id = selfID[@"user_id"];
    //    [self.view addSubview:self.CH_USBtn];
    //    [self.bottomView addSubview:self.searchTextField];
    
    //    YBZLanguageSearchResultViewController *resultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"YBZLanguageSearchResultViewController"];
    //
    //    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    //
    //    self.searchController.searchResultsUpdater = resultsController;
    //
    //    self.searchController.searchResultsUpdater = resultsController;
    //    [self.searchController.searchBar sizeToFit];
    //    self.cellView.tableHeaderView = self.searchController.searchBar;
    //    self.definesPresentationContext = YES;
    //
    
    //    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //    _searchController.searchResultsUpdater = self;
    //    _searchController.dimsBackgroundDuringPresentation = NO;
    //    _searchController.hidesNavigationBarDuringPresentation = NO;
    //    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    //    self.cellView.tableHeaderView = self.searchController.searchBar;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.cellView];
    [self createSearchController];
    
    [self initData];
    
    [self.cellView setTableHeaderView:self.searchController.searchBar];

    _searchTableView.tableView.delegate=self;
}


-(void)initData{
    
    self.cellArr=[NSMutableArray array];
    
//    YBZChangeLanguageInfo *cell1 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"简体中文" AndContent:@"简体中文"];
//    [self.cellArr addObject:cell1];
    
    YBZChangeLanguageInfo *cell2 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"English" AndContent:@"英文"];
    [self.cellArr addObject:cell2];
    
    YBZChangeLanguageInfo *cell3 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Français" AndContent:@"法文"];
    [self.cellArr addObject:cell3];
    
    YBZChangeLanguageInfo *cell4 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Deutsch" AndContent:@"德文"];
    [self.cellArr addObject:cell4];
    
    YBZChangeLanguageInfo *cell5 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"日本語" AndContent:@"日文"];
    [self.cellArr addObject:cell5];
    
    YBZChangeLanguageInfo *cell6 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Italiano" AndContent:@"意大利文"];
    [self.cellArr addObject:cell6];
    
    YBZChangeLanguageInfo *cell7 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Español" AndContent:@"西班牙文"];
    [self.cellArr addObject:cell7];
    
    YBZChangeLanguageInfo *cell8 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"한국어" AndContent:@"韩文"];
    [self.cellArr addObject:cell8];
    
    YBZChangeLanguageInfo *cell9 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Português" AndContent:@"葡萄牙文"];
    [self.cellArr addObject:cell9];
    
    YBZChangeLanguageInfo *cell10 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Pусский" AndContent:@"俄文"];
    [self.cellArr addObject:cell10];
    
    YBZChangeLanguageInfo *cell11 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Dansk" AndContent:@"丹麦文"];
    [self.cellArr addObject:cell11];
    YBZChangeLanguageInfo *cell12 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"English(US)" AndContent:@"英文（美国）"];
    [self.cellArr addObject:cell12];
    YBZChangeLanguageInfo *cell13 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"ภาษาไทย" AndContent:@"泰文"];
    [self.cellArr addObject:cell13];
    YBZChangeLanguageInfo *cell14 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"العربية " AndContent:@"阿拉伯文"];
    [self.cellArr addObject:cell14];
    YBZChangeLanguageInfo *cell15 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Ελληνικά" AndContent:@"希腊文"];
    [self.cellArr addObject:cell15];
    YBZChangeLanguageInfo *cell16 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Nederlands" AndContent:@"荷兰文"];
    [self.cellArr addObject:cell16];
    YBZChangeLanguageInfo *cell17 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Polski" AndContent:@"波兰文"];
    [self.cellArr addObject:cell17];
    YBZChangeLanguageInfo *cell18 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Suomi" AndContent:@"芬兰文"];
    [self.cellArr addObject:cell18];
    YBZChangeLanguageInfo *cell19 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Čeština" AndContent:@"捷克文"];
    [self.cellArr addObject:cell19];
    YBZChangeLanguageInfo *cell20 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Svenska" AndContent:@"瑞典文"];
    [self.cellArr addObject:cell20];
    YBZChangeLanguageInfo *cell21 = [[YBZChangeLanguageInfo alloc]initWithTitle:@"Magyar" AndContent:@"匈牙利文"];
    [self.cellArr addObject:cell21];
    
}

#pragma mark - UITableViewDelegate&UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return [self.cellArr count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    YBZChangeLanguageInfo *model = self.cellArr[indexPath.row];
//
//    static NSString *cellID = @"YBZChangeLanguageCell";
//
//    YBZChangeLanguageCell *cell = nil;
//
//    //cell = [cellView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//
//    cell = [self.cellView dequeueReusableCellWithIdentifier:cellID];
//
//    if(!cell){
//
//         cell = [[YBZChangeLanguageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//
//    }
//
//    cell.titleLabel.text = model.title;
//    cell.contentLabel.text = model.content;
//
//    return cell;
//
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return 60;
//}

#pragma mark - 点击事件

- (void)intoInterpretClick{
    
    
    YBZInterpretViewController *interpretVC = [[YBZInterpretViewController alloc]initWithTitle:@"口语即时"];
    
    [self.navigationController pushViewController:interpretVC animated:YES];
    
}

#pragma mark - getters

//- (UIView *)bottomView{
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)];
//
//    }
//    return _bottomView;
//}


- (UITableView *)cellView{
    
    if (!_cellView) {
        
        _cellView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        
        //_cellView.backgroundColor = [UIColor whiteColor];
        
        //_cellView.tableHeaderView = self.bottomView;
        
        _cellView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.cellView.delegate = self;
        
        self.cellView.dataSource = self;
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aa)];
//        
//        tapGesture.delegate = self;
//        tapGesture.numberOfTapsRequired = 1;//单击
//        tapGesture.numberOfTouchesRequired = 1;//点按手指数
//        
//        [_cellView addGestureRecognizer:tapGesture];
        
    }
    
    return _cellView;
    
}

- (void)aa{
    
}

//- (UITextField *)searchTextField{
//
//    if (!_searchTextField) {
//        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)];
//        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _searchTextField.placeholder = @"搜索";
//        _searchTextField.textAlignment = NSTextAlignmentCenter;
//
//    }
//    return _searchTextField;
//
//
//}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchArr count];
    }else{
        return [self.cellArr count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *flag=@"cellFlag";
    YBZChangeLanguageCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[YBZChangeLanguageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (!self.searchController.active) {
        YBZChangeLanguageInfo *model = self.cellArr[indexPath.row];

        //[cell.textLabel setText:self.searchArr[indexPath.row]];
        cell.titleLabel.text = model.title;
        cell.contentLabel.text = model.content;
    }else{
        NSLog(@"sadsdasd%@",self.cellArr[indexPath.row]);
        
        if(_searchArr.count == 0){
            
        }else{
            YBZChangeLanguageInfo *searchModel = _searchArr[indexPath.row];
            cell.titleLabel.text = searchModel.title;
            cell.contentLabel.text = searchModel.content;
        }
        
        
       
//        cell.titleLabel.text = model.title;
//        cell.contentLabel.text = model.content;
        
    }
    return cell;
}

//封装－－－匹配译员
-(void)matchTranslatorWithsenderID:(NSString *)senderID WithsendMessage:(NSString *)sendMessage WithlanguageCatgory:(NSString *)language WithpayNumber:(NSString *)payNumber{
    
    [WebAgent selectWaitingQueue:language success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray   *dictionary = dic[@"data"];
        if (dictionary.count !=0){
            NSLog(@"开始聊天");
            NSDictionary *dict = [self getLanguageWithString:language];
            [WebAgent sendRemoteNotificationsWithuseId:dictionary[0][@"user_id"] WithsendMessage:@"进入聊天" WithlanguageCatgory:language WithpayNumber:payNumber WithSenderID:user_id success:^(id responseObject) {
                NSLog(@"反馈推送—进入聊天通知成功！");
                QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:user_id WithTargetID:dictionary[0][@"user_id"] WithUserIdentifier:@"USER" WithVoiceLanguage:dict[@"voice"] WithTransLanguage:dict[@"trans"]];
                [self.navigationController pushViewController:quickVC animated:YES];
            } failure:^(NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"进入聊天页面失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            }];
        }else {
            [WebAgent matchTranslatorWithchooseLanguage:language success:^(id responseObject) {
                
                //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *arr = dic[@"data"];
                NSLog(@"%@",arr);
                
                if (arr.count == 0) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"抱歉，当前没有该语种的对应译员" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertVC addAction:okAction];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }else{
                    
                    for (int i = 0 ; i< arr.count; i++) {
                        NSString *user_ID = arr[i];
                        NSString * strid = [user_ID stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                        [WebAgent sendRemoteNotificationsWithuseId:strid WithsendMessage:sendMessage WithlanguageCatgory:language WithpayNumber:payNumber WithSenderID:senderID success:^(id responseObject) {
                            NSLog(@"发送远程推送成功!");
                        } failure:^(NSError *error) {
                            NSLog(@"发送远程推送失败－－－>%@",error);
                        }];
                        
                    }
                }
                
            } failure:^(NSError *error) {
                NSLog(@"查询语种对应的译员信息失败－－－>%@",error);
            }];
            
            YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]init];
            
            [self.navigationController pushViewController:waitVC animated:YES];

        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        NSLog(@"英文");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"YingYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 1) {
        NSLog(@"法语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"FaYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 2) {
        NSLog(@"德语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"DeYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 3) {
        NSLog(@"日语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"RiYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 4) {
        NSLog(@"意大利语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"YiDaLiYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 5) {
        NSLog(@"西班牙");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"XiBanYa" WithpayNumber:@"20"];
    }
    if (indexPath.row == 6) {
        NSLog(@"韩文");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"HanYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 7) {
        NSLog(@"葡萄牙语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"PuTaoYaYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 8) {
        NSLog(@"俄语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"EYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 9) {
        NSLog(@"丹麦语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"DanMaiYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 10) {
        NSLog(@"美国语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"MeiYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 11) {
        NSLog(@"泰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"TaiYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 12) {
        NSLog(@"阿拉伯语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"ALaBoYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 13) {
        NSLog(@"希腊语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"XiLaYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 14) {
        NSLog(@"荷兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"HeLanYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 15) {
        NSLog(@"波兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"BoLanYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 16) {
        NSLog(@"芬兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"FenLanYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 17) {
        NSLog(@"捷克语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"JieKeYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 18) {
        NSLog(@"瑞典语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"RuiDianYu" WithpayNumber:@"20"];
    }
    if (indexPath.row == 19) {
        NSLog(@"匈牙利语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [self matchTranslatorWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"XiongYaLiYu" WithpayNumber:@"20"];
    }

    
}


- (void)createSearchController
{
    //表格界面
    _searchTableView = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    //tableview是表格视图
    //UITableViewController表格视图控制器
    _searchTableView.tableView.dataSource = self;
    _searchTableView.tableView.delegate = self;
    //设置大小
    _searchTableView.tableView.frame = self.view.bounds;
    //创建搜索界面
    _searchController = [[UISearchController alloc]initWithSearchResultsController:_searchTableView];
    //把表格视图控制器跟搜索界面相关联
    
    //设置搜索栏的大小
    _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    
    //把搜索栏放到tableview的头视图上
    _cellView.tableHeaderView = _searchController.searchBar;
    //设置搜索的代理
    _searchController.searchResultsUpdater = self;
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"搜索");
    //在点击搜索时会调用一次，点击取消按钮又调用一次
    //判断当前搜索是否在搜索状态还是取消状态
    if (_searchController.isActive) {
        //表示搜索状态
        
        //初始化搜索数组

            [_searchArr removeAllObjects];
            //遍历数据源，给搜索数组添加对象
            for (YBZChangeLanguageInfo *info in _cellArr)
            {
                
//                NSString *dataTitle = info.title;
//                NSString *dataContent = info.content;
//                YBZChangeLanguageInfo *searchInfo = [[YBZChangeLanguageInfo alloc]initWithTitle:dataTitle AndContent:dataContent];
                
                
                ////                NSArray *info = array;
                //if (NSString * name in info){
                
                NSRange rangeTitle = [info.title rangeOfString:searchController.searchBar.text];
                NSRange rangeContent = [info.content rangeOfString:searchController.searchBar.text];
                
                if (rangeTitle.location != NSNotFound |rangeContent.location != NSNotFound) {
                    [_searchArr addObject:info];
                }
                //}
            }
        }
        //刷新搜索界面的tableview
        [_searchTableView.tableView reloadData];
        _searchTableView.tableView.frame = CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height + 44);
    }

    
    


//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [_searchDataSource removeAllObjects];
//    
//    NSMutableArray *dataSource = [NSMutableArray array];
//    NSMutableArray *searchDataSource = [NSMutableArray array];
//    NSMutableArray *contentDataSource = [NSMutableArray array];
//
//
//    NSArray *ary = [NSArray new];
//    for (YBZChangeLanguageInfo * info in _cellArr){
//        NSString *dataTitle = info.title;
//        NSString *dataContent = info.content;
//        YBZChangeLanguageInfo *searchInfo = [[YBZChangeLanguageInfo alloc]initWithTitle:dataTitle AndContent:dataContent];
//        [contentDataSource addObject:dataContent];
//        [dataSource addObject:searchInfo];
//    }
//    ary = [ZYPinYinSearch searchWithOriginalArray:contentDataSource andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
//    if (searchController.searchBar.text.length == 0) {
//        [_searchDataSource addObjectsFromArray:dataSource];
//    }else {
//        [_searchDataSource addObjectsFromArray:ary];
//    }
//    
//    [_searchTableView.tableView reloadData];
//
//    _searchTableView.tableView.frame = CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height + 44);//    _cellView.frame = CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height + 44);
//}

//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//
//    NSString *searchString = searchController.searchBar.text;
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    if (!(_searchArr == nil)) {
//        [self.searchArr removeAllObjects];
//    }
//    //过滤数据
//
//    self.searchArr = [NSMutableArray arrayWithArray:[_cellArr filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [self.cellView reloadData];
//
//}



-(NSDictionary *)getLanguageWithString:(NSString *)language{

    NSString *VoiceLanguage;
    NSString *TransLanguage;
    if ([language isEqualToString:@"YingYu"]) {
        
        VoiceLanguage = Voice_YingYu;
        TransLanguage = Trans_YingYu;
    }
    if ([language isEqualToString:@"MeiYu"]) {
        
        VoiceLanguage = Voice_MeiYu;
        TransLanguage = Trans_MeiYu;
    }
    if ([language isEqualToString:@"HanYu"]) {
        
        VoiceLanguage = Voice_HanYu;
        TransLanguage = Trans_HanYu;
    }
    if ([language isEqualToString:@"XiBanYa"]) {
        
        VoiceLanguage = Voice_XiBanYa;
        TransLanguage = Trans_XiBanYa;
    }
    if ([language isEqualToString:@"TaiYu"]) {
        
        VoiceLanguage = Voice_TaiYu;
        TransLanguage = Trans_TaiYu;
    }
    if ([language isEqualToString:@"ALaBoYu"]) {
        
        VoiceLanguage = Voice_ALaBoYu;
        TransLanguage = Trans_ALaBoYu;
    }
    if ([language isEqualToString:@"EYu"]) {
        
        VoiceLanguage = Voice_EYu;
        TransLanguage = Trans_EYu;
    }
    if ([language isEqualToString:@"PuTaoYaYu"]) {
        
        VoiceLanguage = Voice_PuTaoYaYu;
        TransLanguage = Trans_PuTaoYaYu;
    }
    if ([language isEqualToString:@"XiLaYu"]) {
        
        VoiceLanguage = Voice_XiLaYu;
        TransLanguage = Trans_XiLaYu;
    }
    if ([language isEqualToString:@"HeLanYu"]) {
        
        VoiceLanguage = Voice_HeLanYu;
        TransLanguage = Trans_HeLanYu;
    }
    if ([language isEqualToString:@"BoLanYu"]) {
        
        VoiceLanguage = Voice_BoLanYu;
        TransLanguage = Trans_BoLanYu;
    }
    if ([language isEqualToString:@"DanMaiYu"]) {
        
        VoiceLanguage = Voice_DanMaiYu;
        TransLanguage = Trans_DanMaiYu;
    }
    if ([language isEqualToString:@"FenLanYu"]) {
        
        VoiceLanguage = Voice_FenLanYu;
        TransLanguage = Trans_FenLanYu;
    }
    if ([language isEqualToString:@"JieKeYu"]) {
        
        VoiceLanguage = Voice_JieKeYu;
        TransLanguage = Trans_JieKeYu;
    }
    if ([language isEqualToString:@"RuiDianYu"]) {
        
        VoiceLanguage = Voice_RuiDianYu;
        TransLanguage = Trans_RuiDianYu;
    }
    if ([language isEqualToString:@"XiongYaLiYu"]) {
        
        VoiceLanguage = Voice_XiongYaLiYu;
        TransLanguage = Trans_XiongYaLiYu;
    }
    if ([language isEqualToString:@"RiYu"]) {
        
        VoiceLanguage = Voice_RiYu;
        TransLanguage = Trans_RiYu;
    }
    if ([language isEqualToString:@"FaYu"]) {
        
        VoiceLanguage = Voice_FaYa;
        TransLanguage = Trans_FaYu;
    }
    if ([language isEqualToString:@"DeYu"]) {
        
        VoiceLanguage = Voice_DeYu;
        TransLanguage = Trans_DeYu;
    }
    if ([language isEqualToString:@"YiDaLiYu"]) {
        
        VoiceLanguage = Voice_YiDaLiYu;
        TransLanguage = Trans_YiDaLiYu;
    }

    NSDictionary *dict = @{@"voice":VoiceLanguage,
                                            @"trans":TransLanguage
                           };
    return dict;
}

@end

