//
//  RegisterViewController.h
//  Qianjituan
//
//  Created by zengbixing on 15/9/23.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "RegisterConfirmViewController.h"
#import "RegisterProtocolViewController.h"

#import <UIKit/UIKit.h>


@protocol OnLoginSuccessDelegate<NSObject>

@required
-(void) onLoginSucceeded: (NSString*)account
                password: (NSString*)password;


@end


@interface RegisterViewController : UIViewController
{
    @private
    UIView* mInputContainerView;
    
    UITextField* mInputPhoneTextfield;
    
    UILabel* mRegisterProtocolLabel;
    
    UIButton* mRegisterProtocolBtn;
    
    UIButton* mRegisterBtn;
    
    //
    UIButton* mBackBtn;
    
    //
    UIView* mNoticeContainerView;
    
    UIView* mNoticeBgView;
    
    UILabel* mNoticeLabel;
    
    NSTimer* mDelayDismissNoticeTimer;
}

@property (strong, nonatomic) IBOutlet UIView* mInputContainerView;

@property (strong, nonatomic) IBOutlet UITextField* mInputPhoneTextfield;

@property (strong, nonatomic) IBOutlet UILabel* mRegisterProtocolLabel;

@property (strong, nonatomic) IBOutlet UIButton* mRegisterProtocolBtn;

@property (strong, nonatomic) IBOutlet UIButton* mRegisterBtn;

//
@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

//
@property (strong, nonatomic) IBOutlet UIView* mNoticeContainerView;

@property (strong, nonatomic) IBOutlet UIView* mNoticeBgView;

@property (strong, nonatomic) IBOutlet UILabel* mNoticeLabel;

//
@property (strong, retain) NSString* mInputedPhoneNum;
///wlg
/**
 *  Description
 */
@property (strong, retain) id<OnLoginSuccessDelegate> mOnLoginSuccessDelegate;
@end
