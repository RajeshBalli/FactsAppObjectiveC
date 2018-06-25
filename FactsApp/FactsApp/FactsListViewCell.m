//
//  FactsListViewCell.m
//  FactsApp
//
//  Created by cts on 25/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

#import "FactsListViewCell.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, FactsListViewCellConstants) {

  // Constants to setup constraints between subviews
  FactsListViewCellConstraintTitleLabelTopOffset = 10,
  FactsListViewCellConstraintLeftOffset = 20,
  FactsListViewCellConstraintRightOffset = -20,
  FactsListViewCellConstraintFactsImageViewBottomOffset = -10
};

@interface FactsListViewCell ()
{
  UILabel *_titleLabel;
  UILabel *_descriptionLabel;
  UIImageView *_factsImageView;
}

@end

@implementation FactsListViewCell

@synthesize titleLabel = _titleLabel, descriptionLabel = _descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    [self addSubview:_titleLabel];

    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _descriptionLabel.numberOfLines = 0;  // support multiple lines
    [self addSubview:_descriptionLabel];

    _factsImageView = [[UIImageView alloc] init];
    _factsImageView.clipsToBounds = YES;
    [self addSubview:_factsImageView];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(FactsListViewCellConstraintTitleLabelTopOffset);
      make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
      make.right.equalTo(self).offset(FactsListViewCellConstraintRightOffset);
    }];

    __weak FactsListViewCell *weakSelf = self;

    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      if (weakSelf != nil) {
        make.top.equalTo([weakSelf titleLabel].mas_bottom).offset(1);
        make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
        make.right.equalTo(self).offset(FactsListViewCellConstraintRightOffset);
      }
    }];

    [_factsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      if (weakSelf != nil) {
        make.top.equalTo([weakSelf descriptionLabel].mas_bottom).offset(1);
        make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
        make.bottom.equalTo(self).offset(FactsListViewCellConstraintFactsImageViewBottomOffset);
      }
    }];
  }

  return self;
}

@end
