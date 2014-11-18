//
//  NormalStyleViewController.m
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "NormalStyleViewController.h"
#import "UIScrollView+DXRefresh.h"
#import "GifStyleViewController.h"

@interface NormalStyleViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int _idx;
}


@end

@implementation NormalStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"TableView";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.images = [NSMutableArray array];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Header" style:UIBarButtonItemStylePlain target:self action:@selector(handUpdateH)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Footer" style:UIBarButtonItemStylePlain target:self action:@selector(handUpdateF)];

    
    [self.tableView addHeaderWithTarget:self action:@selector(refreshHeader)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshFooter)];
    [self updateSomeThing];
    
}

- (void)updateSomeThing
{
    for (int i = 0; i < 50; i ++) {
        _idx ++;
        NSString *ds = [NSString stringWithFormat:@"currentIndex is %d", _idx];
        [self.images addObject:ds];
    }
}

- (void)handUpdateH
{
    [self.tableView headerBeginRefreshing];
    [self refreshHeader];
}

- (void)handUpdateF
{
    [self.tableView footerBeginRefreshing];
    [self refreshFooter];
}


- (void)refreshHeader
{
    [self updateSomeThing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

- (void)refreshFooter
{
    [self updateSomeThing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.images[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor cyanColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GifStyleViewController *gift = [GifStyleViewController new];
    gift.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gift animated:YES];
}

@end
