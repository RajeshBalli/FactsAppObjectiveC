//
//  FactsRowData.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "FactsRowData.h"

@interface FactsRowData ()
{
  NSString *_title;
  NSString *_description;
  NSString *_imageURL;
  UIImage *_image;
}

@end

@implementation FactsRowData

@synthesize factTitle = _title, factDescription = _description, factImageURL = _imageURL,
            factImage = _image;

- (id)initWithFactTitle:(NSString *)aTitle
               Description:(NSString *)aDescription
                  ImageURL:(NSString *)anImageURL {

  if (self = [super init]) {
    _title = aTitle;
    _description = aDescription;
    _imageURL = anImageURL;
  }

  return self;
}

@end
