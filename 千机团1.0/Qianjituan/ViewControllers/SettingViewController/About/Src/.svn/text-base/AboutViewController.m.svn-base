//
//  AboutViewController.m
//  Pisen cloud
//
//  Created by pisen on 14-3-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize mBackBtn;

@synthesize mHeaderContainerView;

@synthesize mAppNameLable;

@synthesize mVersionCodeLable;

- (id)initWithNibName: (NSString*)nibNameOrNil
               bundle: (NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString* app_Version = [infoDictionary objectForKey: @"CFBundleShortVersionString"];
    
    NSString* build_version = [infoDictionary objectForKey: @"CFBundleVersion"];
    
    NSString* versionStr =
    [NSString stringWithFormat: @"For iOS V%@ build%@", app_Version, build_version];
    
    [mVersionCodeLable setText: versionStr];
}

- (IBAction) onBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

@end
