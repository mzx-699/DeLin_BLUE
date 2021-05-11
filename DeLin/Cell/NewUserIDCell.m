//
//  NewUserIDCell.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/28.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NewUserIDCell.h"

@implementation NewUserIDCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_leftLabel) {
            _leftLabel = [[UILabel alloc] init];
            _leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
            _leftLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
            _leftLabel.textAlignment = NSTextAlignmentLeft;
            _leftLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:_leftLabel];
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(100),yAutoFit(25)));
                make.left.equalTo(self.contentView.mas_left).offset((20.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_rightLabel) {
            _rightLabel = [[UILabel alloc] init];
            _rightLabel.textColor = [UIColor colorWithHexString:@"FF9700"];
            _rightLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
            _rightLabel.textAlignment = NSTextAlignmentRight;
            _rightLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:_rightLabel];
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(100), yAutoFit(25)));
                make.right.equalTo(self.contentView.mas_right).offset(-10.f);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
    }
    return self;
}

@end
