//
//  PromotionDetailsViewController.h
//  SocialConnection
//
//  Created by Celia on 13/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenuesResult.h"
#import "VIPViewController.h"

@interface PromotionDetailsViewController : VIPViewController

@property (nonatomic, strong)Promotion *promotion;
@property (nonatomic, strong)NSString *venueName;
@property (nonatomic, strong)Venue *venue;

- (void)fetchVenueInfo:(NSInteger)venueId;

@end
