//
//  PromotionsDayViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "PromotionsDayViewController.h"
#import "PromotionDetailsViewController.h"
#import "ReservationFormViewController.h"
#import "VIPButton.h"
#import "ServiceHelper.h"
#import "PromotionsResult.h"
#import "VenuesResult.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface PromotionsDayViewController ()

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *venues;

@end

@implementation PromotionsDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _day.uppercaseString;
    
    self.bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 100)];
    [self loadAdvertising];
    [self.view addSubview:self.bannerView];
    
    [self fetchData];
}

- (void)fetchData
{
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]allPromotionsForDay:[_day substringToIndex:2] success:^(id myResults) {
        [self stopLoadingView];
        
        NSError *error;
        
        PromotionsDayResult *result = [[PromotionsDayResult alloc]initWithDictionary:myResults error:&error];
        _dataArray = result.data;
        [self loadViewWithFetchedData];
    } failure:^(NSError *error) {
    }];
}

- (void)loadViewWithFetchedData
{
    NSInteger topMargin = 187;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, self.view.frame.size.width, self.view.frame.size.height - topMargin)];
    [self.view addSubview:scrollView];

    for(int x = 0; x < _dataArray.count; x++)
    {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, topMargin + 80 * x, self.view.frame.size.width, 70)];
        backView.backgroundColor = RGB(146, 121, 66);
        backView.alpha = 0.6;
        [self.view addSubview:backView];
        
        UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, topMargin + 80 * x + 28, 25, 35)];
        UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8, 15, 20)];
        infoImage.image = [UIImage imageNamed:@"information"];
        [infoButton addSubview:infoImage];
        infoButton.tag = x;
        infoButton.layer.cornerRadius = 3;
        infoButton.backgroundColor = RGB(39,34,24);
        [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:infoButton];
        
        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, topMargin + 80 * x - 5, 170, 35)];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.text = [[(DayPromotion*)[_dataArray objectAtIndex:x]venue]name];
        [self.view addSubview:dayLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, topMargin + 80 * x + 28, 170, 35)];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.alpha = 0.8;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
        label.backgroundColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"  %@",[[[_dataArray objectAtIndex:x]name]uppercaseString]];
        [self.view addSubview:label];
        
        VIPButton *bookButton = [[VIPButton alloc]initWithFrame:CGRectMake(220, topMargin + 80 * x + 28, 90, 35)];
        [bookButton setTitle:@"RESERVAR" forState:UIControlStateNormal];
        bookButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        [bookButton addTarget:self action:@selector(bookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        bookButton.tag = x;
        bookButton.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bookButton];
    }
}

#pragma mark - IBAction Methods
- (void)infoButtonPressed:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PromotionDetailsViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailsViewController"];
    detailViewController.promotion = [_dataArray objectAtIndex:sender.tag];
    detailViewController.venue = (Venue*)[(DayPromotion*)[_dataArray objectAtIndex:sender.tag]venue];
    detailViewController.venueName = [detailViewController.venue name];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)bookButtonPressed:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ReservationFormViewController *reservation = [storyboard instantiateViewControllerWithIdentifier:@"ReservationFormViewController"];
    reservation.promotion = [_dataArray objectAtIndex:sender.tag];
    reservation.venue = (Venue*)[(DayPromotion*)[_dataArray objectAtIndex:sender.tag]venue];
    
    [self.navigationController pushViewController:reservation animated:YES];
}

#pragma mark - Memory managment
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
