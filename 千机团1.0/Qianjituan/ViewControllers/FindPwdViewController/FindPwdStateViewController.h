//
//  FindPwdStateViewController.h
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "LoginViewController.h"

#import <UIKit/UIKit.h>

@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end

@interface FindPwdStateViewController : UIViewController
{
@private
    UIView* mFindPwdStateContainerView;
    
    UIImageView* mFindPwdStateImageView;
    
    UILabel* mFindPwdStateLabel;
    
    UITextView* mFindPwdStateContentTextView;
    
    UIButton* mGoLoginActionBtn;
    
    UIButton* mRepeatFindPwdActionBtn;
    
    //
    UIButton* mBackBtn;
}

@property (strong, nonatomic) IBOutlet UIView* mFindPwdStateContainerView;

@property (strong, nonatomic) IBOutlet UIImageView* mFindPwdStateImageView;

@property (strong, nonatomic) IBOutlet UILabel* mFindPwdStateLabel;

@property (strong, nonatomic) IBOutlet UITextView* mFindPwdStateContentTextView;

@property (strong, nonatomic) IBOutlet UIButton* mGoLoginActionBtn;

@property (strong, nonatomic) IBOutlet UIButton* mRepeatFindPwdActionBtn;

//
@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property Boolean mIsFindPwdSuccess;

@property (strong, retain) NSString* mFindPwdStateContent;

@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;

@end