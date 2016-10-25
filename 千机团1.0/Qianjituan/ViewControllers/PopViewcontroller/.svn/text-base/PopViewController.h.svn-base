//
//  PopViewController.h
//  PisenCloud_iPad
//
//  Created by pisen_lyy on 14-12-30.
//  Copyright (c) 2014年 pisen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopViewControllerDelegate <NSObject>

- (void)popcontrollerCellDidSelect:(NSInteger)index;

@end


@interface PopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray * imageArray;

@property (strong,nonatomic) NSArray * titleArray;

@property (assign,nonatomic) NSInteger cellHeight;

@property (assign) NSInteger cellWidth;

@property (assign,nonatomic) id<PopViewControllerDelegate> delegate;

@end
