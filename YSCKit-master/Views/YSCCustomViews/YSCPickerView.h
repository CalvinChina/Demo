//
//  YSCPickerView.h
//  YSCKit
//
//  Created by YangShengchao on 15/3/28.
//  Copyright (c) 2015年 yangshengchao. All rights reserved.
//

#import "RegionModel.h"

typedef NS_ENUM(NSInteger, YSCPickerType) {
    YSCPickerTypeDate = 0,
    YSCPickerTypeTime,
    YSCPickerTypeDateTime,
    YSCPickerTypeAddress,
    YSCPickerTypeCustom,
};

@interface YSCPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottom;//260
@property (strong, nonatomic) NSArray *customDataArray;

@property (assign, nonatomic) YSCPickerType pickerType;
@property (copy, nonatomic) YSCIdResultBlock selectingBlock;        //选中的value发生变化时回调(点击【确定】按钮不回调)
@property (copy, nonatomic) YSCIdResultBlock selectedBlock;         //点击【确定】按钮回调
@property (copy, nonatomic) YSCBlock completionShowBlock;
@property (copy, nonatomic) YSCBlock completionHideBlock;

+ (instancetype)CreateYSCPickerView;
- (void)showPickerView:(id)initObject;
- (void)hidePickerView;

@end
