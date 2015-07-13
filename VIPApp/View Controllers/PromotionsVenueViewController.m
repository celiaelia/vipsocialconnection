//
//  PromotionsVenueViewController.m
//  SocialConnection
//
//  Created by Celia on 13/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "PromotionsVenueViewController.h"
#import "PromotionDetailsViewController.h"
#import "ReservationFormViewController.h"
#import "VIPButton.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface PromotionsVenueViewController ()

@end

@implementation PromotionsVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _venue.name.uppercaseString;
    
    NSInteger topMargin = 187;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, 100)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_venue.image_url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = imageView.frame.size;
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageView.image = newImage;
        });
    });
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, self.view.frame.size.width, self.view.frame.size.height - topMargin)];
    [self.view addSubview:scrollView];
    
    NSDictionary *days = @{ @"lu" : @"LUNES",
                            @"ma" : @"MARTES",
                            @"mi" : @"MIERCOLES",
                            @"ju" : @"JUEVES",
                            @"vi" : @"VIERNES",
                            @"sa" : @"SABADO",
                            @"do" : @"DOMINGO"};
    
    int x = 0;
    for(NSString *day in days.allKeys)
    for(Promotion *promotion in _venue.promotions)
    for(Schedule *schedule in promotion.schedules)
    {
        if(![schedule.day isEqualToString:day])
            continue;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 80 * x, self.view.frame.size.width, 70)];
        backView.backgroundColor = RGB(146, 121, 66);
        backView.alpha = 0.6;
        [scrollView addSubview:backView];
        
        UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 80 * x + 28, 25, 35)];
        UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8, 15, 20)];
        infoImage.image = [UIImage imageNamed:@"information"];
        [infoButton addSubview:infoImage];
        infoButton.tag = [_venue.promotions indexOfObject:promotion];
        infoButton.layer.cornerRadius = 3;
        infoButton.backgroundColor = RGB(39,34,24);
        [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:infoButton];
        
        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 80 * x - 5, 170, 35)];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.text = [days valueForKey:day];
        [scrollView addSubview:dayLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 80 * x + 28, 170, 35)];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.alpha = 0.8;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
        label.backgroundColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"  %@", promotion.name.uppercaseString];
        [scrollView addSubview:label];
        
        VIPButton *bookButton = [[VIPButton alloc]initWithFrame:CGRectMake(220, 80 * x + 28, 90, 35)];
        [bookButton setTitle:@"RESERVAR" forState:UIControlStateNormal];
        bookButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        [bookButton addTarget:self action:@selector(bookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        bookButton.tag = [_venue.promotions indexOfObject:promotion];
        bookButton.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:bookButton];
        x++;
    }

    if(x * 80 > scrollView.contentSize.height)
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, x * 80);
}

#pragma mark - IBAction Methods

- (void)infoButtonPressed:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PromotionDetailsViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"PromotionDetailsViewController"];
    detailViewController.promotion = [_venue.promotions objectAtIndex:sender.tag];
    detailViewController.venueName = _venue.name;
    detailViewController.venue = _venue;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)bookButtonPressed:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ReservationFormViewController *reservation = [storyboard instantiateViewControllerWithIdentifier:@"ReservationFormViewController"];
    reservation.promotion = [_venue.promotions objectAtIndex:sender.tag];
    reservation.venue = _venue;
    
    [self.navigationController pushViewController:reservation animated:YES];
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
