//
//  LeftDrawerCell.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/23.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "LeftDrawerCell.h"

@implementation LeftDrawerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置cell的样式
        self.backgroundColor = [UIColor clearColor];
        if (!_listImage) {
            _listImage = [[UIImageView alloc] init];
            [self.contentView addSubview:_listImage];
            [_listImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(30.f), yAutoFit(30.f)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(20.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_listLabel) {
            _listLabel = [[UILabel alloc] init];
            _listLabel.font = [UIFont systemFontOfSize:16.f];
            _listLabel.backgroundColor = [UIColor clearColor];
            _listLabel.textColor = [UIColor whiteColor];
            _listLabel.adjustsFontSizeToFitWidth = YES;
            _listLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_listLabel];
            [_listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(200), yAutoFit(30)));
                make.left.equalTo(self.listImage.mas_right).offset(yAutoFit(10));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
    }
    return self;
}


@end
