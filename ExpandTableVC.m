//
//  ExpandTableVC.m
//  点击按钮出现下拉列表
//
//  Created by 杜甲 on 14-3-26.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import "ExpandTableVC.h"
#import "ExpandCell.h"


@interface ExpandTableVC ()

@end

@implementation ExpandTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_ContentArr = [NSArray array];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled =NO;
     self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma mark - warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma mark - warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.m_ContentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //[cell setCellContentData:[self.m_ContentArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.m_ContentArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize: 14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate_ExpandTableVC respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
         [_delegate_ExpandTableVC tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end

