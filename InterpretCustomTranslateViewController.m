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
    
    [self.view addSubview:self.mainTableView];
    
}
#define mark - getters
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    }
    return _mainTableView;
}

-(void)loadDate{
    
    CustomTranslateInfoModel *infoModel1 = [[CustomTranslateInfoModel alloc]init];
    infoModel1.langueKind = @"日语";
    infoModel1.scene = @"语音";
    infoModel1.content = @"体育";
    infoModel1.translateTime = @"2015-08-10  11:00";
    infoModel1.duration = @"1小时" ;
    infoModel1.cellKind = @"0";

    _mArr = [[NSMutableArray alloc]initWithObjects:infoModel1,infoModel1,infoModel1,infoModel1, nil];
}


#pragma mark - 表示图协议

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _mArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    CustomTranslateTableViewCell *cell = [[CustomTranslateTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier contentModel:_mArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.view.bounds.size.width*0.375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
