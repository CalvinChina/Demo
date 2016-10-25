//
//  QianjituanViewController.h
//  Qianjituan
//
//  Created by ios-mac on 15/9/16.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "NetworkManager.h"

#import "LoginViewController.h"

#import "UserDataDBManager.h"

#import "Reachability.h"

#import "CitySelectViewController.h"

#import "SettingViewController.h"

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface KeyMap: NSObject
{
@public
    NSString* key;
    
    NSString* value;
}
@end

@interface QianjituanViewController : UIViewController<BMKLocationServiceDelegate,UIScrollViewDelegate>
{
@private
    /**返回按钮所在的View*/
    UIView* mBackBtnContainerView;
    /**城市按钮所在的View*/
    UIView* mCityContainerView;
    
    UILabel* mCityLabel;
    
    UIButton* mCityBtn;
    
    UIView* mBackgroundView;
    /**titleLable所在的View*/
    UIView* mTitleCoontainerView;
    /**titleLable*/
    UILabel* mTitleLabel;
    /**设置按钮所在的View*/
    UIView* mMenuContainerView;
    /**分享按钮所在的View*/
    UIView* mShareContainerView;
    /**webView*/
    UIWebView* mMainWebView;
    
    
    /**无网络状态View*/
    UIView* mNoNetworkContainerView;
    
    UIImageView* mNoNetworkImageView;
    
    UILabel* mNoNetworkLabel;
    
    UIButton* mNoNetworkRefreshButton;
    
    /**加载View*/
    UIView* mLoadingViewContainer;
    
    UIImageView* mLoadingImageView;
    
    //
    UIView* mCityNotifyContainerView;
    
    UIView* mCityNotifyVisibleContainerView;
    
    UIButton* mCityNotifyBtn;
    
    //
    NSTimer* mDelayDismissNoticeTimer;
    
    //
    NSString* mCurrentLoadingUrl;
    
    NSMutableArray* mIgnoreBackMapList;
    
    NSMutableArray* mHideBackMapList;
    
    KeyMap* mCurrentMatchKeyMap;
    
    //
    UserDataDBManager* mUserDataDBManager;
    
    UserData* mCurrentUserData;
    
    BMKLocationService* mLocService;
    
    BMKGeoCodeSearch* mGeocodesearch;
    
    NSMutableArray* mCityDataArray;
    
    NSString* mLocatedCityName;
    
    NSString* mSelectedCityName;
    
    NSString* mSelectedCityCode;
    
    BOOL mIsCurrentUrlIgnored;
    
    NSString* mCurrentShareContent;
    
    NSString* mCurrentShareImageUrl;
    
    NSString* mCurrentShareUrl;
    /**返回键导致加载失败*/
    BOOL goBackLeadingtoFail;
}

@property (strong, nonatomic) IBOutlet UIView* mBackBtnContainerView;

@property (strong, nonatomic) IBOutlet UIView* mCityContainerView;

@property (strong, nonatomic) IBOutlet UILabel* mCityLabel;

@property (strong, nonatomic) IBOutlet UIButton* mCityBtn;

@property (strong, nonatomic) IBOutlet UIView* mBackgroundView;

@property (strong, nonatomic) IBOutlet UIView* mTitleCoontainerView;

@property (strong, nonatomic) IBOutlet UILabel* mTitleLabel;

@property (strong, nonatomic) IBOutlet UIView* mMenuContainerView;

@property (strong, nonatomic) IBOutlet UIView* mShareContainerView;

@property (strong, nonatomic) IBOutlet UIWebView* mMainWebView;

//
@property (strong, nonatomic) IBOutlet UIView* mNoNetworkContainerView;

@property (strong, nonatomic) IBOutlet UIImageView* mNoNetworkImageView;

@property (strong, nonatomic) IBOutlet UILabel* mNoNetworkLabel;

@property (strong, nonatomic) IBOutlet UIButton* mNoNetworkRefreshButton;

//
@property (strong, nonatomic) IBOutlet UIView* mLoadingViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView* mLoadingImageView;

@property (weak, nonatomic) IBOutlet UILabel *mLoadingLabel;
//
@property (strong, nonatomic) IBOutlet UIView* mCityNotifyContainerView;

@property (strong, nonatomic) IBOutlet UIView* mCityNotifyVisibleContainerView;

@property (strong, nonatomic) IBOutlet UIButton* mCityNotifyBtn;
// Calvin adds  this UILable to describe the Appliction
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loadLoadingIV;

@property (nonatomic ,assign) BOOL fromCenter;
//
@property Boolean mIsNeedInjectLoginData;
//登录帐号===
@property(nonatomic,copy)NSString * account;
@property (nonatomic ,assign) BOOL isBack;
//===

@end
