//
//  PopViewController.m
//  PisenCloud_iPad
//
//  Created by pisen_lyy on 14-12-30.
//  Copyright (c) 2014年 pisen. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController(){

    UITableView * _tableView;
}

@end

@implementation PopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    fullBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [self.view addSubview:fullBtn];
    
    [fullBtn addTarget:self action:@selector(clickFullBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth - _cellWidth - 5, 25, _cellWidth, _cellHeight*_titleArray.count)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.scrollEnabled = NO;
}

- (void)clickFullBtn {
    
    [self.view removeFromSuperview];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
}

#pragma -mark tableviewdatasourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PopViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel * labtitle = nil;

//        if ([self.imageArray count] > indexPath.row) {
//            
//            UIImageView * imaeView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
//            
//            imaeView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
//            
//            [cell addSubview:imaeView];
//            
//            labtitle = [[UILabel alloc] initWithFrame:CGRectMake(58, 10, 290, 25)];
//        }
//        else {
        
            CGRect rect = tableView.frame;
            
            labtitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 110, 25)];
            
            labtitle.textAlignment = NSTextAlignmentCenter;
        //}
        
        labtitle.text = self.titleArray[indexPath.row];
        
        labtitle.font = [UIFont systemFontOfSize:17.0];
        
        labtitle.textColor = [common rgbColor:"333333" alpha:1];
        
        [cell addSubview:labtitle];
        
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        
        lineview.backgroundColor = [common rgbColor:"ccccccc" alpha:1];
        
        [cell addSubview:lineview];
        
        if (0 == indexPath.row) {
            
            lineview.hidden = YES;
            
        }else{
        
            lineview.hidden = NO;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma
#pragma -mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(popcontrollerCellDidSelect:)]) {
        
        [self.delegate popcontrollerCellDidSelect:indexPath.row];
    }
    
    [self.view removeFromSuperview];
}

@end
