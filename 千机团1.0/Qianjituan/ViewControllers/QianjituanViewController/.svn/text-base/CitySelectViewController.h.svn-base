//
//  CitySelectViewController.h
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "CityCollectionViewCell.h"

#import <UIKit/UIKit.h>

@protocol OnCitySelectedDelegate<NSObject>

@required
-(void) onCitySelected: (NSString*)cityName
                  code: (NSString*)cityCode;

@end

@interface CityData:NSObject
{
    @public
    NSString* cityName;
    
    NSString* cityID;
}

@end

@interface CitySelectViewController : UIViewController
{
    @private
    UILabel* mCityLabel;
    
    UIButton* mTitleBackBtn;
    
    UICollectionView* mCityCollectionView;
    
    //
    NSMutableArray* mCityDataArray;
}

@property (strong, nonatomic) IBOutlet UILabel* mCityLabel;

@property (strong, nonatomic) IBOutlet UIButton* mTitleBackBtn;

@property (strong, nonatomic) IBOutlet UICollectionView* mCityCollectionView;

@property NSString* mCurrentCity;

@property (nonatomic, assign)id<OnCitySelectedDelegate> mOnCitySelectedDelegate;

- (void) setCityData: (NSMutableArray*)cityData;

@end
