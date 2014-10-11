//
//  NormalStyleViewController.m
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "NormalStyleViewController.h"
#import "UIScrollView+DXRefresh.h"

@interface NormalStyleViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int _idx;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation NormalStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.images = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Header" style:UIBarButtonItemStylePlain target:self action:@selector(handUpdateH)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Footer" style:UIBarButtonItemStylePlain target:self action:@selector(handUpdateF)];

    
    [self.tableView addHeaderWithTarget:self action:@selector(refreshHeader)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshFooter)];
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
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    });
}

- (void)refreshFooter
{
    [self updateSomeThing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        
        if (self.images.count > 100) {
            [self.tableView removeFooter];
        }
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
    cell.textLabel.text = self.images[indexPath.row];
    return cell;
}

@end
