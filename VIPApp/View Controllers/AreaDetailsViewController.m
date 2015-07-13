//
//  AreaDetailsViewController.m
//  SocialConnection
//
//  Created by Celia on 11/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "AreaDetailsViewController.h"
#import "ServiceHelper.h"
#import "VenuesResult.h"
#import "VenueAddressViewController.h"
#import "PromotionsVenueViewController.h"
#import "VenueImagesViewController.h"

@interface AreaDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

@implementation AreaDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _venue.name.uppercaseString;
    _descriptionTextView.text = [_venue.description uppercaseString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_venue.image_url]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSData *logoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_venue.banner_url]];
        UIImage *logoImage = [UIImage imageWithData:logoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = _imageView.frame.size;
            UIGraphicsBeginImageContext(size);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _imageView.image = newImage;
            size = _bannerImageView.frame.size;
            UIGraphicsBeginImageContext(size);
            [logoImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            _bannerImageView.image = newImage;
            _bannerImageView.userInteractionEnabled = NO;
        });
    });
}

#pragma mark - IBAction Methods
- (IBAction)promotionsButtonPressed:(id)sender {
    PromotionsVenueViewController *promotionsVenue = [[PromotionsVenueViewController alloc]init];
    promotionsVenue.venue = _venue;
    [self.navigationController pushViewController:promotionsVenue animated:YES];
}

- (IBAction)photosButtonPressed:(id)sender {
    VenueImagesViewController *addressViewController = [[VenueImagesViewController alloc]init];
    addressViewController.venue = _venue;
    [self.navigationController pushViewController:addressViewController animated:YES];
}

- (IBAction)locationButtonPressed:(id)sender {
    VenueAddressViewController *addressViewController = [[VenueAddressViewController alloc]init];
    addressViewController.venue = _venue;
    [self.navigationController pushViewController:addressViewController animated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ReserveVenue"])
    {
        [segue.destinationViewController setVenue:(DayVenue*)_venue];
    }
}

#pragma mark - Memory managment methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
