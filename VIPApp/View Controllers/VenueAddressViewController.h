//
//  VenueAddressViewController.h
//  SocialConnection
//
//  Created by Celia on 12/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "VenuesResult.h"
#import "VIPViewController.h"

@interface VenueAddressViewController : VIPViewController<MKMapViewDelegate>

@property (nonatomic, strong)Venue *venue;

@end
