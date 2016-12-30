//
//  AppDelegate.h
//  OperationDemo
//
//  Created by pisen on 16/12/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

