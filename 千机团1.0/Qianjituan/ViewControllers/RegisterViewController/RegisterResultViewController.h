//
//  RegisterResultViewController.h
//  Qianjituan
//
//  Created by Pisen on 15/12/9.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "QianjituanViewController.h"

#import <UIKit/UIKit.h>


@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end


@interface RegisterResultViewController : UIViewController
{
@private
    UIView* mRegisterStateContainerView;
    
    UIImageView* mRegisterStateImageView;
    
    UILabel* mRegisterStateLabel;
    
    UITextView* mRegisterStateContentTextView;
    
    UIButton* mGoMainPageActionBtn;
    
    UIButton* mRepeatRegisterActionBtn;
    
    //
    UIButton* mBackBtn;
    
    //
    NSTimer* mDelayEnterMainTimer;
}

@property (strong, nonatomic) IBOutlet UIView* mRegisterStateContainerView;

@property (strong, nonatomic) IBOutlet UIImageView* mRegisterStateImageView;

@property (strong, nonatomic) IBOutlet UILabel* mRegisterStateLabel;

@property (strong, nonatomic) IBOutlet UITextView* mRegisterStateContentTextView;

@property (strong, nonatomic) IBOutlet UIButton* mGoMainPageActionBtn;

@property (strong, nonatomic) IBOutlet UIButton* mRepeatRegisterActionBtn;

//
@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property Boolean mIsRegisterSuccess;

@property (strong, retain) NSString* mRegisterStateContent;
//登录帐号
@property(nonatomic,copy)NSString * account;
//secot
@property(nonatomic,copy)NSString *seAccount;

///wlg
/**
 *  Description
 */
@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;

@end
