//
//  NormalStyleViewController.h
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalStyleViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *images;

- (void)refreshHeader;
- (void)refreshFooter;
- (void)updateSomeThing;

@end
