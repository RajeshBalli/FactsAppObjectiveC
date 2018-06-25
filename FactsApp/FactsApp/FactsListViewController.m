//
//  FactsListViewController.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "FactsListViewController.h"
#import "ServiceManager.h"
#import "FactsListViewCell.h"
#import "FactsRowData.h"

NSString * const gFactsTableViewCellUniqueID = @"factsTableViewCell";

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

  [self.tableView registerClass:FactsListViewCell.self
         forCellReuseIdentifier:gFactsTableViewCellUniqueID];

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
      [weakSelf.tableView reloadData];

      [[weakSelf activityIndicator] stopAnimating];
    }
  }];
}

// MARK: TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return _serviceManager.factsRowData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  FactsListViewCell *factsListViewCell = [tableView
                                          dequeueReusableCellWithIdentifier:
                                          gFactsTableViewCellUniqueID];

  factsListViewCell.selectionStyle = UITableViewCellSelectionStyleNone;

  FactsRowData *factData = _serviceManager.factsRowData[indexPath.row];

  if ([factData.factTitle isEqual:[NSNull null]] == false) {
    factsListViewCell.titleLabel.text = factData.factTitle;
  }

  if ([factData.factDescription isEqual:[NSNull null]] == false) {
    factsListViewCell.descriptionLabel.text = factData.factDescription;
  }

  factsListViewCell.factsImageView.image = nil;

  return factsListViewCell;
}

@end
