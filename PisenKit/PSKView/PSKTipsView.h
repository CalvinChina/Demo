//
//  PSKTipsView.h
//  PisenKit
//
//  Created by 杨胜超 on 16/7/1.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKTipsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

#pragma mark - create
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView;
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView
                           buttonAction:(PSKBlock)buttonAction;
+ (instancetype)createPSKTipsViewOnView:(UIView *)contentView
                             edgeInsets:(UIEdgeInsets)edgeInsets
                            withMessage:(NSString *)message
                              imageName:(NSString *)imageName
                            buttonTitle:(NSString *)buttonTitle
                           buttonAction:(PSKBlock)buttonAction;

#pragma mark - reset
- (void)resetFrameWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)resetMessage:(NSString *)message;
- (void)resetImageName:(NSString *)imageName;
- (void)resetActionWithButtonTitle:(NSString *)buttonTitle
                      buttonAction:(PSKBlock)buttonAction;
@end
