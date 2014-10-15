DXRefresh
=========

Simple style and Simple way to integrate pull down refresh and pull up fresh

###Features

+ Simple style, just UIRefreshControl and UIActivityIndicatorView.
+ Simple Drop in, just import "UIScrollView+DXRefresh.h".
+ Simple and easy api to combine the code, no need to set something `scrollViewDidScroll` or others.

###how to use
	
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
	
###Demo

![gif](demo.gif)

