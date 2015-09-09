# DXRefresh

[![Version](https://img.shields.io/cocoapods/v/DXRefresh.svg?style=flat)](http://cocoapods.org/pods/DXRefresh)
[![License](https://img.shields.io/cocoapods/l/DXRefresh.svg?style=flat)](http://cocoapods.org/pods/DXRefresh)
[![Platform](https://img.shields.io/cocoapods/p/DXRefresh.svg?style=flat)](http://cocoapods.org/pods/DXRefresh)

Clean style and Simple way to integrate pull down refreshing and drap up refreshing

###Demo

![gif](demo.gif)

###Features

+ Simple style, just UIRefreshControl and UIActivityIndicatorView.
+ Simple Drop in, just import "UIScrollView+DXRefresh.h".
+ Simple api to combine the code, no need to set something `scrollViewDidScroll` or others.

###how to use
	
eg1:
	
    [self.tableView addHeaderWithTarget:self action:@selector(refreshHeader)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshFooter)];
    
	- (void)refreshHeader
	{
	    [someClass ansycFuncWithBlock:^{
	        [self.tableView reloadData];
	        [self.tableView headerEndRefreshing];
    	}];
	}
	
	- (void)refreshFooter
	{
	    [someClass ansycFuncWithBlock:^{
	        [self.tableView reloadData];
	        [self.tableView footerEndRefreshing];
    	}];
	}

	- (void)handStartHeaderRefresh
	{
	    [self.tableView headerBeginRefreshing];
    	[self refreshHeader];
	}
	
eg2:
	
	[self.collectionView addHeaderWithBlock:^{
        [weakSelf refreshHeader];
    }];
    
    [self.collectionView addFooterWithBlock:^{
        [weakSelf refreshFooter];
    }];

###Note

iOS 7 refreshControl has some bugs. Here is the solution for two situations.

The bug:

First, you pull half of it(Header).

Second, switch to other tabs or press the iPhone home.

Finaly, back to the refresh screen. You will see the refreshControl is buggy apperance.

The solution:

1. for switch tab situation
	
		// your ViewController which has add header
		-(void)viewDidAppear:(BOOL)animated
		{
		   [super viewDidAppear:animated];
		   [self.tableView relaxHeader];
		}

2. for back screen and enterforeground
	
		// your ViewController which has add header
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


It's odd, but here is the tempory solution. 



