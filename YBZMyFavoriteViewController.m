//
//  YBZMyFavoriteViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/16.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyFavoriteViewController.h"
#import "CollectionModel.h"
#import "CollectionCellFrameInfo.h"
#import "CollectionMessageInfoCell.h"
#import "FreeWalkerInfoCell.h"
#import "DetailsView.h"
#import "CollectionAudioInfoCell.h"
@interface YBZMyFavoriteViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UILabel *mainLabel;
@property (nonatomic , strong) UISegmentedControl *segmented;
@property (nonatomic , strong) UISearchController *searchCon;
@property (nonatomic , strong) UITableView *translateTabelView;
@property (nonatomic , strong) NSArray *collectionArray;
@property (nonatomic , strong) NSArray *freeWalkerArray;
@property (nonatomic , strong) NSString *marked;

@property (nonatomic , strong) NSMutableArray *collectionSearchDataList;
@property (nonatomic , strong) NSMutableArray *freeWalkerSearchDataList;
@property (nonatomic , strong) NSMutableArray *searchList;

@end

@implementation YBZMyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionArray = [NSArray array];
    self.freeWalkerArray = [NSArray array];
    self.searchList = [NSMutableArray array];
    
    self.marked = @"collection";
    [self.view addSubview:self.mainLabel];
    [self.view addSubview:self.segmented];
    [self loadCollectionData];
    [self loadFreeWalkerData];
    [self loadCollectionSearchDataList];
    [self loadFreeWalkerSearchDataList];
    [self searchCon];
    
    //    [self.view addSubview:self.searchBar];
}
-(UILabel *)mainLabel
{
    if(!_mainLabel)
    {
        _mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 60)];
        _mainLabel.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
    }
    return _mainLabel;
}

#pragma mark - SegmentedController
-(UISegmentedControl *)segmented
{
    if(!_segmented)
    {
        _segmented = [[UISegmentedControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2, _mainLabel.frame.origin.y + 20, 200, 30)];
        _segmented.tintColor = [UIColor yellowColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,[UIFont fontWithName:@"黑体" size:24],UITextAttributeFont ,nil];
        [_segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
        [_segmented insertSegmentWithTitle:@"翻译" atIndex:0 animated:NO];
        [_segmented insertSegmentWithTitle:@"自由行" atIndex:1 animated:NO];
        [_segmented addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
        _segmented.selectedSegmentIndex = 0;//初始指定第0个选中
        [self segmentedClick:@"sender"];
        
    }
    return _segmented;
}

#pragma mark - SearchController
-(UISearchController *)searchCon
{
    if(!_searchCon)
    {
        _searchCon = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchCon.searchResultsUpdater = self;
        _searchCon.dimsBackgroundDuringPresentation = NO;
        _searchCon.hidesNavigationBarDuringPresentation = NO;
        _searchCon.searchBar.frame = CGRectMake(self.searchCon.searchBar.frame.origin.x, self.searchCon.searchBar.frame.origin.y,self.searchCon.searchBar.frame.size.width, 44.0);
        _searchCon.searchBar.placeholder = @"搜索";
        
        self.translateTabelView.tableHeaderView = self.searchCon.searchBar;
    }
    return _searchCon;
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //过滤数据
    if([self.marked isEqualToString:@"collection"])
    {
        NSString *searchString = [self.searchCon.searchBar text];
        
        if (self.searchList!= nil)
        {
            [self.searchList removeAllObjects];
        }
        for(int i = 0 ; i < self.collectionSearchDataList.count ; i ++)
        {
            NSString *message = self.collectionSearchDataList[i][@"Message"];
            NSRange range = [message rangeOfString:searchString];
            if(range.location != NSNotFound)
            {
                [self.searchList addObject:self.collectionSearchDataList[i]];
            }
            else
            {
                //没有找到
            }
        }
        [self.translateTabelView reloadData];
    }
    else
    {
        NSString *searchString = [self.searchCon.searchBar text];
        
        if (self.searchList!= nil)
        {
            [self.searchList removeAllObjects];
        }
        for(int i = 0 ; i < self.freeWalkerSearchDataList.count ; i ++)
        {
            //            CollectionModel *model = self.freeWalkerSearchDataList[i];
            NSString *message = self.freeWalkerSearchDataList[i][@"Information"];
            NSRange range = [message rangeOfString:searchString];
            if(range.location != NSNotFound)
            {
                [self.searchList addObject:self.freeWalkerSearchDataList[i]];
            }
            else
            {
                //没有找到
            }
        }
        [self.translateTabelView reloadData];
    }
    //刷新表格
    
}
//跳转页面后移除UISearchController  否则UISearchController 依然存在
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.searchCon.active)
    {
        self.searchCon.active = NO;
        [self.searchCon.searchBar removeFromSuperview];
    }
}
#pragma mark - loadCollectionSearchDataList
-(NSMutableArray *)loadCollectionSearchDataList
{
    if (!_collectionSearchDataList)
    {
        _collectionSearchDataList = [NSMutableArray array];
        for(int i = 0 ; i < self.collectionArray.count ; i ++)
        {
            if([self.collectionArray[i][@"Type"] isEqualToString:@"text"])
            {
                NSDictionary *searchDic = @{@"UserImage":self.collectionArray[i][@"UserImage"],
                                            @"UserName":self.collectionArray[i][@"UserName"],
                                            @"Time":self.collectionArray[i][@"Time"],
                                            @"Message":self.collectionArray[i][@"Message"],
                                            @"Type":self.collectionArray[i][@"Type"],
                                            @"FirstTranslate":self.collectionArray[i][@"FirstTranslate"],
                                            @"SecondTranslate":self.collectionArray[i][@"SecondTranslate"]};
                [_collectionSearchDataList addObject:searchDic];
            }
        }
    }
    return _collectionSearchDataList;
}
-(NSMutableArray *)loadFreeWalkerSearchDataList
{
    if(!_freeWalkerSearchDataList)
    {
        _freeWalkerSearchDataList = [NSMutableArray array];
        for(int i = 0 ; i < self.freeWalkerArray.count ; i ++)
        {
            NSDictionary *searchDict = @{@"ID":self.freeWalkerArray[i][@"ID"],
                                         @"WalkerTime":self.freeWalkerArray[i][@"WalkerTime"],
                                         @"Information":self.freeWalkerArray[i][@"Information"]};
            [_freeWalkerSearchDataList addObject:searchDict];
        }
    }
    return _freeWalkerSearchDataList;
}

