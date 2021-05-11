//
//  UIView+Border.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/3.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Border)

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

-(void)setBorderWithTop:(BOOL)top
                   Left:(BOOL)left
                 Bottom:(BOOL)bottom
                  Right:(BOOL)right
            BorderColor:(UIColor *)borderColor
            BorderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
