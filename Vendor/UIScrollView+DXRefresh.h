//
//  UIScrollView+DXRefresh.h
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DXRefresh)

- (void)addHeaderWithTarget:(id)target action:(SEL)action withIndicatorColor:(UIColor *)color;
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

- (void)addHeaderWithBlock:(dispatch_block_t)block withIndicatorColor:(UIColor *)color;
- (void)addHeaderWithBlock:(dispatch_block_t)block;

- (void)headerBeginRefreshing;

- (void)headerEndRefreshing;

- (BOOL)isHeaderRefreshing;


/**
 *  iOS 7 RefreshControl have some bugs, this is a solution for the situation when pull half of it, and then switch tabs or press iPhone home button and then back to screen
 
    You should use it in these two situation:
 
 1.
 - (void)viewDidAppear:(BOOL)animated
 {
     [super viewDidAppear:animated];
     [self.tableView relaxHeader];
 }
 
 2.
 - (void)viewDidLoad
 {
    ...
 
    // end of this
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(relaxHeader) name:UIApplicationDidBecomeActiveNotification object:nil];
 }
 
 - (void)dealloc
 {
     [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:UIApplicationDidBecomeActiveNotification object:nil];
 }
 
 You must imp these two methods
 
 */
- (void)relaxHeader;


- (void)removeHeader;

- (void)addFooterWithTarget:(id)target action:(SEL)action withIndicatorColor:(UIColor *)color;
- (void)addFooterWithTarget:(id)target action:(SEL)action;

- (void)addFooterWithBlock:(dispatch_block_t)block withIndicatorColor:(UIColor *)color;
- (void)addFooterWithBlock:(dispatch_block_t)block;

/**
 *  Trigger footer target's action
 *
 *  @param scroll If YES, then it will jump to the footer position of the scrollview
 */
- (void)footerBeginRefreshingScrollToFooter:(BOOL)scroll;

/**
 *  Same as footerBeginRefreshingScrollToFooter:NO
 */
- (void)footerBeginRefreshing;

- (void)footerEndRefreshing;

- (BOOL)isFooterRefreshing;

- (void)removeFooter;



@end
