//
//  FactsListViewCell.h
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FactsListViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;
@property (nonatomic, readonly) UIImageView *factsImageView;

@end
