//
//  AppDelegate.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "AppDelegate.h"
#import "FactsListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

  FactsListViewController *factsListViewController = [[FactsListViewController alloc] init];

  UINavigationController *navigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:
                                                  factsListViewController];

  self.window.rootViewController = navigationController;
  self.window.backgroundColor = UIColor.whiteColor;
  [self.window makeKeyAndVisible];

  return YES;
}

@end