//-(UISearchBar *)searchBar
//{
//    if(!_searchBar)
//    {
//        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, _segmented.frame.origin.y + 50, [UIScreen mainScreen].bounds.size.width, 40)];
//        _searchBar.placeholder = @"搜索";
//        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
//        _searchDisplayController.delegate = self;
//        _searchDisplayController.searchResultsDataSource = self;
////        [_searchBar resignFirstResponder];//失去第一焦点
////        _searchDisplayController.searchResultsDataSource = self;
//    }
//    return _searchBar;
//}
#pragma mark - segmentedClick
-(void)segmentedClick:(id)sender
{
    if(self.segmented.selectedSegmentIndex == 0)
    {
        self.marked = @"collection";
        [self.view addSubview:self.translateTabelView];
        [self.translateTabelView reloadData];
    }
    else
    {
        self.marked = @"freewalker";
        [self.view addSubview:self.translateTabelView];
        [self.translateTabelView reloadData];
    }
    
}
#pragma mark - loadData
-(NSArray *)loadCollectionData
{
    NSDictionary *dict1 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"阿斯顿飞111",
                            @"Time":@"今天",
                            @"Type":@"text",
                            @"Message":@"天发的更好的法国和德国法国和德国法国和德国法国和德国哦哦哦哦哦哦哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",
                            @"FirstTranslate":@"de guo and fa guo    de guo and fa guo de guo and fa guo    de guo and fa guo",
                            @"SecondTranslate":@"天发的更好的法国和德国法国和德国法国和德国法国和德国哦哦哦哦哦哦哈哈哈哈啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"};
    NSDictionary *dict2 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"阿狸",
                            @"Time":@"前天",
                            @"Type":@"audio",
                            @"AudioTime":@"5秒",
                            @"FirstTranslate":@"we are family we are family   realy?? ",
                            @"SecondTranslate":@"我们心有灵犀 不是吗"};
    NSDictionary *dict3 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"瑞雯",
                            @"Time":@"7天前",
                            @"Type":@"audio",
                            @"AudioTime":@"7秒",
                            @"FirstTranslate":@"duan jian chong zhu zhi ri  qi shi gui lai zhi shi ",
                            @"SecondTranslate":@"断剑重铸之日 骑士归来之时"};
    NSDictionary *dict4 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"伊泽瑞尔",
                            @"Time":@"2016/06/07",
                            @"Type":@"text",
                            @"Message":@"在其他游戏里 像我这么帅的  一般都是主角哦",
                            @"FirstTranslate":@"I am zhujue in other games",
                            @"SecondTranslate":@"在其他游戏里 像我这么帅的  一般都是主角哦"};
    NSDictionary *dict5 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"锤石",
                            @"Time":@"2016/06/01",
                            @"Type":@"text",
                            @"Message":@"这儿是生 这儿是死 然后这儿 是我",
                            @"FirstTranslate":@"this is sheng  this is die  there is mine",
                            @"SecondTranslate":@"这儿是生 这儿是死 然后这儿 是我"};
    NSDictionary *dict6 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"崔斯特",
                            @"Time":@"2016/05/07",
                            @"Type":@"text",
                            @"Message":@"胜利女神在微笑哈",
                            @"FirstTranslate":@"my girl is smiling ha",
                            @"SecondTranslate":@"胜利女神在微笑哈"};
    NSDictionary *dict7 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"弗雷尔卓德之心",
                            @"Time":@"2016/05/01",
                            @"Type":@"text",
                            @"Message":@"心脏时最强壮的肌肉",
                            @"FirstTranslate":@"my girl is smiling ha",
                            @"SecondTranslate":@"心脏时最强壮的肌肉"};
    NSDictionary *dict8 = @{@"UserImage":@"weizhi.jpg",
                            @"UserName":@"唤潮跤姬",
                            @"Time":@"2016/04/07",
                            @"Type":@"text",
                            @"Message":@"我的命运有我做主",
                            @"FirstTranslate":@"my girl is smiling ha",
                            @"SecondTranslate":@"我的命运有我做主"};
    self.collectionArray = @[dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8];
    return self.collectionArray;
}
-(NSArray *)loadFreeWalkerData
{
    
    NSDictionary *dict1 = @{@"ID":@"12341234",
                            @"Information":@"<贵州黄果树瀑布1日游>天津出发",
                            @"WalkerTime":@"今天"};
    NSDictionary *dict2 = @{@"ID":@"12341234",
                            @"Information":@"<北京天安门1日游>天津出发",
                            @"WalkerTime":@"5天前"};
    NSDictionary *dict3 = @{@"ID":@"12341234",
                            @"Information":@"<四川乐山大佛1日游>天津出发",
                            @"WalkerTime":@"一个月前"};
    NSDictionary *dict4 = @{@"ID":@"12341234",
                            @"Information":@"<蒙古大草原1日游>天津出发",
                            @"WalkerTime":@"2016/05/20"};
    NSDictionary *dict5 = @{@"ID":@"12341234",
                            @"Information":@"<撒哈拉大沙漠1年游>天津出发",
                            @"WalkerTime":@"2016/03/03"};
    NSDictionary *dict6 = @{@"ID":@"12341234",
                            @"Information":@"<埃及金字塔里边1日游>天津出发",
                            @"WalkerTime":@"2015/08/03"};
    NSDictionary *dict7 = @{@"ID":@"12341234",
                            @"Information":@"<太平洋10000米深1日游>天津出发",
                            @"WalkerTime":@"2014/08/08"};
    NSDictionary *dict8 = @{@"ID":@"12341234",
                            @"Information":@"<北极冰原10日游>天津出发",
                            @"WalkerTime":@"2014/07/09"};
    
    self.freeWalkerArray = @[dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8];
    return self.freeWalkerArray;
}
#pragma mark - UITableView
-(UITableView *)translateTabelView
{
    if(!_translateTabelView)
    {
        _translateTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, _mainLabel.frame.size.height + 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _translateTabelView.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
        _translateTabelView.delegate = self;
        _translateTabelView.dataSource = self;
        _translateTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//去掉cell的白线
    }
    return _translateTabelView;
}
//cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.marked isEqualToString:@"collection"])
    {
        if(self.searchCon.active)
        {
            //将cancel按钮  改为  取消
            _searchCon.searchBar.showsCancelButton = YES;
            UIButton *cancel = [_searchCon.searchBar valueForKey:@"cancelButton"];
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            //点击搜索框时cell的行数
            return self.searchList.count;
        }
        else
        {
            return self.collectionArray.count;
        }
    }
    else
    {
        if(self.searchCon.active)
        {
            //将cancel按钮  改为  取消
            _searchCon.searchBar.showsCancelButton = YES;
            UIButton *cancel = [_searchCon.searchBar valueForKey:@"cancelButton"];
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            //点击搜索框时cell的行数
            return self.searchList.count;
        }
        return self.freeWalkerArray.count;
    }
}
//cell样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.marked isEqualToString:@"collection"]) {
        if(self.searchCon.active)
        {
            static NSString *cellIdentifier = @"cellIdentifier";
            CollectionMessageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil)
            {
                cell = [[NSBundle mainBundle]loadNibNamed:@"CollectionMessageInfoCell" owner:nil options:nil].lastObject;
            }
            CollectionCellFrameInfo *collectionFrameInfo = [[CollectionCellFrameInfo alloc]initWithCollectionModel:self.searchList[indexPath.row]];
            [cell setCellData:self.searchList[indexPath.row] collectionFrameInfo:collectionFrameInfo];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, collectionFrameInfo.cellHeight, [UIScreen mainScreen].bounds.size.width, 10)];
            label.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            //文字cell
            NSDictionary *dict = self.collectionArray[indexPath.row];
            if ([dict[@"Type"] isEqualToString:@"text"]) {
                static NSString *cellIdentifier = @"cellIdentifier";
                CollectionMessageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(cell == nil)
                {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"CollectionMessageInfoCell" owner:nil options:nil].lastObject;
                }
                CollectionCellFrameInfo *collectionFrameInfo = [[CollectionCellFrameInfo alloc]initWithCollectionModel:dict];
                [cell setCellData:dict collectionFrameInfo:collectionFrameInfo];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, collectionFrameInfo.cellHeight, [UIScreen mainScreen].bounds.size.width, 10)];
                label.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
                [cell addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                //语音cell
                static NSString *cellID = @"CollectionAudioInfoCell";
                CollectionAudioInfoCell *cell = nil;
                cell = [self.translateTabelView dequeueReusableCellWithIdentifier:cellID];
                if(!cell){
                    cell = [[CollectionAudioInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.userImage.image = [UIImage imageNamed:dict[@"UserImage"]];
                cell.userNameLabel.text = dict[@"UserName"];
                cell.collectionTimeLabel.text = dict[@"Time"];
                //            cell.audioImage.image = [UIImage imageNamed:dict[@"AudioImage"]];
                cell.audioTimeLabel.text = dict[@"AudioTime"];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 10)];
                label.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
                [cell addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else
    {
        if(self.searchCon.active)
        {
            NSDictionary *dict = self.searchList[indexPath.row];
            //            CollectionModel *model = self.searchList[indexPath.row];
            static NSString *cellID = @"FreeWalkerInfoCell";
            FreeWalkerInfoCell *cell = nil;
            cell = [self.translateTabelView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[FreeWalkerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSString *text = @"自由行编号:";
            cell.numberLabel.text = [NSString stringWithFormat:@"%@%@",text,dict[@"ID"]];//字符串拼接
            cell.walkerTimeLabel.text = dict[@"WalkerTime"];
            cell.informationLabel.text = dict[@"Information"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 8)];
            label.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NSDictionary *dict = self.freeWalkerArray[indexPath.row];
            //            CollectionModel *model = self.freeWalkerArray[indexPath.row];
            static NSString *cellID = @"FreeWalkerInfoCell";
            FreeWalkerInfoCell *cell = nil;
            cell = [self.translateTabelView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[FreeWalkerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSString *text = @"自由行编号:";
            cell.numberLabel.text = [NSString stringWithFormat:@"%@%@",text,dict[@"ID"]];//字符串拼接
            cell.walkerTimeLabel.text = dict[@"WalkerTime"];
            cell.informationLabel.text = dict[@"Information"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 8)];
            label.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.marked isEqualToString:@"collection"])
    {
        if(self.searchCon.active)
        {
            NSDictionary *dict = self.collectionSearchDataList[indexPath.row];
            CollectionCellFrameInfo *frameInfo = [[CollectionCellFrameInfo alloc]initWithCollectionModel:dict];
            return frameInfo.cellHeight + 10;
        }
        else
        {
            NSDictionary *dict = self.collectionArray[indexPath.row];
            if([dict[@"Type"] isEqualToString:@"text"])
            {
                CollectionCellFrameInfo *frameInfo = [[CollectionCellFrameInfo alloc]initWithCollectionModel:dict];
                return frameInfo.cellHeight + 10;
            }
            else
            {
                return 160;
            }
        }
    }
    else
    {
        return 108;
    }
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.marked isEqualToString:@"collection"])
    {
        if(self.searchCon.active)
        {
            NSDictionary *dict = self.searchList[indexPath.row];
            DetailsView *detail = [[DetailsView alloc]init];
            detail.detailsDictionary = dict;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else
        {
            NSDictionary *dict = self.collectionArray[indexPath.row];
            DetailsView *detail = [[DetailsView alloc]init];
            detail.detailsDictionary = dict;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
