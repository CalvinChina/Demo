//
//  LoginViewController.h
//  Qianjituan
//
//  Created by ios-mac on 15/9/15.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "AccountHistoryTableViewCell.h"
#import "UserDataDBManager.h"
#import "RegisterViewController.h"
#import "FindPwdViewController.h"
#import "QianjituanViewController.h"

#import "NetworkManager.h"
#import "HTTPManager.h"

#import <UIKit/UIKit.h>

@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end


@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    @private
    
    UIView* mMovableView;
    
    //
    UIButton* mBackBtn;
    
    //
    UIView* mInputContainerView;
    
    //
    UIView* mAccountInputContainerView;
    
    UITextField* mAccountTextField;
    
    //
    UIView* mPasswordInputContainerView;
    
    UITextField* mPasswordTextField;
    
    //
    UIView* mVerifyContainerView;
    
    UITextField* mVerifyCodeInputTextField;
    
    UILabel* mVerifyCodeLabel;
    
    UIButton* mRefreshVerifyBtn;
    
    //
    UIView* mActionBtnContainerView;
    
    UIButton* mLoginBtn;
    
    UIButton* mRegisterBtn;
    
    UIButton* mForgetPasswordBtn;
    
    //
    UIView* mNoticeContainerView;
    
    UIView* mNoticeBgView;
    
    UILabel* mNoticeLabel;
    
    //
    UIView* mLoadingViewContainer;
    
    UIImageView* mLoadingImageView;
    
    //
    NSTimer* mDelayDismissNoticeTimer;
    
    NSUserDefaults* mLoginFailCounterDefaults;
    
    UserDataDBManager* mUserDataDBManager;
    
    UserData* mCurrentUserData;
    
    //
    NetworkManager* mNetworkManager;
    
    NSString* mVerifyCode;
    
    NSString* mVerifyKey;
    
    //
    HTTPManager* mHTTPManager;
    
    //
    Boolean mIsKeyboardShowing;
}

@property (strong, nonatomic) IBOutlet UIView* mMovableView;

@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mInputContainerView;

//
@property (strong, nonatomic) IBOutlet UIView* mAccountInputContainerView;

@property (strong, nonatomic) IBOutlet UITextField* mAccountTextField;

//
@property (strong, nonatomic) IBOutlet UIView* mPasswordInputContainerView;

@property (strong, nonatomic) IBOutlet UITextField* mPasswordTextField;

//
@property (strong, nonatomic) IBOutlet UIView* mVerifyContainerView;

@property (strong, nonatomic) IBOutlet UITextField* mVerifyCodeInputTextField;

@property (strong, nonatomic) IBOutlet UILabel* mVerifyCodeLabel;

@property (strong, nonatomic) IBOutlet UIButton* mRefreshVerifyBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mActionBtnContainerView;

@property (strong, nonatomic) IBOutlet UIButton* mLoginBtn;

@property (strong, nonatomic) IBOutlet UIButton* mRegisterBtn;

@property (strong, nonatomic) IBOutlet UIButton* mForgetPasswordBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mNoticeContainerView;

@property (strong, nonatomic) IBOutlet UIView* mNoticeBgView;

@property (strong, nonatomic) IBOutlet UILabel* mNoticeLabel;

//
@property (strong, nonatomic) IBOutlet UIView* mLoadingViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView* mLoadingImageView;

//
@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;

@property Boolean mIsFromMain;

@end
