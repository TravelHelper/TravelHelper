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
#import "BaiduMobStat.h"


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
    NSString *message_id;
    NSTimer *timer;
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row     == 0) {
        NSLog(@"英文");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"英语"];
        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于英语的口语即时翻译请求" WithlanguageCatgory:@"英语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];

    }
    if (indexPath.row == 1) {
        NSLog(@"法语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"法语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于法语的口语即时翻译请求" WithlanguageCatgory:@"法语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 2) {
        NSLog(@"德语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"德语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于德语的口语即时翻译请求" WithlanguageCatgory:@"德语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 3) {
        NSLog(@"日语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"日语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于日语的口语即时翻译请求" WithlanguageCatgory:@"日语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 4) {
        NSLog(@"意大利语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"意大利语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于意大利语的口语即时翻译请求" WithlanguageCatgory:@"意大利语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 5) {
        NSLog(@"西班牙");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"西班牙"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于西班牙语的口语即时翻译请求" WithlanguageCatgory:@"西班牙语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 6) {
        NSLog(@"韩文");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"韩文"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于韩语的口语即时翻译请求" WithlanguageCatgory:@"韩语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 7) {
        NSLog(@"葡萄牙语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"葡萄牙语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于葡萄牙语的口语即时翻译请求" WithlanguageCatgory:@"葡萄牙语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 8) {
        NSLog(@"俄语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"俄语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于俄语的口语即时翻译请求" WithlanguageCatgory:@"俄语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 9) {
        NSLog(@"丹麦语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"丹麦语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于丹麦语的口语即时翻译请求" WithlanguageCatgory:@"丹麦语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 10) {
        NSLog(@"美国语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"美国语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于美语的口语即时翻译请求" WithlanguageCatgory:@"美语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 11) {
        NSLog(@"泰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"泰语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于泰语的口语即时翻译请求" WithlanguageCatgory:@"泰语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 12) {
        NSLog(@"阿拉伯语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"阿拉伯语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于阿拉伯语的口语即时翻译请求" WithlanguageCatgory:@"阿拉伯语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 13) {
        NSLog(@"希腊语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"希腊语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于希腊语的口语即时翻译请求" WithlanguageCatgory:@"希腊语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 14) {
        NSLog(@"荷兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"荷兰语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于荷兰语的口语即时翻译请求" WithlanguageCatgory:@"荷兰语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 15) {
        NSLog(@"波兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"波兰语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于波兰语的口语即时翻译请求" WithlanguageCatgory:@"波兰语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 16) {
        NSLog(@"芬兰语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"芬兰语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于芬兰语的口语即时翻译请求" WithlanguageCatgory:@"芬兰语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 17) {
        NSLog(@"捷克语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"捷克"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于捷克语的口语即时翻译请求" WithlanguageCatgory:@"捷克语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 18) {
        NSLog(@"瑞典语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"瑞典语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于瑞典语的口语即时翻译请求" WithlanguageCatgory:@"瑞典语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
    }
    if (indexPath.row == 19) {
        NSLog(@"匈牙利语");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *selfID = [defaults objectForKey:@"user_id"];
        [[BaiduMobStat defaultStat] logEvent:@"0001" eventLabel:@"匈牙利语"];

        YBZWaitViewController *waitVC = [[YBZWaitViewController alloc]initWithsenderID:selfID[@"user_id"] WithsendMessage:@"您收到一个关于匈牙利语的口语即时翻译请求" WithlanguageCatgory:@"匈牙利语" WithpayNumber:@"20"];
        [self.navigationController pushViewController:waitVC animated:YES];
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

    


@end

