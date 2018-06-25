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
  NSMutableDictionary *_imageCache;  // used for image caching
  UIRefreshControl *_refreshDataControl;
}

- (ServiceManager *)serviceManager;
- (UIActivityIndicatorView *)activityIndicator;

@property (nonatomic, strong) NSMutableDictionary *imageCache;

@end

@implementation FactsListViewController

@synthesize imageCache = _imageCache;

- (void)viewDidLoad {

  [super viewDidLoad];

  _imageCache = [[NSMutableDictionary alloc] init];

  _refreshDataControl = [[UIRefreshControl alloc] init];

  _serviceManager = [[ServiceManager alloc] init];

  _activityIndicator = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

  _activityIndicator.center = self.view.center;
  _activityIndicator.color = [UIColor grayColor];

  [self.view addSubview:_activityIndicator];

  [self.tableView registerClass:FactsListViewCell.self
         forCellReuseIdentifier:gFactsTableViewCellUniqueID];

  [_refreshDataControl addTarget:self
                          action:@selector(refreshData)
                forControlEvents:UIControlEventValueChanged];

  self.refreshControl = _refreshDataControl;

  [self fetchFactsDataWithEndRefreshing:NO];
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

- (void)fetchFactsDataWithEndRefreshing:(BOOL)endRefreshing {

  [_activityIndicator startAnimating];

  __weak FactsListViewController *weakSelf = self;

  // Fetch facts json, parse data and cache it in memory
  [_serviceManager fetchFactsWithCompletionHandler:^{
    if (weakSelf != nil) {
      weakSelf.navigationItem.title = [[weakSelf serviceManager] factsTitle];
      [weakSelf.tableView reloadData];

      [[weakSelf activityIndicator] stopAnimating];

      // End table view refresh only during refresh data flow
      if (endRefreshing == YES) {

        [weakSelf.refreshControl endRefreshing];
      }
    }
  }];
}

- (void)refreshData {

  [self.refreshControl beginRefreshing];
  [_serviceManager resetFactsData]; // Reset cached data
  [self fetchFactsDataWithEndRefreshing:YES];
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
  } else {
    factsListViewCell.titleLabel.text = nil;
  }

  if ([factData.factDescription isEqual:[NSNull null]] == false) {
    factsListViewCell.descriptionLabel.text = factData.factDescription;
  } else {
    factsListViewCell.descriptionLabel.text = nil;
  }

  factsListViewCell.factsImageView.image = nil;

  if ([factData.factImageURL isEqual:[NSNull null]] == false) {
    FactsRowData *cachedFactsData = self.imageCache[factData.factImageURL];

    // is image cached? if cached then do not download else download and cache it
    if (cachedFactsData != nil) {
      factsListViewCell.factsImageView.image = cachedFactsData.factImage;
    } else {
      __weak FactsListViewController *weakSelf = self;

      [_serviceManager
       fetchFactsImageForFactsRowData:factData
                withCompletionHandler:^{
                  weakSelf.imageCache[factData.factImageURL] = factData;

                  FactsListViewCell *updateFactsListViewCell;
                  updateFactsListViewCell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];

                  // if cell is visible and image is not set then update the image
                  if (updateFactsListViewCell != nil
                      && updateFactsListViewCell.factsImageView.image == nil) {
                    updateFactsListViewCell.factsImageView.image = factData.factImage;

                    /* setNeedsLayout and layoutIfNeeded are not refreshing the cell
                     so reloading the specific row at that particular index */
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath]
                                              withRowAnimation:UITableViewRowAnimationAutomatic];
                  }
                }];
    }
  }

  return factsListViewCell;
}

@end
