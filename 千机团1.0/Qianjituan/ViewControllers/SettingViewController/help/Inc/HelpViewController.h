//
//  HelpViewController.h
//  路由器项目
//
//

#import "Reachability.h"

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIWebViewDelegate>
{
@private
    
    UILabel* mTitleLabel;
    
    UIButton* mBackBtn;
    
    UIWebView* mMainWebView;
    
    
    //
    UIView* mNoNetworkContainerView;
    
    UIImageView* mNoNetworkImageView;
    
    UILabel* mNoNetworkLabel;
    
    UIButton* mNoNetworkRefreshButton;
    
    //
    UIView* mLoadingViewContainer;
    
    UIImageView* mLoadingImageView;
    
    //
    NSTimer* mDelayDismissNoticeTimer;
}

@property (strong, nonatomic) IBOutlet UILabel* mTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton* mBackBtn;

@property (strong, nonatomic) IBOutlet UIWebView* mMainWebView;

//
@property (strong, nonatomic) IBOutlet UIView* mNoNetworkContainerView;

@property (strong, nonatomic) IBOutlet UIImageView* mNoNetworkImageView;

@property (strong, nonatomic) IBOutlet UILabel* mNoNetworkLabel;

@property (strong, nonatomic) IBOutlet UIButton* mNoNetworkRefreshButton;

//
@property (strong, nonatomic) IBOutlet UIView* mLoadingViewContainer;

@property (strong, nonatomic) IBOutlet UIImageView* mLoadingImageView;

@end
