//
//  FactsRowData.h
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#ifndef FactsRowData_h
#define FactsRowData_h

#import <Foundation/Foundation.h>

@class UIImage;

@interface FactsRowData : NSObject

@property (nonatomic, copy) NSString *factTitle;
@property (nonatomic, copy) NSString *factDescription;
@property (nonatomic, copy) NSString *factImageURL;
@property (nonatomic, strong) UIImage *factImage;

- (id)initWithFactTitle:(NSString *)aTitle
               Description:(NSString *)aDescription
                  ImageURL:(NSString *)anImageURL;

@end

#endif /* FactsRowData_h */
