//
//  AATextField.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/3.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAEmailTextField : UIView <UITextFieldDelegate>

@property (nonatomic,strong) NSString *PlaceholderText;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *labelView;

@property (nonatomic,assign) CGRect emailTFFrame;

@property (nonatomic,strong) UITextField *inputText;

-(instancetype)initWithFrame:(CGRect)frame withIcon:(NSString *)iconName withPlaceholderText:(NSString *)placeText;

-(instancetype)initWithFrame:(CGRect)frame withPlaceholderText:(NSString *)placeText;

-(void)emailTFBeginEditing;

-(void)emailTFEndEditing;

@end

NS_ASSUME_NONNULL_END
