//
//  PersonSettingCell.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/9.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "PersonSettingCell.h"

@implementation PersonSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_leftLabel) {
            _leftLabel = [[UILabel alloc] init];
            _leftLabel.font = [UIFont systemFontOfSize:16.f];
            _leftLabel.backgroundColor = [UIColor clearColor];
            _leftLabel.textColor = [UIColor whiteColor];
            _leftLabel.adjustsFontSizeToFitWidth = YES;
            _leftLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_leftLabel];
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(30)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(50));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
    }
    return self;
}

@end
