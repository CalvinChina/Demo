//
//  FindPwdViewController.h
//  Qianjituan
//
//  Created by zengbixing on 15/9/23.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "FindPwdConfirmViewController.h"

#import <UIKit/UIKit.h>

@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end

@interface FindPwdViewController : UIViewController
{
    @private
    UIView* mFindPasswordContainerView;
    
    UIView* mFindPasswordInputContainerView;
    
    UITextField* mFindPasswordPhoneTextField;
    
    UIButton* mFindPasswordNextBtn;
    
    //
    UILabel* mTitleLabel;
    
    UIButton* mBackBtn;
    
    //
    UIView* mNoticeContainerView;
    
    UIView* mNoticeBgView;
    
    UILabel* mNoticeLabel;
    
    //
    UIView* mLoadingViewContainer;
    
    UIImageView* mLoadingImageView;
    
    //
    NSTimer* mDelayDismissNoticeTimer;
}

@property (strong, nonatomic) IBOutlet UIView* mFindPasswordContainerView;

@property (strong, nonatomic) IBOutlet UIView* mFindPasswordInputContainerView;

@property (strong, nonatomic) IBOutlet UITextField* mFindPasswordPhoneTextField;

@property (strong, nonatomic) IBOutlet UIButton* mFindPasswordNextBtn;

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
