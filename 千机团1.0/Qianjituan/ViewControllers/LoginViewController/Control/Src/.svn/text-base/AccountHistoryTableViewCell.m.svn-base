//
//  MoreTableViewCell.m
//  PisenCloud3.0
//
//  Created by Pisen on 15/5/25.
//
//

#import "AccountHistoryTableViewCell.h"

@implementation AccountHistoryTableViewCell

@synthesize mNameLabel;

@synthesize mAccountLabel;

@synthesize mRightImgView;

@synthesize mRightClickButton;

@synthesize mExtraData;

- (void)awakeFromNib
{
    // Initialization code
}

- (void) setRightImgViewHidden: (Boolean)isHidden
{
    [self.mRightImgView setHidden: isHidden];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) onRightBtnClick:(id)sender
{
    if(self.mOnRightBtnClickDelegate != nil)
    {
        [self.mOnRightBtnClickDelegate onCellRightBtnClick: mExtraData];
    }
}

@end
