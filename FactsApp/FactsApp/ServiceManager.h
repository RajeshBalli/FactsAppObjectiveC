//
//  ServiceManager.h
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ServiceManager_h
#define ServiceManager_h

#define FACTS_URL_PATH @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

@class FactsRowData;

@interface ServiceManager : NSObject

@property (nonatomic, copy) NSString *factsTitle;
@property (nonatomic, strong) NSMutableArray *factsRowData;

- (void)fetchFactsWithCompletionHandler:(void(^)(void))completionHandler;
- (void)fetchFactsImageForFactsRowData:(FactsRowData *)factData
                 withCompletionHandler:(void(^)(void))completionHandler;

@end

#endif /* ServiceManager_h */
