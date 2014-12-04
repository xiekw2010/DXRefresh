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
