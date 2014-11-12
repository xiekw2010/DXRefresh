//
//  UIScrollView+DXRefresh.m
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "UIScrollView+DXRefresh.h"
#import <objc/runtime.h>



@protocol DXRefreshView <NSObject>

@required
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;
@optional
+ (CGFloat)standHeight;
+ (CGFloat)standTriggerHeight;

@end

@interface DXRfreshFooter : UIControl<DXRefreshView>

@property (nonatomic, strong) UIActivityIndicatorView *acv;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL observed;

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

+ (CGFloat)standHeight;
+ (CGFloat)standTriggerHeight;

@end

@implementation DXRfreshFooter

- (void)dealloc
{
    if (self.observed) {
        [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
        self.observed = NO;
    }
}

+ (CGFloat)standHeight
{
    return 44.0;
}

+ (CGFloat)standTriggerHeight
{
    return [self standHeight] + 20.0;
}

- (void)beginRefreshing
{
    self.refreshing = YES;
    [self.acv startAnimating];
}

- (BOOL)isRefreshing
{
    return self.acv.isAnimating;
}

- (void)endRefreshing
{
    //wierd handle way, otherwise it will flash the table view when reloaddata
    
    __weak typeof(self)wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        wself.refreshing = NO;
        [wself.acv stopAnimating];
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (wself.superview) {
                UIScrollView *scrollView = (UIScrollView *)wself.superview;
                scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, MAX(0, scrollView.contentInset.bottom - [DXRfreshFooter standHeight]), 0.0f);
            }
        } completion:^(BOOL finished) {
        }];
    });
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.acv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat height = CGRectGetHeight(frame) * 0.8;
        self.acv.frame = CGRectMake((CGRectGetWidth(frame)-height)*0.5, 0, height, height);
        [self addSubview:self.acv];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (self.observed) {
        [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
        self.observed = NO;
    }
    
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.observed = YES;
        [self adjustFrameWithContentSize];
    }
}

- (void)adjustFrameWithContentSize
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat scrollHeight = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom;
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = MAX(contentHeight, scrollHeight);
    self.frame = selfFrame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self adjustFrameWithContentSize];
    } else if ([@"contentOffset" isEqualToString:keyPath]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        if (scrollView.contentOffset.y <= 0) {
            return;
        }
        
        if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+[DXRfreshFooter standTriggerHeight] + scrollView.contentInset.bottom && !self.refreshing) {
            
            [self beginRefreshing];
            
            [UIView animateWithDuration:0.2 delay:0.01 options:UIViewAnimationOptionCurveEaseIn animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, scrollView.contentInset.bottom + [DXRfreshFooter standHeight], 0.0f);
            } completion:^(BOOL finished) {
                
            }];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end


@interface UIScrollView ()

@property (nonatomic, strong) UIControl<DXRefreshView> *header;
@property (nonatomic, strong) UIControl<DXRefreshView> *footer;
@property (nonatomic, weak) id target;

@end

@implementation UIScrollView (DXRefresh)

static char DXRefreshHeaderViewKey;
static char DXRefreshFooterViewKey;
static char DXTarget;


- (void)setHeader:(UIView *)header {
    objc_setAssociatedObject(self, &DXRefreshHeaderViewKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)header {
    return objc_getAssociatedObject(self, &DXRefreshHeaderViewKey);
}

- (void)setFooter:(UIView *)footer {
    objc_setAssociatedObject(self, &DXRefreshFooterViewKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)footer {
    return objc_getAssociatedObject(self, &DXRefreshFooterViewKey);
}

- (void)setTarget:(id)target {
//#warning It should not be retained here, because target retain self, self retain target now
    objc_setAssociatedObject(self, &DXTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)target {
    return objc_getAssociatedObject(self, &DXTarget);
}

- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    if (self.header) {
        return;
    }
    
    self.target = target;
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    self.alwaysBounceVertical = YES;
    self.header = (UIControl<DXRefreshView> *)refresh;
    [self addSubview:self.header];
    [self.header addTarget:self.target action:action forControlEvents:UIControlEventValueChanged];
}

- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

static CGFloat const _kRefreshControlHeight = -64.0;

- (void)headerBeginRefreshing
{
    if ([self.header isKindOfClass:[UIRefreshControl class]]) {
        UIRefreshControl *refresh = (UIRefreshControl *)self.header;
        CGFloat contentOffsetY = _kRefreshControlHeight - self.contentInset.top;
        [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        [refresh beginRefreshing];
    }
}

- (void)headerEndRefreshing
{
    if ([self.header isKindOfClass:[UIRefreshControl class]]) {
        UIRefreshControl *refresh = (UIRefreshControl *)self.header;
        [refresh endRefreshing];
    }
}

- (BOOL)isHeaderRefreshing
{
    if ([self.header isKindOfClass:[UIRefreshControl class]]) {
        UIRefreshControl *refresh = (UIRefreshControl *)self.header;
        return refresh.isRefreshing;
    }
    return NO;
}

- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    if (self.footer) {
        return;
    }
    self.footer = [[DXRfreshFooter alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [DXRfreshFooter standHeight])];
    [self.footer addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.footer];
}

- (void)footerBeginRefreshing
{
    [self footerBeginRefreshingScrollToFooter:NO];
}

- (void)footerBeginRefreshingScrollToFooter:(BOOL)scroll
{
    if (!self.footer) {
        return;
    }
    
    if (scroll) {
        CGFloat upOffset = self.contentSize.height - CGRectGetHeight(self.bounds);
        upOffset = MAX(0, upOffset);
        [self setContentOffset:CGPointMake(0, upOffset + [DXRfreshFooter standTriggerHeight]) animated:YES];
    }
    
    [self.footer beginRefreshing];
}


- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

- (BOOL)isFooterRefreshing
{
    return self.footer.isRefreshing;
}

- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

@end
