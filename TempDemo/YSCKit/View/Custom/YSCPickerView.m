//
//  YSCPickerView.m
//  YSCKit
//
//  Created by YangShengchao on 15/3/28.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "YSCPickerView.h"
#import "BlocksKit+UIKit.h"
#define HeightOfContainerView       360
#define DurationOfAnimation         0.3f

@interface YSCPickerView ()
@property (nonatomic, strong) NSMutableArray *selectedIndexArray;
@end

@implementation YSCPickerView

- (void)dealloc {
    NSLog(@"YSCPickerView deallocing...");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    @weakiy(self)
    [self resetSize];
    self.selectedIndexArray = [NSMutableArray array];
    
    //初始化
    self.containerBottom.constant = -AUTOLAYOUT_LENGTH(HeightOfContainerView);
    self.hidden = YES;
    [self.datePicker bk_addEventHandler:^(id sender) {
        if (weak_self.pickerType < YSCPickerTypeCustom) {
            if (weak_self.selectingBlock) {
                weak_self.selectingBlock([weak_self.datePicker date], nil);
            }
        }
    } forControlEvents:UIControlEventValueChanged];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    [self.datePicker setMinimumDate:[NSDate dateFromString:@"1930-01-01" withFormat:kDateFormat3]];
    [self.datePicker setMaximumDate:CURRENT_DATE];

    
    //点击半透明关闭选择器
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if ( ! CGRectContainsPoint(weak_self.containerView.frame, location)) {
            [weak_self hidePickerView];
        }
    }];
    [self addGestureRecognizer:tapGesture];
    
    //点击取消按钮关闭选择器
    [self.cancelButton addCornerWithRadius:5];
    [self.cancelButton makeBorderWithColor:[UIColor blackColor] borderWidth:1];
    [self.cancelButton bk_addEventHandler:^(id sender) {
        [weak_self hidePickerView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    //点击完成按钮关闭选择器
    [self.doneButton addCornerWithRadius:5];
    [self.doneButton makeBorderWithColor:[UIColor blackColor] borderWidth:1];
    [self.doneButton bk_addEventHandler:^(id sender) {
        [weak_self hidePickerView];
        if (weak_self.selectedBlock) {
            if (YSCPickerTypeCustom == weak_self.pickerType) {
                weak_self.selectedBlock(weak_self.selectedIndexArray, nil);
            }
            else if (weak_self.pickerType <= YSCPickerTypeDateTime) {
                weak_self.selectedBlock([weak_self.datePicker date], nil);
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)setPickerType:(YSCPickerType)pickerType {
    _pickerType = pickerType;
    if (pickerType < YSCPickerTypeCustom) {
        self.pickerView.hidden = YES;
        self.datePicker.hidden = NO;
    }
    else {
        self.pickerView.hidden = NO;
        self.datePicker.hidden = YES;
    }
    
    //必须要初始化数据
    if (YSCPickerTypeDate == pickerType) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if (YSCPickerTypeTime == pickerType) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if (YSCPickerTypeDateTime == pickerType) {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else if (YSCPickerTypeCustom == pickerType) {
        
    }
}

+ (instancetype)CreateYSCPickerView {
    YSCPickerView *pickerView = FIRST_VIEW_IN_XIB(@"YSCPickerView");
    pickerView.width = SCREEN_WIDTH;
    pickerView.height = SCREEN_HEIGHT;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    return pickerView;
}

- (void)showPickerView:(id)initObject {
    if ( ! self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    self.hidden = NO;
    [UIView animateWithDuration:DurationOfAnimation animations:^{
        self.containerBottom.constant = AUTOLAYOUT_LENGTH(0);
        if (self.completionShowBlock) {
            self.completionShowBlock();
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //必须重新刷新界面
        if (self.pickerType < YSCPickerTypeCustom) {
            NSDate *initDate = (NSDate *)initObject;
            if (OBJECT_IS_EMPTY(initDate) || (! [initDate isKindOfClass:[NSDate class]])) {
                initDate = CURRENT_DATE;
            }
            [self.datePicker setDate:initDate animated:YES];
        }
        else {
            [self.pickerView reloadAllComponents];
            [self.selectedIndexArray removeAllObjects];
            for (int i = 0; i < self.pickerView.numberOfComponents; i++) {
                [self.selectedIndexArray addObject:@(0)];
            }
            
            NSArray *indexArray = initObject;
            if ([indexArray isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < MIN(self.pickerView.numberOfComponents, [indexArray count]); i++) {
                    NSInteger tempRow = MIN([((NSArray *)self.customDataArray[i]) count] - 1,
                                            [indexArray[i] integerValue]);
                    [self.pickerView selectRow:tempRow inComponent:i animated:YES];
                    self.selectedIndexArray[i] = @(tempRow);
                }
            }
        }
    }];
}
- (void)hidePickerView {
    [UIView animateWithDuration:DurationOfAnimation animations:^{
        self.containerBottom.constant = -AUTOLAYOUT_LENGTH(HeightOfContainerView);
        if (self.completionHideBlock) {
            self.completionHideBlock();
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (YSCPickerTypeCustom == self.pickerType) {
        return [self.customDataArray count];
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (YSCPickerTypeCustom == self.pickerType) {
        return [((NSArray *)self.customDataArray[component]) count];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (YSCPickerTypeCustom == self.pickerType) {
        NSString *title = [NSString stringWithFormat:@"%@", self.customDataArray[component][row]];
        return title;
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (YSCPickerTypeCustom == self.pickerType) {
        self.selectedIndexArray[component] = @(row);
        if (self.selectingBlock) {
            self.selectingBlock(self.selectedIndexArray, nil);
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLabel = (UILabel*)view;
    if (!titleLabel) {
        CGSize size = [pickerView rowSizeForComponent:component];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = AUTOLAYOUT_FONT(32);
    }
    if (YSCPickerTypeCustom == self.pickerType) {
        NSString *title = [NSString stringWithFormat:@"%@", self.customDataArray[component][row]];
        titleLabel.text = title;
    }
    
    return titleLabel;
}

@end
