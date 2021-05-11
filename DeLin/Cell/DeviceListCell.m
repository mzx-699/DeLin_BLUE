//
//  LandroidListCell.m
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        if (!_deviceImage) {
            _deviceImage = [[UIImageView alloc] init];
            [self.contentView addSubview:_deviceImage];
            [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(90.f), yAutoFit(50.f)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(40.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_deviceListLabel) {
            _deviceListLabel = [[UILabel alloc] init];
            _deviceListLabel.font = [UIFont systemFontOfSize:20.f];
            _deviceListLabel.backgroundColor = [UIColor clearColor];
            _deviceListLabel.textColor = [UIColor whiteColor];
            _deviceListLabel.adjustsFontSizeToFitWidth = YES;
            _deviceListLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_deviceListLabel];
            [_deviceListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(30)));
                make.left.equalTo(self.deviceImage.mas_right).offset(yAutoFit(30));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }

    }
    return self;
}

//重写frame 自定义Cell之间的间距
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
