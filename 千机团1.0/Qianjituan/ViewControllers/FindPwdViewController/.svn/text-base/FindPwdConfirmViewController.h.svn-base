//
//  FindPwdConfirmViewController.h
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "NetworkManager.h"
#import "UserDataDBManager.h"
#import "LoginViewController.h"
#import "FindPwdStateViewController.h"

#import <UIKit/UIKit.h>

@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end

@interface FindPwdConfirmViewController : UIViewController
{
@private
    UIView* mFindPasswordContainerView;
    
    UIView* mFindPasswordInputContainerView;
    
    UILabel* mFindPasswordPhoneLabel;
    
    UITextField* mVerifyCodeInputTextfield;
    
    UIButton* mSMSVerifyCodeFetchBtn;
    
    UIButton* mShowPasswordBtn;
    
    //
    UITextField* mInputPasswordTextfield;
    
    UIButton* mResetPasswordFinishBtn;
    
    //
    UILabel* mTitleLabel;
    
    UIButton* mBackBtn;
    
    UIActivityIndicatorView* mIndicator;
    
    //
    UIView* mNoticeContainerView;
    
    UIView* mNoticeBgView;
    
    UILabel* mNoticeLabel;
    
    //
    UIView* mLoadingViewContainer;
    
    UIImageView* mLoadingImageView;
    
    //
    NSTimer* mDelayDismissNoticeTimer;
    
    //
    NetworkManager* mNetworkManager;
    
    NSTimer* mVerifyCodeFetchingTimer;
    
    int mVerifyCodeFetchingCounter;
}

@property (strong, nonatomic) IBOutlet UIView* mFindPasswordContainerView;

@property (strong, nonatomic) IBOutlet UIView* mFindPasswordInputContainerView;

@property (strong, nonatomic) IBOutlet UILabel* mFindPasswordPhoneLabel;

@property (strong, nonatomic) IBOutlet UITextField* mVerifyCodeInputTextfield;

@property (strong, nonatomic) IBOutlet UIButton* mSMSVerifyCodeFetchBtn;

@property (strong, nonatomic) IBOutlet UITextField* mInputPasswordTextfield;

@property (strong, nonatomic) IBOutlet UIButton* mShowPasswordBtn;

@property (strong, nonatomic) IBOutlet UIButton* mResetPasswordFinishBtn;

//
@property (strong, nonatomic) IBOutlet UILabel* mTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mNoticeContainerView;

@property (strong, nonatomic) IBOutlet UIView* mNoticeBgView;

@property (strong, nonatomic) IBOutlet UILabel* mNoticeLabel;

//
@property (strong, nonatomic) IBOutlet UIView* mLoadingViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView* mLoadingImageView;

//
@property (strong, retain) NSString* mPreAccount;

//
@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;

@end