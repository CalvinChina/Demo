//
//  CitySelectViewController.m
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "CitySelectViewController.h"

@implementation CityData

@end

@implementation CitySelectViewController

@synthesize mCityLabel;
@synthesize mCityCollectionView;

NSString* KCellID = @"CityCollectionViewCell";

- (void) setCityData: (NSMutableArray*)cityData
{
    mCityDataArray = cityData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initComponents
{
    //
    if(self.mCurrentCity != nil)
    {
        mCityLabel.text = self.mCurrentCity;
    }
    
    //
    CGRect screenFrame = [ UIScreen mainScreen ].bounds;
    
    if(screenFrame.size.width == 320 &&
       screenFrame.size.height == 480)
    {
        mCityCollectionView.frame =
        CGRectMake(
                   0,
                   mCityCollectionView.frame.origin.y,
                   mCityCollectionView.frame.size.width,
                   mCityCollectionView.frame.size.height - 87);
        
    }
    
    mCityCollectionView.delegate = self;
    
    mCityCollectionView.dataSource = self;
    
    [mCityCollectionView registerNib:[UINib nibWithNibName: KCellID bundle:nil]
          forCellWithReuseIdentifier: KCellID];
    
    if(mCityDataArray == nil)
    {
        mCityDataArray = [[NSMutableArray alloc] init];
        
        //
        CityData* chengduCityData = [[CityData alloc] init];
        
        chengduCityData->cityName = @"成都";
        
        chengduCityData->cityID = @"510100";
        
        [mCityDataArray addObject:chengduCityData];
        
        //
        CityData* beijingCityData = [[CityData alloc] init];
        
        beijingCityData->cityName = @"北京";
        
        beijingCityData->cityID = @"110100";
        
        [mCityDataArray addObject:beijingCityData];
        
        //
        CityData* shanghaiCityData = [[CityData alloc] init];
        
        shanghaiCityData->cityName = @"上海";
        
        shanghaiCityData->cityID = @"310100";
        
        [mCityDataArray addObject:shanghaiCityData];
        
        //
        CityData* guangzhouCityData = [[CityData alloc] init];
        
        guangzhouCityData->cityName = @"广州";
        
        guangzhouCityData->cityID = @"440100";
        
        [mCityDataArray addObject:guangzhouCityData];
        
        //
        CityData* shenzhenCityData = [[CityData alloc] init];
        
        shenzhenCityData->cityName = @"深圳";
        
        shenzhenCityData->cityID = @"440300";
        
        [mCityDataArray addObject:shenzhenCityData];
        
        //
        CityData* nanjingCityData = [[CityData alloc] init];
        
        nanjingCityData->cityName = @"南京";
        
        nanjingCityData->cityID = @"510100";
        
        [mCityDataArray addObject:nanjingCityData];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark Table view delegate end#pragma mark -CollectionView datasource

//section
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if(mCityDataArray != nil)
    {
        return mCityDataArray.count;
    }
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityCollectionViewCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier: KCellID
                                              forIndexPath: indexPath];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed: KCellID
                                              owner: self
                                            options: nil] lastObject];
    }
    
    //
    cell.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 15;
    
    cell.layer.borderWidth = 1.0;
    
    cell.layer.borderColor = [[UIColor clearColor] CGColor];
    
    if(mCityDataArray != nil &&
       indexPath.row < mCityDataArray.count)
    {
        CityData* cityData = [mCityDataArray objectAtIndex: indexPath.row];
        
        cell.titleLabel.text = cityData->cityName;
    }
    
    return cell;
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 32);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {0,0};
    
    return size;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size= {0,0};
    
    return size;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath == nil ||
       mCityDataArray == nil ||
       indexPath.row >= mCityDataArray.count)
    {
        return;
    }
    
    CityData* cityData = [mCityDataArray objectAtIndex: indexPath.row];
    
    if(self.mOnCitySelectedDelegate != nil)
    {
        [self.mOnCitySelectedDelegate onCitySelected: cityData->cityName
                                                code: cityData->cityID];
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
