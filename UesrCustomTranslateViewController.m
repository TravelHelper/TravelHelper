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



@interface UesrCustomTranslateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *mainTableView;
@property(nonatomic , strong)NSMutableArray *mArr;

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
    }
    return _mainTableView;
}

-(void)loadDate{
    
    CustomTranslateInfoModel *infoModel1 = [[CustomTranslateInfoModel alloc]initWithlangueKind:@"日语" scene:@"语音" content:@"体育" interper:@"huge" translateTime:@"2015-08-10  11:00" duration:@"1小时" offerMoney:@"50.00" publishTime:@"2015.08.01"  cellKind:@"0"];
    CustomTranslateInfoModel *infoModel2 = [[CustomTranslateInfoModel alloc]initWithlangueKind:@"日语" scene:@"语音" content:@"体育" interper:@"huge" translateTime:@"2015-08-10  11:00" duration:@"1小时" offerMoney:@"50.00" publishTime:@"2015.08.01"  cellKind:@"1"];
    CustomTranslateInfoModel *infoModel3 = [[CustomTranslateInfoModel alloc]initWithlangueKind:@"日语" scene:@"语音" content:@"体育" interper:@"huge" translateTime:@"2015-08-10  11:00" duration:@"1小时" offerMoney:@"50.00" publishTime:@"2015.08.01"  cellKind:@"2"];
    CustomTranslateInfoModel *infoModel4 = [[CustomTranslateInfoModel alloc]initWithlangueKind:@"日语" scene:@"语音" content:@"体育" interper:@"huge" translateTime:@"2015-08-10  11:00" duration:@"1小时" offerMoney:@"50.00" publishTime:@"2015.08.01"  cellKind:@"3"];
    _mArr = [[NSMutableArray alloc]initWithObjects:infoModel1,infoModel2,infoModel3,infoModel4,infoModel1,infoModel2,infoModel3,infoModel4, nil];
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
    CustomTranslateTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    if ([cell.infoModel.cellKind isEqualToString:@"0"]) {
        
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"是否需要删除？" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            [cell removeFromSuperview];
            [_mArr removeObjectAtIndex:indexPath.row];
            [self.mainTableView reloadData];
            
        }];
        

    }else{
            if ([cell.infoModel.cellKind isEqualToString:@"1"]) {
                NSLog(@"----1---1:距离开始时间15分钟内，进入等候页2.大于15弹出提示，“请在开始15分钟内进入等候页”"
                      );
                NSString *str = @"请在开始15分钟内进入等候页";
                CGSize sizeh = [str boundingRectWithSize:CGSizeMake(110, 100) options:NSStringDrawingUsesLineFragmentOrigin    attributes:@{NSFontAttributeName:FONT_14} context:nil].size;
                
                 UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width -  sizeh.width-50) / 2, 250, sizeh.width+50, sizeh.height+50)];
                
                alertLabel.backgroundColor = [UIColor blackColor];
                alertLabel.layer.cornerRadius = 5;
                
                //将UiLabel设置圆角 此句不可少
                alertLabel.layer.masksToBounds = YES;
                alertLabel.alpha = 0.8;
                alertLabel.text = str;
                alertLabel.font = FONT_14;
                [alertLabel setTextAlignment:NSTextAlignmentCenter];
                alertLabel.textColor = [UIColor whiteColor];
                [alertLabel setNumberOfLines:0];
                [self.mainTableView addSubview:alertLabel];
                
                //设置动画
                [UIView animateWithDuration:4 animations:^{
                    alertLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    //将警告Label透明后 在进行删除
                    [alertLabel removeFromSuperview];
                }];
            }else if ([cell.infoModel.cellKind isEqualToString:@"2"]) {
                NSLog(@"---2---点击进入“定制进行页面”");
            }else{
                NSLog(@"----3----点击可以评价进入“订单详情页”");
                YBZOrderDetailsViewController *details = [[YBZOrderDetailsViewController alloc]init];
                [self.navigationController pushViewController:details animated:YES];
                
            }
    }
}

@end
