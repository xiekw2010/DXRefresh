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
- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;

- (void)addFooterWithTarget:(id)target action:(SEL)action;
- (void)footerBeginRefreshing;
- (void)footerEndRefreshing;
- (void)removeFooter;

@end
