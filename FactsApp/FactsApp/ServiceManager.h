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

#define FACTS_URL_PATH = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json";

@interface ServiceManager : NSObject

@property (nonatomic, strong) NSString *factsTitle;
@property (nonatomic, strong) NSArray *factsRowData;

@end

#endif /* ServiceManager_h */
