//
//  PFMTitleBarView.m
//  PisenFM
//
//  Created by pisen on 16/10/27.
//  Copyright © 2016年 Pisen. All rights reserved.
//

#import "PFMTitleBarView.h"
#import "PFMTitlebarModel.h"
@interface  PFMTitleBarCollectionViewCell: UICollectionViewCell

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) PFMTitlebarModel * barModel;

@end

@implementation PFMTitleBarCollectionViewCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.clipsToBounds = YES;
        [self setupItemUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    self.contentView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setupItemUI{
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = kDefaultBlueColor1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = self.contentView.bounds;
    [self.contentView addSubview:self.titleLabel];
}


- (void)setBarModel:(PFMTitlebarModel *)barModel{
    _barModel = barModel;

    self.titleLabel.text = barModel.title;
    self.titleLabel.psk_width = [NSString psk_widthOfNormalString:barModel.title maxHeight:30 withFont:[UIFont systemFontOfSize:16]];
    
    if ([_barModel.isSelected isEqualToNumber:@1]) {
        self.titleLabel.textColor = kDefaultBlueColor1;
    }else{
        self.titleLabel.textColor = kDefaultGray102;
    }
}

@end

static NSString * mCellIdentifier = @"PFMCollectionViewCell";

static CGFloat dis = 50;

#define   PFMTitleItemHeight  self.frame.size.height - 2 * 5

@interface PFMTitleBarView()<UICollectionViewDelegate ,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView * titleColletion;

@property (nonatomic ,strong) NSMutableArray * PFMTitleDataArr;

@property (nonatomic ,strong) UIView * flatView;

@property (nonatomic ,assign) BOOL isOriginalState;

@end

@implementation PFMTitleBarView

- (UIView *)flatView{
    if (!_flatView) {
        _flatView = [[UIView alloc]init];
    }
    return _flatView;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        
        _isOriginalState = YES;
        [self setupData:titleArray];
        [self setupCollectionView];
        [self setupFlatView];
    }
    return self;
}

- (void)setupData:(NSArray *)titleArray{
    _PFMTitleDataArr = [NSMutableArray array];
    
    for (int index = 0 ;index < titleArray.count; index ++ ) {
        
        NSString * str = titleArray[index];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:@{@"title":str,@"isSelected":@0}];
        if (index == 0) {
            dict = [NSMutableDictionary dictionaryWithDictionary:@{@"title":str,@"isSelected":@1}];
        }
        PFMTitlebarModel * model = [PFMTitlebarModel mj_objectWithKeyValues:dict];
        [_PFMTitleDataArr addObject:model];
    }
}


- (void)setupCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //水平滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = dis;
    
    self.titleColletion = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height) collectionViewLayout:layout];
    self.titleColletion.backgroundColor= [UIColor whiteColor];
    self.titleColletion.delegate=self;
    self.titleColletion.dataSource=self;
    self.titleColletion.showsHorizontalScrollIndicator  = NO;
    self.titleColletion.showsVerticalScrollIndicator = NO;

    [self.titleColletion registerClass:[PFMTitleBarCollectionViewCell class] forCellWithReuseIdentifier:mCellIdentifier];
    [self addSubview:self.titleColletion];
}

- (void)setupFlatView{
    self.flatView.backgroundColor = kDefaultBlueColor1;
    self.flatView.frame = CGRectMake(0, self.frame.size.height - 3, 10, 3);
    // 这个有点厉害了，不加在collectionView上就无法移到对应的item下面
    [self.titleColletion addSubview:self.flatView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.PFMTitleDataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = [self _getItemWidthWithIndexPath:indexPath];
    return CGSizeMake(itemWidth, PFMTitleItemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFMTitleBarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:mCellIdentifier forIndexPath:indexPath];
    
    if (_isOriginalState) {
        if (indexPath.row == 0) {
            //动态获取第一个cell下的flatView的宽度
            self.flatView.psk_width =  [self _getItemWidthWithIndexPath:indexPath];
            self.flatView.psk_left = cell.psk_left;
        }
    }
    
    PFMTitlebarModel * model = self.PFMTitleDataArr[indexPath.row];
    cell.barModel = model;
    return cell;
}
// 点击加载不同页面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 为了解决点击之后刷新的bug
    _isOriginalState = NO;
    
    PFMTitleBarCollectionViewCell * cell = (PFMTitleBarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CGFloat itemWidth = [self _getItemWidthWithIndexPath:indexPath];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    self.flatView.psk_width = itemWidth;
    self.flatView.psk_left = cell.psk_left;
    [UIView commitAnimations];
    
#warning 需要处理
    
    if (cell.psk_centerX != 0) {
        if (cell.psk_centerX + cell.psk_width / 2 > SCREEN_WIDTH) {
         
            
            
        }
    }
//
//    if (self.PFMTitleDataArr.count > 4) {
//        
//        if (cell.center.x > self.frame.size.width / 2) {
//            
//            if (cell.center.x + self.frame.size.width / 2 >= self.contentSize.width) {
//                
//                [_titleColletion setContentOffset:CGPointMake(cell.center.x - self.contentSize.width / 2 - cell.frame.size.width / 2, 0) animated:YES];
//            }
//            else{
//                [_titleColletion setContentOffset:CGPointMake(cell.frame.origin.x-self.frame.size.width/2+ cell.frame.size.width / 2, 0) animated:YES];
//            }
//        }else{
//            [_titleColletion setContentOffset:CGPointMake(0,0) animated:YES];
//        }
//    }
//
//
//    
//    for (int index = 0; index < collectionView.visibleCells.count; index ++ ) {
//        
//       
//    }
    
    
    for (int i = 0; i < self.PFMTitleDataArr.count; i++) {
        PFMTitlebarModel * model = self.PFMTitleDataArr[i];
        if (i == indexPath.row) {
            model.isSelected = @1;
        }
        else {
            model.isSelected = @0;
        }
    }
    [collectionView reloadData];
    
    if ([self.pageDelegate respondsToSelector:@selector(changePage:)]) {
        [self.pageDelegate changePage:indexPath.row];
    }
}

#pragma mark -- privateMethod start
// 获取cell宽度
- (CGFloat)_getItemWidthWithIndexPath:(NSIndexPath *)indexPath{
    PFMTitlebarModel * tempModel = self.PFMTitleDataArr[indexPath.row];
    NSString * str = tempModel.title;
    CGFloat itemWidth = [NSString psk_widthOfNormalString:str maxHeight:PFMTitleItemHeight withFont:[UIFont systemFontOfSize:16]];
    return itemWidth;
}
#pragma mark -- privateMethod end


#pragma mark -- publicMethod start
- (void)scrollToIndex:(NSInteger)index
{
    for (int i = 0; i < self.PFMTitleDataArr.count; i++) {
        PFMTitlebarModel * model = self.PFMTitleDataArr[i];
        if (i == index) {
            model.isSelected = @1;
        }
        else {
            model.isSelected = @0;
        }
    }
    [_titleColletion reloadData];
}
#pragma mark -- publicMethod end






@end
