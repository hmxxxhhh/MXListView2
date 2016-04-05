//
//  ViewController.m
//  MXListView2
//
//  Created by IOS_HMX on 16/4/5.
//  Copyright © 2016年 humingxing. All rights reserved.
//

#import "ViewController.h"
#import "MXListView.h"
#import "MJRefresh.h"
@interface ViewController ()<MXListViewDataSource,MXListViewDelegate>
@property(nonatomic,strong)MXListView *listView;
@end

@implementation ViewController
+(void)initialize
{
    [[MXListView appearance]setSeparatorColor:[UIColor whiteColor]];
    [[MXListView appearance]setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _listView = [[MXListView  alloc]initWithFrame:self.view.frame];
    _listView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _listView.dataSource = self;
    _listView.delegate = self;
    //_listView.selectionStyle = MXListViewSelectionStyleNone;
    
    _listView.selectionColor = [UIColor greenColor];
    [self.view addSubview:_listView];
    
    
    _listView.contentScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_listView.contentScrollView.mj_header endRefreshing];
        });
    }];
    _listView.contentScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_listView.contentScrollView.mj_footer endRefreshing];
        });
    }];
    
}
#pragma delegate
-(void)listView:(MXListView *)listView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"section:%ld\nrow:%ld",indexPath.section,indexPath.row] delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:nil, nil];
    [alert show];
}
-(CGFloat)listView:(MXListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)listView:(MXListView *)listView widthForCulumnAtIndex:(NSInteger)index
{
    return 60.;
}
-(CGFloat)listView:(MXListView *)listView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)listView:(MXListView *)listView reuseViewForHeader:(UIView *)reuseView inSection:(NSInteger)section inColumn:(NSInteger)inColumn
{
    NSArray *arr = @[@"aa",@"bb",@"cc",@"dd",@"ee",@"ff"];
    if (!reuseView) {
        reuseView = [[UILabel alloc]init];
    }
    
    ((UILabel *)reuseView).text = arr[section];
    
    ((UILabel *)reuseView).textColor = [UIColor whiteColor];
    ((UILabel *)reuseView).textAlignment = NSTextAlignmentRight;
    reuseView.backgroundColor = [UIColor grayColor];
    return reuseView;
}

#pragma dataSource
-(NSInteger)numberOfSectionsInListView:(MXListView *)listView
{
    return 6;
}
-(NSInteger)listView:(MXListView *)listView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(NSInteger)numberOfColumnsEachRowInListView:(MXListView *)listView
{
    return 9;
}
-(UIView *)listView:(MXListView *)listView reuseView:(UIView *)reuseView indexPath:(NSIndexPath *)indexPath inColumn:(NSInteger)inColumn
{
    if (reuseView==nil) {
        reuseView = [[UILabel alloc]init];
        
    }
    if (inColumn == 0) {
        ((UILabel *)reuseView).backgroundColor = [UIColor redColor];
    }else
    {
        ((UILabel *)reuseView).backgroundColor = [UIColor clearColor];
    }
    ((UILabel *)reuseView).text = [NSString stringWithFormat:@"%ld",indexPath.section + inColumn];
    ((UILabel *)reuseView).textColor = [UIColor whiteColor];
    ((UILabel *)reuseView).textAlignment = NSTextAlignmentRight;
    return reuseView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

