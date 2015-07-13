//
//  ReservationsViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "ReservationsViewController.h"
#import "ServiceHelper.h"
#import "ReservationsResult.h"
#import "VIPButton.h"

@interface ReservationsViewController ()
{
    NSInteger selectedReservation;
    NSInteger topMargin;
    UIScrollView *scrollView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ReservationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"MIS RESERVACIONES";
    self.isMainMenu = YES;
    
    topMargin = 90;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topMargin, self.view.frame.size.width, self.view.frame.size.height - topMargin)];
    [self.view addSubview:scrollView];
    
    [self fetchData];
}

- (void)fetchData
{
    [self startLoadingView];
    
    [[ServiceHelper sharedServiceHelper]allReservationsWithSuccess:^(id result)
     {
         [self stopLoadingView];
         NSError *error;
         ReservationsResult *reservations = [[ReservationsResult alloc]initWithDictionary:result error:&error];
         _dataArray = [[NSMutableArray alloc]initWithArray:reservations.data];
         [self createReservationsWithFetchedData];
     } failure:^(NSError *error) {
         
     }];
}

- (void)createReservationsWithFetchedData
{
    CGSize size = CGSizeMake(80, 80);
    
    int x = 0;
    for(int index = 0; index < _dataArray.count; index++)
    {
        Reservation *reservation = [_dataArray objectAtIndex:index];
        
        if(reservation.status == 3)
            continue;
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(20 + size.width,(size.height + 10) * x, self.view.frame.size.width - 30 - size.width, size.height)];
        rightView.backgroundColor = [UIColor whiteColor];
        rightView.alpha = 0.8;
        rightView.layer.cornerRadius = 5;
        [scrollView addSubview:rightView];
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, rightView.frame.size.width - 20, size.height/2)];
        infoLabel.numberOfLines = 2;
        infoLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
        infoLabel.text = [NSString stringWithFormat:@"%@\n%@",reservation.venue.name, reservation.date].uppercaseString;
        [rightView addSubview:infoLabel];
        
        VIPButton *button = [VIPButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"CANCELAR" forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.frame.size.width - 160, rightView.frame.origin.y + rightView.frame.size.height - 35, 140, 30);
        button.tag = index;
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, rightView.frame.origin.y + rightView.frame.size.height - 35, self.view.frame.size.width, 30)];
        backView.backgroundColor = button.backgroundColor;
        backView.alpha = 0.9;
        [scrollView addSubview:backView];
        
        button.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (size.height + 10) * x, size.width, size.height)];
        imageView.layer.cornerRadius = 5;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:imageView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *url = reservation.venue.logo_url;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIGraphicsBeginImageContext(CGSizeMake(93, 93));
                [image drawInRect:CGRectMake(0, 0, 93, 93)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                imageView.image = newImage;
            });
        });
        x++;
    }
    
    if(x * topMargin > scrollView.contentSize.height)
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, x * topMargin);
}

- (void)cancelButtonPressed:(UIButton*)sender
{
    selectedReservation = sender.tag;
    [[[UIAlertView alloc]initWithTitle:@"¿Está seguro quiere cancelar?" message:nil delegate:self cancelButtonTitle:@"Sí" otherButtonTitles:@"No", nil]show ];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex)
    {
        [self startLoadingView];
        [[ServiceHelper sharedServiceHelper]cancelReservation:[[_dataArray objectAtIndex:selectedReservation]id] success:^(id myResults) {
            [_dataArray removeObjectAtIndex:selectedReservation];
            [self stopLoadingView];
            [[[UIAlertView alloc]initWithTitle:@"Tu reservación ha sido cancelada" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show ];
            for(UIView *view in scrollView.subviews)
                [view removeFromSuperview];
            [self createReservationsWithFetchedData];
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
