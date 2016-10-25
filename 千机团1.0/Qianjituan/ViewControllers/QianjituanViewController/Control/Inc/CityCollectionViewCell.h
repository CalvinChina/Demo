//
//  CityCollectionViewCell.h
//  Qianjituan
//
//  Created by Pisen on 16/2/17.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCollectionViewCell : UICollectionViewCell
{
@private
    UILabel* titleLabel;
}

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@end
