//
//  ServiceManager.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "ServiceManager.h"
#import "FactsRowData.h"
#import "AFNetworking.h"

@interface ServiceManager ()
{
  NSString *_factsTitle;
  NSMutableArray *_factsRowData;
}
@end

@implementation ServiceManager

@synthesize factsTitle = _factsTitle, factsRowData = _factsRowData;

- (id) init {

  if (self = [super init]) {
    _factsRowData = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)fetchFactsWithCompletionHandler:(void(^)(void))completionHandler {

  NSURLSessionConfiguration *URLSessionConfiguration = [NSURLSessionConfiguration
                                                        defaultSessionConfiguration];
  AFURLSessionManager *URLSessionManager = [[AFURLSessionManager alloc]
                                            initWithSessionConfiguration:URLSessionConfiguration];

  NSURL *URL = [NSURL URLWithString:FACTS_URL_PATH];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

  URLSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

  NSURLSessionDataTask *dataTask;
  dataTask = [URLSessionManager dataTaskWithRequest:request
                                  completionHandler:^(NSURLResponse *response,
                                                      id responseObject,
                                                      NSError *error) {
    if (error) {
      NSLog(@"Could not get data from URL. Error: %@", error);
    } else {
      // Downlaoded data contains special characters so convert the data into string
      NSString *factsJsonStr = [[NSString alloc] initWithData:responseObject
                                                     encoding:NSISOLatin1StringEncoding];

      // Convert the string into UTF8 encoded data
      if (factsJsonStr != nil) {
        NSData *factsJsonData = [factsJsonStr dataUsingEncoding:NSUTF8StringEncoding];

        if (factsJsonData != nil) {
          NSError *error = nil;

          NSDictionary *factsJsonDictionary = [NSJSONSerialization
                                               JSONObjectWithData:factsJsonData
                                               options:NSJSONReadingMutableLeaves
                                               error:&error];
          if (error) {
            NSLog(@"Parsing JSON data failed. Error: %@", error);
          } else {
            self.factsTitle = factsJsonDictionary[@"title"];

            NSArray *factsRows = factsJsonDictionary[@"rows"];

            for (NSDictionary *factsRow in factsRows) {
              /* if title and description and imageHref are not available then do not process
               that row */
              if (factsRow[@"title"] != [NSNull null]
                || factsRow[@"description"] != [NSNull null]
                || factsRow[@"imageHref"] != [NSNull null])
              {
                FactsRowData *factsRowData = [[FactsRowData alloc]
                                              initWithFactTitle:factsRow[@"title"]
                                              Description:factsRow[@"description"]
                                              ImageURL:factsRow[@"imageHref"]];

                [self.factsRowData addObject:factsRowData];
              }
            }
          }
        }
      }
    }

    completionHandler();
  }];
  [dataTask resume];
}

- (void)fetchFactsImageForFactsRowData:(FactsRowData *)factData
                 withCompletionHandler:(void(^)(void))completionHandler {

  if ([factData.factImageURL isEqual:[NSNull null]] == false) {
    NSURLSessionConfiguration *URLSessionConfiguration = [NSURLSessionConfiguration
                                                          defaultSessionConfiguration];
    AFURLSessionManager *URLSessionManager = [[AFURLSessionManager alloc]
                                              initWithSessionConfiguration:
                                              URLSessionConfiguration];

    NSURL *URL = [NSURL URLWithString:factData.factImageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    URLSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSURLSessionDataTask *dataTask;
    dataTask = [URLSessionManager
                dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *response,
                                    id responseObject,
                                    NSError *error) {
                                      if (error) {
                                        NSLog(@"Could not get image from image URL.. Error: %@"
                                              ,error);
                                      } else {
                                        factData.factImage = [UIImage
                                                              imageWithData:responseObject];
                                      }

                                      completionHandler();
                                    }];
    [dataTask resume];

  } else {
    NSLog(@"Image URL doesn't exist.");
    completionHandler();
  }
}

- (void)resetFactsData {

  self.factsTitle = @"";
  self.factsRowData = [[NSMutableArray alloc] init];
}

@end
