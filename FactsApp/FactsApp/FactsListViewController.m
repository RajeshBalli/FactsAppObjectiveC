//
//  FactsListViewController.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "FactsListViewController.h"
#import "ServiceManager.h"

@interface FactsListViewController ()
{
  ServiceManager *_serviceManager;
  UIActivityIndicatorView *_activityIndicator;
}

- (ServiceManager *)serviceManager;
- (UIActivityIndicatorView *)activityIndicator;

@end

@implementation FactsListViewController

- (void)viewDidLoad {

  [super viewDidLoad];

  _serviceManager = [[ServiceManager alloc] init];

  _activityIndicator = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

  _activityIndicator.center = self.view.center;
  _activityIndicator.color = [UIColor grayColor];

  [self.view addSubview:_activityIndicator];

  [self fetchFactsData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (ServiceManager *)serviceManager {
  return _serviceManager;
}

- (UIActivityIndicatorView *)activityIndicator {
  return _activityIndicator;
}

- (void)fetchFactsData {

  [_activityIndicator startAnimating];

  __weak FactsListViewController *weakSelf = self;

  // Fetch facts json, parse data and cache it in memory
  [_serviceManager fetchFactsWithCompletionHandler:^{
    if (weakSelf != nil) {
      weakSelf.navigationItem.title = [[weakSelf serviceManager] factsTitle];

      [[weakSelf activityIndicator] stopAnimating];
    }
  }];
}

@end
