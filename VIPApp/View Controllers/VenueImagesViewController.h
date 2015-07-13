//
//  VenueImagesViewController.h
//  SocialConnection
//
//  Created by Celia on 15/12/13.
//  Copyright (c) 2014 VIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPViewController.h"
#import "VenuesResult.h"

@interface VenueImagesViewController : VIPViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)Venue *venue;

@end
