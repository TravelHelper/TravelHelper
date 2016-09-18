//
//  YBZalertView.m
//  YBZTravel
//
//  Created by 刘芮东 on 16/9/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZtoalertView.h"
#import "WebAgent.h"
#import "MBProgressHUD+XMG.h"

@interface YBZtoalertView ()<UITableViewDelegate,UITableViewDataSource>


    
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView    *alertTableView;
@property (nonatomic, strong) UILabel        *alertLabel;
@property (nonatomic, strong) UIButton       *refuseBtn;
@property (nonatomic, strong) UIView         *alertNeedView;
@property (nonatomic,strong) UIView             *hubView;


@end


@implementation YBZtoalertView{

    int needIndex;
}

- (instancetype)initWithFrame:(CGRect)frame andModel:(YBZtoAlertModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        needIndex=0;
        self.backgroundColor=[UIColor whiteColor];
        self.dataSource=[NSMutableArray array];
        [self.dataSource addObject:model];
        self.alertTableView.frame=CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height-120);
        self.refuseBtn.frame=CGRectMake(self.bounds.size.width/2-50,self.bounds.size.height-50 , 100, 35);
        [self addSubview:self.refuseBtn];
        [self addSubview:self.alertLabel];
        [self addSubview:self.alertTableView];
    }
    return self;
}

//- (instancetype)initWithModel:(YBZtoAlertModel *)model
//{
//    self = [super init];
//    if (self) {
//        self.dataSource=[NSMutableArray array];
//        [self.dataSource addObject:model];
//        [self addSubview:self.alertTableView];
//    }
//    return self;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (self.bounds.size.height-150)/4;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    YBZtoAlertModel *model=self.dataSource[indexPath.row];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.bounds.size.height-10,cell.bounds.size.height-10)];
    
//    imgView.image=[UIImage imageNamed:@"backgroundImage"];
    
    NSString *str=[NSString stringWithFormat:@"%@.jpg",model.yonghuID];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/TravelHelper/uploadimg/%@",serviseId,str];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage *img=[UIImage imageWithData:data];
    
    if(img){
        [imgView setImage:img];
    }else{
        [imgView setImage:[UIImage imageNamed:@"head"]];
    }
    [cell addSubview:imgView];
    
    UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.height+5, 5, cell.bounds.size.height*1.5, cell.bounds.size.height)];
    
//    namelabel.backgroundColor=[UIColor redColor];
    
    [WebAgent userGetInfo:model.yonghuID success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *user_name=dic[@"user_name"];
        
        namelabel.text=user_name;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取用户数据失败,请检查网络"];
    }];
    
    [cell addSubview:namelabel];
    
    UILabel *languageLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-cell.bounds.size.height*1.5, 5, cell.bounds.size.height*1.5, cell.bounds.size.height)];
//    languageLabel.backgroundColor=[UIColor redColor];
    
    languageLabel.text=model.language_catgory;
    
    [cell addSubview:languageLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSLog(@"%ld",(long)indexPath.row);
    YBZtoAlertModel *model=self.dataSource[indexPath.row];
    NSLog(@"%@",model.yonghuID);
    needIndex=(int)indexPath.row;
    [self addSubview:self.hubView];
    [self addSubview:self.alertNeedView];

    

}

-(UITableView *)alertTableView{

    if(!_alertTableView){
    
        _alertTableView=[[UITableView alloc]init];
//        _alertTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        _alertTableView.allowsSelection = NO;
        _alertTableView.dataSource=self;
        _alertTableView.delegate=self;
        _alertTableView.showsVerticalScrollIndicator = NO;
        _alertTableView.contentInset = UIEdgeInsetsMake(12,0, 0, 0);
//        _alertTableView.tableFooterView = [[UIView alloc]init];
//        _alertTableView.showsVerticalScrollIndicator = NO;
//        [_alertTableView setHidden:YES];
    
    }

    return _alertTableView;
}
-(UILabel *)alertLabel{

    if(!_alertLabel){
    
        _alertLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-100,0, 200, 50)];
        _alertLabel.textAlignment=NSTextAlignmentCenter;
        _alertLabel.text=@"收到翻译请求列表";
    }

    return _alertLabel;

}
-(UIButton *)refuseBtn
{
    if(!_refuseBtn){
        _refuseBtn=[[UIButton alloc]init];
        [_refuseBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_refuseBtn setTitle:@"拒 绝" forState:UIControlStateNormal];
//        _refuseBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _refuseBtn.backgroundColor=[UIColor redColor];
        _refuseBtn.layer.masksToBounds=YES;
        _refuseBtn.layer.cornerRadius=0.03*SCREEN_WIDTH;
        [_refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _refuseBtn;
}
-(void)backBtnClick{

    NSLog(@"返回");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textForView" object:nil];

//    [self removeFromSuperview];
//    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
//    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
//    YBZtoAlertModel *model=[[YBZtoAlertModel alloc]init];
//    model.translatorID=user_id[@"user_id"];
//    model.yonghuID=user_id[@"user_id"];
//    model.language_catgory=@"美语";
//    [self addModel:model];
}

-(void)addModel:(YBZtoAlertModel *)model{

    [self.dataSource addObject:model];
    [self.alertTableView reloadData];
}



-(UIView *)alertNeedView{
    
    if(!_alertNeedView){
        
        _alertNeedView=[[UIView alloc]init];
        CGSize needSize;
        needSize.height=SCREEN_HEIGHT;
        needSize.width=SCREEN_WIDTH;
        _alertNeedView.frame=CGRectMake(needSize.width/2-100-SCREEN_WIDTH/2+112, needSize.height/2-80-SCREEN_HEIGHT/2+170, 200, 100);
        //        _alertNeedView.center=self.view.center;
        _alertNeedView.layer.masksToBounds = YES;
        _alertNeedView.layer.cornerRadius = 10;
        _alertNeedView.backgroundColor=[UIColor whiteColor];
        
        UIView *scorlView=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 200, 1)];
        scorlView.backgroundColor=[UIColor grayColor];
        scorlView.alpha=0.2f;
        
        [self.alertNeedView addSubview:scorlView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, 2, 120, 50)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=@"是否接单？";
        
        titleLabel.textColor=[UIColor blackColor];
        [self.alertNeedView addSubview:titleLabel];
        UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 55, 80, 50)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.alertNeedView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 55, 80, 50)];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.alertNeedView addSubview:confirmBtn];
        
        [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *scorlView2=[[UIView alloc]initWithFrame:CGRectMake(100, 60, 1, 40)];
        scorlView2.backgroundColor=[UIColor grayColor];
        scorlView2.alpha=0.2f;
        
        [self.alertNeedView addSubview:scorlView2];
        
        
    }
    
    return _alertNeedView;
    
}
-(void)cancelClick{
    [self.hubView removeFromSuperview];
    [self.alertNeedView removeFromSuperview];

}
-(void)confirmClick{
    [self.hubView removeFromSuperview];
    [self.alertNeedView removeFromSuperview];
    [MBProgressHUD showSuccess:@"匹配中,请等待"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"textForView" object:nil];
    YBZtoAlertModel *model=self.dataSource[needIndex];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"recieveARemoteRequire" object:@{@"yonghuID":model.yonghuID,@"language_catgory":model.language_catgory,@"pay_number":model.pay_number,@"messionID":model.messionID}];
}
-(void)hideLoginView{


}

-(UIView *)hubView{
    if (!_hubView){
        _hubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _hubView.backgroundColor = [UIColor blackColor];
        _hubView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLoginView)];
        [_hubView addGestureRecognizer:tap];
    }
    return _hubView;
}


@end
