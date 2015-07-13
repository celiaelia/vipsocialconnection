//
//  VenueAddressViewController.m
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import "VenueAddressViewController.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface VenueAddressViewController ()

@property (nonatomic, strong)MKMapView *mapView;

@end

@implementation VenueAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"UBICACIÓN"];
    
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
    
    Address *address = _venue.address;
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 197, self.view.frame.size.width, 180)];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = address.latitude.floatValue;
    region.center.longitude = address.longitude.floatValue;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [_mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(address.latitude.floatValue, address.longitude.floatValue)];
    [annotation setTitle:_venue.name];
    [self.mapView addAnnotation:annotation];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 397, self.view.frame.size.width, 90)];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.text = [NSString stringWithFormat:@"%@\n%@ %@,\n%@, %@, C.P. %@", _venue.name.uppercaseString, address.number, address.street, address.city.name, address.state.name, address.zip_code];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    textView.backgroundColor = RGB(146, 121, 66);
    textView.alpha = 0.8;
    [self.view addSubview:textView];
}

#pragma mark - Memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
