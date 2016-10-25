//
//  WelocomeViewController.m
//  PisenCloud_iPad
//
//  Created by zengbixing on 15/2/6.
//  Copyright (c) 2015年 pisen. All rights reserved.
//

#import "WelocomeViewController.h"
#import "AppDelegate.h"

@interface WelocomeViewController ()<UIScrollViewDelegate> {
    
    NSMutableArray *imgArr;
    
    UIPageControl *pageControl;
}

@property(nonatomic, weak) IBOutlet UIScrollView *scrolView;


@end

@implementation WelocomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.wantsFullScreenLayout = YES;
    
   imgArr = [[NSMutableArray alloc]initWithObjects:@"guide_1.png",@"guide_2.png",@"guide_3.png", nil];
    
    [UIApplication sharedApplication].statusBarHidden= YES;

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _scrolView.contentSize=CGSizeMake(320*imgArr.count, 0);
    
    _scrolView.backgroundColor = [UIColor clearColor];
    
    _scrolView.delegate = self;

    CGFloat height = _scrolView.frame.size.height;
   
    for (int i = 0; i < [imgArr count]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame: CGRectMake(0 + i*320, 0, 320, height)];
        
        imageView.userInteractionEnabled=YES;
        
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        imageView.image=[UIImage imageNamed:[imgArr objectAtIndex:i]];
        
        [_scrolView addSubview:imageView];

        if (i == [imgArr count] - 1) {
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterMain)];
            [imageView addGestureRecognizer:tap];
        }
        else {
            
            if (i == 0) {
                
                UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                CGRect btnRect = CGRectMake((i + 1)*320 - 15 - 50, 15, 50, 50);
                
                jumpBtn.frame = btnRect;
                
                [_scrolView addSubview:jumpBtn];
                
                [jumpBtn setBackgroundImage:[UIImage imageNamed:@"jumpBtn"] forState:UIControlStateNormal];
                
                [jumpBtn addTarget:self action:@selector(enterMain) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    _scrolView.bounces = NO;
    
    _scrolView.pagingEnabled = YES;

    _scrolView.showsHorizontalScrollIndicator = NO;
    
    _scrolView.showsVerticalScrollIndicator = NO;
    
    _scrolView.alwaysBounceVertical = NO;
    
    CGRect pageRect = CGRectMake(0, height - 30, _scrolView.frame.size.width, 40);
    
    pageControl= [[UIPageControl alloc] init];
    
    pageControl.numberOfPages=imgArr.count-1;
    
    pageControl.currentPage=0;
    
    pageControl.pageIndicatorTintColor = [common rgbColor:"e5e5e5" alpha:0];
    
    pageControl.currentPageIndicatorTintColor = [common rgbColor:"cecece" alpha:0];
    
    pageControl.frame = pageRect;
    
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    
}

-(void)enterMain{
    
    [UIApplication sharedApplication].statusBarHidden= NO;

    AppDelegate *rootDelegate = [UIApplication sharedApplication].delegate;
    
    rootDelegate.isNoShowAdvert = YES;
    
    [rootDelegate enterMainController: NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    CGFloat t = scrollView.contentOffset.x;
    
    if (t > 640) {
        
        pageControl.hidden = YES;
        
    }else{
    
        pageControl.hidden = NO;
    }
    

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat t = scrollView.contentOffset.x;
    
    NSInteger pagIndex = t / scrollView.frame.size.width;
    
    if (pagIndex < imgArr.count - 1) {
        
        pageControl.currentPage = pagIndex;
    }
    
    if (imgArr.count - 1 == pagIndex) {
        
        pageControl.hidden = YES;
        
    }else{
        
         pageControl.hidden = NO;
    }
}

- (void)pageTurn:(UIPageControl *)pageView
{
    NSInteger index = [pageView currentPage];
    
    [_scrolView setContentOffset:CGPointMake(index * _scrolView.frame.size.width, 0) animated:YES];
}

- (void) dealloc {
    
    
}

@end
