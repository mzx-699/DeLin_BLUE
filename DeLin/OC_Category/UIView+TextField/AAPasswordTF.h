//
//  AATextField.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/3.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAPasswordTF : UIView <UITextFieldDelegate>

@property (nonatomic,strong) NSString *PlaceholderText;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *labelView;

@property (nonatomic,assign) CGRect passwordTFFrame;

@property (nonatomic,strong) UITextField *inputText;

@property (nonatomic, strong) UIButton *eyespasswordBtn;

-(instancetype)initWithFrame:(CGRect)frame withPlaceholderText:(NSString *)placeText;

-(void)passwordTFBeginEditing;

-(void)passwordTFEndEditing;

@end

NS_ASSUME_NONNULL_END
