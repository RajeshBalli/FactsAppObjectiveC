//
//  ServiceManager.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "ServiceManager.h"
#import "FactsRowData.h"

@interface ServiceManager ()
{
  NSString *_factsTitle;
  NSArray *_factsRowData;
}
@end

@implementation ServiceManager

@synthesize factsTitle = _factsTitle, factsRowData = _factsRowData;

- (id) init {

  if (self = [super init]) {
    _factsRowData = [[NSArray alloc] init];
  }

  return self;
}

@end
