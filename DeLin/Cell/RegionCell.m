//
//  RegionCell.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/29.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "RegionCell.h"

@implementation RegionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_chooseImage) {
            _chooseImage = [[UIImageView alloc] init];
            [self.contentView addSubview:_chooseImage];
            [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(30.f), yAutoFit(30.f)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(30.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_regionLabel) {
            _regionLabel = [[UILabel alloc] init];
            _regionLabel.font = [UIFont systemFontOfSize:16.f];
            _regionLabel.backgroundColor = [UIColor clearColor];
            _regionLabel.textColor = [UIColor whiteColor];
            _regionLabel.adjustsFontSizeToFitWidth = YES;
            _regionLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_regionLabel];
            [_regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(120), yAutoFit(30)));
                make.left.equalTo(self.chooseImage.mas_right).offset(yAutoFit(40));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
    }
    return self;
}

@end
