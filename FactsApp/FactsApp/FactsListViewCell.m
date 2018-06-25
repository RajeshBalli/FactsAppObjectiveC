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

  // store facts image view width constraint to dynamically change width of the imageview
  MASConstraint *_imageViewWidthConstraints;
}

@property (nonatomic, strong) MASConstraint *imageViewWidthConstraints;

@end

@implementation FactsListViewCell

@synthesize titleLabel = _titleLabel, descriptionLabel = _descriptionLabel,
            imageViewWidthConstraints = _imageViewWidthConstraints;

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
      if (@available(iOS 11.0, *)) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop)
            .offset(FactsListViewCellConstraintTitleLabelTopOffset);
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft)
            .offset(FactsListViewCellConstraintLeftOffset);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight)
            .offset(FactsListViewCellConstraintRightOffset);
      } else {
        make.top.equalTo(self).offset(FactsListViewCellConstraintTitleLabelTopOffset);
        make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
        make.right.equalTo(self).offset(FactsListViewCellConstraintRightOffset);
      }
    }];

    __weak FactsListViewCell *weakSelf = self;

    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      if (weakSelf != nil) {
        make.top.equalTo([weakSelf titleLabel].mas_bottom).offset(1);

        if (@available(iOS 11.0, *)) {
          make.left.equalTo(self.mas_safeAreaLayoutGuideLeft)
              .offset(FactsListViewCellConstraintLeftOffset);
          make.right.equalTo(self.mas_safeAreaLayoutGuideRight)
              .offset(FactsListViewCellConstraintRightOffset);
        } else {
          make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
          make.right.equalTo(self).offset(FactsListViewCellConstraintRightOffset);
        }
      }
    }];

    [_factsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      if (weakSelf != nil) {
        make.top.equalTo([weakSelf descriptionLabel].mas_bottom).offset(1);

        if (@available(iOS 11.0, *)) {
          make.left.equalTo(self.mas_safeAreaLayoutGuideLeft)
              .offset(FactsListViewCellConstraintLeftOffset);
          make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom)
              .offset(FactsListViewCellConstraintFactsImageViewBottomOffset);
        } else {
          make.left.equalTo(self).offset(FactsListViewCellConstraintLeftOffset);
          make.bottom.equalTo(self).offset(FactsListViewCellConstraintFactsImageViewBottomOffset);
        }

        // set the width as default 0 to resize it dynamically
        weakSelf.imageViewWidthConstraints = make.width.lessThanOrEqualTo(@0);
      }
    }];
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  if (_factsImageView.image != nil) {
    CGSize imageSize = _factsImageView.image.size;
    CGFloat imageWidth = imageSize.width;

    // offsetwidth = spacing at left + spacing at right
    CGFloat offsetWidth = FactsListViewCellConstraintLeftOffset
                              - FactsListViewCellConstraintRightOffset;

    // if image extends beyond the cell then resize the image
    if (imageSize.width > (self.bounds.size.width - offsetWidth)) {

      /* get new image size based on aspect ratio of image.
       aspectRatio = (oldWidth / oldHeight).
       newWidth = (newHeight * aspectRatio). */
      imageWidth = _factsImageView.bounds.size.height
                      * ((self.bounds.size.width - offsetWidth)
                         / imageSize.height);
    }

    // update imageview width
    self.imageViewWidthConstraints.offset(imageWidth);
  }
}

@end
