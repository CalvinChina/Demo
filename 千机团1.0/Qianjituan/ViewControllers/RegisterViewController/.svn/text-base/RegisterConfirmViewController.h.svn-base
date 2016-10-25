//
//  RegisterConfirmViewController.h
//  Qianjituan
//
//  Created by Pisen on 15/12/9.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "UserDataDBManager.h"

#import "NetworkManager.h"

#import "RegisterResultViewController.h"

#import "QianjituanViewController.h"

#import <UIKit/UIKit.h>


@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end


@interface RegisterConfirmViewController : UIViewController
{
@private
    UIView* mInputContainerView;
    
    UILabel* mInputedPhoneNumLabel;
    
    UITextField* mInputVerifyCodeTextfield;
    
    UIButton* mRefreshVerifyCodeBtn;
    
    UITextField* mInputPasswordTextfield;
    
    UIButton* mShowPasswordBtn;
    
    UIButton* mRegisterBtn;
    
    //
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
    NSUserDefaults* mLoginFailCounterDefaults;
    
    UserDataDBManager* mUserDataDBManager;
    
    Boolean mIsKeyboardShowing;
    
    //
    NetworkManager* mNetworkManager;
    
    NSTimer* mVerifyCodeFetchingTimer;
    
    int mVerifyCodeFetchingCounter;
}

@property (strong, nonatomic) IBOutlet UIView* mInputContainerView;

@property (strong, nonatomic) IBOutlet UILabel* mInputedPhoneNumLabel;

@property (strong, nonatomic) IBOutlet UITextField* mInputVerifyCodeTextfield;

@property (strong, nonatomic) IBOutlet UIButton* mRefreshVerifyCodeBtn;

@property (strong, nonatomic) IBOutlet UITextField* mInputPasswordTextfield;

@property (strong, nonatomic) IBOutlet UIButton* mShowPasswordBtn;

@property (strong, nonatomic) IBOutlet UIButton* mRegisterBtn;

//
@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mNoticeContainerView;

@property (strong, nonatomic) IBOutlet UIView* mNoticeBgView;

@property (strong, nonatomic) IBOutlet UILabel* mNoticeLabel;

//
@property (strong, nonatomic) IBOutlet UIView* mLoadingViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView* mLoadingImageView;

//
@property (strong, retain) NSString* mInputedPhoneNum;
///wlg
/**
 *  Description
 */
@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;

@end
