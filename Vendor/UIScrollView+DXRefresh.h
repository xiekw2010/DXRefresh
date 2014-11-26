//
//  UIScrollView+DXRefresh.h
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DXRefresh)

- (void)addHeaderWithTarget:(id)target action:(SEL)action;
- (void)removeHeader;

- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (BOOL)isHeaderRefreshing;

- (void)addFooterWithTarget:(id)target action:(SEL)action;
- (void)footerBeginRefreshing;
- (void)footerEndRefreshing;
- (BOOL)isFooterRefreshing;

// if scroll==YES, self will scroll to bottom to refresh animated.
- (void)footerBeginRefreshingScrollToFooter:(BOOL)scroll;

// Some times there are no data available, then we remove it.
- (void)removeFooter;


- (void)addHeaderWithBlock:(dispatch_block_t)block;
- (void)addFooterWithBlock:(dispatch_block_t)block;


@end
