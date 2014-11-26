DXRefresh
=========

Simple style and Simple way to integrate pull down refreshing and drap up refreshing

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

	
###Demo

![gif](demo.gif)

