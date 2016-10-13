//
//  YSCTipsView.h
//  YSCKit
//
//  Created by YangShengchao on 15/4/12.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

@interface YSCKTipsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

+ (instancetype)CreateYSCTipsViewOnView:(UIView *)contentView
                              edgeInsets:(UIEdgeInsets)edgeInsets
                             withMessage:(NSString *)message
                                iconImage:(UIImage *)image
                             buttonTitle:(NSString *)buttonTitle
                            buttonAction:(YSCBlock)buttonAction;

- (void)resetFrameWithEdgeInsets:(UIEdgeInsets)edgeInsets;

@end
