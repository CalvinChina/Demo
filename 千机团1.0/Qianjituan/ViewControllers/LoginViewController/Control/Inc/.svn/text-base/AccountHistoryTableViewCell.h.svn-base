//
//  MoreTableViewCell.h
//  PisenCloud3.0
//
//  Created by Pisen on 15/5/25.
//
//

#import <UIKit/UIKit.h>

@protocol OnRightBtnClickDelegate <NSObject>

- (void) onCellRightBtnClick: (NSObject*)extraData;

@end

@interface AccountHistoryTableViewCell : UITableViewCell
{
    @private
    UILabel* mNameLabel;
    
    UILabel* mAccountLabel;
    
    UIImageView* mRightImgView;
    
    UIButton* mRightClickButton;
}

@property (strong, nonatomic) IBOutlet UILabel* mNameLabel;

@property (strong, nonatomic) IBOutlet UILabel* mAccountLabel;

@property (strong, nonatomic) IBOutlet UIImageView* mRightImgView;

@property (strong, nonatomic) IBOutlet UIButton* mRightClickButton;

@property NSObject* mExtraData;

@property (strong, retain) id<OnRightBtnClickDelegate> mOnRightBtnClickDelegate;

@end
