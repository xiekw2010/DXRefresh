//
//  GifStyleViewController.m
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "GifStyleViewController.h"
#import "UIScrollView+DXRefresh.h"
#import "NormalStyleViewController.h"

@interface GifStyleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GifStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView removeFromSuperview];
    
    self.title = @"CollectionView";
    
    CGFloat allFlowWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 171 : 70;
    CGFloat itemSpacing = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 7 : 5);
    CGFloat lineSpacing = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10 : 5;

    
    UICollectionViewFlowLayout *allFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    allFlowLayout.itemSize = CGSizeMake(allFlowWidth, allFlowWidth);
    allFlowLayout.minimumInteritemSpacing = itemSpacing;
    allFlowLayout.sectionInset = UIEdgeInsetsMake( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30 : 5, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 27 : 12, 15,  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 27 : 12);
    allFlowLayout.minimumLineSpacing = lineSpacing;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:allFlowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    
    __weak typeof(self)weakSelf = self;
    [self.collectionView addHeaderWithBlock:^{
        [weakSelf refreshHeader];
    }];
    
    [self.collectionView addFooterWithBlock:^{
        [weakSelf refreshFooter];
    }];

}

- (void)handUpdateH
{
    [self.collectionView headerBeginRefreshing];
    [self refreshHeader];
}

- (void)handUpdateF
{
    [self.collectionView footerBeginRefreshing];
    [self refreshFooter];
}


- (void)refreshHeader
{
    [self updateSomeThing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    });
}

- (void)refreshFooter
{
    [self updateSomeThing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
    });
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NormalStyleViewController *normal = [NormalStyleViewController new];
    normal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:normal animated:YES];
}

@end
