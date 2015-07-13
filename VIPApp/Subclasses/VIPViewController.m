//
//  VIPViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VIPViewController.h"
#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ServiceHelper.h"
#import "AdvertisingResult.h"
#import "PromotionDetailsViewController.h"
#import "AdvertisingImageViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface VIPViewController ()

@property (nonatomic, strong)UIView *loadingView;
@property (nonatomic, strong)UIActivityIndicatorView *activityView;

@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    
    [self.view insertSubview:_backgroundView atIndex:0];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = RGB(146, 121, 66);
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(146, 121, 66), NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:20.0f]}];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [backButton setTitleTextAttributes:@{[UIFont fontWithName:@"Roboto-Regular" size:30.0]:NSFontAttributeName} forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;
    
    if([self isKindOfClass:[LoginViewController class]])
        return;
    
    UIImageView *crownImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crown"]];
    crownImage.frame = CGRectMake(self.view.frame.size.width - 50, 20, 36, 30);
    [self.view addSubview:crownImage];
    
}

- (void)setIsMainMenu:(BOOL)isMainMenu
{
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Hamburger"]];
    view.frame = CGRectMake(12, 18, 28, 20);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuPressed)];
    [view addGestureRecognizer:tap];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)loadAdvertising
{
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.userInteractionEnabled = YES;
    [[ServiceHelper sharedServiceHelper]setAdvertiseImageView:_bannerView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(advertisePressed:)];
    [_bannerView addGestureRecognizer:tapGesture];
}

- (void)advertisePressed:(id)sender
{
    Advertising *advertise = [[ServiceHelper sharedServiceHelper]advertise];
    if(!advertise || [advertise isKindOfClass:[AdvertisingNoProm class]])
    {
        AdvertisingImageViewController *advertise = [[AdvertisingImageViewController alloc]init];
        advertise.promotion = (AdvertisingNoProm*)[[ServiceHelper sharedServiceHelper]advertise];
        [self.navigationController pushViewController:advertise animated:YES];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PromotionDetailsViewController *promotionInfo = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailsViewController"];
    promotionInfo.promotion = (Promotion*)[[[ServiceHelper sharedServiceHelper]advertise]promotion];
    [promotionInfo fetchVenueInfo:promotionInfo.promotion.venue_id];
    [self.navigationController pushViewController:promotionInfo animated:YES];
}

- (void)menuPressed
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initializePickerView
{
    _pickerView = [[UIPickerView alloc]initWithFrame:
                    CGRectMake(0, 0, self.view.frame.size.width, 258)];
    _pickerView.dataSource = (id<UIPickerViewDataSource>)self;
    _pickerView.delegate = (id<UIPickerViewDelegate>)self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addPickerToContainer:_pickerView];
}

- (void)initializeDatePickerView
{
    _datePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 258)];
    _datePickerView.backgroundColor = [UIColor whiteColor];
    [self addPickerToContainer:_datePickerView];
}

- (void)addPickerToContainer:(UIView*)picker
{
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
    toolbar.barTintColor = RGB(91, 78, 46);
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"LISTO"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(donePressed)];
    [doneButton setTintColor:[UIColor blackColor]];
    [doneButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:16.0], NSForegroundColorAttributeName : RGB(226, 228, 209)} forState:UIControlStateNormal];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    _pickerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 214)];
    [_pickerContainer addSubview:picker];
    [_pickerContainer addSubview:toolbar];
    
    [self.view addSubview:_pickerContainer];
}

- (void)donePressed{}

- (void)presentPickerView
{
    if(!_isPickerVisible)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center = self.pickerContainer.center;
            _pickerContainer.center = CGPointMake(center.x, center.y - _pickerContainer.frame.size.height);
        }];
        _isPickerVisible = YES;
    }
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _pickerContainer.center;
        _pickerContainer.center = CGPointMake(center.x, center.y + _pickerContainer.frame.size.height);
    }];
    _isPickerVisible = NO;
}

- (void)initLoadingView
{
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(65, 155, 150, 150)];
    _loadingView.backgroundColor = [UIColor darkGrayColor];
    _loadingView.alpha = 0.8;
    _loadingView.clipsToBounds = YES;
    _loadingView.layer.cornerRadius = 10.0;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = CGRectMake(55, 40, _activityView.bounds.size.width, _activityView.bounds.size.height);
    [_loadingView addSubview:_activityView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 130, 30)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Cargando...";
    loadingLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0f];
    [_loadingView addSubview:loadingLabel];
}

- (void)startLoadingView
{
    if(!_loadingView)
        [self initLoadingView];
    
    _loadingView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_loadingView];
}

- (void)stopLoadingView
{
    [_activityView stopAnimating];
    [_loadingView removeFromSuperview];
}
@end
